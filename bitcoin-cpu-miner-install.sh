#!/bin/bash
# Skript als root oder mit sudo ausführen!

echo "System-Update und Upgrade..."
sudo apt update && sudo apt full-upgrade -y

echo "Nicht mehr benötigte Pakete entfernen..."
sudo apt autoremove -y

echo "Benötigte Pakete installieren..."
sudo apt install git automake autoconf libcurl4-openssl-dev libjansson-dev libssl-dev libgmp-dev zlib1g-dev screen build-essential mosquitto-clients -y


# geht er um einen ordner zrück
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

# Stelle sicher, dass start.sh ausführbar ist
echo "Stelle sicher, dass start.sh ausführbar ist..."
chmod +x start.sh

# geht ins start.sh
echo "Miner wird jetzt in der Screen-Session 'btc-miner' gestartet..."
./start.sh

echo "Fertig! Der Miner ist Installirt."
