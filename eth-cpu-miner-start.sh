#!/bin/bash

# Überprüfen, ob der Parameter -u übergeben wurde
if [ "$1" == "-u" ]; then
    # Prüfen, ob update.sh ausführbar ist
    if [ ! -x "./update.sh" ]; then
        echo "update_miner.sh ist nicht ausführbar. Setze Berechtigungen..."
        chmod +x ./update.sh
    fi
    # Update-Skript ausführen
    ./update.sh
    exit 0
fi

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
# Funktion zum Abfragen der Wallet- und Pool-Adresse
frage_daten() {
    echo "Bitte Wallet-Adresse eingeben:"
    read -r WALLET_ADDRESS
    echo "Bitte Pool-URL eingeben (z.B. eu1.solopool.org:8011):"
    echo "EU-Server"
    echo "4G	eu1.solopool.org	8011	Low-End Hardware"
    echo "16G	eu1.solopool.org	7011	Mid-Range Hardware"
    echo "64G	eu1.solopool.org	9011	High-End Hardware"
    echo "USA-Server"
    echo "4G	us1.solopool.org	8011	Low-End Hardware"
    echo "16G	us1.solopool.org	7011	Mid-Range Hardware"
    echo "64G	us1.solopool.org	9011	High-End Hardware"
    read -r POOL_URL

    # Speichern der Daten in der Datei
    echo "WALLET_ADDRESS=\"$WALLET_ADDRESS\"" > "$DATA_FILE"
    echo "POOL_URL=\"$POOL_URL\"" >> "$DATA_FILE"
}

# Variablen
SESSION_NAME="ETH-miner"
MINER_VERZEICHN="$HOME/ethminer"
DATA_FILE="eth-cpu.userdata"

# Parameterverarbeitung (bestehender Code)
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

# Überprüfen, ob die Screen-Session bereits läuft
if screen -list | grep -q "$SESSION_NAME"; then
    echo "Die Screen-Session '$SESSION_NAME' läuft bereits."
else
    echo "Starte den Miner in einer neuen Screen-Session..."

    # In das Verzeichnis wechseln und Miner starten in einer Screen-Session
    cd "$MINER_VERZEICHN" && \
        screen -dmS "$SESSION_NAME" ./ethminer -U -P stratum1+tcp://$WALLET_ADDRESS.Worker1@"$POOL_URL"

    if [ $? -eq 0 ]; then
        echo "Miner wurde erfolgreich gestartet."
    else
        echo "Fehler beim Starten des Miners."
        exit 1
    fi
fi
