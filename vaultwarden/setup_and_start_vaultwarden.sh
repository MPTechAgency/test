#!/bin/bash

# Nome del file di avvio
SCRIPT_NAME="start_vaultwarden.sh"

# Controlla se il file di avvio esiste
if [ -f "$SCRIPT_NAME" ]; then
  # Rendi il file eseguibile
  echo "Rendendo eseguibile $SCRIPT_NAME..."
  chmod +x "$SCRIPT_NAME"

  # Avvia lo script
  echo "Avviando $SCRIPT_NAME..."
  ./"$SCRIPT_NAME"

  echo "Vaultwarden dovrebbe essere in esecuzione."
else
  echo "Errore: $SCRIPT_NAME non trovato. Assicurati che il file esista nella directory corrente."
  exit 1
fi
