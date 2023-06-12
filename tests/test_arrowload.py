from .helpers import run_stata, sanitize


def test_arrowload_single_batch():
    """
    Test the happy path with an arrow file that is loaded in a single batch.

    The arrow file is generated using `generate_arrow_fixtures.py`. Fixed values are
    inserted in the first 2 rows, and the last row; other values are random.

    The arrow file contains:
    1000 variables, processed as a single batch, with variables:
        b1: boolean
        d1: date
        d1a: date with nulls
        t1: timestamp
        t1a: timestamp with nulls
        i1, i2, i3: integers fitting byte/int/long vars in stata
        i1a, i2a, i3a: as above, with nulls
        i4: int64 var, too big for stata int, converted to string
        i4a: as i4, with nulls
        f1, f1a: float, with and without nulls
        s1, s1a: i4/i4a values, already converted to string before loading
        c1, c1a: category (A, B, C, D), with and without nulls
    """
    return_code, output, log_content = run_stata("analysis/arrowload/arrowload.do")
    assert return_code == 0

    # Assert that there's just one batch
    batch_log = "Reading batch 1 of 1"
    # Assert that all the variables as expected types
    description_table = sanitize(
        """
        Contains data
        obs:         1,000
        vars:            19
        -------------------------------------------------------------------------------
                    storage   display    value
        variable name   type    format     label      variable label
        -------------------------------------------------------------------------------
        d1              long    %12.0g                d1
        d1a             long    %12.0g                d1a
        t1              double  %10.0g                t1
        t1a             double  %10.0g                t1a
        b1              byte    %8.0g                 b1
        i1              byte    %8.0g                 i1
        i1a             byte    %8.0g                 i1a
        i2              int     %8.0g                 i2
        i2a             int     %8.0g                 i2a
        i3              long    %12.0g                i3
        i3a             long    %12.0g                i3a
        f1              float   %9.0g                 f1
        f1a             float   %9.0g                 f1a
        c1              byte    %8.0g      c1         c1
        c1a             byte    %8.0g      c1a        c1a
        i4              str11   %11s                  i4
        i4a             str11   %11s                  i4a
        s1              str11   %11s                  s1
        s1a             str11   %11s                  s1a
        -------------------------------------------------------------------------------
    """
    )
    for content in [output, log_content]:
        assert batch_log in content
        assert description_table in content

    # expected boolean and category values in rows 1, 2 and 1000
    # null values are shown as stata null .
    bool_cat_1_and_2 = sanitize(
        """
            b1   c1   c1a
        1.    1    A     A
        2.    1    A     .
    """
    )
    bool_cat_1000 = sanitize(
        """
                b1   c1   c1a
        1000.    0    C     C
    """
    )
    # expected date and timestamp values in rows 1, 2 and 1000
    # null values are shown as stata null .
    date_ts_1_and_2 = sanitize(
        """
                    d1         d1a                   t1                  t1a
        1.   01oct2023   01oct2023   01oct2023 10:30:00   01oct2023 10:30:00
        2.   01oct2023           .   01oct2023 10:30:00                    .
    """
    )
    date_ts_1000 = sanitize(
        """
                    d1         d1a                   t1                  t1a
        1000.   01dec2023   01dec2023   01oct2023 22:30:00   01oct2023 22:30:00
    """
    )
    # expected byte, int, long, float in rows 1, 2 and 1000
    # null values are shown as stata null .
    numeric_1_and_2 = sanitize(
        """
            i1   i1a     i2    i2a       i3      i3a       f1      f1a
        1.   10    10   2000   2000   100000   100000   55.565   55.565
        2.   10     .   2000      .   100000        .   55.565        .
    """
    )
    numeric_1000 = sanitize(
        """
                i1   i1a     i2    i2a        i3       i3a     f1    f1a
        1000.   -12   -12   -350   -350   -200000   -200000   -4.5   -4.5
    """
    )
    # expected int64 (converted to string when loaded to stata)
    # and string equivalent (already converted to string)
    # null values are shown as empty string
    int64_1_and_2 = sanitize(
        """
                    i4          i4a           s1          s1a
        1.   2500000000   2500000000   2500000000   2500000000
        2.   2500000000                2500000000
    """
    )
    int64_1000 = sanitize(
        """
                        i4           i4a            s1           s1a
        1000.   -2700000000   -2700000000   -2700000000   -2700000000
    """
    )
    expected = {
        "boolean and category rows 1 and 2": bool_cat_1_and_2,
        "boolean and category row 1000": bool_cat_1000,
        "date and ts rows 1 and 2": date_ts_1_and_2,
        "date and ts row 1000": date_ts_1000,
        "byte, int, long rows 1 and 2": numeric_1_and_2,
        "byte, int, long row 1000": numeric_1000,
        "int64 and string rows 1 and 2": int64_1_and_2,
        "int64 and string row 1000": int64_1000,
    }

    for label, values in expected.items():
        assert values in output, f"Unexpected values found in {label}: {output}"


