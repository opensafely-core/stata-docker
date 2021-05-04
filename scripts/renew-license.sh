#!/bin/bash
set -euo pipefail
# run expect script to feed input to stinit
/src/scripts/stinit.exp "$1" "$2" "$3"
# copy resulting license file out
cp stata.lic /src/stata.lic
echo "New license file: ./stata.lic"
