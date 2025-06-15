#!/bin/bash
set -e

# Wechsel in das Hauptverzeichnis des Containers
cd /home/container

# --- Installationslogik ---
if [ ! -f "coduo_lnxded" ]; then
    echo "COD:UO Serverdateien nicht gefunden. Starte Download..."
    wget -q -O coduo-server.tar.xz "http://linuxgsm.download/CallOfDutyUnitedOffensive/coduo-lnxded-1.51b-full.tar.xz"
    tar -xf coduo-server.tar.xz
    rm coduo-server.tar.xz
    chmod +x ./coduo_lnxded
    echo "Installation abgeschlossen."
fi

# --- KONFIGURATIONSPRÜFUNG & MODIFIKATOREN ---

# Definiere den Pfad und den Namen der Konfigurationsdatei
CFG_DIR="./.callofduty/uo"
CFG_FILE_NAME="uoconfig_mp_server.cfg"
FULL_CFG_PATH="${CFG_DIR}/${CFG_FILE_NAME}"

# Prüfe, ob die Konfigurationsdatei existiert und setze den +exec Befehl
EXEC_COMMAND=""
if [ -f "${FULL_CFG_PATH}" ]; then
    echo "Konfigurationsdatei '${FULL_CFG_PATH}' gefunden. Sie wird geladen."
    EXEC_COMMAND="+exec ${CFG_FILE_NAME}"
else
    echo "WARNUNG: Konfigurationsdatei '${FULL_CFG_PATH}' nicht gefunden. Nur Kommandozeilen-Parameter werden verwendet."
fi


# --- FINALE SERVER-STARTLOGIK ---
# Baue den Startbefehl mit allen Pterodactyl-Variablen zusammen.
# Diese überschreiben die Werte aus der .cfg-Datei.
START_COMMAND="./coduo_lnxded \
+set dedicated 2 \
+set net_ip 0.0.0.0 \
+set net_port ${SERVER_PORT} \
+set sv_hostname \"${SV_HOSTNAME}\" \
+set rconPassword \"${RCON_PASSWORD}\" \
+set g_password \"${G_PASSWORD}\" \
+set sv_maxclients ${SV_MAXCLIENTS} \
+set scr_friendlyfire ${SCR_FRIENDLYFIRE} \
+set scr_killcam ${SCR_KILLCAM} \
+set scr_teambalance ${SCR_TEAMBALANCE} \
+set g_allowvote ${G_ALLOWVOTE} \
+set sv_punkbuster ${SV_PUNKBUSTER} \
+set sv_pure ${SV_PURE} \
+set sv_maxPing ${SV_MAXPING} \
${EXEC_COMMAND} \
+set g_gametype ${GAMETYPE} \
+map ${STARTUP_MAP}"

echo "Finaler Startbefehl wird ausgeführt:"
echo "${START_COMMAND}"
# Führe den Befehl aus. exec ersetzt den aktuellen Shell-Prozess.
eval exec ${START_COMMAND}
