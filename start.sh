#!/bin/bash

# Funktion zum Installieren des Bitcoin CPU Miners
install_bitcoin_cpu_miner() {
    echo "Bitcoin CPU Miner wird installiert..."
    cd "$(dirname "$0")"
    chmod +x bitcoin-cpu-miner-install.sh
    ./bitcoin-cpu-miner-install.sh
}

# Funktion zum Installieren des XMR CPU Miners
install_xmr_cpu_miner() {
    echo "XMR CPU Miner wird installiert..."
    cd "$(dirname "$0")"
    chmod +x XMR-cpu-miner-install.sh
    ./XMR-cpu-miner-install.sh
}

# Funktion zum Ausführen des btc-cpu-miner.sh Skripts
run_btc_cpu_miner() {
    echo "Starte btc-cpu-miner.sh..."
    chmod +x btc-cpu-miner.sh
    ./btc-cpu-miner.sh
}

# Funktion zum Ausführen des xmr-cpu-miner.sh Skripts
run_xmr_cpu_miner() {
    echo "Starte xmr-cpu-miner.sh..."
    chmod +x xmr-cpu-miner.sh
    ./xmr-cpu-miner.sh
}

# Funktion für die Bitcoin CPU Miner Auswahl basierend auf Ordner
bitcoin_miner_auswahl() {
    local script_dir="$(dirname "$0")"

    if [ -d "$script_dir/../cpuminer-multi" ]; then
        echo "Der Ordner 'cpuminer-multi' wurde gefunden."
        # Stelle sicher, dass das Skript ausführbar ist
        chmod +x "$script_dir/btc-cpu-miner.sh"
        run_btc_cpu_miner
    else
        echo "Der Ordner 'cpuminer-multi' wurde nicht gefunden."
        echo "Bitte wählen Sie eine Option:"
        echo "1) Bitcoin CPU Miner installieren"
        echo "2) Zurück"
        echo "3) Beenden"
        read -p "Ihre Wahl (1/2): " miner_auswahl

        case "$miner_auswahl" in
            1)
                install_bitcoin_cpu_miner
                ;;
            2)
                echo "Zurück zum Hauptmenü."
                ;;
            3)
                echo "Beenden..."
                exit 0
                ;;
            *)
                echo "Ungültige Auswahl. Zurück zum Hauptmenü."
                ;;
        esac
    fi
}

# Nur mit Xmrig (XMR Miner)
xmr_miner_auswahl() {
    local script_dir="$(dirname "$0")"

    if [ -d "$script_dir/../xmrig" ]; then
        echo "Der Ordner 'xmrig' wurde gefunden."
        # Stelle sicher, dass das Installationsskript ausführbar ist
        chmod +x "$script_dir/XMR-cpu-miner-install.sh"
        run_xmr_cpu_miner
    else
        echo "Der Ordner 'xmrig' wurde nicht gefunden."
        echo "Bitte wählen Sie eine Option:"
        echo "1) XMR CPU Miner installieren"
        echo "2) Zurück"
        echo "3) Beenden"
        read -p "Ihre Wahl (1/2): " miner_auswahl

        case "$miner_auswahl" in
            1)
                install_xmr_cpu_miner
                ;;
            2)
                echo "Zurück zum Hauptmenü."
                ;;
            3)
                echo "Beenden..."
                exit 0
                ;;
            *)
                echo "Ungültige Auswahl. Zurück zum Hauptmenü."
                ;;
        esac
    fi
}

# Hauptmenü in einer Schleife, damit es wiederholt wird
while true; do
    echo ""
    echo "Hauptmenü:"
    echo "1) Programm beenden"
    echo "2) Update ausführen"
    echo "3) Bitcoin CPU Miner verwalten"
    echo "4) Xmr CPU Miner verwalten"
    read -p "Deine Wahl (1/2/3/4): " haupt_auswahl

    case "$haupt_auswahl" in
        1)
            echo "Programm wird beendet."
            exit 0
            ;;
        2)
            if [ -f "$(dirname "$0")/update.sh" ]; then
                chmod +x "$(dirname "$0")/update.sh"
                "$(dirname "$0")/update.sh"
            else 
                echo "'update.sh' wurde nicht gefunden."
            fi
            ;;
        3)
            bitcoin_miner_auswahl
            ;;
        4)
            xmr_miner_auswahl
            ;;
        *)
            echo "Ungültige Auswahl. Bitte versuche es erneut."
            ;;
    esac
done

echo "Skript beendet."
exit 0
