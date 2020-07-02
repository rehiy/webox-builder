FROM ubuntu:18.04

COPY builder /srv

RUN chmod +x /srv/cell-* \
    && cd /srv && ./cell-build \
    && cd /srv && ./cell-minify
