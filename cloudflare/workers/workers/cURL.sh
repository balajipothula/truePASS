#!/bin/bash

# List Workers
curl \
  --silent \
  --location \
  --get \
  --request 'GET' \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/workers/workers" \
  --header "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
  --data-urlencode "page=1" \
  --data-urlencode "per_page=9" \
| jq

curl \
  --silent \
  --location \
  --request 'GET' \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/workers/workers?page=1&per_page=9" \
  --header "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
| jq

# Get Worker
curl \
  --silent \
  --location \
  --request 'GET' \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/workers/workers/$CLOUDFLARE_WORKER_ID" \
  --header "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
| jq

# Create Worker
curl \
  --silent \
  --location \
  --request 'POST' \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/workers/workers" \
  --header 'Content-Type: application/json; charset=utf-8' \
  --header "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
  --data '{
    "name": "truepass9",
    "logpush": false,
    "observability": {
      "enabled": false,
      "head_sampling_rate": 0,
      "logs": {
        "enabled": false,
        "head_sampling_rate": 0,
        "invocation_logs": false 
      }
    },
    "subdomain": {
      "enabled": true,
      "previews_enabled": true
    },
    "tags": [
      "truePASS",
      "Balaji Pothula"
    ],
    "tail_consumers": []
  }' \
| jq

# Update Worker
curl \
  --silent \
  --location \
  --request 'PUT' \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/workers/workers/$CLOUDFLARE_WORKER_ID" \
  --header 'Content-Type: application/json; charset=utf-8' \
  --header "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
  --data '{
    "name": "truepass99",
    "logpush": false,
    "observability": {
      "enabled": false,
      "head_sampling_rate": 25,
      "logs": {
        "enabled": false,
        "head_sampling_rate": 25,
        "invocation_logs": false 
      }
    },
    "subdomain": {
      "enabled": true,
      "previews_enabled": true
    },
    "tags": [
      "truePASS99",
      "Balaji Pothula"
    ],
    "tail_consumers": []
  }' \
| jq

# Edit Worker - Need to be tested.
curl \
  --silent \
  --location \
  --request 'PATCH' \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/workers/workers/$CLOUDFLARE_WORKER_ID" \
  --header 'Content-Type: application/json; charset=utf-8' \
  --header "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
  --data '{
    "logpush": false,
    "observability": {
      "enabled": false,
      "head_sampling_rate": 25,
      "logs": {
        "enabled": false,
        "head_sampling_rate": 25,
        "invocation_logs": false 
      }
    }
  }' \
| jq

# Delete Worker
curl \
  --silent \
  --location \
  --request 'DELETE' \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/workers/workers/$CLOUDFLARE_WORKER_ID" \
  --header 'Content-Type: application/json; charset=utf-8' \
  --header "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
| jq
