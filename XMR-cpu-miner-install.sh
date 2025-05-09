#!/bin/bash

# Speichere den ursprünglichen Ordner (wo das Skript liegt)
ORIGINAL_DIR=$(pwd)

# Funktion zum Ausführen von Befehlen mit Root-Rechten
run_as_root() {
    if [ "$EUID" -ne 0 ]; then
        sudo "$@"
    else
        "$@"
    fi
}

# Falls nicht als root, neu starten mit sudo
if [ "$EUID" -ne 0 ]; then
    echo "Dieses Skript wird jetzt mit root-Rechten neu gestartet..."
    exec sudo "$0" "$@"
fi

# Funktion zum Starten des Miners im xmrig-Verzeichnis
start_miner() {
    echo "Stelle sicher, dass start.sh ausführbar ist..."
    chmod +x start.sh

    # Miner starten (z.B. in Screen oder direkt)
    ./start.sh

    echo "Miner wurde gestartet."
}

# Prüfen, ob xmrig bereits installiert ist
if [ -d "xmrig" ]; then
    echo "Der Ordner 'xmrig' wurde gefunden. Es scheint, dass der Miner bereits installiert ist."

    # In den xmrig-Ordner wechseln
    cd xmrig || { echo "Fehler beim Wechsel in den xmrig-Ordner"; exit 1; }

    # Miner starten
    start_miner

    # Zurück in den ursprünglichen Ordner (miner-installer)
    cd "$ORIGINAL_DIR"

    exit 0
fi

# Wenn nicht vorhanden: in den Parent-Ordner wechseln (weil das Skript im miner-installer liegt)
echo "xmrig nicht gefunden. Installation wird gestartet..."
cd .. || { echo "Fehler beim Wechsel in den Parent-Ordner"; exit 1; }

# System aktualisieren und upgraden
echo "System-Update und Upgrade..."
run_as_root apt update || { echo "Fehler bei apt update"; exit 1; }
run_as_root apt full-upgrade -y || { echo "Fehler bei apt full-upgrade"; exit 1; }

# Nicht mehr benötigte Pakete entfernen
echo "Nicht mehr benötigte Pakete entfernen..."
run_as_root apt autoremove -y || { echo "Fehler bei autoremove"; exit 1; }

# Benötigte Pakete installieren
echo "Benötigte Pakete installieren..."
run_as_root apt install git screen build-essential cmake libuv1-dev libssl-dev libhwloc-dev -y || { echo "Fehler bei Paketinstallation"; exit 1; }

# Klonen des Miners-Repositories
echo "Klonen des Miners-Repositories..."
run_as_root git clone https://github.com/xmrig/xmrig.git || { echo "Fehler beim Klonen des Repositories"; exit 1; }

# Zurück in den ursprünglichen Ordner (miner-installer)
cd "$ORIGINAL_DIR" || { echo "Fehler beim Zurückkehren zum Originalordner"; exit 1; }

# In den xmrig-Ordner wechseln und bauen
cd xmrig || { echo "Fehler beim Wechsel in den xmrig-Ordner"; exit 1; }
echo "Erstelle build..."
mkdir build && cd build || { echo "Fehler beim Erstellen des Build-Ordners"; exit 1; }
echo "Konfigurieren..."
cmake .. || { echo "Fehler bei cmake"; exit 1; }
echo "Bauen..."
make || { echo "Fehler beim Kompilieren"; exit 1; }

# Nach Abschluss: wieder in den ursprünglichen Ordner zurückkehren (falls gewünscht)
cd "$ORIGINAL_DIR"

# Optional: hier kannst du noch automatisch start.sh ausführen, falls vorhanden.
