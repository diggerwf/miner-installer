#!/bin/bash

# Variablen
SESSION_NAME="btc-miner"
MINER_VERZEICHN="$HOME/cpuminer-multi"
DATA_FILE="btc-cpu-userdata"

# Parameterverarbeitung für -stop
if [ "$1" == "-stop" ]; then
    if screen -list | grep -q "$SESSION_NAME"; then
        echo "Beende die Screen-Session '$SESSION_NAME'..."
        screen -S "$SESSION_NAME" -X quit
        echo "Miner wurde gestoppt."
    else
        echo "Keine laufende Screen-Session '$SESSION_NAME' gefunden."
    fi
    exit 0
fi

# Beispiel: Daten löschen (-w)
if [[ "$1" == "-w" ]]; then
    echo "Lösche gespeicherte Daten..."
    rm -f "$DATA_FILE"
    echo "Daten gelöscht. Das Skript wird beendet."
    exit 0
fi

# Falls keine Daten vorhanden, abfragen (hier kannst du deine Funktion einfügen)
if [ ! -f "$DATA_FILE" ]; then
    # Beispiel: Daten eingeben oder laden
    echo "Bitte gib deine Wallet-Adresse ein:"
    read WALLET_ADDRESS
    echo "Bitte gib den Pool-URL ein:"
    read POOL_URL

    # Daten speichern
    echo "WALLET_ADDRESS='$WALLET_ADDRESS'" > "$DATA_FILE"
    echo "POOL_URL='$POOL_URL'" >> "$DATA_FILE"
else
    source "$DATA_FILE"
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

    (
        cd "$MINER_VERZEICHN" && \
        screen -dmS "$SESSION_NAME" ./xmrig --donate-level=1 -o "$POOL_URL" -u "$WALLET_ADDRESS" -p x

        if [ $? -eq 0 ]; then
            echo "Miner wurde erfolgreich gestartet."
        else 
            echo "Fehler beim Starten des Miners."
            exit 1
        fi
    )
fi
