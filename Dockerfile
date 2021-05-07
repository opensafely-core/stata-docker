FROM ghcr.io/opensafely-core/base-docker

# stata needs libpng16
RUN apt-get update && apt-get install -y libpng16-16 libtinfo5 libncurses5 python3 expect

RUN mkdir -p /usr/local/stata
COPY bin/ /usr/local/stata

RUN mkdir /workspace
WORKDIR /workspace
RUN mkdir -p /root/ado/plus
COPY libraries/ /root/ado/plus
COPY entrypoint.py /root/

ENTRYPOINT ["/usr/bin/python3", "/root/entrypoint.py"]
