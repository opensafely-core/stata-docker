#!/bin/bash
set -euo pipefail

test -z "${STATA_LICENSE:-}" && { echo "No STATA_LICENSE environment variable found"; exit 1; }
echo "$STATA_LICENSE" >  /tmp/stata.lic

# make any local study libraries automatically available
if test -d /workspace/libraries; then
    for lib in /workspace/libraries/*.ado; do
        ln -sf "$lib" "$STATA_SITE/"
    done
fi

exec /usr/local/stata/stata-mp "$@"
