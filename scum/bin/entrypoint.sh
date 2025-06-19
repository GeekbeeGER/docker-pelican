#!/bin/bash
set -e

cd /mnt/server

: "${STEAM_USER:?Bitte gib einen Steam-Benutzernamen in den Server-Startvariablen an.}"
: "${STEAM_PASS:?Bitte gib ein Steam-Passwort in den Server-Startvariablen an.}"

echo "========================================="
echo "Installiere/Aktualisiere den SCUM Server mit dem Account: ${STEAM_USER}"
echo "Verwende STABILE App-ID: 1824900"
echo "Erzwinge Linux-Plattform für SteamCMD."
echo "========================================="

# FÜGE @sSteamCmdForcePlatformType HINZU, UM BEKANNTE BUGS ZU UMGEHEN
# Leite stdout und stderr in eine Log-Datei um, um mehr Details zu sehen
/opt/steamcmd/steamcmd.sh \
    +@sSteamCmdForcePlatformType linux \
    +force_install_dir /mnt/server \
    +login "${STEAM_USER}" "${STEAM_PASS}" \
    +app_update 1824900 validate \
    +quit > /tmp/steamcmd_output.log 2>&1

# Gib den Inhalt der Log-Datei aus, um Fehler zu sehen
cat /tmp/steamcmd_output.log

# Überprüfe den Exit-Code von SteamCMD (optional, aber gut für die Fehlersuche)
if [ $? -ne 0 ]; then
    echo "SteamCMD ist mit einem Fehler fehlgeschlagen. Siehe Log oben."
    exit 1
fi

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
