#!/bin/bash

# # Load environment variables from .env file
# if [ -f .env ]; then
#   echo "Loading environment variables from .env file..."
#   set -a  # automatically export all variables
#   source .env
#   set +a  # stop automatically exporting
# else
#   echo "Warning: .env file not found. Please create one from .env.example"
#   exit 1
# fi

# Set Fly.io secrets for the o11y app
fly secrets set "ORG=$ORG" -a o11y;
# fly secrets set "ACCESS_TOKEN=$FLY_ACCESS_TOKEN" -a o11y;
fly secrets set "LOKI_URL=$LOKI_URL" -a o11y;
fly secrets set "LOKI_USERNAME=$LOKI_USERNAME" -a o11y;
fly secrets set "LOKI_PASSWORD=$LOKI_PASSWORD" -a o11y;
