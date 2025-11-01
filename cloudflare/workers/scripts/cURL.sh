#!/bin/bash

# List Workers / List Scripts
curl \
  --silent \
  --location \
  --request 'GET' \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/workers/scripts" \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY" \
| jq

# Delete Worker / Delete Script
curl \
  --silent \
  --location \
  --request 'DELETE' \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/workers/scripts/$CLOUDFLARE_SCRIPT_NAME" \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY" \
| jq
