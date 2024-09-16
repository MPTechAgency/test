#!/bin/bash

# Directory in cui salvare i dati di Vaultwarden
DATA_DIR="./vw-data"

# File per l'ADMIN_TOKEN
TOKEN_FILE="$DATA_DIR/admin_token.txt"

# Controlla se podman-compose è installato
if ! [ -x "$(command -v podman-compose)" ]; then
  echo "Errore: podman-compose non è installato." >&2
  exit 1
fi

# Controlla se la directory dei dati esiste, altrimenti la crea
if [ ! -d "$DATA_DIR" ]; then
  mkdir -p "$DATA_DIR"
fi

# Genera l'ADMIN_TOKEN se non esiste
if [ ! -f "$TOKEN_FILE" ]; then
  echo "Generando un nuovo ADMIN_TOKEN..."
  ADMIN_TOKEN=$(openssl rand -base64 32)
  echo "$ADMIN_TOKEN" > "$TOKEN_FILE"
  echo "ADMIN_TOKEN salvato in $TOKEN_FILE"
else
  ADMIN_TOKEN=$(cat "$TOKEN_FILE")
  echo "Usando l'ADMIN_TOKEN esistente trovato in $TOKEN_FILE"
fi

# Crea un file podman-compose.yml temporaneo includendo l'ADMIN_TOKEN
cat > podman-compose.yml <<EOL
version: "3"
services:
  vaultwarden:
    image: vaultwarden/server:latest
    container_name: vaultwarden
    restart: unless-stopped
    environment:
      - ADMIN_TOKEN=$ADMIN_TOKEN
    volumes:
      - ./vw-data:/data
    ports:
      - "8080:80"
    logging:
      options:
        max-size: "10m"
        max-file: "3"
EOL

# Avvia Vaultwarden usando podman-compose
echo "Avviando Vaultwarden..."
podman-compose up -d

echo "Vaultwarden è in esecuzione."
echo "Puoi accedere alla dashboard di amministrazione su http://localhost:8080/admin"
echo "Utilizza l'ADMIN_TOKEN salvato in $TOKEN_FILE per l'accesso."
