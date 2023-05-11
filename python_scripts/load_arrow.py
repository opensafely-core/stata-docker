import csv
import sys
from datetime import datetime
from pathlib import Path

import pyarrow
import sfi
from pyarrow import RecordBatch, compute, int8, string
from pyarrow.types import (
    is_boolean,
    is_date,
    is_dictionary,
    is_floating,
    is_integer,
    is_timestamp,
)


def main(filename, configfile=None):
    converter = ArrowConverter(filename, configfile)
    converter.load_data()


class ArrowConverter:
    def __init__(self, filename, configfile):
        # Read config file if there is one, and identify aliases to use for column naming
        config = self.read_config(configfile)
        self.aliases = self.get_aliases_from_config(config)

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
            "date": 2147483621,
            "timestamp": stata_system_missing,
            "float": stata_system_missing,
            "double": stata_system_missing,
        }

        # these will be set on the first batch reading
        self.column_names = None
        self.column_types = None
        self.category_variables = None
        self.value_labels = None
        self.arrow_batches = self.iter_arrow_batches(filename)

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

    def iter_arrow_batches(self, filename):
        """Read the arrow file in batches"""
        with pyarrow.memory_map(str(filename), "rb") as f:
            with pyarrow.ipc.open_file(f) as reader:
                total_batches = reader.num_record_batches
                for i in range(0, total_batches):
                    yield reader.get_record_batch(i), i + 1, total_batches

    def convert_int64_column_to_string(self, batch, column_name):
        """
        Stata can only deal with int8, int16, int32; if we have ints that require
        int64, they're likely to just be identifiers. We convert them to a literal
        string and let users deal with them later.
        """
        converted = batch[column_name].cast(string())
        return self._replace_column(batch, column_name, converted)

    def get_range_for_column(self, batch, column_name, column_type="int"):
        """
        Return the min and max value for a column from an arrow column
        """
        if column_type == "int":
            col_range = compute.min_max(batch[column_name]).as_py()
            return col_range["min"], col_range["max"]

        assert (
            column_type == "category"
        ), f"Can only get range for int or category types, got {column_type}"
        return (0, len(batch[column_name].dictionary))

    def get_stata_type_from_range(self, batch, min_val, max_val, column_name):
        """
        Identify the appropriate integer type from the range of values in this
        batch
        Note that due to stata's treatment of missing values, the max valid
        value is 27 less than the largest value for that type
        https://www.stata.com/manuals/dmissingvalues.pdf
        """
        type_weights = {"byte": 0, "int": 1, "long": 2, "string": 3}
        range_to_stata_type = {
            (-127, 100): "byte",
            (-32_767, 32_740): "int",
            (-2_147_483_647, 2_147_483_620): "long",
        }

        batch_type = None
        for int_range, stata_type in range_to_stata_type.items():
            if min_val >= int_range[0] and max_val <= int_range[1]:
                batch_type = stata_type
                break

        if batch_type is None:
            # range is too big for stata integer types
            print(f"Column {column_name} is out of integer range; converting to string")
            batch = self.convert_int64_column_to_string(batch, column_name)
            batch_type = "string"

        current_type = (
            self.column_types[column_name] if self.column_types is not None else "byte"
        )
        if batch_type == current_type:
            return batch, batch_type
        # return the largest of the two possible types
        return batch, max([current_type, batch_type], key=lambda x: type_weights[x])

    def get_column_types(self, batch):
        """
        Method to find the types of each column of a record batch.
        We need to do this for each batch to ensure that any integer variable are set to
        the correct stata type based on the range of their values.
        Set:
          self.column_types - a dictionary containing the modal type for each column
          self.category_variables - a list of category variables
        """
        column_test_mapping = {
            is_floating: "float",
            is_boolean: "boolean",
            is_date: "date",
            is_timestamp: "timestamp",
            is_integer: "int",
            is_dictionary: "category",
        }

        column_types = {}
        for column_name in self.column_names:
            column_metadata = batch.schema.field(column_name)
            column_types[column_name] = next(
                (
                    col_type
                    for test_fn, col_type in column_test_mapping.items()
                    if test_fn(column_metadata.type)
                ),
                "string",
            )

        # For the integer and category types, refine them to the stata type their values fit into
        if self.category_variables is None:
            self.category_variables = [
                col for col, type_ in column_types.items() if type_ == "category"
            ]
        integer_variables = [
            col for col, type_ in column_types.items() if type_ == "int"
        ]
        for col in [*integer_variables, *self.category_variables]:
            column_type = "category" if col in self.category_variables else "int"
            column_range = self.get_range_for_column(
                batch, col, column_type=column_type
            )
            batch, column_type = self.get_stata_type_from_range(
                batch, *column_range, col
            )
            column_types[col] = column_type
        self.column_types = column_types
        return batch

    def clean_names(self, batch):
        """
        Function to ensure all of the names of the variables in the table
        are valid Stata variable names.
        If an aliases file has been provided, record the column name mapping.
        """
        original_names = batch.schema.names
        if self.column_names is None:
            # This is the first batch; identify any provided aliases and ensure variable names
            # are valid for stata
            # Keep a note of names that are too long so we can report those back to the user.
            too_long_names = []
            self.column_names = []
            for varname in batch.schema.names:
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
                self.column_names.append(cleaned_name)

            if too_long_names:
                raise ValueError(
                    f"Invalid variable names found ({','.join(too_long_names)})\n"
                    f"To fix this, rename variables in arrow file to <32 characters.\n"
                    f"Alternatively, a CSV file of original to alias names can be provided."
                )

        # Generate a new batch with the cleaned/aliased column names.
        if original_names != self.column_names:
            batch = RecordBatch.from_arrays(batch.columns, names=self.column_names)
        return batch

    def convert_bool_to_int(self, batch):
        """
        Stata has no boolean types and encodes bools as 0/1
        Convert any boolean columns to int8
        """
        for column_name, column_type in self.column_types.items():
            if column_type == "boolean":
                converted = batch[column_name].cast(int8())
                batch = self._replace_column(batch, column_name, converted)
        return batch

    def convert_date_and_timestamp_columns(self, batch):
        for column_name, column_type in self.column_types.items():
            if column_type in ["date", "timestamp"]:
                if column_type == "timestamp":
                    timestamp_units = batch[column_name].type.unit
                else:
                    timestamp_units = None
                converted = self._convert_datetime_data(
                    batch[column_name], column_type, timestamp_units
                )
                batch = self._replace_column(batch, column_name, converted)
        return batch

    def _convert_datetime_data(self, column_data, column_type, timestamp_units=None):
        """
        Convert a list of pyarrow dates or timestamps to their stata numeric equivalent
        Pyarrow dates are stored as days since 1970-1-1
        Pyarrow timestamps are stored as time since 1970-1-1, in seconds, milliseconds,
        microseconds or nanoseconds
        Stata stores dates/timestamps using 1960-1-1
        - dates: days since 1960-1-1
        - timestamps: milliseconds since 1960-1-1
        """
        epoch_base_timedelta = datetime(1970, 1, 1) - datetime(1960, 1, 1)
        date_epoch_modifier = epoch_base_timedelta.days

        # tuple of multipliers for each possible pyarrow timestamp unit needed to convert:
        # 1) seconds to pyarrow timestamp units
        # 2) pyarrow timestamp units to milliseconds
        ts_units_multipliers = {
            None: (1, 1),
            "s": (1, 1000),
            "ms": (1000, 1),
            "us": (1_000_000, 0.001),
            "ns": (1_000_000_000, 0.000001),
        }
        # this is the amount we need to add to a pyarrow timestamp value to
        # get its value since the stata epoch in the ORIGINAL units
        ts_epoch_modifier = (
            epoch_base_timedelta.total_seconds()
            * ts_units_multipliers[timestamp_units][0]
        )
        # this is what we multiply the original units by to get the time since epoch in MILLISECONDS
        ts_units_to_ms = ts_units_multipliers[timestamp_units][1]

        def _convert_date_to_days_since(dt):
            if dt.value is not None:
                days_since_pyarrow_epoch = dt.value
                return days_since_pyarrow_epoch + date_epoch_modifier

        def _convert_ts_to_milliseconds_since(dt):
            if dt.value is not None:
                units_since_pyarrow_epoch = dt.value
                return (units_since_pyarrow_epoch + ts_epoch_modifier) * ts_units_to_ms

        converters = {
            "date": _convert_date_to_days_since,
            "timestamp": _convert_ts_to_milliseconds_since,
        }

        conversion_func = converters[column_type]
        return [conversion_func(val) for val in column_data]

    def _replace_column(self, batch, column_name, converted):
        """
        Replace a column in the batch with another type
        Columns are immutable, so first find the index of the original column,
        remove it, and replace it with the new column at the same index and with the
        same name.
        Return a new batch with the replaced column
        """
        col_name_index = self.column_names.index(column_name)
        arrays = [batch[column_name] for column_name in self.column_names]
        arrays[col_name_index] = converted
        return RecordBatch.from_arrays(arrays, names=self.column_names)

    def replace_missing_values(self, batch):
        """
        Replace null values in the batch with the value stata needs.
        Note that we lose the categorical information in the batch,
        but that's OK, because we do this last before loading into
        stata, and we've already identified any categorical label info
        that needs to be applied.
        """
        for column_name, column_type in self.column_types.items():
            null_value = self.MISSING_VALUES[column_type]
            column_data = batch[column_name]
            if column_name in self.category_variables:
                # convert category data to a list of indices
                column_data = column_data.indices
            converted = column_data.fill_null(null_value)
            batch = self._replace_column(batch, column_name, converted)
        return batch

    def get_categorical_encodings(self, batch):
        """
        Retrieve a mapping of labels: values for categorical vars.
        Returns a dict where the variable names are the keys and the value
        is a dictionary consisting of label : value key/value pairs
        """
        if self.value_labels is not None:
            return
        self.value_labels = {}
        for varname in self.category_variables:
            # Get the unique values for this variable and numeric mapping
            value_map = {
                str(value): idx for idx, value in enumerate(batch[varname].dictionary)
            }
            self.value_labels[varname] = value_map

    def make_vars(self, pre_processed_column_types, batch):
        """
        Function used to create the Stata variables in memory.
        """
        if not pre_processed_column_types:
            # This is the first batch
            # Loop over the variable name / variable type mappings and add
            # variables with the appropriate typing based on the vartype
            for varname, vartype in self.column_types.items():
                if vartype == "string":
                    max_length = max(len(val.as_py()) for (val) in batch[varname])
                    sfi.Data.addVarStr(varname, length=max_length)
                elif vartype in ["boolean", "byte"]:
                    sfi.Data.addVarByte(varname)
                elif vartype == "int":
                    sfi.Data.addVarInt(varname)
                elif vartype in ["long", "date"]:
                    sfi.Data.addVarLong(varname)
                elif vartype == "timestamp":
                    sfi.Data.addVarDouble(varname)
                elif vartype == "float":
                    sfi.Data.addVarFloat(varname)
                else:
                    assert False, f"Unhandled type: {vartype}"
        else:
            # If any columns have changed required type when we process a
            # subsequent batch, recast the existing stata column
            column_type_mappings = {"boolean": "byte", "date": "long"}
            changed_cols = {
                col: col_type
                for col, col_type in self.column_types.items()
                if self.column_types[col] != pre_processed_column_types[col]
            }
            for changed_col, changed_type in changed_cols.items():
                print(f"Converting {changed_cols}")
                if changed_type == "string":
                    # If the variable has changed in a subsequent batch to string type, it
                    # means it was previously considered integer type and is now too big to
                    # fit into `long`. recast doesn't work in this case; we need to change it
                    # to a new string column, drop the old column and rename it.
                    sfi.SFIToolkit.stata(f"tostring {changed_col}, gen({changed_col}1)")
                    sfi.Data.dropVar(changed_col)
                    sfi.SFIToolkit.stata(f"rename {changed_col}1 {changed_col}")
                else:
                    cast_to = column_type_mappings.get(changed_type, changed_type)
                    sfi.SFIToolkit.stata(f"recast {cast_to} {changed_col}")

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

        We need to do this for each batch, so that nulls from the first batch are treated
        appropriately if the column is re-cast in a second batch. e.g.
        Batch 1 contains a variable x with byte sized numbers and a null; the null is replaced
        with the missing value 101; the variable is created as `byte` type
        Batch 2 contains int sized numbers for variable x; the variable is recast to `int`. If the
        missing value 101 from Batch 1 hasn't already been replaced with its stata null
        value, it will become the non-missing integer 101 when the column is re-cast to `int` type.
        """
        # for byte/int/long variables, replace the missing value with stata missing and recast
        # the variable to the type we expect it to be
        column_type_mappings = {"boolean": "byte", "date": "long"}
        for column_name, column_type in self.column_types.items():
            if column_type not in ["boolean", "byte", "int", "long", "date"]:
                continue
            column_type = column_type_mappings.get(column_type, column_type)
            print(f"Finalising column {column_name} (type ({column_type})")
            sfi.SFIToolkit.stata(
                f"replace {column_name} = . if {column_name} == {self.MISSING_VALUES[column_type]}"
            )
            sfi.SFIToolkit.stata(f"recast {column_type} {column_name}")

    def process_batch(self, batch):
        """
        Process a single batch.
        """

        if self.column_types is not None:
            pre_processing_column_types = {**self.column_types}
        else:
            pre_processing_column_types = {}

        # Ensure that all variable names are valid Stata varnames
        batch = self.clean_names(batch)

        # Identify the column names and types, and which variables are category ones
        batch = self.get_column_types(batch)

        # convert boolean columns to int8
        batch = self.convert_bool_to_int(batch)

        # convert dates/timestamps to their relevant numeric type
        batch = self.convert_date_and_timestamp_columns(batch)

        # Generate the value label mappings for categorical variables
        self.get_categorical_encodings(batch)

        # Replace null values in each column.  Note this must be done last, as replacing
        # the categorical nulls loses the category info from the batch
        batch = self.replace_missing_values(batch)

        return batch, pre_processing_column_types

    def load_data(self):
        next_obs = 0
        for batch, batch_num, total in self.arrow_batches:
            print(f"Reading batch {batch_num} of {total}")
            batch, pre_processed_column_types = self.process_batch(batch)
            # make variables
            self.make_vars(pre_processed_column_types, batch)

            # add observations
            sfi.Data.addObs(batch.num_rows)
            # find the indices of the observations for this batch
            batch_observations = range(next_obs, next_obs + batch.num_rows)

            # get the values to load into stata
            values = []
            for varname in self.column_names:
                column_data = batch[varname].to_pylist()
                values.append(column_data)

            next_obs += batch.num_rows

            # store values at specified observation indices
            sfi.Data.store(
                var=self.column_names, obs=batch_observations, val=zip(*values)
            )
            self.replace_stata_missing_and_recast()

        self.define_value_labels()
        self.apply_variable_labels()
        self.apply_value_labels()


def parse_args():
    # The stata `arrowload` command always passes 2 positional arguments
    # The first argument is the arrow filename
    args = dict(filename=sys.argv[1])
    # If no config CSV was provided, the string "none" will be the second arg, and we
    # can ignore it
    if sys.argv[2] != "none":
        args.update(configfile=sys.argv[2])
    return args


if __name__ == "__main__":
    main(**parse_args())
