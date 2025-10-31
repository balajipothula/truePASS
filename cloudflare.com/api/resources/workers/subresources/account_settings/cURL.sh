#!/bin/bash

# Fetch Worker Account Settings
curl \
  --silent \
  --location \
  --request GET \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/workers/account-settings" \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY" \
| jq


curl https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/workers/account-settings \
  --request PUT \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY" \
  --data '{}'

curl \
  --silent \
  --location \
  --request PUT "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/workers/scripts/truepass-worker" \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY" \
  --header "Content-Type: application/javascript" \
  --data-binary "worker.js" \
| jq
