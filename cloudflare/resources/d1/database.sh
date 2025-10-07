#!/bin/bash

# Prerequisites:
# - Set the CLOUDFLARE_API_KEY and CLOUDFLARE_ACCOUNT_ID environment variables
#   CLOUDFLARE_API_KEY: Your Cloudflare API token with appropriate permissions
#   CLOUDFLARE_ACCOUNT_ID: Your Cloudflare account ID
# Note: jq is used to format the JSON response for better readability.

# Create a new D1 database for a Cloudflare account using Cloudflare API
curl \
  --silent \
  --location \
  --request POST \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/d1/database" \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY" \
  --data '{
    "name": "truepass-db",
    "primary_location_hint": "apac"
  }' \
| jq

# List D1 databases for a Cloudflare account using Cloudflare API
curl \
  --silent \
  --location \
  --request GET \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/d1/database" \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY" \
| jq -r '.result[] | select(.name == "truepass-db") | .uuid'


# Get details of a specific D1 database for a Cloudflare account using Cloudflare API
curl \
  --silent \
  --location \
  --request GET \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/d1/database/$DATABASE_ID" \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY" \
| jq

# Initialize an import for a D1 database using Cloudflare API
curl \
  --silent \
  --location \
  --request POST \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/d1/database/$DATABASE_ID/import" \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY" \
  --data '{
    "action": "init"
  }' \
| jq

# Upload a SQL file to Cloudflare R2 for D1 import
curl \
  --location \
  --request PUT \
  --upload-file ./7473503b-6bd4-4ec9-8e67-e1585303a23b.3510b07d8a69fb40.sql \
  --dump-header - \
  "https://1ad59b064bfa3690063414a9906129e4.r2.cloudflarestorage.com/d1-sqlio-incoming-prod/7473503b-6bd4-4ec9-8e67-e1585303a23b.3510b07d8a69fb40.sql?X-Amz-Expires=3600&X-Amz-Date=20251007T105420Z&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=f591b8dcd0794c54409cf0613171d42b%2F20251007%2Fauto%2Fs3%2Faws4_request&X-Amz-SignedHeaders=host&X-Amz-Signature=2c703fdd181d566b40e3dd1452ca17dfdfe5d8380e3ff7d6cf69815f9bc34a0d"

# Complete the import for a D1 database using Cloudflare API
curl \
  --silent \
  --location \
  --request POST \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/d1/database/$DATABASE_ID/import" \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY" \
  --data '{
    "action": "ingest",
    "etag": "987503e0943a74071b527740b9d2499f",
    "filename": "7473503b-6bd4-4ec9-8e67-e1585303a23b.3510b07d8a69fb40.sql"
  }' \
| jq

# Delete a D1 database for a Cloudflare account using Cloudflare API
curl \
  --silent \
  --location \
  --request DELETE \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/d1/database/$DATABASE_ID" \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY" \
| jq
