# VERWENDE DEBIAN BULLSEYE (64-BIT), DA SCUM EINE 64-BIT ANWENDUNG IST
FROM debian:bullseye-slim

# Setze Umgebungsvariablen
ENV DEBIAN_FRONTEND=noninteractive
ENV WINEARCH=win64
ENV WINEPREFIX=/mnt/server/.wine

# Installiere notwendige Pakete für Wine, SteamCMD und den SCUM-Server
# 1. Füge i386-Architektur für SteamCMD-Abhängigkeiten hinzu
# 2. Update Paketlisten
# 3. Installiere wget, ca-certificates, tar, xz-utils (allgemeine Tools)
# 4. Installiere wine64 (Kernkomponente für Windows-Anwendungen)
# 5. Installiere lib32gcc-s1 (32-bit-Abhängigkeit für SteamCMD)
# 6. Räume den apt-Cache auf, um das Image klein zu halten
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

# Erstelle den non-root-Benutzer 'container'
RUN useradd --system --home /home/container --shell /bin/bash container

# Erstelle die Verzeichnisse für den Server und SteamCMD
RUN mkdir -p /mnt/server /home/container/steamcmd && \
    chown -R container:container /mnt/server /home/container

# Wechsle zum 'container' Benutzer
USER container
WORKDIR /home/container

# Lade SteamCMD herunter und entpacke es
RUN wget -qO- https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz | tar xvz -C ./steamcmd

# Setze das Arbeitsverzeichnis auf das Server-Verzeichnis
WORKDIR /mnt/server

# Kopiere das Startskript und mache es ausführbar
COPY --chown=container:container entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Definiere den Entrypoint
ENTRYPOINT ["/entrypoint.sh"]
