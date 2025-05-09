#!/bin/bash

# Speichere den ursprünglichen Ordner
ORIGINAL_DIR=$(pwd)

# Funktion zum Starten des Miners
start_miner() {
    echo "Wechsel in den miner-installer-Ordner..."
    cd miner-installer || { echo "Fehler beim Wechsel in den miner-installer-Ordner"; exit 1; }
    echo "Stelle sicher, dass start.sh ausführbar ist..."
    chmod +x start.sh
    ./start.sh
    # Nach dem Start wieder in den ursprünglichen Ordner zurückkehren (optional)
    cd "$ORIGINAL_DIR"
}

# Prüfen, ob die start.sh bereits vorhanden ist (im aktuellen Verzeichnis)
if [ -f "miner-installer/start.sh" ]; then
    echo "start.sh im miner-installer gefunden. Miner wird gestartet..."
    start_miner
    exit 0
fi

# Wenn nicht vorhanden: in den Parent-Ordner wechseln (falls notwendig)
echo "start.sh nicht gefunden. Installation wird gestartet..."
cd .. || { echo "Fehler beim Wechsel in den Parent-Ordner"; exit 1; }

# System aktualisieren und bauen (wie vorher)
apt update && apt full-upgrade -y
apt autoremove -y
apt install git screen build-essential cmake libuv1-dev libssl-dev libhwloc-dev -y

# Klonen des Miners-Repositories
git clone https://github.com/xmrig/xmrig.git

# Zurück im ursprünglichen Ordner
cd "$ORIGINAL_DIR"

# In den xmrig-Ordner wechseln und bauen
cd xmrig || { echo "Fehler beim Wechsel in den xmrig-Ordner"; exit 1; }
mkdir build && cd build
cmake .. || { echo "cmake Fehler"; exit 1; }
make || { echo "Make Fehler"; exit 1; }

# Nach dem Build: wieder in den ursprünglichen Ordner zurückkehren
cd "$ORIGINAL_DIR"

# Optional: Miner automatisch starten nach der Installation
echo "Starte Miner..."
start_miner
