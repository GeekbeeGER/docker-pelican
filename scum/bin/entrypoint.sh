#!/bin/bash
# SCUM Server Installation Script

# Setze CWD auf das Container-Verzeichnis
cd /home/container || exit 1

# Update und installiere notwendige Pakete
echo "Updating packages and installing wine..."
apt-get update
apt-get install -y --no-install-recommends wine64

## SteamCMD Installation des Servers
echo "Downloading SCUM Dedicated Server..."
# AppID 1824900 ist für den SCUM Dedicated Server
./steamcmd.sh +login anonymous +force_install_dir /home/container +app_update 1824900 validate +quit

# Erstelle die notwendigen Verzeichnisse, falls sie nach der Installation nicht existieren
echo "Creating necessary directories..."
mkdir -p SCUM/Saved/Config/WindowsServer/

echo "========================================="
echo "SCUM Server Installation abgeschlossen."
echo "========================================="
