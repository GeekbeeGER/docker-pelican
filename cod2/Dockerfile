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

# Setze das Arbeitsverzeichnis
WORKDIR /home/container

# Kopiere das Entrypoint-Skript
COPY bin/entrypoint.sh /entrypoint.sh
# Setze die Rechte auf das Skript UND das gesamte Home-Verzeichnis.
# Dies ist der entscheidende Schritt, um die Berechtigungsfehler zu beheben.
RUN chown -R container:container /home/container && chmod +x /entrypoint.sh

# Wechsle zum unprivilegierten Benutzer
USER container

# Setze den Entrypoint
ENTRYPOINT ["/entrypoint.sh"]
