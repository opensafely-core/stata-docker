#!/bin/bash
set -euo pipefail

test -n "$STATA_LICENSE" || { echo "No STATA_LICENSE detected"; exit 1; }

image=${1:-stata-mp-local}
error=0
output=$(mktemp)

show-pass() { echo "PASS: $*"; }

show-fail() { echo "FAIL: $*"; error=1; }


run-docker() {
    docker run --rm -e STATA_LICENSE -v "$PWD/tests:/workspace" "$image" "$@" > "$output"
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


trap 'docker run --rm -e STATA_LICENSE -v "$PWD/tests:/workspace" --entrypoint /bin/bash "$image" -c "rm -f *.log"' EXIT

try "basic stata succeeds" analysis/success.do a b c
assert-content "OK in output" "$output" "^OK" 
assert-content "OK in log" "tests/success.log" "^OK"
assert-content "cli args in output" "$output" "aXbXc" 
assert-content "cli args in log" "tests/success.log" "aXbXc"

fail "bad stata errors" analysis/failure.do
assert-content "error in output" "$output" "badstring"
assert-content "error in log" "tests/failure.log" "badstring"


exit $error
