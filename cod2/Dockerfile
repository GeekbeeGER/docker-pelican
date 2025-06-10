# VERWENDE DEBIAN BUSTER, da es libstdc++5 garantiert enthält.
FROM i386/debian:buster-slim

# Setze Umgebungsvariablen
ENV DEBIAN_FRONTEND=noninteractive

# Führe alle System-Operationen in einer einzigen, sauberen RUN-Anweisung aus
RUN \
    # 1. Update Paketlisten
    apt-get update && \
    # 2. Installiere alle Abhängigkeiten
    apt-get install -y --no-install-recommends \
        wget \
        tar \
        xz-utils \
        libstdc++5 && \
    # 3. Erstelle den Benutzer 'container'
    useradd --system --home /home/container --shell /bin/bash container && \
    # 4. Räume den Cache auf
    rm -rf /var/lib/apt/lists/*

# Setze das Arbeitsverzeichnis auf das Home-Verzeichnis des neuen Benutzers
WORKDIR /home/container

# Kopiere das Entrypoint-Skript
COPY bin/entrypoint.sh /entrypoint.sh

# ---> HIER IST DER ENTSCHEIDENDE BEFEHL <---
# Setze die Rechte auf das Skript UND das gesamte Home-Verzeichnis rekursiv.
RUN chown -R container:container /home/container && chmod +x /entrypoint.sh

# Wechsle zum unprivilegierten Benutzer
USER container

# Setze den Entrypoint, der beim Start des Containers ausgeführt wird
ENTRYPOINT ["/entrypoint.sh"]
