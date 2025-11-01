#!/bin/bash

# List Versions
curl \
  --silent \
  --location \
  --request 'GET' \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/workers/workers/$CLOUDFLARE_WORKER_ID/versions" \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY" \
  --data-urlencode "page=1" \
  --data-urlencode "per_page=9" \
| jq

curl \
  --silent \
  --location \
  --request 'GET' \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/workers/workers/$CLOUDFLARE_WORKER_ID/versions?page=1&per_page=9" \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY" \
| jq

# Get Version
curl \
  --silent \
  --location \
  --request 'GET' \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/workers/workers/$CLOUDFLARE_WORKER_ID/versions/$CLOUDFLARE_WORKER_VER_ID" \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY" \
| jq

curl \
  --silent \
  --location \
  --request 'GET' \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/workers/workers/$CLOUDFLARE_WORKER_ID/versions/$CLOUDFLARE_WORKER_VER_ID?include=modules" \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY" \
| jq

# Create Version
curl \
  --silent \
  --location \
  --request 'POST' \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/workers/workers/$CLOUDFLARE_WORKER_ID/versions?deploy=false" \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY" \
  --data '{
    "annotations": {
      "workers/message": "truePASS JavaScript Code",
      "workers/tag": "1.0.0",
      "workers/triggered_by": "curl"
    }
  }'
