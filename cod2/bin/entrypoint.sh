#!/bin/bash
set -e

# Change to the container's root directory
cd /home/container

# --- Installation Logic (unchanged and working) ---
if [ ! -f "cod2_lnxded" ]; then
    echo "COD2-Serverdateien nicht gefunden. Starte Download..."
    wget -q -O cod2-server.tar.xz "http://linuxgsm.download/CallOfDuty2/cod2-lnxded-1.3-full.tar.xz"
    tar -xf cod2-server.tar.xz
    rm cod2-server.tar.xz
    chmod +x ./cod2_lnxded
    echo "Installation abgeschlossen."
fi

# --- CORRECTED LOGIC: Create server.cfg in the ROOT directory ---

# Define the config file's name (defaults to server.cfg)
CFG_FILE="${SERVER_CFG:-server.cfg}"

# Check if the config file exists in the ROOT directory (/home/container)
if [ ! -f "${CFG_FILE}" ]; then
    echo "Konfigurationsdatei '${CFG_FILE}' nicht gefunden. Erstelle eine Standard-Version..."
    # Create the default configuration in the root directory.
    cat <<EOF > ${CFG_FILE}
// ### Automatisch erstellte Konfiguration ###
// Sie können diese Datei nach Belieben bearbeiten.

// --- GRUNDEINSTELLUNGEN ---
sets sv_hostname "^2Neuer ^7Call of Duty 2 Server"
set rcon_password "${RCON_PASSWORD}"

// --- MAP-ROTATION & START ---
// Definiere die Map-Rotation. Der Server startet mit der ersten Map in dieser Liste.
set sv_maprotation "gametype dm map mp_carentan gametype tdm map mp_toujane gametype sd map mp_burgundy"
set sv_maprotationcurrent ""

// Starte die Rotation.
wait
map_rotate
EOF
    echo "Standard-Konfiguration wurde erfolgreich in '${CFG_FILE}' erstellt."
fi

# --- FINAL SERVER STARTUP ---
# The +exec command now uses a simple, relative path that the game engine understands.
START_COMMAND="./cod2_lnxded +set dedicated 2 +set net_ip 0.0.0.0 +set net_port ${SERVER_PORT} +set logfile 1 +exec ${CFG_FILE}"

echo "Finaler, manuell gebauter Startbefehl: ${START_COMMAND}"
exec ${START_COMMAND}
