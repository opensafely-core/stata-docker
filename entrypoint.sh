#!/bin/bash
set -euo pipefail

test -z "${STATA_LICENSE:-}" && { echo "No STATA_LICENSE environment variable found"; exit 1; }
echo "$STATA_LICENSE" > /usr/local/stata/stata.lic

script="$1"
shift

test -f "$script" || { echo "$script does not exist"; exit 1; }

# make any local study libraries automatically available
if test -d /workspace/libraries; then
    for lib in /workspace/libraries/*.ado; do
        ln -s "$lib" /root/ado/plus/
    done
fi

# Stata is super odd in its cli interactions and behaviour. It will never exit
# with anything except code 0. It does stop on error however, but only when
# running a script. So we wrap the actual script with a wrapper that runs the
# original script, and then writes that has succeeded to a file. Because we are
# running a script, if there is an error, it will stop, and not write the file,
# so we can use this as a proxy for success or failure.
success=$(mktemp)
wrapper=${script%.do}.wrapper.do

# batch mode writes output for script.do to script.log in PWD, so we preserve that
# behaviour
script_name=$(basename "$script")
log=${script_name%.do}.log

cat <<EOF > "$wrapper"
. do "$script" $@
. file open output using "$success", write text replace
. file write output "success" 
. file close output
EOF

# clean up wrapper afterwards, or else it leaves files owned by root in /workspace
trap 'rm -f $wrapper' EXIT

/usr/local/stata/stata "$wrapper" "$@" < /dev/null | tee "$log"

# exit cleanly if we find the file has been written
grep -q success "$success" 2>/dev/null
