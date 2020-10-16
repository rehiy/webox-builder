FROM ubuntu:18.04

COPY builder /opt/build

RUN chmod +x /opt/build/* \
    && cd /opt/build && ./cell-build \
    && cd /opt/build && ./dist-minify
