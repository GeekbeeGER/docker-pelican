# ------------------------------------------------------------------
#  STAGE 1: Basis-Setup und Abhängigkeiten
# ------------------------------------------------------------------
FROM --platform=$TARGETOS/$TARGETARCH i386/debian:bookworm-slim

LABEL author="Geekbee" maintainer="support@bawialnia.biz"
LABEL org.opencontainers.image.licenses=GPLv3

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
        libstdc++6 \
        locales \
        tzdata && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8 && \
    useradd -m -d ${HOME} -s /bin/bash ${USER} && \
    rm -rf /var/lib/apt/lists/*

# ------------------------------------------------------------------
#  STAGE 2: Installation der Call of Duty 2 Serverdateien
# ------------------------------------------------------------------
WORKDIR ${HOME}

# --- HIER IST DIE WICHTIGSTE ÄNDERUNG ---
# Wir kopieren den Inhalt eines bestimmten Quellordners anstatt des ganzen Kontexts.
# ANNAHME: Alle deine CoD2-Serverdateien liegen in einem Unterordner namens 'serverfiles'.
# Der Befehl kopiert den *Inhalt* von 'serverfiles' nach '/home/container'.
COPY --chown=container:container serverfiles/ .

# Mache die Server-Executable ausführbar.
# Dieser Befehl sollte jetzt funktionieren, da die Datei nun am richtigen Ort ist.
RUN chmod +x ./cod2_lnxded

# ------------------------------------------------------------------
#  STAGE 3: Finale Konfiguration und Entrypoint
# ------------------------------------------------------------------
USER ${USER}

COPY --chown=container:container ./bin/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

CMD ["./cod2_lnxded"]
