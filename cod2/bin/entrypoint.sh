#!/bin/bash
set -e

# Standardwerte setzen, falls keine Umgebungsvariablen vorhanden sind
IP=${IP:-"0.0.0.0"}
PORT=${PORT:-"28960"}
MAX_CLIENTS=${MAX_CLIENTS:-"20"}

# Eine Zeichenkette mit den Startparametern zusammenbauen
PARAMS=""

if [[ -n "${HOSTNAME}" ]]; then
    PARAMS="${PARAMS} +set sv_hostname \"${HOSTNAME}\""
fi
if [[ -n "${GAMETYPE}" ]]; then
    PARAMS="${PARAMS} +set g_gametype ${GAMETYPE}"
fi
if [[ -n "${MAP}" ]]; then
    PARAMS="${PARAMS} +map ${MAP}"
fi
if [[ -n "${PASSWORD}" ]]; then
    PARAMS="${PARAMS} +set g_password \"${PASSWORD}\""
fi
if [[ -n "${PRIVATE_CLIENTS}" ]]; then
    PARAMS="${PARAMS} +set sv_privateclients ${PRIVATE_CLIENTS}"
fi

# Wechsle in das Server-Verzeichnis
cd /home/cod2server/server

# Starte den Server
# +set dedicated 2: Startet als dedizierter Server im Hintergrund
# +exec server.cfg: Lädt deine Serverkonfiguration aus dem 'main'-Verzeichnis
# Der Rest der Parameter wird über die Umgebungsvariablen gesteuert
echo "Starting CoD2 Server on ${IP}:${PORT}..."
./cod2_lnxded_1.3 \
    +set dedicated 2 \
    +set net_ip "${IP}" \
    +set net_port "${PORT}" \
    +set sv_maxclients "${MAX_CLIENTS}" \
    ${PARAMS} \
    +exec server.cfg
