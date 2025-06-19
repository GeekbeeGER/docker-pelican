#!/bin/bash
set -e

# Der Arbeitspfad ist jetzt /home/container/server

echo "========================================="
echo "Installiere/Aktualisiere den SCUM Server mit ANONYMEM Login."
echo "Verwende PLAYTEST App-ID: 3792580"
echo "========================================="

# Der Pfad zu steamcmd ist immer noch derselbe, aber das Installationsverzeichnis ist jetzt anders.
/home/steam/steamcmd/steamcmd.sh \
    +@sSteamCmdForcePlatformType linux \
    +force_install_dir "/home/container/server" \
    +login anonymous \
    +app_update 3792580 validate \
    +quit

# Dieser Befehl wird jetzt funktionieren, da der 'container'-Benutzer
# die vollen Rechte über sein Arbeitsverzeichnis hat.
mkdir -p ./SCUM/Saved/Config/WindowsServer

: "${SERVER_IP:=0.0.0.0}"
: "${SERVER_PORT:=7040}"
: "${QUERY_PORT:=7041}"
: "${MAX_PLAYERS:=64}"
: "${ADDITIONAL_ARGS:=""}"

echo "========================================="
echo "Installation/Update abgeschlossen. Server wird gestartet."
echo "Server IP: ${SERVER_IP}"
echo "Server Port: ${SERVER_PORT}"
echo "Query Port: ${QUERY_PORT}"
echo "Max Players: ${MAX_PLAYERS}"
echo "Zusätzliche Argumente: ${ADDITIONAL_ARGS}"
echo "========================================="

# Starte den SCUM Server mit Wine.
exec wine ./SCUM/Binaries/Win64/SCUMServer.exe -log -Multihome=${SERVER_IP} -Port=${SERVER_PORT} -QueryPort=${QUERY_PORT} -MaxPlayers=${MAX_PLAYERS} ${ADDITIONAL_ARGS}
