#!/bin/bash
set -e

# Wechsel in das Hauptverzeichnis des Containers
cd /home/container

# --- Installationslogik (unverändert und funktionierend) ---
if [ ! -f "coduo_lnxded" ]; then
    echo "CODUO-Serverdateien nicht gefunden. Starte Download..."
    wget -q -O coduo-server.tar.xz "http://linuxgsm.download/CallOfDutyUnitedOffensive/coduo-lnxded-1.51b-full.tar.xz"
    tar -xf coduo-server.tar.xz
    rm coduo-server.tar.xz
    chmod +x ./coduo_lnxded
    echo "Installation abgeschlossen."
fi

# --- LOGIK ZUR ERSTELLUNG DER server.cfg IM "main" ORDNER ---

# Stelle sicher, dass der "main" Ordner existiert
mkdir -p ./main

# Definiere den Namen und den vollständigen Pfad der Konfigurationsdatei
CFG_FILE_NAME="${SERVER_CFG:-server.cfg}"
FULL_CFG_PATH="./main/${CFG_FILE_NAME}"

# Prüfe, ob die Konfigurationsdatei im "main"-Ordner NICHT existiert
if [ ! -f "${FULL_CFG_PATH}" ]; then
    echo "Konfigurationsdatei unter '${FULL_CFG_PATH}' nicht gefunden. Erstelle eine Standard-Version..."
    # Schreibe die Standard-Konfiguration in die Datei im "main" Ordner
    cat <<EOF > ${FULL_CFG_PATH}
// ### Automatisch erstellte Konfiguration ###
// Diese Datei wurde erstellt, weil keine im 'main'-Ordner vorhanden war.
// Sie können diese Datei im Pterodactyl File Manager unter /main/${CFG_FILE_NAME} bearbeiten.

//Initialisieren Read Only Vars:

//Punkbuster
set sv_punkbuster "1"
pb_sv_enable
wait 5

//IP des Servers
set net_ip ""

//Port des Servers
set net_port "12203"

//Spiel loggen ( 0 = aus 1 = an )
set logfile "1"

//0 - gepuffertes Loggen (zeitversetzt)
//1 - sofortiges Loggen
set g_logsync "1"

//Name der Log-Datei
set g_log "games_mp.log"

//Oeffentliche Server-Informationen:

//Name des Servers
set sv_hostname "CODUO by Geekbee"

//Administrator des Servers
sets .Admin "Geekbee"

//E-Mail-Adresse des Admins
sets .Email ""

//IRC-Channels
sets .IRC "#n/a"

//Homepage
sets .Url ""

//Standort des Servers
sets .Location "Germany"

//Begruessung
set scr_motd "Willkommen"

//***

//Passwoerter

//RCON-Passwort
set rconPassword "geheim"

//NUR EINS VON BEIDEN VERWENDEN!
//Server-Passwort
set g_password ""

//Privates Passwort
set sv_privatepassword ""

//***

//Allgemeine Servereinstellungen:

//Maximale Spieleranzahl
set sv_maxclients "32"

//Private Clients
set sv_privateClients ""

//Maximale Datenrate
set sv_maxRate "25000"

//Mindest-Ping der Clients (0 = egal)
set sv_minPing ""

//Max-Ping der Clients (0 = egal)
set sv_maxPing "120"

//Antilag-Feature
set g_antilag "1"

//Friendly Fire (0 = an, 1 = aus,2 = reflektierend, 3 = geteilter Schaden)
set scr_friendlyfire "0"

//KillCam
set scr_killcam "1"

//Freies Umsehen
set scr_freelook "0"

//Gegner im Zuschauer-Modus beobachten
set scr_spectateenemy "0"

//PK3-Dateien-Abgleich (0 = an, 1 = aus)
//Wenn an mssen die pk3s des Servers und der Clients gleich sein!
set sv_pure "1"

//Automatischer Team-Ausgleich
set scr_teambalance "1"

//Wiedereinstieg erzwingen
set scr_forcerespawn "0"

//Schockeffekte an/aus
set scr_shellshock "1"

//Medi-Packs fallen lassen
set scr_drophealth "1"

//Battle Rank
set scr_battlerank "1"

//Anonymous
set sv_allowAnonymous "1"

//Cheats
set sv_cheats "0"

//Spam-Schutz
set sv_floodprotect "1"

//FPS des Servers
set sv_fps "20"

