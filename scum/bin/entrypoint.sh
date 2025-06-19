#!/bin/bash
set -e

# Der Arbeitspfad wird bereits von der Dockerfile auf /home/steam/server gesetzt.

echo "========================================="
echo "Installiere/Aktualisiere den SCUM Server mit ANONYMEM Login."
echo "Verwende PLAYTEST App-ID: 3792580"
echo "========================================="

# HIER IST DER KORRIGIERTE, ABSOLUTE PFAD ZU STEAMCMD
# und der Login auf 'anonymous' mit der Playtest-ID gesetzt.
/home/steam/steamcmd/steamcmd.sh \
    +@sSteamCmdForcePlatformType linux \
    +force_install_dir "/home/steam/server" \
    +login anonymous \
    +app_update 3792580 validate \
    +quit

mkdir -p ./SCUM/Saved/Config/WindowsServer

: "${SERVER_IP:=0.0.0.0}"
: "${SERVER_PORT:=7040}"
: "${QUERY_PORT:=7041}"
: "${MAX_PLAYERS:=64}"
: "${ADDITIONAL_ARGS:=""}"

echo "========================================="
echo "Server IP: ${SERVER_IP}"
echo "Server Port: ${SERVER_PORT}"
echo "Query Port: ${QUERY_PORT}"
echo "Max Players: ${MAX_PLAYERS}"
echo "Zusätzliche Argumente: ${ADDITIONAL_ARGS}"
echo "========================================="

echo "Starte SCUMServer.exe..."
exec wine ./SCUM/Binaries/Win64/SCUMServer.exe -log -Multihome=${SERVER_IP} -Port=${SERVER_PORT} -QueryPort=${QUERY_PORT} -MaxPlayers=${MAX_PLAYERS} ${ADDITIONAL_ARGS}
