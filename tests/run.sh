#!/bin/bash
set -euo pipefail

image=${1:-stata-mp-local}
error=0
output=$(mktemp)

pass() { echo "PASS: $*"; }

fail() { echo "FAIL: $*"; error=1; }


try() {
    local msg=$1
    local script=$2
    local fail=${3:-}
    code=0
    docker run --rm -e STATA_LICENSE -v "$PWD/tests:/workspace" "$image" "$script" > "$output" || code=$?
    if test "$code" == "0"; then
        if test -n "$fail"; then
            fail "$msg"
        else
            pass "$msg"
        fi
    else
        if test -n "$fail"; then
            pass "$msg"
        else
            fail "$msg"
        fi
 
    fi
}

fail() {
    try "$1" "$2" fail
}

assert-content() {
    local msg=$1
    local file=$2
    shift
    if grep -q "$@" "$file"; then
        pass "$msg"
    else
        fail "$msg"
    fi
}


trap 'docker run --rm -e STATA_LICENSE -v "$PWD/tests:/workspace" --entrypoint bash "$image" -c "rm *.log"' EXIT

try "basic stata succeeds" success.do
assert-content "OK in output" "^OK" "$output"
assert-content "OK in log" "^OK" "tests/success.log"

fail "bad stata errors" failure.do
assert-content "error in output" "badstring" "$output"
assert-content "error in log" "badstring" "tests/failure.log"


exit $error
