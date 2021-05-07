#!/bin/bash
set -euo pipefail

test -z "${STATA_LICENSE:-}" && { echo "No STATA_LICENSE environment variable found"; exit 1; }
echo "$STATA_LICENSE" > /usr/local/stata/stata.lic

script=$1
shift

test -f "$script" || { echo "$script does not exist"; exit 1; }

# stata is super odd in its cli interactions and behaviour. So we wrap up the
# actual script

tmp=$(mktemp)
wrapper=wrapper.$script
cat <<EOF > "$wrapper"
. do "$script"
. file open output using "$tmp", write text replace
. file write output "success" 
. file close output
EOF

# make any local study libraries automatically available
if test -d /workspace/libraries; then
    for lib in /workspace/libraries/*.ado; do
        ln -s "$lib" /root/ado/plus/
    done
fi

/usr/local/stata/stata "$wrapper" "$@" < /dev/null

# exit cleanly if we find the file has been written
grep -q success "$tmp" 2>/dev/null
