#!/bin/bash
set -e

cd /home/container

# --- Installationslogik (unverändert und funktionierend) ---
if [ ! -f "cod2_lnxded" ]; then
    echo "COD2-Serverdateien nicht gefunden. Starte Download..."
    wget -q -O cod2-server.tar.xz "http://linuxgsm.download/CallOfDuty2/cod2-lnxded-1.3-full.tar.xz"
    tar -xf cod2-server.tar.xz
    rm cod2-server.tar.xz
    chmod +x ./cod2_lnxded
    echo "Installation abgeschlossen."
else
    echo "Dateien bereits vorhanden."
fi

# --- NEU: Logik zur automatischen Erstellung der server.cfg ---
# Überprüfe, ob die Variable SERVER_CFG gesetzt ist, sonst nimm einen Standardwert.
if [ -z "${SERVER_CFG}" ]; then
    CFG_FILE="server.cfg"
else
    CFG_FILE="${SERVER_CFG}"
fi

# Prüfe, ob die Konfigurationsdatei NICHT existiert.
if [ ! -f "${CFG_FILE}" ]; then
    echo "Konfigurationsdatei '${CFG_FILE}' nicht gefunden. Erstelle eine Standard-Version..."
    # Schreibe eine Standard-Konfiguration in die Datei.
    # Der `cat <<EOF > ...` Befehl ist ideal, um mehrzeiligen Text zu schreiben.
    cat <<EOF > ${CFG_FILE}
// ### Automatisch erstellte Konfiguration ###
// Diese Datei wurde erstellt, weil keine vorhanden war.

// --- GRUNDEINSTELLUNGEN ---
// Der Name Ihres Servers, wie er in der Serverliste erscheint.
// Farbcodes: ^1=Rot, ^2=Grün, ^3=Gelb, ^4=Blau, ^5=Cyan, ^6=Pink, ^7=Weiß
sets sv_hostname "^2Neuer ^7Call of Duty 2 Server"

// Das RCON-Passwort zur Fernverwaltung des Servers.
// Es wird automatisch aus den Panel-Einstellungen übernommen.
sets rcon_password "${RCON_PASSWORD}"

// --- SPIEL-EINSTELLUNGEN ---
// Der Spielmodus (dm, tdm, sd, ctf, hq)
set g_gametype "dm"

// --- MAP-ROTATION ---
// Eine einfache Standard-Map-Rotation.
set sv_maprotation "map mp_carentan map mp_toujane map mp_dawnville map mp_matmata"
set sv_maprotationcurrent ""

// Starte die erste Map in der Rotation.
wait
map mp_carentan
EOF
    echo "Standard-Konfiguration wurde erfolgreich erstellt."
fi

# --- Server-Startlogik (unverändert und funktionierend) ---
# Baue den Startbefehl manuell mit den vom Panel bereitgestellten Umgebungsvariablen.
START_COMMAND="./cod2_lnxded +set dedicated 2 +set net_ip 0.0.0.0 +set net_port ${SERVER_PORT} +set logfile 1 +exec ${CFG_FILE}"

echo "Finaler, manuell gebauter Startbefehl: ${START_COMMAND}"
exec ${START_COMMAND}
