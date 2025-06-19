#!/bin/bash
# Dieses Skript basiert auf dem Original und wurde um professionelle Features erweitert.
# Es dient nur zur Installation/Aktualisierung des SCUM Servers.
# Der Server wird über die Startkonfiguration des Panels (z.B. Pterodactyl) gestartet.

# Farben für eine bessere Ausgabe definieren
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

clear
echo -e "${BLUE}-------------------------------------------------${NC}"
echo -e "${YELLOW}SCUM Server Installations- & Update-Skript${NC}"
echo -e "${BLUE}-------------------------------------------------${NC}"

# Arbeitsverzeichnis setzen (Standard für viele Panels)
# Das Original verwendete /home/container/server
export HOME=/mnt/server

# Steam-Benutzer prüfen
# Wenn kein Benutzer in den Panel-Variablen gesetzt ist, wird 'anonymous' verwendet.
if [ -z "${STEAM_USER}" ]; then
    echo -e "${YELLOW}STEAM_USER ist nicht gesetzt. Verwende 'anonymous'.${NC}"
    STEAM_USER="anonymous"
    STEAM_PASS=""
    STEAM_AUTH=""
fi

# SteamCMD herunterladen und installieren, falls nicht vorhanden
echo -e "${BLUE}Installiere/Aktualisiere SteamCMD...${NC}"
cd /tmp
mkdir -p /mnt/server/steamcmd
curl -sSL -o steamcmd.tar.gz https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
tar -xzvf steamcmd.tar.gz -C /mnt/server/steamcmd
cd /mnt/server/steamcmd

# SCUM Server installieren/aktualisieren
# Die App-ID wird jetzt über eine Variable ${STEAM_APPID} gesteuert.
# Für den PLAYTEST wäre das 3792580, für die normale Version 513710.
echo -e "${BLUE}-------------------------------------------------${NC}"
echo -e "${YELLOW}Installiere/Aktualisiere SCUM Server (App-ID: ${STEAM_APPID})...${NC}"
echo -e "${YELLOW}Dies kann eine Weile dauern.${NC}"
echo -e "${BLUE}-------------------------------------------------${NC}"

./steamcmd.sh \
    +force_install_dir /mnt/server \
    +login ${STEAM_USER} ${STEAM_PASS} ${STEAM_AUTH} \
    +app_update ${STEAM_APPID} validate \
    +quit

# Notwendige Steam-Bibliotheken für Linux/Wine einrichten
echo -e "${GREEN}Richte Steam-Bibliotheken ein...${NC}"
mkdir -p /mnt/server/.steam/sdk32
cp -v linux32/steamclient.so /mnt/server/.steam/sdk32/steamclient.so
mkdir -p /mnt/server/.steam/sdk64
cp -v linux64/steamclient.so /mnt/server/.steam/sdk64/steamclient.so

# Prüfen, ob die Serverkonfigurationsdatei existiert.
# Wenn nicht, wird eine Standard-Konfiguration heruntergeladen.
cd /mnt/server
CONFIG_FILE="SCUM/Saved/Config/WindowsServer/ServerSettings.ini"

if [ -f "$CONFIG_FILE" ]; then
  echo -e "${GREEN}Konfigurationsdatei '$CONFIG_FILE' bereits vorhanden.${NC}"
else  
  echo -e "${YELLOW}'$CONFIG_FILE' nicht gefunden. Lade Standardkonfiguration herunter...${NC}"
  mkdir -p SCUM/Saved/Config/WindowsServer/
  # --- HIER IST DIE GEÄNDERTE URL ---
  curl -sSL -o "$CONFIG_FILE" https://raw.githubusercontent.com/GeekbeeGER/docker-pelican/refs/heads/main/scum/config/ServerSettings.ini
fi

# Ausgabe der finalen Konfiguration (die vom Panel gesetzten Variablen)
echo -e "${BLUE}-------------------------------------------------${NC}"
echo -e "${GREEN}Installation/Update abgeschlossen.${NC}"
echo -e "Der Server wird mit den folgenden Einstellungen gestartet (aus den Panel-Variablen):"
echo -e "Server IP: ${SERVER_IP}"
echo -e "Server Port: ${SERVER_PORT}"
echo -e "Query Port: ${QUERY_PORT}"
echo -e "Max Players: ${MAX_PLAYERS}"
echo -e "Zusätzliche Argumente: ${ADDITIONAL_ARGS}"
echo -e "${BLUE}-------------------------------------------------${NC}"
