# Stata-docker

The currently packaged version is 16.1

A Docker image for running Stata within the OpenSAFELY framework.

As such, it expects a checked-out study repo to be mounted at `/workspace`, thus:

```sh
 docker run --mount source=$(pwd),dst=/workspace,type=bind stata-mp analysis/model.do
```

## Upgrading Stata

To build, install Stata locally, apply your licence, and then copy the
following into the `bin/` subdirectory:

* `/usr/local/stata/bin/stata*`
* `/usr/local/stata/bin/stinit`
* `/usr/local/stata/bin/ado/`
* `/usr/local/stata/utilities/`


## Relicensing Stata

The docker image contains the machinery needed to update the license. To
generate a new license file, first obtain the new serial number, code, and
authorisation. Then run:

    docker run --rm -v $PWD:/src -w /usr/local/stata --entrypoint /src/scripts/renew-license.sh ghcr.io/opensafely-core/stata-mp "SERIAL" "CODE" "AUTH"

The resulting file will be copied to `./stata.lic` (note: due to docker
shenanigans, it will be owned by root). You can test this works with:

    ./scripts/test-license.sh

The contents of this license file can then be used to update the `STATA_LICENSE`
env var for job-runner. You should also update the `stata.lic` file in
[https://github.com/opensafely/server-instructions](https://github.com/opensafely/server-instruction)
to the new version.

The process above uses the current stata-mp docker image to run stata's
`stinit` process which can validate the license details.  This script is
interactive, so we use the `expect` tool to provide it the input it needs (see
`scripts/stinit.exp`).

