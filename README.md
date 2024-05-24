# Stata-docker

A Docker image for running Stata within the OpenSAFELY framework.

It expects a study repo to be mounted at `/workspace` and take a path relative
to that to execute. e.g. from a study directory:

```sh
 docker run --rm -e STATA_LICENSE -v $PWD:/workspace stata-mp analysis/model.do
```

The currently packaged version is 16.1, and requires a valid license for
Stata-mp in the environment as `STATA_LICENSE` e.g.

    export STATA_LICENSE=$(cat /path/to/stata.lic)

Usually the license is taken care of by the OpenSAFELY platform

## Extra libraries

Comes with the following stata libraries/commands installed:

  - datacheck:https://ideas.repec.org/c/boc/bocode/s457246.html
  - itsa: https://ideas.repec.org/c/boc/bocode/s457793.html
  - gzsave: https://ideas.repec.org/c/boc/bocode/s446701.html
  - safetab: ?
  - safecount: ?
  - arrowload: ?

If you require extra stata libraries, you can add them to a `./libraries`
directory in your study, and they will be available for you to use.


## Upgrading Stata

To build, install Stata locally, apply your licence, and then copy the
following into the `bin/` subdirectory:

* `/usr/local/stata/bin/stata*`
* `/usr/local/stata/bin/stinit`
* `/usr/local/stata/bin/ado/`
* `/usr/local/stata/utilities/`


## Relicensing Stata

This docker image contains the machinery needed to generate a license key file from valid license details.

There are specific instructions for regenerating the OpenSAFELY license key for Bennett Institute staff here:
https://bennettinstitute-team-manual.pages.dev/tech-group/playbooks/stata-license/

In general, to generate a new license file, first obtain the new details (provided in a PDF file on license renewal):

 - serial number: 12 digit number, e.g. "12345678901"
 - code: 46 character string with spaces, e.g. "abcd efgh ijkl abcd efgh ijkl abcd efgh ijkl a"
 - authorisation: 4 character string, e.g. "wxyz"

Then run:

    docker run --rm -v $PWD:/src -w /usr/local/stata --entrypoint /src/scripts/renew-license.sh \
        ghcr.io/opensafely-core/stata-mp \
        'SERIAL' 'CODE' 'AUTH'

Note the single quotes to ensure the code/auth are passed literally.

The resulting file will be copied to `./stata.lic` You can test this works with:

    ./scripts/test-license.sh

The process above uses the current stata-mp docker image to run stata's
`stinit` process which can validate the license details.  This script is
interactive, so we use the `expect` tool to provide it the input it needs (see
`scripts/stinit.exp`).
