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
# 1000 variables, loaded in batches of 600
# - date vars: `date` has no nulls, `died_on`` includes nulls
# - boolean: `flag`
# - int: `age`, `patient_id` (int64 in feather file, int in stata)
# - categorical: sex (coded M/F as 0/1, no nulls), region (includes nulls)
# - num_val: int64 in feather file (values around 50,000; < int32 max), converted to long in stata
# - big_val: int64 in feather file (values > int32 max), converted to string
try "load arrow file" analysis/arrowload/arrowload.do
expected_var_names="patient_id    date   died_on   flag   age   sex   region   num_val"
expected_values_row1="1   10562         .      1    34     .     East     50034"
expected_formatted_values_row1="1   01dec1988         .      1    34     .     East     50034"
expected_formatted_values_row4="4   01dec2007         .      0    15     .   London     50015"
assert-content "Contains expected observations" "$output" "obs:         1,000"
assert-content "Contains expected int variable" "$output" "age             int"
assert-content "Contains expected long variable" "$output" "num_val         long"
assert-content "Contains expected string variable" "$output" "big_val         strL"
assert-content "Contains expected variable names" "$output" "$expected_var_names"
assert-content "Contains expected values (row 1)" "$output" "$expected_values_row1"
assert-content "Contains expected value for big_val (row 1)" "$output" "3147483655"
assert-content "Contains expected formatted values (row 1)" "$output" "$expected_formatted_values_row1"
assert-content "Contains expected formatted values (row 4)" "$output" "$expected_formatted_values_row4"

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
