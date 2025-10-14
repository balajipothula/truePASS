#!/bin/bash

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
