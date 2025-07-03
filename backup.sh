#!/bin/bash

export HOME=/root

# Configura s3cmd con le variabili d'ambiente
cat > /root/.s3cfg <<EOF
[default]
access_key = ${AWS_KEY}
secret_key = ${AWS_SECRET}
region = ${AWS_REGION}
host_base = ${AWS_S3_ENDPOINT}
host_bucket = ${AWS_S3_ENDPOINT}
bucket_location = ${AWS_REGION}
EOF

# Assicurati che la variabile d'ambiente MONGO_URI sia impostata
if [ -z "$MONGO_URI" ]; then
    echo "Errore: la variabile d'ambiente MONGO_URI non è impostata."
    exit 1
fi
# Assicurati che la variabile d'ambiente S3_BUCKET sia impostata
if [ -z "$AWS_S3_BUCKET" ]; then
    echo "Errore: la variabile d'ambiente S3_BUCKET non è impostata."
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

    # Carica su S3 con s3cmd (forza il file di config)
    s3cmd -c /root/.s3cfg put "/backup/db_$timestamp.zip" "s3://$AWS_S3_BUCKET/db_$timestamp.zip"

    # Rimuovi i file originali dopo averli archiviati
    rm -rf /backup/dump
    echo "Attendo 1h prima di effettuare un altro backup..."
    sleep 1h

done
