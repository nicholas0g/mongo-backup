#!/bin/bash

# Assicurati che la variabile d'ambiente MONGO_URI sia impostata
if [ -z "$MONGO_URI" ]; then
    echo "Errore: la variabile d'ambiente MONGO_URI non è impostata."
    exit 1
fi
while true
do 
    echo "Backup in corso..."
    # Usa la variabile d'ambiente per l'URI
    mongodump --uri="$MONGO_URI" --out /backup/dump

    # Crea un archivio zip con la data e ora di oggi
    timestamp=$(date +"%Y%m%d_%H%M%S")
    zip -r "/backup/db_$timestamp.zip" /backup/dump

    # Rimuovi i file originali dopo averli archiviati
    rm -rf /backup/dump
    echo "Attendo 1h prima di effettuare un altro backup..."
    sleep 1h

done
