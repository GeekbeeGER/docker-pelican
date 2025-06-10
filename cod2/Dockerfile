#!/bin/bash
set -e

cd /home/container

# Installationslogik...
if [ ! -f "cod2_lnxded" ]; then
    echo "COD2-Dateien nicht gefunden. Lade herunter..."
    wget -q -O cod2-server.tar.xz "http://linuxgsm.download/CallOfDuty2/cod2-lnxded-1.3-full.tar.xz"
    tar -xf cod2-server.tar.xz
    rm cod2-server.tar.xz
    chmod +x ./cod2_lnxded
    echo "Installation abgeschlossen."
else
    echo "COD2-Dateien bereits vorhanden."
fi

# Ersetze die Panel-Variablen im Startbefehl.
# Pelican übergibt den Startup Command als Umgebungsvariable $STARTUP
# Aber die Variablen {{server.ip}} etc. sind noch nicht ersetzt. Das machen wir hier manuell.
PARSED_STARTUP=$(echo "${STARTUP}" | \
    sed -e "s/{{server.ip}}/${SERVER_IP}/g" \
    -e "s/{{server.port}}/${SERVER_PORT}/g" \
    -e "s/{{server.env.SERVER_CFG}}/${SERVER_CFG}/g")

# Gib den finalen, geparsten Befehl aus
echo "Finaler Startbefehl: ${PARSED_STARTUP}"

# Führe den Befehl aus
exec ${PARSED_STARTUP}
