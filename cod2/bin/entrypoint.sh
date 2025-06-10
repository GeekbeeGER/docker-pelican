#!/bin/bash
set -e

cd /home/container

# --- Installationslogik (unverändert und funktionierend) ---
if [ ! -f "cod2_lnxded" ]; then
    echo "COD2-Dateien nicht gefunden. Starte Download..."
    wget -q -O cod2-server.tar.xz "http://linuxgsm.download/CallOfDuty2/cod2-lnxded-1.3-full.tar.xz"
    tar -xf cod2-server.tar.xz
    rm cod2-server.tar.xz
    chmod +x ./cod2_lnxded
    echo "Installation abgeschlossen."
else
    echo "Dateien bereits vorhanden."
fi

# --- Neue, verbesserte Server-Startlogik ---
# Das Panel übergibt den Startbefehl in der Variable $STARTUP.
# Wir müssen die {{...}}-Platzhalter darin durch die Werte aus den
# anderen Umgebungsvariablen ersetzen.

# Ersetze die Platzhalter im Startbefehl.
# Diese Methode ist sehr robust gegen leere Variablen.
# Wir verwenden hier `eval` um die Befehlsersetzung durchzuführen.
PARSED_STARTUP=$(eval echo $(echo ${STARTUP}))

# Gib den finalen Befehl zur Kontrolle aus
echo "Finaler, geparster Startbefehl: ${PARSED_STARTUP}"

# Führe den Befehl aus
exec ${PARSED_STARTUP}