//Master-Server (wo der Server angemeldet werden soll)
seta sv_master0 "coduomaster.activision.com"
seta sv_master1 "codauthorize.activision.com"
seta sv_master2 "codmaster.infinityward.com"
seta sv_master3 ""
seta sv_master4 ""
set g_gamespy "0"

//Tote k?nen mit allen chatten 0 = aus, 1 = an
set g_deadChat "1"

//Konsolensperre fr Clients
set sv_disableClientConsole "0"

//Download erlauben
set sv_allowDownload "1"

//WWW Download erlauben
set sv_wwwDownload "0"

set sv_wwwBaseURL ""
set sv_wwwDlDisconnected "0"
set sv_reconnectlimit "3"
set sv_dl_maxRate "150000" 

//Voting erlauben
set g_allowvote "1"

//***
//Detailierte Votingoptionen ab UO:

//Spieler Bannen
set g_allowvotetempbanclient "1"

//Spieler kicken
set g_allowvoteclientkick "1"

//Spielmodus
set g_allowvotegametype "1"

//Map voten
set g_allowvotemap "1"

//Neustart
set g_allowvotemaprestart "1"

//Rotate
set g_allowvotemaprotate "1"

//Neustart
set g_allowvotetypemap "1"

//Symbol Freund
set g_allowvotedrawfriend "1"

//Friendly Fire
set g_allowVotefriendlyfire "1"

//Killcam
set g_allowvotekillcam "1"

//***
//Timeouts:

//Wie oft Timeout
set g_timeoutsallowed "3"

//Laenge einer Pause
set g_timeoutlength "6000"

//Verzoegerung vor Wiederaufnahme
set g_timeoutrecovery "300"

//Tiemout Konto pro Spiel
set g_timeoutbank "100000"

//***
//Neu in UO Punktabzug bei Teamkills:

set scr_teamscorepenalty "0"

//***

//Waffen-Einstellungen:
//(0 = verbieten, 1 = erlauben):

//Scharfschuetzengewehre:
set scr_allow_springfield "1"
set scr_allow_svt40 "1"
set scr_allow_kar98ksniper "1"
set scr_allow_nagantsniper "1"
set scr_allow_enfieldsniper "1"

//Gewehre:
set scr_allow_enfield "1"
set scr_allow_kar98k "1"
set scr_allow_m1carbine "1"
set scr_allow_m1garand "1"
set scr_allow_g43 ""
set scr_allow_nagant "1"

//Schwere MG's:
set scr_allow_bar "1"
set scr_allow_bren "1"
set scr_allow_mp44 "1"
set scr_allow_ppsh "1"

//Leichte MG's:
set scr_allow_mp40 "1"
set scr_allow_sten "1"
set scr_allow_thompson "1"
set scr_allow_pps42 "1"
set scr_allow_greasegun "1"

//Panzerfaust:
set scr_allow_panzerfaust "1"

//Granaten:
set scr_allow_fraggrenades ""

//Waffen in UO
set scr_allow_fg42 "1"
set scr_allow_pistols "1"
set scr_allow_satchel "1"
set scr_allow_flamethrower "1"
set scr_allow_artillery "1"
set scr_allow_bazooka "1"
set scr_allow_mg34 "1"
set scr_allow_dp28 "1"
set scr_allow_panzerschreck "1"

//Fahrbare Untersaetze:
set scr_allow_flak88 "1"
set scr_allow_su152 "1"
set scr_allow_elefant "1"
set scr_allow_panzeriv "1"
set scr_allow_t34 "1"
set scr_allow_sherman "1"
set scr_allow_horch "1"
set scr_allow_gaz67b "1"
set scr_allow_willyjeep "1"

//***

//Spiel-Modi-Einstellungen:

//DM (Death Match)

//Punkte-Limit
set scr_dm_scorelimit "50"

//Zeit-Limit
set scr_dm_timelimit "20"

//TDM (Team Deathmatch)
//Punkte-Limit
set scr_tdm_scorelimit "100"

//Zeit-Limit
set scr_tdm_timelimit "20"

//SD (Seach and Destroy)
//Zeit bis Rundenstart (Sekunden)
set scr_sd_graceperiod "15"

//Rundenlaenge
set scr_sd_roundlength "2.5"

//Runden-Limit
set scr_sd_roundlimit "8"

//Punkte-Limit (Runden)
set scr_sd_scorelimit "10"

//Zeit-Limit
set scr_sd_timelimit "20"

//Zeit bis Explosion der Bombe in Sek.
set scr_sd_bombtimer "60"

