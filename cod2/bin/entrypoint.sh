#!/bin/bash

# Wechsle in das Home-Verzeichnis
cd /home/container || exit 1

# --- Installationslogik ---
# Prüfe, ob die Server-Executable bereits existiert.
if [ ! -f "cod2_lnxded" ]; then
    echo "--------------------------------------------------"
    echo "Call of Duty 2 Serverdateien nicht gefunden."
    echo "Starte den einmaligen Download und die Installation..."
    echo "--------------------------------------------------"

    # Lade die Serverdateien von linuxgsm.download herunter
    wget -q -O cod2-server.tar.xz "http://linuxgsm.download/CallOfDuty2/cod2-lnxded-1.3-full.tar.xz"

    # Entpacke das Archiv
    tar -xf cod2-server.tar.xz

    # Lösche das heruntergeladene Archiv, um Platz zu sparen
    rm cod2-server.tar.xz

    # Mache die Server-Executable ausführbar
    chmod +x ./cod2_lnxded

    echo "--------------------------------------------------"
    echo "Installation abgeschlossen!"
    echo "--------------------------------------------------"
else
    echo "Serverdateien bereits vorhanden, überspringe Installation."
fi

# --- Server-Startlogik ---
# Führe den Befehl aus, der vom Pelican Panel übergeben wurde.
# "$@" enthält den kompletten "Startup Command" aus dem Panel.
echo "Starte den Server mit folgendem Befehl:"
echo "exec $@"
exec "$@"
