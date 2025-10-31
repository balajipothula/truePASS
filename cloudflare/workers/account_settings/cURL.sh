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

# Create Worker Account Settings
# "default_usage_model":
#   "bundled" → Uses the older pricing model with request limits.
#   "unbound" → Uses the newer model that charges by CPU time.
# "green_compute":
#   true  → Only deploy Workers to eco-friendly regions.
#   false → Allow Workers to run globally, without restriction.
curl --fail --show-error --silent --location \
  --request PUT \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/workers/account-settings" \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY" \
  --data '{
    "default_usage_model": "unbound",
    "green_compute": true
  }'
