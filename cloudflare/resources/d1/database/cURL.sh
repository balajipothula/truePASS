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

# Delete a D1 database for a Cloudflare account using Cloudflare API
curl \
  --silent \
  --location \
  --request DELETE \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/d1/database/$DATABASE_ID" \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY" \
| jq

# Update a D1 database for a Cloudflare account using Cloudflare API
curl \
  --silent \
  --location \
  --request PATCH \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/d1/database/$DATABASE_ID" \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY" \
  --data '{
    "read_replication": {
      "mode": "disabled"
    }
  }' \
| jq

# Initialize an export for a D1 database using Cloudflare API
curl \
  --silent \
  --location \
  --request POST \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/d1/database/$DATABASE_ID/export" \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY" \
  --data '{
    "output_format": "polling",
    "no_data": true,
    "tables": ["users"]
  }' \
| jq

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
  --upload-file ./hashcode.sql \
  --dump-header - \
  "upload-url-from-init-response"

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
    "etag": "etag-from-upload-response",
    "filename": "hashcode.sql"
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

# Execute a query on a D1 database using Cloudflare API
curl \
  --silent \
  --location \
  --request POST \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/d1/database/$DATABASE_ID/query" \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY" \
  --data '{
    "sql": "SELECT * FROM users WHERE id = ?;",
    "params": [1]
  }' \
| jq

# Insert a new record into the users table in a D1 database using Cloudflare API
curl \
  --silent \
  --location \
  --request POST \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/d1/database/$DATABASE_ID/query" \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY" \
  --data '{
    "sql": "INSERT INTO users (first_name, last_name, email) VALUES (?, ?, ?);",
    "params": ["Sri", "Nivas", "sri.nivas@gmail.com"]
  }' \
| jq

# Execute a raw SQL command on a D1 database using Cloudflare API
# Returns the query result rows as arrays rather than objects.
# This is a performance-optimized version of the `/query` endpoint.
curl \
  --silent \
  --location \
  --request POST \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/d1/database/$DATABASE_ID/raw" \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY" \
  --data '{
    "sql": "SELECT * FROM users WHERE id = ? AND last_name = ?;",
    "params": [2, "Ayyar"]
  }' \
| jq

# Update the read replication settings for a D1 database using Cloudflare API
# mode: "auto" | "disabled"
# Set "mode" to "auto" to enable automatic read replication.
# Set "mode" to "disabled" to disable read replication.
curl \
  --silent \
  --location \
  --request PUT \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/d1/database/$DATABASE_ID" \
  --header 'Content-Type: application/json' \
  --header  "Authorization: Bearer $CLOUDFLARE_API_KEY" \
  --data '{
    "read_replication": {
      "mode": "disabled"
    }
  }' \
| jq

# Create D1 Database.
redbean -i database.lua \
  https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/d1/database \
  POST \
  '{
    "name": "truepass-db",
    "primary_location_hint": "apac"
  }'

# Delete D1 Database.
redbean -i database.lua \
  https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/d1/database/$DATABASE_ID \
  DELETE

# Update D1 Database Partially.
redbean -i database.lua \
  https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/d1/database/$DATABASE_ID \
  PATCH \
  '{}'

# Export D1 Database As Sql.
redbean -i database.lua \
  https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/d1/database/$DATABASE_ID/export \
  POST \
  '{
    "output_format": "polling",
    "no_data": false,
    "tables": []
  }'  

# Get D1 Database.
redbean -i database.lua \
  https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/d1/database/$DATABASE_ID

# Import Sql Into Your D1 Database.
# ETAG=$(md5sum employee.sql | awk '{ print $1 }')
curl \
  --silent \
  --location \
  --request POST \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/d1/database/$DATABASE_ID/import" \
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
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/d1/database/$DATABASE_ID/import" \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY" \
  --data "{
    \"action\": \"ingest\",
    \"etag\": \"$ETAG\",
    \"filename\": \"employee.sql\"
  }" \
| jq

# List D1 Databases.
redbean -i database.lua \
  https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/d1/database

# Query D1 Database
redbean -i database.lua \
  https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/d1/database/$DATABASE_ID/query \
  POST \
  '{
    "sql": "CREATE TABLE emp (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL);"
  }'

redbean -i database.lua \
  https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/d1/database/$DATABASE_ID/query \
  POST \
  '{
    "sql": "INSERT INTO emp (name) VALUES (?);",
    "params": ["Sri Nivas"]
  }'  

# Raw D1 Database Query.
redbean -i database.lua \
  https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/d1/database/$DATABASE_ID/raw \
  POST \
  '{
    "sql": "SELECT * FROM emp WHERE id = ?;",
    "params": [1]
  }'

redbean -i database.lua \
  https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/d1/database/$DATABASE_ID/raw \
  POST \
  '{
    "sql": "DROP TABLE IF EXISTS uni_student;"
  }'

# Update D1 Database.
redbean -i database.lua \
  https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/d1/database/$DATABASE_ID \
  PUT \
  '{
    "read_replication": {
      "mode": "auto"
    }
  }'
