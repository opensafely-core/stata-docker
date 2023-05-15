"""
This script generates two arrow files, one with 1000 observations, which is
read in one batch, and another with 100,000 observations, which is
read in two batches.

It creates a variable, with and without nulls (except for bools), for
each type we expect to encounter in an arrow file. The values are
random, except for rows 0, 1 and -1, which have fixed values inserted
so we can check them in the tests.

For the multi-batch data, the interger-type values are manipulated so
that the first batch always gets small (byte-sized) numbers only, which
will need to be adjusted on the second batch to ensure the variables and
replaced null values are of the right types.
"""

import random
from datetime import date, datetime, timedelta, timezone
from pathlib import Path

import pyarrow
from pyarrow import feather


start_date = datetime.utcnow().replace(tzinfo=timezone.utc) - timedelta(days=365 * 100)
end_date = datetime.utcnow().replace(tzinfo=timezone.utc) + timedelta(days=365 * 100)

FIXTURES_PATH = Path(__file__).parent / "fixtures"

# Fixed values for each type at indices 0 & 1 and -1
# non-nullable values for row 0 and 1 are the same, row -1 has nulls for nullable vars
FIXTURE_DATA = {
    "date": [date(2023, 10, 1), date(2023, 12, 1)],
    # row 1 & 9 are timezone-aware, row -2 is naive
    "datetime": [
        datetime(2023, 10, 1, 10, 30, 0, 0, tzinfo=timezone.utc),
        datetime(2023, 10, 1, 22, 30, 0, 0),
    ],
    "bool": [True, False],
    "byte": [10, -12],
    "int": [2000, -350],
    "long": [100_000, -200_000],
    "int64": [2_500_000_000, -2_700_000_000],
    "float": [55.565, -4.5],
    "category": ["A", "C"],
}

BATCHED_FIXTURE_DATA = {
    **FIXTURE_DATA,
    "int": [15, -350],
    "long": [15, -200_000],
    "int64": [15, -2_700_000_000],
    "category": ["A", "A"],
}


def random_date(date_only):
    value = start_date + (end_date - start_date) * random.random()
    if date_only:
        value = value.date()
    return value


def insert_nulls(values):
    values_with_nulls = [*values]
    # insert 10% nulls
    null_indices = random.sample(range(0, len(values) - 1), round(len(values) * 0.1))
    for i in null_indices:
        values_with_nulls[i] = None
    return values_with_nulls


def insert_fixture_data(var_type, values, with_nulls=False, batched=False):
    fixture_values = (
        BATCHED_FIXTURE_DATA[var_type] if batched else FIXTURE_DATA[var_type]
    )
    values[0] = fixture_values[0]
    values[1] = None if with_nulls else fixture_values[0]
    values[-1] = fixture_values[1]


def date_array(total=1000, include_null=False, date_only=True):
    values = [random_date(date_only) for i in range(total)]
    if include_null:
        values = insert_nulls(values)
    # update fixed values:
    date_type = "date" if date_only else "datetime"
    insert_fixture_data(date_type, values, include_null)
    return pyarrow.array(values)


def numeric_array(
    min_num, max_num, var_type, total=1000, include_null=False, batched=False
):
    if var_type == "float":
        values = [random.uniform(min_num, max_num) for i in range(total)]
    else:
        if batched:
            # To test if batched arrow files correctly cast upwards if they encounter a larger
            # int range in a second batch, we make sure that the first batch is all byte-sized
            values = [random.randint(-127, 100) for i in range(total - 1000)]
            values += [random.randint(min_num, max_num) for i in range(1000)]
        else:
            values = [random.randint(min_num, max_num) for i in range(total)]
    if include_null:
        values = insert_nulls(values)
    # update fixed values:
    insert_fixture_data(var_type, values, include_null, batched=batched)
    return pyarrow.array(values)


def choice_array(choices, var_type, total=1000, include_null=False, batched=False):
    if include_null:
        choices.append(None)
    # To test if batched arrow files correctly include all categories, we make sure that the
    # first batch only includes one choice
    if batched:
        values = [choices[0] for i in range(total - 1000)]
        values += [random.choice(choices) for i in range(1000)]
    else:
        values = [random.choice(choices) for i in range(total)]
    insert_fixture_data(var_type, values, include_null, batched=batched)
    if var_type == "category":
        return pyarrow.array(values).dictionary_encode()
    return pyarrow.array(values)


def string_array_from_numeric(numeric_array):
    def _string_val(val):
        if val is None:
            return ""
        return str(val)

    return pyarrow.array([_string_val(it) for it in numeric_array.to_pylist()])


def generate(total=1000, batched=False):
    # date
    d1 = date_array(total=total)
    d1a = date_array(include_null=True, total=total)

    # timestamp
    t1 = date_array(total=total, date_only=False)
    t1a = date_array(include_null=True, total=total, date_only=False)

    b1 = choice_array([True, False], "bool", total=total)

    # stata byte sized
    i1 = numeric_array(-127, 100, "byte", total=total, batched=batched)
    i1a = numeric_array(
        -127, 100, "byte", total=total, include_null=True, batched=batched
    )

    # stata int sized
    i2 = numeric_array(-32_767, 32_740, "int", total=total, batched=batched)
    i2a = numeric_array(
        -32_767, 32_740, "int", total=total, include_null=True, batched=batched
    )

    # stata long sizes
    i3 = numeric_array(
        -2_147_483_647, 2_147_483_620, "long", total=total, batched=batched
    )
    i3a = numeric_array(
        -2_147_483_647,
        2_147_483_620,
        "long",
        total=total,
        include_null=True,
        batched=batched,
    )

    # int64 size - too long for stata integer; will be converted to string literal
    i4 = numeric_array(
        -3_000_000_000, 3_000_000_000, "int64", total=total, batched=batched
    )
    s1 = string_array_from_numeric(i4)
    i4a = numeric_array(
        -3_000_000_000,
        3_000_000_000,
        "int64",
        total=total,
        batched=batched,
        include_null=True,
    )
    s1a = string_array_from_numeric(i4a)

    f1 = numeric_array(-100.5, 100.5, "float", total=total)
    f1a = numeric_array(-100.5, 100.5, "float", total=total, include_null=True)

    # categorical
    c1 = choice_array(["A", "B", "C", "D"], "category", total=total, batched=batched)
    c1a = choice_array(
        ["A", "B", "C", "D"],
        "category",
        total=total,
        include_null=True,
        batched=batched,
    )

    # define the lists of arrays and their names for the pyarrow table
    arrays = [
        d1,
        d1a,
        t1,
        t1a,
        b1,
        i1,
        i1a,
        i2,
        i2a,
        i3,
        i3a,
        f1,
        f1a,
        c1,
        c1a,
        i4,
        i4a,
        s1,
        s1a,
    ]
    names = [
        "d1",
        "d1a",
        "t1",
        "t1a",
        "b1",
        "i1",
        "i1a",
        "i2",
        "i2a",
        "i3",
        "i3a",
        "f1",
        "f1a",
        "c1",
        "c1a",
        "i4",
        "i4a",
        "s1",
        "s1a",
    ]

    return pyarrow.Table.from_arrays(arrays, names=names)


def export(table, filename):
    feather.write_feather(table, str(filename))


def main():
    data_file = FIXTURES_PATH / "data.arrow"
    table = generate(total=1000, batched=False)
    export(table, data_file)

    data_with_batches_file = FIXTURES_PATH / "data_multiple_batches.arrow"
    big_table = generate(total=100000, batched=True)
    export(big_table, data_with_batches_file)


if __name__ == "__main__":
    main()
