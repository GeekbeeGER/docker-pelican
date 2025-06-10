# Wir verwenden das offizielle i386-Image, das ist sehr gut für 32-Bit-Spiele.
FROM --platform=$TARGETOS/$TARGETARCH i386/debian:bookworm-slim

LABEL author="Geekbee" maintainer="support@bawialnia.biz"
LABEL org.opencontainers.image.licenses=GPLv3

# OS environment
ENV USER=container \
    HOME=/home/container \
    DEBIAN_FRONTEND=noninteractive

# Installiere die nötigen Tools.
# WICHTIG: Wir fügen tar und xz-utils hinzu!
RUN apt-get update && \
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
    useradd -m -d /home/container -s /bin/bash container

# Lösche den APT-Cache, um das Image klein zu halten
RUN rm -rf /var/lib/apt/lists/*

# Wechsle zum neuen Benutzer
USER container
WORKDIR /home/container

# Kopiere das Startskript
COPY ./bin/entrypoint.sh /entrypoint.sh
# Setze den Startbefehl
CMD [ "/bin/bash", "/entrypoint.sh" ]
