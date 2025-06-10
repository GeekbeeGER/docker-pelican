# STAGE 1: Basis-Setup und Abhängigkeiten
FROM --platform=$TARGETOS/$TARGETARCH i386/debian:bookworm-slim

LABEL author="Geekbee" maintainer="support@bawialnia.biz"

ENV USER=container \
    HOME=/home/container \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        wget \
        tar \
        xz-utils \
        libgcc-s1 \
        libstdc++6 && \
    useradd -m -d ${HOME} -s /bin/bash ${USER} && \
    rm -rf /var/lib/apt/lists/*

# STAGE 2: Finale Konfiguration
USER ${USER}
WORKDIR ${HOME}

# Kopiere NUR das Entrypoint-Skript.
COPY --chown=container:container ./bin/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]

CMD ["/bin/bash"]
