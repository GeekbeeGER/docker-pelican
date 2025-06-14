#!/bin/bash
set -e

Wechsel in das Hauptverzeichnis des Containers
cd /home/container

--- Installationslogik (unverändert und funktionierend) ---
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

--- KORRIGIERTE LOGIK ZUR ERSTELLUNG DER server.cfg IM "main" ORDNER ---
1. Definiere den Unterordner für die Konfiguration.
Dies ist der Ordner, der im Panel unter "File Manager" sichtbar ist.
CONFIG_DIR="/home/container"

2. Stelle sicher, dass der Konfigurationsordner existiert.
Normalerweise erledigt der Mount das, aber dies ist eine Absicherung.
mkdir -p ${CONFIG_DIR}

3. Definiere den Namen der Konfigurationsdatei.
Standard ist "server.cfg", kann aber über die Variable SERVER_CFG geändert werden.
if [ -z "
S
E
R
V
E
R
C
F
G
"
]
;
t
h
e
n
C
F
G
F
I
L
E
=
"
s
e
r
v
e
r
.
c
f
g
"
e
l
s
e
C
F
G
F
I
L
E
=
"
SERVER 
C
​
 FG"];thenCFG 
F
​
 ILE="server.cfg"elseCFG 
F
​
 ILE="
{SERVER_CFG}"
fi

4. Kombiniere Ordner und Dateiname zum vollständigen Pfad.
FULL_CFG_PATH="
C
O
N
F
I
G
D
I
R
/
CONFIG 
D
​
 IR/
{CFG_FILE}"

5. Prüfe, ob die Konfigurationsdatei im "main"-Ordner NICHT existiert.
if [ ! -f "
F
U
L
L
C
F
G
P
A
T
H
"
]
;
t
h
e
n
e
c
h
o
"
K
o
n
f
i
g
u
r
a
t
i
o
n
s
d
a
t
e
i
u
n
t
e
r
′
FULL 
C
​
 FG 
P
​
 ATH"];thenecho"Konfigurationsdateiunter 
′
 
{FULL_CFG_PATH}' nicht gefunden. Erstelle eine Standard-Version..."
# Schreibe die Standard-Konfiguration in die Datei im "main" Ordner.
cat <<EOF > ${FULL_CFG_PATH}
// ### Automatisch erstellte Konfiguration ###
// Diese Datei wurde erstellt, weil keine im 'main'-Ordner vorhanden war.
// Sie können diese Datei nach Belieben bearbeiten.

// --- GRUNDEINSTELLUNGEN ---
// Der Name Ihres Servers, wie er in der Serverliste erscheint.
// Farbcodes: ^1=Rot, ^2=Grün, ^3=Gelb, ^4=Blau, ^5=Cyan, ^6=Pink, ^7=Weiß
sets sv_hostname "^2Neuer ^7Call of Duty 2 Server"

// Das RCON-Passwort zur Fernverwaltung des Servers.
// Es wird automatisch aus den Panel-Einstellungen übernommen.
set rcon_password "${RCON_PASSWORD}"

// --- MAP-ROTATION & START ---
// Definiere die Map-Rotation. Der Server startet mit der ersten Map in dieser Liste.
set sv_maprotation "gametype dm map mp_carentan gametype tdm map mp_toujane gametype sd map mp_burgundy"
set sv_maprotationcurrent ""

// Der wichtigste Befehl: Starte die Rotation.
wait
map_rotate
EOF
echo "Standard-Konfiguration wurde erfolgreich in '${FULL_CFG_PATH}' erstellt."
fi

--- ANGEPASSTE SERVER-STARTLOGIK ---
Der +exec Befehl muss jetzt den korrekten Pfad zur Konfigurationsdatei beinhalten.
START_COMMAND="./cod2_lnxded +set dedicated 2 +set net_ip 0.0.0.0 +set net_port ${SERVER_PORT} +set logfile 1 +exec ${FULL_CFG_PATH} +set g_gametype dm +map mp_carentan"

echo "Finaler, manuell gebauter Startbefehl: ${START_COMMAND}"
exec ${START_COMMAND}
