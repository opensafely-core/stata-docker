#!/bin/bash
set -euo pipefail

test -n "$STATA_LICENSE" || { echo "No STATA_LICENSE detected"; exit 1; }
user="$(id -u):$(id -g)"
image=${1:-stata-mp-local}
error=0
output=$(mktemp)

show-pass() { echo "PASS: $*"; }

show-fail() { echo "FAIL: $*"; error=1; }


run-docker() {
    docker run --rm --user "$user" -e STATA_LICENSE -v "$PWD/tests:/workspace" "$image" "$@" > "$output"
}


try() {
    local msg=$1
    shift
    if run-docker "$@"; then
        show-pass "$msg"
    else
        show-fail "$msg"
    fi
}

fail() {
    local msg=$1
    shift
    if run-docker "$@"; then
        show-fail "$msg"
    else
        show-pass "$msg"
    fi
}

assert-content() {
    local msg=$1
    local file=$2
    shift; shift
    if grep -q "$@" "$file"; then
        show-pass "$msg"
    else
        show-fail "$msg"
    fi
}

# cleanup before we start
rm -f tests/*.log
rm -f tests/output/*


try "basic stata succeeds" analysis/success.do a b c
assert-content "OK in output" "$output" "^OK"
assert-content "OK in log" "tests/success.log" "^OK"
assert-content "cli args in output" "$output" "aXbXc"
assert-content "cli args in log" "tests/success.log" "aXbXc"

fail "bad stata errors" analysis/failure.do
assert-content "error in output" "$output" "badstring"
assert-content "error in log" "tests/failure.log" "badstring"

# this tests both the gunzip functionality and also that shipped libraries are
# loaded properly by stata
#
# create a gzipped csv as input
echo -e "a,b,c\n1,2,3" > tests/output/input.csv
gzip tests/output/input.csv

# try load it, and write it out as a compressed dta
try "handle gzip csv data" analysis/gz.do
assert-content "data was ungzipped" "tests/output/input.csv" "1,2,3"

# validate the compressed dta
gunzip tests/output/model.dta.gz
assert-content "dta file was ungzipped" "tests/output/model.dta" "<stata_dta>"

try "load custom libraries" analysis/custom.do
assert-content "custom command called" "tests/custom.log" "custom command called"

cp tests/fixtures/*.arrow tests/output/
# Load the arrow file; contains:
# 1000 variables, processed as a single batch
# b1: boolean
# d1: date, d1a: date with nulls
# t1: timestamp, t1a: timestamp with nulls
# i1, i2, i3: integers fitting byte/int/long vars in stata
# i1a, i2a, i3a: as above, with nulls
# i4: int64 var, too big for stata int, converted to string
# i4a: as i4, with nulls
# f1, f1a: float, with and without nulls
# s1, s1a: i4/i4a values, already converted to string before loading
# c1, c1a: category (A, B, C, D), with and without nulls
try "load arrow file" analysis/arrowload/arrowload.do
assert-content "Contains expected observations" "$output" "obs:         1,000"
assert-content "Contains expected batches (1)" "$output" "Reading batch 1 of 1"
assert-content "Contains expected variable b1" "$output" "b1              byte"
assert-content "Contains expected variable d1" "$output" "d1              long"
assert-content "Contains expected variable d1a" "$output" "d1a             long"
assert-content "Contains expected variable t1" "$output" "t1              double"
assert-content "Contains expected variable t1a" "$output" "t1a             double"
assert-content "Contains expected variable i1" "$output" "i1              byte"
assert-content "Contains expected variable i1a" "$output" "i1a             byte"
assert-content "Contains expected variable i2" "$output" "i2              int"
assert-content "Contains expected variable i2a" "$output" "i2a             int"
assert-content "Contains expected variable i3" "$output" "i3              long"
assert-content "Contains expected variable i3a" "$output" "i3a             long"
assert-content "Contains expected variable i4" "$output" "i4              str11"
assert-content "Contains expected variable i4a" "$output" "i4a             str11"
assert-content "Contains expected variable f1" "$output" "f1              float"
assert-content "Contains expected variablef1a" "$output" "f1a             float"
assert-content "Contains expected variable s1" "$output" "s1              str11"
assert-content "Contains expected variable s1a" "$output" "s1a             str11"
assert-content "Contains expected variable c1" "$output" "c1              byte"
assert-content "Contains expected variable c1a" "$output" "c1a             byte"

expected_b1_c1_c1a_row1="1.    1    A     A"
expected_b1_c1_c1a_row2="2.    1    A     ."
expected_b1_c1_c1a_row1000="1000.    0    C     C"
assert-content "Contains expected bool/category values (row 1)" "$output" "$expected_b1_c1_c1a_row1"
assert-content "Contains expected bool/category values (row 2)" "$output" "$expected_b1_c1_c1a_row2"
assert-content "Contains expected bool/category values (row 1000)" "$output" "$expected_b1_c1_c1a_row1000"

expected_date_ts_row1="1.   01oct2023   01oct2023   01oct2023 10:30:00   01oct2023 10:30:00"
expected_date_ts_row2="2.   01oct2023           .   01oct2023 10:30:00                    ."
expected_date_ts_row1000="1000.   01dec2023   01dec2023   01oct2023 22:30:00   01oct2023 22:30:00"
assert-content "Contains expected date/ts values (row 1)" "$output" "$expected_date_ts_row1"
assert-content "Contains expected date/ts values (row 2)" "$output" "$expected_date_ts_row2"
assert-content "Contains expected date/ts values (row 1000)" "$output" "$expected_date_ts_row1000"

expected_integer_row1="1.   10    10   2000   2000   100000   100000"
expected_integer_row2="2.   10     .   2000      .   100000        ."
expected_integer_row1000="1000.   -12   -12   -350   -350   -200000   -200000"
assert-content "Contains expected byte/int/long values (row 1)" "$output" "$expected_integer_row1"
assert-content "Contains expected byte/int/long values (row 2)" "$output" "$expected_integer_row2"
assert-content "Contains expected byte/int/long values (row 1000)" "$output" "$expected_integer_row1000"

expected_str_row1="1.   2500000000   2500000000   2500000000   2500000000"
expected_str_row2="2.   2500000000                2500000000             "
expected_str_row1000="1000.   -2700000000   -2700000000   -2700000000   -2700000000"
assert-content "Contains expected string values (row 1)" "$output" "$expected_str_row1"
assert-content "Contains expected string values (row 2)" "$output" "$expected_str_row2"
assert-content "Contains expected string values (row 1000)" "$output" "$expected_str_row1000"

# Load the big arrow file; contains:
# 1,000,000 observations variables, processed as two batches
# all the same variables as before
try "load arrow file" analysis/arrowload/arrowload-batches.do
assert-content "Contains expected observations" "$output" "obs:       100,000"
assert-content "Contains expected batches (2)" "$output" "Reading batch 1 of 2"

# just check the types of the integer types; test data is set up so that the
# first batch contains all byte-sized ints; vars are re-cast on the second batch
assert-content "Contains expected variable i1" "$output" "i1              byte"
assert-content "Contains expected variable i2" "$output" "i2              int"
assert-content "Contains expected variable i3" "$output" "i3              long"
# the i4 var is still cast to str11, although in the first batch it would be initially
# created as byte
assert-content "Contains expected variable i4" "$output" "i4              str11"

fail "load arrow file with too-long names" analysis/arrowload/arrowload-too-long.do
assert-content "Invalid variable name error in output" "$output" "Invalid variable names found"

try "load arrow file with aliased too-long names" analysis/arrowload/arrowload-too-long-aliased.do

fail "load arrow file with bad aliases" analysis/arrowload/arrowload-bad-aliases.do
assert-content "Aliases error found in output" "$output" "aliases longer than the allowed length"

try "load arrow file with config file not found" analysis/arrowload/arrowload-configfile-not-found.do
assert-content "Warning in output" "$output" "WARNING: Config file not found"

try "load arrow file with no alias headers in config file (single line)" analysis/arrowload/arrowload-no-aliases-headers-1.do
assert-content "Warning in output" "$output" "WARNING: No data found in configfile"

try "load arrow file with no alias headers in config file (multiline)" analysis/arrowload/arrowload-no-aliases-headers-2.do
assert-content "Warning in output" "$output" "WARNING: file does not contain expected column headers for aliases"

exit $error
