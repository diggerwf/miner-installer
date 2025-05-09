#!/bin/bash

while true; do
    clear
    echo "Bitte wähle eine Option:"
    echo "1) Start"
    echo "2) Stop"
    echo "3) Data neu"
    echo "4) Data nur Löschen"
    echo "5) Zurück"
    echo "6) Beenden"
    read -p "Deine Wahl: " auswahl

    case "$auswahl" in
        1)
            chmod +x btc-cpu-miner-start.sh
            ./xmr-miner-start.sh
            read -p "Drücke Enter, um fortzufahren..."
            ;;
        2)
            chmod +x btc-cpu-miner-start.sh
            ./xmr-miner-start.sh -stop
            read -p "Drücke Enter, um fortzufahren..."
            ;;
        3)
            chmod +x btc-cpu-miner-start.sh
            ./xmr-miner-start.sh -wi
            read -p "Drücke Enter, um fortzufahren..."
            ;;
        4)
            chmod +x btc-cpu-miner-start.sh
            ./xmr-miner-start.sh -w
            read -p "Drücke Enter, um fortzufahren..."
            ;;
        5)
            chmod +x start.sh
            ./start.sh
            read -p "Drücke Enter, um fortzufahren..."
            ;;
        6)
            echo "Beenden..."
            exit 0
            ;;
        *)
            echo "Ungültige Auswahl!"
            sleep 2
            ;;
    esac
done
