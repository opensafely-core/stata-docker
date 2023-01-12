#!/bin/bash
set -euo pipefail

test -z "${STATA_LICENSE:-}" && { echo "No STATA_LICENSE environment variable found"; exit 1; }
echo "$STATA_LICENSE" >  /tmp/stata.lic

exec /usr/local/stata/stata-mp "$@"
