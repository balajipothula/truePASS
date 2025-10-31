#!/bin/bash

# Prerequisites:
# - Set the CLOUDFLARE_API_KEY and CLOUDFLARE_ACCOUNT_ID environment variables
#   CLOUDFLARE_API_KEY: Your Cloudflare API token with appropriate permissions
#   CLOUDFLARE_ACCOUNT_ID: Your Cloudflare account ID
# Note: jq is used to format the JSON response for better readability.

# List D1 Databases
curl \
  --silent \
  --location \
  --request GET \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/d1/database" \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY" \
| jq -r '.result[] | select(.name == "truepass-db") | .uuid'

# Get D1 Database
curl \
  --silent \
  --location \
  --request GET \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/d1/database/$CLOUDFLARE_DB_ID" \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY" \
| jq

# Create D1 Database
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

# Update D1 Database
curl \
  --silent \
  --location \
  --request PUT \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/d1/database/$CLOUDFLARE_DB_ID" \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY" \
  --data '{
    "read_replication": {
      "mode": "disabled"
    }
  }' \
| jq

# Update D1 Database
# mode: "auto" | "disabled"
# Set "mode" to "auto" to enable automatic read replication.
# Set "mode" to "disabled" to disable read replication.
curl \
  --silent \
  --location \
  --request PUT \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/d1/database/$CLOUDFLARE_DB_ID" \
  --header 'Content-Type: application/json' \
  --header  "Authorization: Bearer $CLOUDFLARE_API_KEY" \
  --data '{
    "read_replication": {
      "mode": "disabled"
    }
  }' \
| jq

# Update D1 Database Partially
curl \
  --silent \
  --location \
  --request PATCH \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/d1/database/$CLOUDFLARE_DB_ID" \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY" \
  --data '{}' \
| jq

# Delete D1 Database
curl \
  --silent \
  --location \
  --request DELETE \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/d1/database/$CLOUDFLARE_DB_ID" \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY" \
| jq

# Query D1 Database
# Select record(s) from the table.
curl \
  --silent \
  --location \
  --request POST \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/d1/database/$CLOUDFLARE_DB_ID/query" \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY" \
  --data '{
    "sql": "SELECT * FROM users WHERE id = ?;",
    "params": [1]
  }' \
| jq

# Query D1 Database
# Insert record(s) into the table.
curl \
  --silent \
  --location \
  --request POST \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/d1/database/$CLOUDFLARE_DB_ID/query" \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY" \
  --data '{
    "sql": "INSERT INTO users (first_name, last_name, email) VALUES (?, ?, ?);",
    "params": ["Sri", "Nivas", "sri.nivas@gmail.com"]
  }' \
| jq

# Raw D1 Database Query
# Execute a `SELECT` raw SQL command on a D1 Database
# Returns the query result rows as arrays rather than objects.
# This is a performance-optimized version of the `/query` endpoint.
curl \
  --silent \
  --location \
  --request POST \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/d1/database/$CLOUDFLARE_DB_ID/raw" \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY" \
  --data '{
    "sql": "SELECT * FROM users WHERE id = ? AND last_name = ?;",
    "params": [2, "Ayyar"]
  }' \
| jq

# Export D1 Database As SQL
curl \
  --silent \
  --location \
  --request POST \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/d1/database/$CLOUDFLARE_DB_ID/export" \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY" \
  --data '{
    "output_format": "polling",
    "no_data": true,
    "tables": ["users"]
  }' \
| jq

# Import SQL Into Your D1 Database
# Initialize an import for a D1 Database
curl \
  --silent \
  --location \
  --request POST \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/d1/database/$CLOUDFLARE_DB_ID/import" \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY" \
  --data '{
    "action": "init"
  }' \
| jq

# Import SQL Into Your D1 Database
# Upload a SQL file to Cloudflare R2 for D1 import
curl \
  --location \
  --request PUT \
  --upload-file ./hashcode.sql \
  --dump-header - \
  "upload-url-from-init-response"

# Import SQL Into Your D1 Database
# Complete the import for a D1 Database
curl \
  --silent \
  --location \
  --request POST \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/d1/database/$CLOUDFLARE_DB_ID/import" \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY" \
  --data '{
    "action": "ingest",
    "etag": "etag-from-upload-response",
    "filename": "hashcode.sql"
  }' \
| jq

# Export D1 Database As Sql.
redbean -i database.lua \
  https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/d1/database/$CLOUDFLARE_DB_ID/export \
  POST \
  '{
    "output_format": "polling",
    "no_data": false,
    "tables": []
  }'

# Import Sql Into Your D1 Database.
# ETAG=$(md5sum employee.sql | awk '{ print $1 }')
curl \
  --silent \
  --location \
  --request POST \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/d1/database/$CLOUDFLARE_DB_ID/import" \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY" \
  --data "{
    \"action\": \"init\",
    \"etag\": \"$ETAG\"
  }" \
| jq

curl \
  --silent \
  --location \
  --request PUT \
  --url "upload url" \
  --header 'Content-Type: application/sql' \
  --upload-file "employee.sql"

curl \
  --silent \
  --location \
  --request POST \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/d1/database/$CLOUDFLARE_DB_ID/import" \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY" \
  --data "{
    \"action\": \"ingest\",
    \"etag\": \"$ETAG\",
    \"filename\": \"employee.sql\"
  }" \
| jq
