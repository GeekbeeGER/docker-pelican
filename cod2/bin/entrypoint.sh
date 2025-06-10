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

# Baue den Startbefehl manuell mit den vom Panel bereitgestellten Umgebungsvariablen.
# Dies ist die robusteste Methode.
START_COMMAND="./cod2_lnxded +set dedicated 2 +set net_ip ${SERVER_IP} +set net_port ${SERVER_PORT} +set logfile 1 +exec ${SERVER_CFG}"

echo "Finaler Befehl (manuell gebaut): ${START_COMMAND}"

# Führe den Befehl aus
exec ${START_COMMAND}
