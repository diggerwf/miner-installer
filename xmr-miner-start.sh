#!/bin/bash

# Funktion zum Abfragen der Daten
frage_daten() {
    echo "Bitte Wallet-Adresse eingeben:"
    read -r WALLET_ADDRESS
    echo "Bitte Pool-URL eingeben:"
    read -r POOL_URL

    # Daten in die Datei schreiben
    cat > "$DATA_FILE" <<EOF
WALLET_ADDRESS="$WALLET_ADDRESS"
POOL_URL="$POOL_URL"
EOF
}

# Überprüfen, ob der Parameter -u übergeben wurde
if [ "$1" == "-u" ]; then
    # Prüfen, ob update.sh ausführbar ist
    if [ ! -x "$HOME/miner-installer/update.sh" ]; then
        echo "update.sh ist nicht ausführbar. Setze Berechtigungen..."
        chmod +x "$HOME/miner-installer/update.sh"
    fi
    # Update-Skript ausführen
    "$HOME/miner-installer/update.sh"
    exit 0
fi

# Variablen
SESSION_NAME="xmrig-miner"
MINER_VERZEICHN="$HOME/xmrig/build"
DATA_FILE="xmrig-cpu.userdata"

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

# Weitere Parameterverarbeitung (Löschen, Initialisieren)
if [[ "$1" == "-w" ]]; then
    echo "Lösche gespeicherte Daten..."
    rm -f "$DATA_FILE"
    echo "Daten gelöscht. Das Skript wird beendet."
    exit 0
elif [[ "$1" == "-i" ]]; then
    if [ -f "$DATA_FILE" ]; then
        source "$DATA_FILE"
        echo "Geladene Daten:"
        echo "Wallet: $WALLET_ADDRESS"
        echo "Pool: $POOL_URL"
    else
        frage_daten
        source "$DATA_FILE"
    fi
elif [[ "$1" == "-wi" ]]; then
    echo "Lösche gespeicherte Daten..."
    rm -f "$DATA_FILE"
    frage_daten
    source "$DATA_FILE"
fi

# Falls keine Daten vorhanden, abfragen
if [ ! -f "$DATA_FILE" ]; then
    frage_daten
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

    # In das Verzeichnis wechseln und Miner starten in einer Screen-Session
    (
        cd "$MINER_VERZEICHN" && \
        screen -dmS "$SESSION_NAME" ./xmrig -a rx/0 -o "$POOL_URL" -u "$WALLET_ADDRESS" -p x

        if [ $? -eq 0 ]; then
            echo "Miner wurde erfolgreich gestartet."
        else 
            echo "Fehler beim Starten des Miners."
            exit 1
        fi
    )
fi
