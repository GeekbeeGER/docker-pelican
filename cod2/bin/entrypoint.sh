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

# --- LOGIK ZUM KOPIEREN DER server.cfg AUS GITHUB ---

# Stelle sicher, dass der "main" Ordner existiert
mkdir -p ./main

# Definiere den Namen und den vollständigen Pfad der Konfigurationsdatei
CFG_FILE_NAME="${SERVER_CFG:-server.cfg}"
FULL_CFG_PATH="./main/${CFG_FILE_NAME}"

# Prüfe, ob die Konfigurationsdatei im "main"-Ordner NICHT existiert
if [ ! -f "${FULL_CFG_PATH}" ]; then
    echo "Konfigurationsdatei unter '${FULL_CFG_PATH}' nicht gefunden. Lade Konfiguration von GitHub herunter..."
    # Lade die Konfigurationsdatei von der rohen GitHub-URL herunter
    wget -q -O "${FULL_CFG_PATH}" "https://raw.githubusercontent.com/GeekbeeGER/docker-pelican/main/cod2/server.cfg"
    echo "Konfiguration wurde erfolgreich nach '${FULL_CFG_PATH}' heruntergeladen."
else
    echo "Konfigurationsdatei '${FULL_CFG_PATH}' bereits vorhanden. Überspringe Download."
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
START_COMMAND="./cod2_lnxded +set dedicated 2 +set net_ip 0.0.0.0 +set net_port ${SERVER_PORT} +set logfile 1 +exec ${CFG_FILE_NAME}"

echo "Finaler, manuell gebauter Startbefehl: ${START_COMMAND}"
exec ${START_COMMAND}
