# Wir verwenden das offizielle i386-Image, das ist sehr gut für 32-Bit-Spiele.
FROM --platform=$TARGETOS/$TARGETARCH i386/debian:bookworm-slim

# Metadaten für das Image
LABEL author="Geekbee" maintainer="support@bawialnia.biz"
LABEL org.opencontainers.image.licenses=GPLv3

# Umgebungsvariablen setzen
ENV USER=container \
    HOME=/home/container \
    DEBIAN_FRONTEND=noninteractive

# --- System-Setup und Paketinstallation ---
RUN \
    apt-get update && \
    apt-get install --no-install-recommends -y \
        wget \
        tar \
        xz-utils \
        binutils \
        iproute2 \
        net-tools \
        tzdata \
        locales && \
    update-locale lang=en_US.UTF-8 && \
    dpkg-reconfigure --frontend noninteractive locales && \
    useradd -m -d /home/container -s /bin/bash container && \
    rm -rf /var/lib/apt/lists/*

# --- Vorbereitung des Entrypoint-Skripts (als ROOT) ---
# Annahme: entrypoint.sh liegt im Ordner 'bin' im selben Verzeichnis wie die Dockerfile
COPY ./bin/entrypoint.sh /entrypoint.sh
# Führe chmod und chown als ROOT aus, bevor wir den Benutzer wechseln.
RUN chmod +x /entrypoint.sh && chown ${USER}:${USER} /entrypoint.sh

# --- Wechsel zum unprivilegierten Benutzer ---
# Jetzt ist alles vorbereitet, und wir können sicher zum 'container'-Benutzer wechseln.
USER ${USER}

# Arbeitsverzeichnis festlegen
WORKDIR ${HOME}

# Standardbefehl beim Starten des Containers
CMD [ "/entrypoint.sh" ]
