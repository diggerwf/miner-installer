#!/bin/bash
# Skript als root oder mit sudo ausführen!

# Funktion zum Starten des Miners
start_miner() {
    echo "Stelle sicher, dass start.sh ausführbar ist..."
    chmod +x start.sh
    echo "Miner wird jetzt in der Screen-Session 'btc-miner' gestartet..."
    ./start.sh
    echo "Fertig! Der Miner läuft jetzt."
}

# Überprüfen, ob der Ordner 'cpuminer-multi' bereits existiert
if [ -d "cpuminer-multi" ]; then
    echo "Der Ordner 'cpuminer-multi' wurde gefunden. Es scheint, dass der Miner bereits installiert ist."
    start_miner
    exit 0
fi

# Falls nicht vorhanden, dann den Installationsprozess starten

echo "System-Update und Upgrade..."
sudo apt update && sudo apt full-upgrade -y

echo "Nicht mehr benötigte Pakete entfernen..."
sudo apt autoremove -y

echo "Benötigte Pakete installieren..."
sudo apt install git automake autoconf libcurl4-openssl-dev libjansson-dev libssl-dev libgmp-dev zlib1g-dev screen build-essential mosquitto-clients -y

# Geht um einen Ordner zurück (falls notwendig)
cd ..

echo "Klonen des Miners-Repositories..."
git clone https://github.com/tpruvot/cpuminer-multi
cd cpuminer-multi

echo "Autogen-Skript ausführen..."
sudo ./autogen.sh

echo "Konfigurieren..."
sudo ./configure

echo "Bauen..."
sudo ./build.sh

# Miner starten
start_miner
