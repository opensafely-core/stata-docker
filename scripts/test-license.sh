#!/bin/bash
set -euo pipefail
test -f stata.lic || { echo "No stata.lic file in current directory"; exit 1; }

tmp=$(mktemp -d)
echo 'display "LICENSE OK"' > "$tmp/test.do"
docker run --rm -v "$tmp:/workspace" -e STATA_LICENSE="$(cat stata.lic)" ghcr.io/opensafely-core/stata-mp test.do
if grep -q '^LICENSE OK' "$tmp/test.log"; then
    echo "License OK"
else
    echo "License error"
    cat "$tmp/test.log"
    exit 1
fi
