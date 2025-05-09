#!/bin/bash

# Variablen
HOME_DIR="$HOME"
MINER_DIR="xmrig"
REPO_URL="https://github.com/xmrig/xmrig.git"
INSTALLER_DIR="$HOME/miner-installer"
START_SCRIPT="$INSTALLER_DIR/start.sh"

# Schritt 1: Überprüfen, ob der Miner bereits vorhanden ist
if [ -d "$MINER_DIR" ]; then
    echo "Miner-Verzeichnis gefunden. Gehe wieder zurück in start.sh"
    chmod +x "$START_SCRIPT"
    "$START_SCRIPT"
    exit 0
fi

# Schritt 2: System aktualisieren und benötigte Pakete installieren
echo "System aktualisieren..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y git build-essential cmake libuv1-dev libssl-dev libhwloc-dev

# Schritt 3: Miner klonen (im aktuellen Verzeichnis)
cd "$HOME_DI"
echo "Klonen des xmrig Miners..."
git clone "$REPO_URL" "$MINER_DIR"

# Schritt 4: Xmr Miner bauen
cd "$MINER_DIR"
mkdir -p build && cd build
echo "Konfigurieren..."
sudo cmake ..
echo "Bauen..."
sudo make -j$(nproc)

# Schritt 5: Zurück ins Verzeichnis `miner-installer`
cd ../../"$INSTALLER_DIR"

# Schritt 6: start.sh setzen, chmod +x und ausführen
if [ ! -f "$START_SCRIPT" ]; then
    echo "Die Datei $START_SCRIPT wurde nicht gefunden. Bitte erstelle sie mit folgendem Inhalt:"
    echo ""
    echo "#!/bin/bash"
    echo "./xmrig --config=../xmrig/config.json"
    echo ""
    exit 1
fi

chmod +x "$START_SCRIPT"
echo "Starte den Miner über $START_SCRIPT..."
"$START_SCRIPT"
