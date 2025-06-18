# VERWENDE DEBIAN BULLSEYE (64-BIT)
FROM debian:bullseye-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV WINEARCH=win64
ENV WINEPREFIX=/mnt/server/.wine

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        wget \
        ca-certificates \
        tar \
        xz-utils \
        wine64 \
        lib32gcc-s1 && \
    rm -rf /var/lib/apt/lists/*

RUN useradd --system --home /home/container --shell /bin/bash container

RUN mkdir -p /mnt/server /home/container/steamcmd && \
    chown -R container:container /mnt/server /home/container

USER container
WORKDIR /home/container

RUN wget -qO- https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz | tar xvz -C ./steamcmd

WORKDIR /mnt/server

# HIER IST DIE WICHTIGE ÄNDERUNG: Der Pfad zur entrypoint.sh wurde korrigiert.
COPY --chown=container:container bin/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
