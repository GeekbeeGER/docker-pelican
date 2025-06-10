# VERWENDE DEBIAN BUSTER
FROM i386/debian:buster-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        wget \
        tar \
        xz-utils \
        libstdc++5 && \
    useradd --system --home /home/container --shell /bin/bash container && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /home/container

COPY bin/entrypoint.sh /entrypoint.sh
# DIES IST DER ENTSCHEIDENDE BEFEHL, UM DEN "READ-ONLY" FEHLER ZU BEHEBEN
RUN chown -R container:container /home/container && chmod +x /entrypoint.sh

USER container
ENTRYPOINT ["/entrypoint.sh"]
