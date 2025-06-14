#!/bin/bash
set -e

# Wechsel in das Hauptverzeichnis des Containers
cd /home/container

# --- Installationslogik (unverändert und funktionierend) ---
if [ ! -f "cod2_lnxded" ]; then
    echo "COD2-Serverdateien nicht gefunden. Starte Download..."
    wget -q -O cod2-server.tar.xz "http://linuxgsm.download/CallOfDuty2/cod2-lnxded-1.3-full.tar.xz"
    tar -xf cod2-server.tar.xz
    rm cod2-server.tar.xz
    chmod +x ./cod2_lnxded
    echo "Installation abgeschlossen."
fi

# --- LOGIK ZUR ERSTELLUNG DER server.cfg IM "main" ORDNER ---

# Stelle sicher, dass der "main" Ordner existiert
mkdir -p ./main

# Definiere den Namen und den vollständigen Pfad der Konfigurationsdatei
CFG_FILE_NAME="${SERVER_CFG:-server.cfg}"
FULL_CFG_PATH="./main/${CFG_FILE_NAME}"

# Prüfe, ob die Konfigurationsdatei im "main"-Ordner NICHT existiert
if [ ! -f "${FULL_CFG_PATH}" ]; then
    echo "Konfigurationsdatei unter '${FULL_CFG_PATH}' nicht gefunden. Erstelle eine Standard-Version..."
    # Schreibe die Standard-Konfiguration in die Datei im "main" Ordner
    cat <<EOF > ${FULL_CFG_PATH}
// ### Automatisch erstellte Konfiguration ###
// Diese Datei wurde erstellt, weil keine im 'main'-Ordner vorhanden war.
// Sie können diese Datei im Pterodactyl File Manager unter /main/${CFG_FILE_NAME} bearbeiten.

// --- GRUNDEINSTELLUNGEN ---
sets sv_hostname "^7Call of Duty 2 Server ^2by ^4Geekbee"
set rcon_password "${RCON_PASSWORD}"

// --- MAP-ROTATION & START ---
set sv_maprotation "gametype tdm map mp_toujane gametype sd map mp_burgundy"
set sv_maprotationcurrent ""
wait
map_rotate
EOF
    echo "Standard-Konfiguration wurde erfolgreich in '${FULL_CFG_PATH}' erstellt."
fi

# --- DER TRICK: SYMBOLISCHER LINK ---
# Erstelle eine "Verknüpfung" (symbolischer Link) im Hauptverzeichnis,
# die auf die echte Konfigurationsdatei im 'main'-Ordner zeigt.
# Die Option -f sorgt dafür, dass ein alter Link überschrieben wird.
echo "Erstelle symbolischen Link: ./${CFG_FILE_NAME} -> ${FULL_CFG_PATH}"
ln -sf "${FULL_CFG_PATH}" "./${CFG_FILE_NAME}"


# --- FINALE SERVER-STARTLOGIK ---
# Der +exec Befehl nutzt nun den einfachen Namen. Das Spiel findet den Link im Hauptverzeichnis
# und lädt die korrekte Datei aus dem 'main' Ordner.
# Die Map und Gametype am Ende sind nur für den allerersten Start, danach übernimmt die cfg.
START_COMMAND="./cod2_lnxded +set dedicated 2 +set net_ip 0.0.0.0 +set net_port ${SERVER_PORT} +set logfile 1 +exec ${CFG_FILE_NAME} +set g_gametype dm +map mp_carentan"

echo "Finaler, manuell gebauter Startbefehl: ${START_COMMAND}"
exec ${START_COMMAND}