//CTF (Retrival)
//Punkte-Limit (Runden)
set scr_re_scorelimit "10"

//Zeit-Limit
set scr_re_timelimit "20"
set scr_re_roundlimit "10"
set scr_re_roundlength "4"
set scr_re_graceperiod "10"

//HQ
//Punkte-Limit
set scr_hq_scorelimit "50"

//Zeit-Limit
set scr_hq_timelimit "20"

//***Neue Spieltypen in UO
//BEL (Behind Enemy Lines)

//Punkte bei Ueberleben
set scr_bel_alivepointtime "10"

//Zeit-Limit
set scr_bel_timelimit "20"
set scr_bel_scorelimit "100"

//BAS (Base Assault)

//Punkte-Limit (Runden)
set scr_bas_scorelimit "10"

//Zeit-Limit
set scr_bas_timelimit "20"
set scr_bas_roundlimit "10"
set scr_bas_roundlength "4"
set scr_bas_respawn_wave_time "15"
set scr_bas_startrounddelay "15"
set scr_bas_endrounddelay "15"
set scr_bas_clearscoreeachround "0"

//CTF (Hol die Fahne)

//Punkte-Limit (Runden)
set scr_ctf_scorelimit "10"

//Zeit-Limit
set scr_ctf_timelimit "20"
set scr_ctf_roundlimit "2"
set scr_ctf_roundlength "10"
set scr_ctf_showoncompass "1"
set scr_ctf_startrounddelay "15"
set scr_ctf_endrounddelay "15"
set scr_ctf_clearscoreeachround "0"

//Dom (Domination)

//Punkte-Limit (Runden)
set scr_dom_scorelimit "10"

//Zeit-Limit
set scr_dom_timelimit "20"
set scr_dom_roundlimit "10"
set scr_dom_roundlength "4"
set scr_dom_respawn_wave_time "15"
set scr_dom_startrounddelay "15"
set scr_dom_endrounddelay "15"
set scr_dom_clearscoreeachround "0"

//Start-Spiel-Modus
set g_gametype "tdm"

set sv_mapRotation "gametype ctf map mp_bocage gametype ctf map mp_brecourt gametype ctf map mp_chateau gametype ctf map mp_carentan gametype ctf map mp_dawnville gametype ctf map mp_depot gametype ctf map mp_harbor gametype ctf map mp_hurtgen gametype ctf map mp_neuville gametype ctf map mp_pavlov gametype ctf map mp_railyard gametype ctf map mp_powcamp gametype ctf map mp_rocket gametype ctf map mp_ship gametype ctf map mp_tigertown gametype ctf map mp_arnhem gametype ctf map mp_berlin gametype ctf map mp_cassino gametype ctf map mp_foy gametype ctf map mp_italy gametype ctf map mp_kharkov gametype ctf map mp_kursk gametype ctf map mp_ponyri gametype ctf map mp_rhinevalley gametype ctf map mp_sicily gametype ctf map mp_uo_stanjel "



set sv_mapRotationCurrentmap "mp_berlin"


wait 250
map_rotate
EOF
    echo "Standard-Konfiguration wurde erfolgreich in '${FULL_CFG_PATH}' erstellt."
fi

# --- DER TRICK: SYMBOLISCHER LINK ---
# Erstelle eine "Verknüpfung" (symbolischer Link) im Hauptverzeichnis,
# die auf die echte Konfigurationsdatei im 'main'-Ordner zeigt.
# Die Option -f sorgt dafür, dass ein alter Link überschrieben wird.
echo "Erstelle symbolischen Link: ./${CFG_FILE_NAME} -> ${FULL_CFG_PATH}"
ln -sf "${FULL_CFG_PATH}" "./${CFG_FILE_NAME}"


# --- FINALE SERVER-STARTLOGIK ---
# Der +exec Befehl nutzt nun den einfachen Namen. Das Spiel findet den Link im Hauptverzeichnis
# und lädt die korrekte Datei aus dem 'main' Ordner.
# Die Map und Gametype am Ende sind nur für den allerersten Start, danach übernimmt die cfg.
START_COMMAND="./coduo_lnxded +set dedicated 2 +set net_ip 0.0.0.0 +set net_port ${SERVER_PORT} +set logfile 1 +exec ${CFG_FILE_NAME} +set g_gametype tdm +map mp_berlin"

echo "Finaler, manuell gebauter Startbefehl: ${START_COMMAND}"
exec ${START_COMMAND}
