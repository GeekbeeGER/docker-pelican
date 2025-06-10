#!/bin/bash
set -e
cd /home/container

# Installationslogik (bleibt unverändert)
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

# Führe den vom Panel übergebenen Befehl direkt aus.
# Das Panel selbst wird die Variablen ersetzen.
echo "Führe Befehl vom Panel aus: $@"
exec "$@"
