import csv
import sys
from pathlib import Path

import sfi
from pyarrow import compute, feather, int8, string
from pyarrow.types import (
    is_boolean,
    is_date,
    is_dictionary,
    is_floating,
    is_integer,
    is_timestamp,
)


def main(filename, configfile=None, max_chunksize=64000):
    # max_chunksize is set, somewhat arbitrarily, to the same default value that
    # ehrQL uses to write arrow files.
    converter = ArrowConverter(filename, configfile, max_chunksize)
    converter.load_data()


class ArrowConverter:
    def __init__(self, filename, configfile, max_chunksize):
        # read the feather file into a table
        print(f"Reading file {filename}")
        self.arrow_table = feather.read_table(filename)

        config = self.read_config(configfile)
        self.aliases = self.get_aliases_from_config(config)

        self.max_chunksize = max_chunksize

        # stata has 27 missing values
        # https://www.stata.com/manuals/dmissingvalues.pdf
        # the first of these, `.`,  is the sysmiss, which we want to use
        # the remaining 26 are different types of missingness, which we ignore
        # The sysmiss for byte, int and long, is the 26 less than the largest value for
        # each type
        stata_system_missing = sfi.Missing.getValue()  # sysmiss for float/double
        self.MISSING_VALUES = {
            "string": "",
            "boolean": 101,
            "byte": 101,
            "int": 32741,
            "long": 2147483621,
            "date": stata_system_missing,
            "timestamp": stata_system_missing,
            "float": stata_system_missing,
            "double": stata_system_missing,
        }

        # Ensure that all variable names are valid Stata varnames
        self.column_names = self.clean_names()

        # Identify the column names and types, and which variables are category ones
        self.column_types, self.category_variables = self.get_column_types()

        # convert boolean columns to int8
        self.convert_bool_to_int()

        # Replace null values in original arrow table where possible at this stage
        self.replace_missing_values()

        # Generate the value label mappings for categorical variables
        self.value_labels = self.get_categorical_encodings(self.category_variables)

        # Get a list of date or timestamp typed variables
        self.date_vars = [
            varname
            for varname, vartype in self.column_types.items()
            if vartype in ["date", "timestamp"]
        ]

    def read_config(self, configfile):
        """
        Read an optional config CSV file.
        Return a list of dicts representing config options such as aliased columns.
        """
        config = []
        if configfile is None:
            return config
        config_path = Path(configfile)
        if not config_path.exists():
            print(f"WARNING: Config file not found at {configfile}")
            return config

        with open(config_path) as config_csv:
            reader = csv.DictReader(config_csv)
            config = [row for row in reader]
            if not config:
                print(
                    f"WARNING: No data found in configfile {configfile}; does it contain headers?"
                )
            return config

    def get_aliases_from_config(self, config):
        aliases = {}
        if not config:
            return aliases
        # check the first config dict for the required headers
        expected_headers = {"original_column", "aliased_column"}
        first_row = config[0]
        if expected_headers - set(first_row.keys()):
            print(
                "WARNING: file does not contain expected column headers for aliases "
                "(original_column, aliased_column)"
            )
            return aliases
        aliases = {row["original_column"]: row["aliased_column"] for row in config}
        too_long_aliases = any(key for key, value in aliases.items() if len(value) > 32)
        if too_long_aliases:
            raise ValueError(
                "Config file contains aliases longer than the allowed length (32)"
            )
        return aliases

    def convert_int64_column_to_string(self, column_name):
        """
        Stata can only deal with int8, int16, int32; if we have ints that require
        int64, they're likely to just be identifiers. We convert them to a literal
        string and let users deal with them later.
        """
        converted = self.arrow_table[column_name].cast(string())
        self._replace_column(column_name, converted)

    def get_range_for_column(self, column_name, column_type="int"):
        """
        Return the min and max value for a column from an arrow column
        """
        if column_type == "int":
            col_range = compute.min_max(self.arrow_table[column_name]).as_py()
            return col_range["min"], col_range["max"]

        assert (
            column_type == "category"
        ), f"Can only get range for int or category types, got {column_type}"
        return (0, len(self.arrow_table[column_name].chunks[0].dictionary))

    def get_stata_type_from_range(
        self, min_val, max_val, column_name, is_category=False
    ):
        """
        Identify the appropriate integer type from the range of values in this
        batch
        Note that due to stata's treatment of missing values, the max valid
        value is 27 less than the largest value for that type
        https://www.stata.com/manuals/dmissingvalues.pdf
        """
        range_to_stata_type = {
            (-127, 100): "byte",
            (-32_767, 32_740): "int",
            (-2_147_483_647, 2_147_483_620): "long",
        }

        for int_range, stata_type in range_to_stata_type.items():
            if min_val >= int_range[0] and max_val <= int_range[1]:
                return stata_type

        # range is too big for stata integer types
        print(f"Column {column_name} is out of integer range; converting to string")
        self.convert_int64_column_to_string(column_name)
        return "string"

    def get_column_types(self):
        """
        Method to return the modal dtype across columns of the data frames
        :return: A dictionary containing the modal type for each column
        """
        column_test_mapping = {
            is_floating: "float",
            is_boolean: "boolean",
            is_timestamp: "timestamp",
            is_date: "date",
            is_integer: "int",
            is_dictionary: "category",
        }
        column_types = {}
        for column_name in self.column_names:
            column_metadata = self.arrow_table.schema.field(column_name)
            column_types[column_name] = next(
                (
                    col_type
                    for test_fn, col_type in column_test_mapping.items()
                    if test_fn(column_metadata.type)
                ),
                "string",
            )

        # For the integer and category types, refine them to the stata type their values fit into
        category_variables = [
            col for col, type_ in column_types.items() if type_ == "category"
        ]
        integer_variables = [
            col for col, type_ in column_types.items() if type_ == "int"
        ]
        for col in [*integer_variables, *category_variables]:
            column_type = "category" if col in category_variables else "int"
            column_range = self.get_range_for_column(col, column_type=column_type)
            column_types[col] = self.get_stata_type_from_range(
                *column_range, col, is_category=column_type == "category"
            )
        return column_types, category_variables

    def clean_names(self):
        """
        Function to ensure all of the names of the variables in the table
        are valid Stata variable names.
        If an aliases file has been provided, use it to rename the columns.
        """
        # Creates a mapping from existing column names to names allowed by Stata
        clean_column_names = []
        # Keep a note of names that are too long so we can report those back to the user.
        too_long_names = []
        for varname in self.arrow_table.column_names:
            if len(varname) > 32 and varname not in self.aliases:
                too_long_names.append(varname)
                continue
            # Get the aliases name, if one exists, and run it through the sfitoolkit method to make
            # sure it's valid for stata
            cleaned_name = sfi.SFIToolkit.strToName(
                self.aliases.get(varname, varname), prefix=False
            )
            if cleaned_name != varname:
                print(f"{varname} aliased to {cleaned_name}")
            clean_column_names.append(cleaned_name)

        if too_long_names:
            raise ValueError(
                f"Invalid variable names found ({','.join(too_long_names)})\n"
                f"To fix this, rename variables in arrow file to <32 characters.\n"
                f"Alternatively, a CSV file of original to alias names can be provided."
            )
        self.arrow_table = self.arrow_table.rename_columns(clean_column_names)
        return self.arrow_table.column_names

    def convert_bool_to_int(self):
        """
        Stata has no boolean types and encodes bools as 0/1
        Convert any boolean columns to int8
        """
        for column_name, column_type in self.column_types.items():
            if column_type == "boolean":
                converted = self.arrow_table[column_name].cast(int8())
                self._replace_column(column_name, converted)

    def _replace_column(self, column_name, converted):
        """
        Replace a column the arrow table to another type
        Columns are immutable, so first find the index of the original column,
        remove it, and replace it with the new column at the same index and with the
        same name.
        """
        col_name_index = self.column_names.index(column_name)
        self.arrow_table = self.arrow_table.remove_column(col_name_index)
        self.arrow_table = self.arrow_table.add_column(
            col_name_index, column_name, converted
        )

    def replace_missing_values(self):
        """
        Replace null values in the arrow table with the value stata needs.
        Dates/timestamps/category require additional conversion before loading to
        stata, so null replacements are deferred till later.
        """
        for column_name, column_type in self.column_types.items():
            if (
                column_type in ["date", "timestamp"]
                or column_name in self.category_variables
            ):
                # Skip dates/timestamps/category
                # We replace these after conversion to stata dates in `load_data`
                continue
            null_value = self.MISSING_VALUES[column_type]
            converted = self.arrow_table[column_name].fill_null(null_value)
            col_name_index = self.column_names.index(column_name)
            self.arrow_table = self.arrow_table.remove_column(col_name_index)
            self.arrow_table = self.arrow_table.add_column(
                col_name_index, column_name, converted
            )

    def get_categorical_encodings(self, varnames):
        """
        Retrieve a mapping of labels: values for categorical vars.
        Returns a dict where the variable names are the keys and the value
        is a dictionary consisting of label : value key/value pairs
        """
        value_labels = {}
        for varname in varnames:
            first_chunk = self.arrow_table[varname].chunks[0]
            # Get the unique values for this variable and numeric mapping
            value_map = {
                str(value): idx for idx, value in enumerate(first_chunk.dictionary)
            }
            value_labels[varname] = value_map

        return value_labels

    def make_vars(self):
        """
        Function used to create the Stata variables in memory.
        """
        # Loop over the variable name / variable type mappings and add
        # variables with the appropriate typing based on the vartype
        for varname, vartype in self.column_types.items():
            if vartype == "string":
                sfi.Data.addVarStrL(varname)
            elif vartype in ["boolean", "byte"]:
                sfi.Data.addVarByte(varname)
            elif vartype == "int":
                sfi.Data.addVarInt(varname)
            elif vartype == "long":
                sfi.Data.addVarLong(varname)
            elif vartype in ["float", "date", "timestamp"]:
                sfi.Data.addVarFloat(varname)
            else:
                assert False, f"Unhandled type: {vartype}"

    def define_value_labels(self):
        """
        Function used to define new value labels for use in Stata
        Uses the value_labels generated in `get_categorical_encodings`; a dict
        where the keys are the names of the variables that correspond to the
        value labels and the values are dicts that map string labels to numeric
        values that are used to define the value labels associated with the variable.
        """
        for varname, value_mapping in self.value_labels.items():
            sfi.ValueLabel.createLabel(varname)
            for label, value in value_mapping.items():
                sfi.ValueLabel.setLabelValue(varname, value, label)

    def apply_value_labels(self):
        """
        Assumes that the variable names and value label names are the
        same and assigns the variable labels to variables with the same
        names.
        """
        for label_name in self.value_labels.keys():
            sfi.ValueLabel.setVarValueLabel(label_name, label_name)

    def apply_variable_labels(self):
        for variable_name in self.column_names:
            sfi.Data.setVarLabel(variable_name, variable_name)

    def replace_stata_missing_and_recast(self):
        """
        Null values are replace prior to loading into stata, with the sysmiss value
        for that variable type. However, for byte, int and long types, this results
        in stata converting the variable type to one that can hold the sysmiss value.
        i.e. if we have a byte column which can take the values 1, 2, or None, it will
        be converted to an int column in stata, with the values 1, 2, and 101.

        After the data is loaded to stata, we replace any numeric missing values with stata's
        missing notation ("."), and recast the column to the expected type.
        """
        # for byte/int/long variables, replace the missing value with stata missing and recast
        # the variable to the type we expect it to be
        for column_name, column_type in self.column_types.items():
            if column_type not in ["boolean", "byte", "int", "long"]:
                continue
            column_type = "byte" if column_type == "boolean" else column_type
            print(f"Finalising column {column_name} (type ({column_type})")
            sfi.SFIToolkit.stata(
                f"replace {column_name} = . if {column_name} == {self.MISSING_VALUES[column_type]}"
            )
            sfi.SFIToolkit.stata(f"recast {column_type} {column_name}")

    def load_data(self):
        self.make_vars()
        self.define_value_labels()

        def _timestamp_as_sif(python_datetime):
            """
            Convert a python datetime to a stata %td format (number of days
            since 1960-01-01)
            """
            if python_datetime is not None:
                return sfi.Datetime.getSIF(python_datetime, "%td")
            return self.MISSING_VALUES["timestamp"]

        next_obs = 0
        for i, batch in enumerate(self.arrow_table.to_batches(self.max_chunksize)):
            # add observations
            sfi.Data.addObs(batch.num_rows)
            # find the indices of the observations for this batch
            # Note that we need to keep track of which observation we're processing next
            # and use that for identifying which observations this batch is for, because
            # the batch size is not always exactly self.max_chunksize
            batch_observations = range(next_obs, next_obs + batch.num_rows)

            # get the values to load into stata
            values = []
            for i, varname in enumerate(self.column_names):
                if varname in self.category_variables:
                    # convert category data to a list of indices
                    column_data = batch.columns[i].indices.to_pylist()
                    # fill missing values with stata "extended missing"
                    column_data = [
                        val
                        if val is not None
                        else self.MISSING_VALUES[self.column_types[varname]]
                        for val in column_data
                    ]
                else:
                    column_data = batch.columns[i].to_pylist()
                    if self.column_types[varname] in ["date", "timestamp"]:
                        column_data = [_timestamp_as_sif(val) for val in column_data]
                values.append(column_data)
            next_obs += batch.num_rows

            # store values at specified observation indices
            sfi.Data.store(
                var=self.column_names, obs=batch_observations, val=zip(*values)
            )

        self.apply_variable_labels()
        self.apply_value_labels()
        self.replace_stata_missing_and_recast()


def parse_args():
    # The stata `arrowload` command always passes 3 positional arguments
    # The first argument is the arrow filename
    args = dict(filename=sys.argv[1])
    # If no config CSV was provided, the string "none" will be the second arg, and we
    # can ignore it
    if sys.argv[2] != "none":
        args.update(configfile=sys.argv[2])
    # Finally the max_chunksize; will be a user-specified value or the default 64000
    args.update(max_chunksize=int(sys.argv[3]))
    return args


if __name__ == "__main__":
    main(**parse_args())
