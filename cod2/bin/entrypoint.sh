#!/bin/bash
set -e
cd /home/container

if [ ! -f "cod2_lnxded" ]; then
    echo "COD2-Dateien nicht gefunden. Starte Download..."
    wget -q -O cod2-server.tar.xz "http://linuxgsm.download/CallOfDuty2/cod2-lnxded-1.3-full.tar.xz"
    tar -xf cod2-server.tar.xz
    rm cod2-server.tar.xz
    chmod +x ./cod2_lnxded
    echo "Installation abgeschlossen."
else
    echo "Dateien bereits vorhanden."
fi

# Ersetze die Platzhalter.
# $STARTUP kommt vom Panel und enthält {{...}}
# $SERVER_IP, $SERVER_PORT etc. werden ebenfalls vom Panel gesetzt.
PARSED_STARTUP=$(echo "${STARTUP}" | \
    sed -e "s/{{server.ip}}/${SERVER_IP}/g" \
    -e "s/{{server.port}}/${SERVER_PORT}/g" \
    -e "s/{{server.env.SERVER_CFG}}/${SERVER_CFG}/g")

echo "Finaler Befehl: ${PARSED_STARTUP}"
exec ${PARSED_STARTUP}
