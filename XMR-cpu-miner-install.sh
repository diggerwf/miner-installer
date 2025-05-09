#!/bin/bash

# Dieses Skript installiert und startet den XMRig CPU-Miner.
# Es sollte mit Root-Rechten oder sudo ausgeführt werden.

# Variablen
MINER_DIR="../xmrig"
REPO_URL="https://github.com/xmrig/xmrig.git"
SCREEN_SESSION_NAME="xmr-miner"
START_SCRIPT_NAME="start.sh"

# Funktion zum Starten des Miners
start_miner() {
    echo "Stelle sicher, dass $START_SCRIPT_NAME ausführbar ist..."
    chmod +x "$START_SCRIPT_NAME"

    echo "Starte den Miner in der Screen-Session '$SCREEN_SESSION_NAME'..."
    # Überprüfen, ob die Session bereits läuft
    if screen -list | grep -q "$SCREEN_SESSION_NAME"; then
        echo "Die Screen-Session '$SCREEN_SESSION_NAME' läuft bereits."
    else
        screen -dmS "$SCREEN_SESSION_NAME" "./$START_SCRIPT_NAME"
        echo "Miner wurde in der Screen-Session gestartet."
    fi
}

# Prüfen, ob der Miner bereits installiert ist
if [ -d "$MINER_DIR" ]; then
    echo "Der Ordner '$MINER_DIR' wurde gefunden. Der Miner ist wahrscheinlich bereits installiert."
    start_miner
    exit 0
fi

# System aktualisieren und benötigte Pakete installieren
echo "System-Update und Upgrade..."
sudo apt update && sudo apt full-upgrade -y

echo "Nicht mehr benötigte Pakete entfernen..."
sudo apt autoremove -y

echo "Benötigte Pakete installieren..."
sudo apt install -y screen git build-essential cmake libuv1-dev libssl-dev libhwloc-dev

# In das Verzeichnis wechseln (falls notwendig)
cd "$(dirname "$0")"

# Klonen des Miners-Repositories
echo "Klonen des Miners-Repositories..."
git clone "$REPO_URL" "$MINER_DIR"

# In das Build-Verzeichnis wechseln
mkdir -p "$MINER_DIR/build"
cd "$MINER_DIR/build"

# Konfigurieren und bauen
echo "Konfigurieren..."
sudo cmake ..

echo "Bauen..."
sudo make -j$(nproc)

# Erstellen eines einfachen Start-Skripts (falls noch nicht vorhanden)
cat <<EOF > "$START_SCRIPT_NAME"
#!/bin/bash
./xmrig --config=config.json
EOF

chmod +x "$START_SCRIPT_NAME"

# Optional: Beispiel-Konfigurationsdatei erstellen (hier nur ein Platzhalter)
cat <<EOF > "$MINER_DIR/config.json"
{
    "autosave": true,
    "cpu": {
        "enabled": true,
        "hugePages": true,
        "priority": null,
        "memoryPool": false,
        "yield": true,
        "maxThreads": 0,
        "threads": []
    },
    "donate-level": 1,
    "pools": [
        {
            "url": "<POOL_URL>",
            "user": "<YOUR_WALLET_ADDRESS>",
            "pass": "<PASSWORD>",
            "keepalive": true,
            "algo": null,
            "coin": null,
            "rig-id": null,
            "nicehash": false,
            "enabled": true
        }
    ]
}
EOF

echo "Installation abgeschlossen."

# Miner starten
start_miner

echo "Fertig! Der Miner läuft jetzt in der Screen-Session '$SCREEN_SESSION_NAME'."
