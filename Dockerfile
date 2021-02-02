FROM ghcr.io/opensafely/base-docker

# stata needs libpng16
RUN apt-get update && apt-get install -y libpng16-16  python3

RUN mkdir -p /usr/local/stata
COPY bin/ /usr/local/stata

RUN mkdir /workspace
WORKDIR /workspace
RUN mkdir -p /root/ado/plus
COPY libraries/ /root/ado/plus
COPY entrypoint.py /tmp

ENTRYPOINT ["/usr/bin/python3", "/tmp/entrypoint.py"]
