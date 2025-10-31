#!/bin/bash

# Upload Assets
curl \
  --silent \
  --location \
  --request POST "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/workers/assets/upload" \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY" \
  --header "Content-Type: multipart/form-data" \
  --data-binary "worker.js" \
| jq


curl -X PUT "https://api.cloudflare.com/client/v4/accounts/$CF_ACCOUNT_ID/workers/scripts/$WORKER_NAME" \
  -H "Authorization: Bearer $CF_API_TOKEN" \
  -H "Content-Type: application/javascript" \
  --data-binary "@worker.js"
