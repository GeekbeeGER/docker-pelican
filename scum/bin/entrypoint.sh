#!/bin/bash
set -e

# Der Arbeitspfad wird bereits von der Dockerfile auf /home/steam/server gesetzt.
# Der 'cd'-Befehl ist nicht mehr nötig und wird entfernt.

: "${STEAM_USER:?Bitte gib einen Steam-Benutzernamen in den Server-Startvariablen an.}"
: "${STEAM_PASS:?Bitte gib ein Steam-Passwort in den Server-Startvariablen an.}"

echo "========================================="
echo "Installiere/Aktualisiere den SCUM Server mit dem Account: ${STEAM_USER}"
echo "Verwende STABILE App-ID: 1824900"
echo "========================================="

# Der Pfad zu steamcmd.sh und zum Installationsverzeichnis sind in diesem Image anders
# Wir sind bereits im richtigen Verzeichnis, daher reicht der relative Pfad.
./steamcmd.sh \
    +@sSteamCmdForcePlatformType linux \
    +force_install_dir "/home/steam/server" \
    +login "${STEAM_USER}" "${STEAM_PASS}" \
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
