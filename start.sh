#!/bin/bash

datei2="update.sh"
auswahl2="update"

echo "Bitte wähle eine Option:"
echo "1) Beenden"
echo "2) $auswahl2"
read -p "Deine Wahl (1 oder 2): " auswahl

if [ "$auswahl" == "1" ]; then
    echo "Programm wird beendet."
    exit 0
elif [ "$auswahl" == "2" ]; then
    if [ -f "$datei2" ]; then
        chmod +x "$datei2"
        ./"$datei2"
    else
        echo "Datei '$datei2' wurde nicht gefunden."
    fi
else
    echo "Ungültige Auswahl."
fi

echo "Skript beendet."
exit 0
