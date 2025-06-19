#!/bin/bash
# WICHTIG: set -e wird hier vorübergehend entfernt, damit das Skript nach einem Fehler weiterläuft und wir die Logs ausgeben können.
# set -e

echo "========================================="
echo "Installiere/Aktualisiere den SCUM Server mit ANONYMEM Login."
echo "Verwende PLAYTEST App-ID: 3792580"
echo "========================================="

# Führe SteamCMD aus
/home/steam/steamcmd/steamcmd.sh \
    +@sSteamCmdForcePlatformType linux \
    +force_install_dir "/home/steam/server" \
    +login anonymous \
    +app_update 3792580 validate \
    +quit

# Warte kurz, um sicherzustellen, dass die Log-Datei geschrieben wird
sleep 2

echo "========================================="
echo "SteamCMD Prozess beendet. Überprüfe die Log-Dateien auf Fehler..."
echo "Inhalt von /home/steam/Steam/logs/stderr.txt:"
cat /home/steam/Steam/logs/stderr.txt || echo "stderr.txt nicht gefunden oder leer."
echo "========================================="

# Das Skript wird hier absichtlich beendet, um zu verhindern, dass es versucht, einen nicht installierten Server zu starten.
# Entferne 'exit 1' für den produktiven Betrieb.
echo "Skript wird zur Fehlersuche beendet."
exit 1

# Der folgende Code wird nicht ausgeführt, solange 'exit 1' aktiv ist.
mkdir -p ./SCUM/Saved/Config/WindowsServer

: "${SERVER_IP:=0.0.0.0}"
: "${SERVER_PORT:=7040}"
: "${QUERY_PORT:=7041}"
: "${MAX_PLAYERS:=64}"
: "${ADDITIONAL_ARGS:=""}"

echo "Starte SCUMServer.exe..."
exec wine ./SCUM/Binaries/Win64/SCUMServer.exe -log -Multihome=${SERVER_IP} -Port=${SERVER_PORT} -QueryPort=${QUERY_PORT} -MaxPlayers=${MAX_PLAYERS} ${ADDITIONAL_ARGS}
