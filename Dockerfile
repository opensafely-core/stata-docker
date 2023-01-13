# syntax=docker/dockerfile:1.2
#################################################
#
# We need base python dependencies on both the builder and python images, so
# create base image with those installed to save installing them twice.
#
# DL3007 ignored because base-docker a) doesn't have any other tags currently,
# and b) we specifically always want to build on the latest base image, by
# design.
#
# hadolint ignore=DL3006
FROM ghcr.io/opensafely-core/base-action

# Some static metadata for this specific image, as defined by:
# https://github.com/opencontainers/image-spec/blob/master/annotations.md#pre-defined-annotation-keys
# The org.opensafely.action label is used by the jobrunner to indicate this is
# an approved action image to run.
LABEL org.opencontainers.image.title="stata-mp" \
      org.opencontainers.image.description="Stata action for opensafely.org" \
      org.opencontainers.image.source="https://github.com/opensafely-core/stata-docker" \
      org.opensafely.action="stata-mp"


# stata needs libpng16
COPY packages.txt /root/packages.txt
RUN /root/docker-apt-install.sh /root/packages.txt

ENV STATA_SITE=/usr/local/ado
RUN mkdir -p /usr/local/stata /workspace $STATA_SITE && \
    chmod 777 $STATA_SITE && \
    ln -s /tmp/stata.lic /usr/local/stata/stata.lic
WORKDIR /workspace

COPY bin/ /usr/local/stata
COPY stata-wrapper.sh /usr/local/bin/stata
COPY stata-wrapper.sh /usr/local/bin/stata-mp
COPY libraries/* $STATA_SITE/
COPY script-wrapper.sh /usr/local/bin/script-wrapper.sh
ENV ACTION_EXEC="/usr/local/bin/script-wrapper.sh"

# tag with build info as the very last step, as it will never be cached
ARG BUILD_DATE
ARG VERSION
LABEL org.opencontainers.image.created=$BUILD_DATE org.opencontainers.image.revision=$VERSION
