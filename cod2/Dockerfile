#!/bin/bash

# Wechsle in das Home-Verzeichnis
cd /home/container || exit 1

# --- Installationslogik (bleibt gleich) ---
if [ ! -f "cod2_lnxded" ]; then
    echo "--------------------------------------------------"
    echo "Call of Duty 2 Serverdateien nicht gefunden."
    echo "Starte den einmaligen Download und die Installation..."
    echo "--------------------------------------------------"
    wget -q -O cod2-server.tar.xz "http://linuxgsm.download/CallOfDuty2/cod2-lnxded-1.3-full.tar.xz"
    tar -xf cod2-server.tar.xz
    rm cod2-server.tar.xz
    chmod +x ./cod2_lnxded
    echo "--------------------------------------------------"
    echo "Installation abgeschlossen!"
    echo "--------------------------------------------------"
else
    echo "Serverdateien bereits vorhanden, überspringe Installation."
fi

# --- NEUE Server-Startlogik ---
# Wir ignorieren den Befehl vom Panel ("$@") komplett.
# Stattdessen bauen wir den Befehl selbst zusammen,
# indem wir die Umgebungsvariablen verwenden, die das Panel setzt.

# Weise die Panel-Variablen lokalen Shell-Variablen zu (gute Praxis)
IP_ADDR=${SERVER_IP:-{{server.ip}}}
PORT=${SERVER_PORT:-{{server.port}}}
CONFIG_FILE=${SERVER_CFG:-{{server.env.SERVER_CFG}}}

# Baue den finalen Startbefehl
START_COMMAND="./cod2_lnxded +set dedicated 2 +set net_ip ${IP_ADDR} +set net_port ${PORT} +set logfile 1 +exec ${CONFIG_FILE}"

# Gib den Befehl aus, den wir ausführen werden (fürs Debugging)
echo "Starte den Server mit festem Befehl aus dem Entrypoint:"
echo "exec ${START_COMMAND}"

# Führe den Befehl aus
exec ${START_COMMAND}
