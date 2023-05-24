#!/bin/bash
set -euo pipefail
apt update --yes
apt install expect --yes --no-install-recommends
# stinit expects a binary called stata, but we only ship the stata-mp binary to save space
# so fake it
ln -s /usr/local/stata/stata-mp /usr/local/stata/stata
# run expect script to feed input to stinit
/src/scripts/stinit.exp "$1" "$2" "$3"
# copy resulting license file out
cp stata.lic /src/stata.lic
echo "New license file: ./stata.lic"
