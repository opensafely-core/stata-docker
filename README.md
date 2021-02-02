# Stata-docker

The currently packaged version is 16.1

A docker image for running stata within the OpenSAFELY framework.

As such, it expects a checked-out study repo to be mounted at `/workspace`, thus:

```sh
 docker run --mount source=$(pwd),dst=/workspace,type=bind stata-mp analysis/model.do
```

## Upgrading stata

To build, install stata locally, apply your licence, and then copy the
following into the `bin/` subdirectory:

* `/usr/local/stata/bin/stata*`
* `/usr/local/stata/bin/ado/`
* `/usr/local/stata/utilites/`

## Relicensing stata

To relicense, apply the licence locally, and then copy
`/usr/local/stata/stata.lic` into `bin/`.
