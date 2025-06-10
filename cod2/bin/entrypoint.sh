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

if [ -z "${SERVER_CFG}" ]; then
    CFG_FILE="server.cfg"
else
    CFG_FILE="${SERVER_CFG}"
fi

START_COMMAND="./cod2_lnxded +set dedicated 2 +set net_ip ${SERVER_IP} +set net_port ${SERVER_PORT} +set logfile 1 +exec ${CFG_FILE}"

echo "Finaler, manuell gebauter Startbefehl: ${START_COMMAND}"
exec ${START_COMMAND}
