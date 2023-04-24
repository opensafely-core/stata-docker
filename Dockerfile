# syntax=docker/dockerfile:1.2
#################################################
#
# We need base python dependencies on both the builder and python images, so
# create base image with those installed to save installing them twice.
#
# hadolint ignore=DL3006
FROM ghcr.io/opensafely-core/base-action:22.04 as base

# Add deadsnakes PPA for installing new Python versions
# ensure fully working base python3.11 installation
# see: https://gist.github.com/tiran/2dec9e03c6f901814f6d1e8dad09528e
# use space efficient utility from base image

RUN --mount=type=cache,target=/var/cache/apt \
    echo "deb http://ppa.launchpad.net/deadsnakes/ppa/ubuntu jammy main" > /etc/apt/sources.list.d/deadsnakes-ppa.list &&\
    /usr/lib/apt/apt-helper download-file 'https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xf23c5a6cf475977595c89f51ba6932366a755776' /etc/apt/trusted.gpg.d/deadsnakes.asc

# stata needs libpng16, install python dependencies
COPY packages.txt /root/packages.txt
RUN --mount=type=cache,target=/var/cache/apt \
    /root/docker-apt-install.sh /root/packages.txt

##################################################
#
# Build image
#
# Ok, now we have local base image with python and our system dependencies on.
# We'll use this as the base for our builder image, where we'll build and
# install any python packages needed.
#
# We use a separate, disposable build image to avoid carrying the build
# dependencies into the production image.
FROM base as builder

# Install any system build dependencies
COPY build-dependencies.txt /tmp/build-dependencies.txt
RUN --mount=type=cache,target=/var/cache/apt \
    /root/docker-apt-install.sh /tmp/build-dependencies.txt

# Install python packages
# The cache mount means a) /root/.cache is not in the image, and b) it's preserved
# between docker builds locally, for faster dev rebuild.
COPY python-requirements.txt /tmp/python-requirements.txt

# DL3042: using cache mount instead
# DL3013: we always want latest pip/setuptools/wheel, at least for now
# Install with the --user option so we can copy dependencies in the final image
#
# Note that we can't use a venv here because stata gets itself confused
# Using a venv runs into the same error seen here with embedded python in swift
# https://discuss.python.org/t/fatal-python-error-init-fs-encoding-failed-to-get-the-python-codec-of-the-filesystem-encoding/3173/11
# hadolint ignore=DL3042,DL3013
RUN --mount=type=cache,target=/root/.cache \
    python3.11 -m pip install -U --user pip setuptools wheel && \
    python3.11 -m pip install --user  --require-hashes  --requirement /tmp/python-requirements.txt


##################################################

FROM base as stata-prod

# copy /root/.local files over from builder image to get the installed python dependencies.
# These will have root:root ownership, but are readable by all.
COPY --from=builder /root/.local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
# Set PYTHONPATH to ensure they're found even when user is not root
ENV PYTHONPATH=/usr/local/lib/python3.11/site-packages

# Some static metadata for this specific image, as defined by:
# https://github.com/opencontainers/image-spec/blob/master/annotations.md#pre-defined-annotation-keys
# The org.opensafely.action label is used by the jobrunner to indicate this is
# an approved action image to run.
LABEL org.opencontainers.image.title="stata-mp" \
      org.opencontainers.image.description="Stata action for opensafely.org" \
      org.opencontainers.image.source="https://github.com/opensafely-core/stata-docker" \
      org.opensafely.action="stata-mp"

ENV STATA_SITE=/usr/local/ado
RUN mkdir -p /usr/local/stata /workspace $STATA_SITE && \
    chmod 777 $STATA_SITE && \
    ln -s /tmp/stata.lic /usr/local/stata/stata.lic
WORKDIR /workspace

COPY bin/ /usr/local/stata
COPY stata-wrapper.sh /usr/local/bin/stata
COPY stata-wrapper.sh /usr/local/bin/stata-mp
COPY libraries/* $STATA_SITE/
COPY python_scripts/ /python_scripts
COPY script-wrapper.sh /usr/local/bin/script-wrapper.sh
ENV ACTION_EXEC="/usr/local/bin/script-wrapper.sh"

# tag with build info as the very last step, as it will never be cached
ARG BUILD_DATE
ARG VERSION
LABEL org.opencontainers.image.created=$BUILD_DATE org.opencontainers.image.revision=$VERSION
