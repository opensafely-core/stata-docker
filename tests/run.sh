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
    docker run --rm -e STATA_LICENSE="$STATA_LICENSE" -v "$PWD/tests:/workspace" "$image" "$script" > "$output" || code=$?
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

assert-output() {
    local msg=$1
    shift
    if grep -q "$@" "$output"; then
        pass "$msg"
    else
        fail "$msg"
    fi
}


try "basic stata succeeds" success.do
assert-output "OK in output" "^OK"

fail "bad stata errors" failure.do


exit $error
