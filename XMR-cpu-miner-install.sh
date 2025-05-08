#!/bin/bash

# Funktion zum Ausführen von Befehlen mit Root-Rechten
run_as_root() {
    if [ "$EUID" -ne 0 ]; then
        sudo "$@"
    else
        "$@"
    fi
}

# Falls das Skript nicht als root läuft, neu starten mit sudo
if [ "$EUID" -ne 0 ]; then
    echo "Dieses Skript wird jetzt mit root-Rechten neu gestartet..."
    exec sudo "$0" "$@"
fi

# Ab hier läuft das Skript bereits als root

# Funktion zum Starten des Miners
start_miner() {
    echo "Stelle sicher, dass start.sh ausführbar ist..."
    chmod +x start.sh || { echo "Fehler beim Setzen der Ausführungsrechte für start.sh"; exit 1; }
    echo "Miner wird jetzt in der Screen-Session 'xmr' gestartet..."
    ./start.sh || { echo "Fehler beim Starten des Miners"; exit 1; }
    echo "Fertig! Der Miner läuft jetzt."
}

# Überprüfen, ob der Ordner 'xmrig' bereits existiert
if [ -d "xmrig" ]; then
    echo "Der Ordner 'xmrig' wurde gefunden. Es scheint, dass der Miner bereits installiert ist."
    start_miner
    exit 0
fi

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

# In den Parent-Ordner wechseln (falls notwendig)
cd .. || { echo "Fehler beim Wechsel in den Parent-Ordner"; exit 1; }

# Klonen des Miners-Repositories
echo "Klonen des Miners-Repositories..."
run_as_root git clone https://github.com/xmrig/xmrig.git || { echo "Fehler beim Klonen des Repositories"; exit 1; }

cd xmrig || { echo "Fehler beim Wechsel in den xmrig-Ordner"; exit 1; }

# Erstellen des Builds
echo "Erstelle build"
mkdir build && cd build || { echo "Fehler beim Erstellen des Build-Ordners"; exit 1; }

# Konfigurieren (ohne sudo)
echo "Konfigurieren..."
cmake .. || { echo "Fehler bei cmake"; exit 1; }

# Bauen (ohne sudo)
echo "Bauen..."
make || { echo "Fehler beim Kompilieren"; exit 1; }

# Miner starten
start_miner
