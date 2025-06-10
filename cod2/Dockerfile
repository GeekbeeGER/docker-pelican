# ------------------------------------------------------------------
#  STAGE 1: Basis-Setup und Abhängigkeiten
# ------------------------------------------------------------------
# Wir verwenden ein sauberes i386-Image.
FROM --platform=$TARGETOS/$TARGETARCH i386/debian:bookworm-slim

# Metadaten
LABEL author="Geekbee" maintainer="support@bawialnia.biz"

# Umgebungsvariablen
ENV USER=container \
    HOME=/home/container \
    DEBIAN_FRONTEND=noninteractive

# Installiere NUR die Werkzeuge, die für den Download und den Betrieb nötig sind.
# KEINE Spieldateien werden hier kopiert.
RUN apt-get update && \
    dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        wget \
        tar \
        xz-utils \
        libgcc-s1 \
        libstdc++6 && \
    # Erstelle den unprivilegierten Benutzer
    useradd -m -d ${HOME} -s /bin/bash ${USER} && \
    # Räume den Apt-Cache auf
    rm -rf /var/lib/apt/lists/*

# ------------------------------------------------------------------
#  STAGE 2: Entrypoint und finale Konfiguration
# ------------------------------------------------------------------
# Wechsle zum unprivilegierten Benutzer.
USER ${USER}
WORKDIR ${HOME}

# Kopiere das Entrypoint-Skript. Dieses Skript wird die MAGIE vollbringen.
# ANNAHME: Das Skript liegt im Unterordner 'bin' deines Projekts.
COPY --chown=container:container ./bin/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Setze den Entrypoint.
ENTRYPOINT [ "/entrypoint.sh" ]

# Der CMD-Befehl wird vom Panel überschrieben.
CMD ["/bin/bash"]
