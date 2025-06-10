# Wir verwenden das offizielle i386-Image, das ist sehr gut für 32-Bit-Spiele.
FROM --platform=$TARGETOS/$TARGETARCH i386/debian:bookworm-slim

# Metadaten für das Image
LABEL author="Geekbee" maintainer="support@bawialnia.biz"
LABEL org.opencontainers.image.licenses=GPLv3

# Umgebungsvariablen setzen
ENV USER=container \
    HOME=/home/container \
    DEBIAN_FRONTEND=noninteractive

# --- System-Setup und Paketinstallation in einem optimierten Schritt ---
RUN \
    # 1. Paketlisten aktualisieren
    apt-get update && \
    \
    # 2. Notwendige Pakete installieren
    apt-get install --no-install-recommends -y \
        wget \
        tar \
        xz-utils \
        binutils \
        iproute2 \
        net-tools \
        tzdata \
        locales && \
    \
    # 3. Spracheinstellungen konfigurieren
    update-locale lang=en_US.UTF-8 && \
    dpkg-reconfigure --frontend noninteractive locales && \
    \
    # 4. Nicht-privilegierten Benutzer erstellen
    useradd -m -d /home/container -s /bin/bash container && \
    \
    # 5. APT-Cache im selben Layer löschen, um die Image-Größe zu reduzieren
    rm -rf /var/lib/apt/lists/*

# Wechsel zum neu erstellten Benutzer
USER ${USER}

# Arbeitsverzeichnis festlegen (erstellt den Ordner, falls nicht vorhanden)
WORKDIR ${HOME}

# Kopiere das Startskript und setze die Rechte
# Annahme: entrypoint.sh liegt im Ordner 'bin' im selben Verzeichnis wie die Dockerfile
COPY ./bin/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Standardbefehl beim Starten des Containers
CMD [ "/entrypoint.sh" ]