def test_arrowload_multiple_batch():
    """
    Test the happy path with an arrow file that is loaded in a two batches.

    The arrow file is generated using `generate_arrow_fixtures.py`. Fixed values are
    inserted in the first 2 rows, and the last row; other values are random.

    The arrow file contains:
    100,000 variables, processed as two batches, with all the same variables as the
    single batch file.
    The test data is set up so that the numeric types are all byte-sized ints, and
    bigger values are only encountered (and therefor re-cast) on the second batch.
    The string var (which is a stringified version of the int64 var) also creates a
    smaller string type in the first batch, which is recast to str11 in the second batch.
    """
    return_code, output, log_content = run_stata(
        "analysis/arrowload/arrowload-batches.do"
    )
    assert return_code == 0

    # Assert that there are two batches
    batch_log = "Reading batch 1 of 2"
    # Assert that all the variables as expected types
    description_table = sanitize(
        """
        Contains data
        obs:       100,000
        vars:            19
        -------------------------------------------------------------------------------
                    storage   display    value
        variable name   type    format     label      variable label
        -------------------------------------------------------------------------------
        d1              long    %12.0g                d1
        d1a             long    %12.0g                d1a
        t1              double  %10.0g                t1
        t1a             double  %10.0g                t1a
        b1              byte    %8.0g                 b1
        i1              byte    %8.0g                 i1
        i1a             byte    %8.0g                 i1a
        i2              int     %8.0g                 i2
        i2a             int     %8.0g                 i2a
        i3              long    %8.0g                 i3
        i3a             long    %8.0g                 i3a
        f1              float   %9.0g                 f1
        f1a             float   %9.0g                 f1a
        c1              byte    %8.0g      c1         c1
        c1a             byte    %8.0g      c1a        c1a
        i4              str11   %11s                  i4
        i4a             str11   %11s                  i4a
        s1              str11   %11s                  s1
        s1a             str11   %11s                  s1a
        -------------------------------------------------------------------------------
    """
    )
    for content in [output, log_content]:
        assert batch_log in content
        assert description_table in content

    # expected byte, int, long in rows 1, 2 and 100,000
    # byte-sized for all
    # null values are still read correctly as stata null .
    numeric_1_and_2 = sanitize(
        """
        i1   i1a   i2   i2a   i3   i3a
    1.   10    10   15    15   15    15
    2.   10     .   15     .   15     .
    """
    )
    numeric_100000 = sanitize(
        """
            i1   i1a     i2    i2a        i3       i3a
    100000.   -12   -12   -350   -350   -200000   -200000
    """
    )
    # expected int64 (converted to string when loaded to stata)
    # and string equivalent (already converted to string)
    # also byte-sized in rows 1 and 2
    int64_1_and_2 = sanitize(
        """
        i4   s1
    1.   15   15
    2.   15   15
    """
    )
    int64_1000000 = sanitize(
        """
                    i4            s1
    100000.   -2700000000   -2700000000
    """
    )
    expected = {
        "byte, int, long rows 1 and 2": numeric_1_and_2,
        "byte, int, long row 1000": numeric_100000,
        "int64 and string rows 1 and 2": int64_1_and_2,
        "int64 and string row 1000": int64_1000000,
    }

    for label, values in expected.items():
        assert values in output, f"Unexpected values found in {label}: {output}"


def test_arrowload_too_long_variable_names():
    """
    Variable names that are too long for stata variables raise an error
    """
    return_code, output, _ = run_stata("analysis/arrowload/arrowload-too-long.do")
    assert return_code == 1
    assert "Invalid variable names found" in output


def test_arrowload_aliased_long_variable_names():
    """
    Test an arrowload command with a config file containing aliased for the too-long
    variable names
    """
    return_code, _, _ = run_stata("analysis/arrowload/arrowload-too-long-aliased.do")
    assert return_code == 0


def test_arrowload_bad_aliases():
    """
    Aliased variable names that are too long for stata variables raise an error
    """
    return_code, output, _ = run_stata("analysis/arrowload/arrowload-bad-aliases.do")
    assert return_code == 1
    assert "aliases longer than the allowed length" in output


def test_arrowload_config_file_not_found():
    """
    If a specified config file isn't found, the arrowload module attempts to continue
    and just shows a warning
    """
    return_code, output, _ = run_stata(
        "analysis/arrowload/arrowload-configfile-not-found.do"
    )
    assert return_code == 0
    assert "WARNING: Config file not found" in output


def test_arrowload_config_file_no_data():
    """
    If a specified config file has no data (contains only one line, and no alias headers),
    the arrowload module attempts to continue and just shows a warning
    """
    return_code, output, _ = run_stata(
        "analysis/arrowload/arrowload-no-aliases-headers-1.do"
    )
    assert return_code == 0
    assert "WARNING: No data found in configfile" in output


def test_arrowload_config_file_no_alias_headers():
    """
    If a specified config file has data, but no alias headers, the arrowload module attempts
    to continue and just shows a warning
    """
    return_code, output, _ = run_stata(
        "analysis/arrowload/arrowload-no-aliases-headers-2.do"
    )
    assert return_code == 0
    assert (
        "WARNING: file does not contain expected column headers for aliases" in output
    )


def test_arrowload_aliases_with_multiple_batches():
    """
    Test that the variable name aliasing succeeds when the arrow file is read in multiple
    batched
    """
    return_code, output, _ = run_stata(
        "analysis/arrowload/arrowload-batches-aliased.do"
    )
    assert "i3a aliased to aliased_i3a" in output
    assert "s1 aliased to aliased_s1" in output
    assert return_code == 0
