#!/bin/bash

# Variablen
SESSION_NAME="btc-miner"
MINER_VERZEICHN="$HOME/btc-miner/build"
DATA_FILE="btc-cpu-userdata"

# Parameterverarbeitung für Stop
if [ "$1" == "-stop" ]; then
    if screen -list | grep -q "$SESSION_NAME"; then
        echo "Beende die Screen-Session '$SESSION_NAME'..."
        screen -S "$SESSION_NAME" -X quit
        echo "Miner gestoppt."
    else
        echo "Keine laufende Screen-Session '$SESSION_NAME' gefunden."
    fi
    exit 0
fi

# Hier kannst du weitere Parameterverarbeitungen hinzufügen, z.B. für Start, Daten löschen etc.
# Beispiel: Daten löschen (-w), Daten eingeben (-i), etc.

# Beispiel: Daten löschen
if [[ "$1" == "-w" ]]; then
    echo "Lösche gespeicherte Daten..."
    rm -f "$DATA_FILE"
    echo "Daten gelöscht. Das Skript wird beendet."
    exit 0
fi

# Falls keine Daten vorhanden, abfragen (falls notwendig)
if [ ! -f "$DATA_FILE" ]; then
    # Funktion zum Abfragen der Wallet- und Pool-Adresse kannst du hier einfügen
    # oder andere Initialisierungen vornehmen.
    echo "Hier kannst du deine Eingaben machen oder das Skript anpassen."
fi

# Überprüfen, ob das Verzeichnis existiert
if [ ! -d "$MINER_VERZEICHN" ]; then
    echo "Fehler: Das Verzeichnis '$MINER_VERZEICHN' existiert nicht."
    exit 1
fi

# Überprüfen, ob die Screen-Session bereits läuft (nur starten, wenn nicht)
if screen -list | grep -q "$SESSION_NAME"; then
    echo "Die Screen-Session '$SESSION_NAME' läuft bereits."
else
    echo "Starte den Miner in einer neuen Screen-Session..."

    # In das Verzeichnis wechseln und Miner starten in einer Screen-Session
    (
        cd "$MINER_VERZEICHN" && \
        screen -dmS "$SESSION_NAME" ./miner-binary --optionen

        if [ $? -eq 0 ]; then
            echo "Miner wurde erfolgreich gestartet."
        else 
            echo "Fehler beim Starten des Miners."
            exit 1
        fi
    )
fi
