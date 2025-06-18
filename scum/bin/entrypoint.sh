#!/bin/bash
set -e # Beendet das Skript sofort bei einem Fehler

# Wechsle in das Serververzeichnis
cd /mnt/server

# Aktualisiere den SCUM Server mit SteamCMD
# Die SteamCMD-Installation befindet sich im Home-Verzeichnis des Benutzers
echo "========================================="
echo "Installiere/Aktualisiere den SCUM Server..."
echo "========================================="
/home/container/steamcmd/steamcmd.sh +login anonymous +force_install_dir /mnt/server +app_update 1824900 validate +quit

# Erstelle notwendige Verzeichnisse, falls sie nicht existieren
mkdir -p ./SCUM/Saved/Config/WindowsServer

# Setze Standardwerte für Umgebungsvariablen, falls sie nicht vom Panel gesetzt werden
: "${SERVER_IP:=0.0.0.0}"
: "${SERVER_PORT:=7040}"
: "${QUERY_PORT:=7041}"
: "${MAX_PLAYERS:=64}"
: "${ADDITIONAL_ARGS:=""}" # Zusätzliche Startargumente

# Gib die Startkonfiguration aus
echo "========================================="
echo "Server IP: ${SERVER_IP}"
echo "Server Port: ${SERVER_PORT}"
echo "Query Port: ${QUERY_PORT}"
echo "Max Players: ${MAX_PLAYERS}"
echo "Zusätzliche Argumente: ${ADDITIONAL_ARGS}"
echo "========================================="

# Starte den Server mit Wine
# exec ersetzt den Shell-Prozess, sodass der Server direkt auf Signale (wie STOP) vom Panel reagieren kann
echo "Starte SCUMServer.exe..."
exec wine ./SCUM/Binaries/Win64/SCUMServer.exe -log -Multihome=${SERVER_IP} -Port=${SERVER_PORT} -QueryPort=${QUERY_PORT} -MaxPlayers=${MAX_PLAYERS} ${ADDITIONAL_ARGS}
