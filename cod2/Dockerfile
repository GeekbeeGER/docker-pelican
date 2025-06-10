# ------------------------------------------------------------------
#  STAGE 1: Basis-Setup und Abhängigkeiten
# ------------------------------------------------------------------
# Wir verwenden das offizielle i386-Image, das ist sehr gut für 32-Bit-Spiele.
FROM --platform=$TARGETOS/$TARGETARCH i386/debian:bookworm-slim

# Metadaten für das Image
LABEL author="Geekbee" maintainer="support@bawialnia.biz"
LABEL org.opencontainers.image.licenses=GPLv3

# Umgebungsvariablen für eine saubere Konfiguration
ENV USER=container \
    HOME=/home/container \
    DEBIAN_FRONTEND=noninteractive

# Installiere alle notwendigen Systempakete als ROOT
# - wget, tar, xz-utils: Zum Herunterladen und Entpacken, falls nötig
# - lib32gcc-s1, lib32stdc++6: Kritische 32-Bit-Bibliotheken für alte Spiele
# - locales, tzdata: Für korrekte Zeit- und Spracheinstellungen
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        wget \
        tar \
        xz-utils \
        lib32gcc-s1 \
        lib32stdc++6 \
        locales \
        tzdata && \
    # Konfiguriere die Locales
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8 && \
    # Erstelle den unprivilegierten Benutzer
    useradd -m -d ${HOME} -s /bin/bash ${USER} && \
    # Räume den Apt-Cache auf, um das Image klein zu halten
    rm -rf /var/lib/apt/lists/*

# ------------------------------------------------------------------
#  STAGE 2: Installation der Call of Duty 2 Serverdateien
# ------------------------------------------------------------------
# Wechsle zum Arbeitsverzeichnis des Benutzers
WORKDIR ${HOME}

# --- HIER KOMMT DIE WICHTIGSTE ÄNDERUNG ---
# Kopiere die CoD2-Serverdateien in das Arbeitsverzeichnis des Containers.
# ANNAHME: Die CoD2-Dateien (`cod2_lnxded`, `main`-Ordner etc.)
# liegen im gleichen Verzeichnis wie dein Dockerfile.
COPY --chown=container:container . .

# Mache die Server-Executable ausführbar.
# Dieser Schritt ist KRITISCH und löst wahrscheinlich deinen "No such file or directory"-Fehler.
RUN chmod +x ./cod2_lnxded

# ------------------------------------------------------------------
#  STAGE 3: Finale Konfiguration und Entrypoint
# ------------------------------------------------------------------
# Wechsle jetzt endgültig zum unprivilegierten Benutzer.
# Alles, was ab hier passiert, wird als 'container'-Benutzer ausgeführt.
USER ${USER}

# Definiere den Entrypoint. Dieser wird anstelle des Panel-Startbefehls ausgeführt.
# WICHTIG: Wenn du einen Entrypoint definierst, wird der "Startup Command" aus dem Panel
# als Argument an diesen Entrypoint übergeben!
COPY --chown=container:container ./bin/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

# Der CMD-Befehl wird hier ignoriert, wenn der Server über das Pelican Panel gestartet wird,
# da das Panel seine eigenen Argumente (den "Startup Command") an den Entrypoint übergibt.
CMD ["./cod2_lnxded"]
