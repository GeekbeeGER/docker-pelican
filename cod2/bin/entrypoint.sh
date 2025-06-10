# STAGE 1: Basis-Setup und Abhängigkeiten
FROM --platform=$TARGETOS/$TARGETARCH i386/debian:bookworm-slim

LABEL author="Geekbee" maintainer="support@bawialnia.biz"

ENV USER=container \
    HOME=/home/container \
    DEBIAN_FRONTEND=noninteractive

# Führe ALLE Shell-Befehle innerhalb EINER RUN-Anweisung aus.
RUN apt-get update && \
    dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        wget \
        tar \
        xz-utils \
        libgcc-s1 \
        libstdc++6 \
        libstdc++5 && \
    # useradd ist ein Shell-Befehl, daher muss er hier stehen.
    useradd -m -d ${HOME} -s /bin/bash ${USER} && \
    # Räume den Apt-Cache auf.
    rm -rf /var/lib/apt/lists/*

# STAGE 2: Finale Konfiguration
USER ${USER}
WORKDIR ${HOME}

# Kopiere das Entrypoint-Skript.
COPY --chown=container:container ./bin/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]

CMD ["/bin/bash"]
