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

cp tests/fixtures/data.arrow tests/output/data.arrow
# Load the arrow file; contains:
# 1000 variables, loaded in batches of 600
# - date vars: `date` has no nulls, `died_on`` includes nulls
# - boolean: `flag`
# - int: `age`, `patient_id` (int64 in feather file, int in stata)
# - categorical: sex (coded M/F as 0/1, no nulls), region (includes nulls)
# - num_val: int64 in feather file (values with mean 50,000), converted to long in stata
try "load arrow file" analysis/arrowload.do
expected_var_names="date   died_on   flag   age   sex      region   num_val   patient_id"
expected_values_row1="22560         .      0    69     F        .     49850         1293"
expected_formatted_values_row1="07oct2021         .      0    69     F        .     49850         1293"
expected_formatted_values_row4="24jul2021         .      1    52     F   E12000003     50236         8097"
assert-content "Contains expected observations" "$output" "obs:         1,000"
assert-content "Contains expected int variable" "$output" "age             int"
assert-content "Contains expected long variable" "$output" "num_val         long"
assert-content "Contains expected variable names" "$output" "$expected_var_names"
assert-content "Contains expected values (row 1)" "$output" "$expected_values_row1"
assert-content "Contains expected formatted values (row 1)" "$output" "$expected_formatted_values_row1"
assert-content "Contains expected formatted values (row 4)" "$output" "$expected_formatted_values_row4"

exit $error
