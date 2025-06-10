# ------------------------------------------------------------------
#  STAGE 1: Basis-Setup und Abhängigkeiten
# ------------------------------------------------------------------
# Wir verwenden das offizielle i386-Image. Das ist ideal für 32-Bit-Spiele.
FROM --platform=$TARGETOS/$TARGETARCH i386/debian:bookworm-slim

# Metadaten für das Image
LABEL author="Geekbee" maintainer="support@bawialnia.biz"
LABEL org.opencontainers.image.licenses=GPLv3

# Umgebungsvariablen für eine saubere Konfiguration
ENV USER=container \
    HOME=/home/container \
    DEBIAN_FRONTEND=noninteractive

# Installiere alle notwendigen Systempakete als ROOT
# HINWEIS: Die 'lib32'-Präfixe werden in einem nativen i386-Image nicht benötigt.
RUN apt-get update && \
    # Stelle sicher, dass die i386-Architektur bekannt ist (doppelt hält besser)
    dpkg --add-architecture i386 && \
    apt-get update && \
    # Installiere die Pakete mit den korrekten Namen für i386
    apt-get install -y --no-install-recommends \
        wget \
        tar \
        xz-utils \
        libgcc-s1 \
        libstdc++6 \
        locales \
        tzdata && \
    # Konfiguriere die Locales für UTF-8-Unterstützung
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8 && \
    # Erstelle den unprivilegierten Benutzer für den Serverbetrieb
    useradd -m -d ${HOME} -s /bin/bash ${USER} && \
    # Räume den Apt-Cache auf, um das Image klein zu halten
    rm -rf /var/lib/apt/lists/*

# ------------------------------------------------------------------
#  STAGE 2: Installation der Call of Duty 2 Serverdateien
# ------------------------------------------------------------------
# Setze das Arbeitsverzeichnis auf das Home-Verzeichnis des neuen Benutzers
WORKDIR ${HOME}

# Kopiere die CoD2-Serverdateien in das Arbeitsverzeichnis des Containers.
# ANNAHME: Die CoD2-Dateien (`cod2_lnxded`, `main`-Ordner etc.)
# liegen im gleichen Verzeichnis wie dieses Dockerfile.
# --chown sorgt dafür, dass die Dateien dem korrekten Benutzer gehören.
COPY --chown=container:container . .

# Mache die Server-Executable ausführbar.
# Dieser Schritt ist KRITISCH und löst "No such file or directory" oder "Permission denied"-Fehler.
RUN chmod +x ./cod2_lnxded

# ------------------------------------------------------------------
#  STAGE 3: Finale Konfiguration und Entrypoint
# ------------------------------------------------------------------
# Wechsle jetzt endgültig zum unprivilegierten Benutzer.
# Alles, was ab hier passiert, wird als 'container'-Benutzer ausgeführt.
USER ${USER}

# Kopiere den Entrypoint und mache ihn ausführbar.
# Dieses Skript wird als erstes ausgeführt, wenn der Container startet.
COPY --chown=container:container ./bin/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

# Der CMD-Befehl dient als Standard-Aktion, wird aber vom Pelican Panel
# überschrieben. Der "Startup Command" aus dem Panel wird stattdessen
# an den ENTRYPOINT als Argument übergeben.
CMD ["./cod2_lnxded"]
