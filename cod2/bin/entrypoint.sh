#!/bin/bash
# Dieses Skript wird innerhalb des Containers ausgeführt.
set -e

# Wechsle in das Arbeitsverzeichnis
cd /home/container

# --- Installationslogik ---
if [ ! -f "cod2_lnxded" ]; then
    echo "COD2-Serverdateien nicht gefunden. Starte einmaligen Download..."
    wget -q -O cod2-server.tar.xz "http://linuxgsm.download/CallOfDuty2/cod2-lnxded-1.3-full.tar.xz"
    tar -xf cod2-server.tar.xz
    rm cod2-server.tar.xz
    chmod +x ./cod2_lnxded
    echo "Installation abgeschlossen."
else
    echo "Serverdateien bereits vorhanden. Überspringe Installation."
fi

# --- Server-Startlogik ---
# Ersetze die Platzhalter im Startbefehl des Panels ($STARTUP)
# mit den Werten aus den Umgebungsvariablen.
PARSED_STARTUP=$(echo "${STARTUP}" | \
    sed -e "s/{{server.ip}}/${SERVER_IP}/g" \
    -e "s/{{server.port}}/${SERVER_PORT}/g" \
    -e "s/{{server.env.SERVER_CFG}}/${SERVER_CFG}/g")

echo "Finaler, geparster Startbefehl: ${PARSED_STARTUP}"

exec ${PARSED_STARTUP}
