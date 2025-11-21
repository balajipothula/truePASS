#!/bin/bash

# Prerequisites:
# - Set the CLOUDFLARE_API_KEY and CLOUDFLARE_ACCOUNT_ID environment variables
#   CLOUDFLARE_API_KEY: Your Cloudflare API token with appropriate permissions
#   CLOUDFLARE_ACCOUNT_ID: Your Cloudflare account ID
# Note: jq is used to format the JSON response for better readability.

# http and ip.addr in {34.236.82.201}
# tls and ip.addr in {104.19.192.174}

zip redbean -j ~/.mitmproxy/mitmproxy-ca-cert.pem.
unzip -l redbean

# Whole system wide.
# penguin.linux.test:8888

HTTPS_PROXY=http://127.0.0.1:8888 redbean -i truePASS/cloudflare/test_mitmproxy.lua

export MITMPROXY_SSLKEYLOGFILE="$HOME/mitmproxy_sslkeys.log"

export https_proxy=http://127.0.0.1:8888

export no_proxy=localhost,127.0.0.1

mitmproxy \
  --http2 \
  --listen-host '127.0.0.1' \
  --listen-port 8888 \
  --mode 'transparent' \
  --save-stream-file mitmproxy.log \
  --verbose

mitmproxy \
  --listen-host '0.0.0.0' \
  --listen-port 8888 \
  --mode 'transparent' \
  --save-stream-file mitmproxy.log

mitmweb \
  --listen-host 127.0.0.1 \
  --listen-port 8888 \
  --mode regular \
  --verbose

mitmproxy \
  --http2 \
  --listen-host 127.0.0.1 \
  --listen-port 8888 \
  --mode transparent \
  --verbose

mitmproxy \
  --allow-hosts '^httpbin\.org$' \
  --http2 \
  --listen-host 127.0.0.1 \
  --listen-port 8888 \
  --mode regular \
  --verbose

mitmproxy \
  --allow-hosts '^httpbin\.org$' \
  --certs '' \
  --http2 \
  --listen-host 127.0.0.1 \
  --listen-port 8888 \
  --mode regular \
  --verbose

curl \
  --verbose \
  --silent \
  --location \
  --retry 3 \
  --retry-delay 69 \
  --proxy http://127.0.0.1:8888 \
  --request GET \
  --url https://httpbin.org/get

# Http Codes,
# Http request and response
# Content type, mime
# form encoding / char encoding
# Wireshark wrangler, cURL, redbean

# Anatomy of an HTTP message, Checking the Headers in the Chrome, HTTP/2 pseudo-headers,
# MIME / Media Types, 
# Now I understand why `ngx_http_gzip_module` required by 'NGINX'
# HEAD Request for health checking.
# ETag and Last-Modified useful for Web Crawlers

# List D1 Databases
curl \
  --verbose \
  --silent \
  --location \
  --request 'GET' \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/d1/database" \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY" \
| jq -r '.result[] | select(.name == "truepass-db") | .uuid'

curl \
  --verbose \
  --silent \
  --location \
  --retry 3 \
  --retry-delay 69 \
  --request 'GET' \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/d1/database" \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY" \
  --header "Accept-Encoding: br, gzip" --compressed \
| jq

curl \
  --silent \
  --location \
  --include \
  --request 'HEAD' \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/d1/database" \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY"

curl \
  --silent \
  --output /dev/null \
  --write-out "%{http_code}\n" \
  --request 'HEAD' \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/d1/database" \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY"

curl \
  --silent \
  --location \
  --request 'OPTIONS' \
  --url 'https://postman-echo.com/get'

nghttp \
  --data=/dev/null \
  --header=":method: GET" \
  --header="authorization: Bearer $CLOUDFLARE_API_KEY" \
  "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/d1/database" \
| jq

# Get D1 Database
curl \
  --silent \
  --location \
  --request GET \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/d1/database/$CLOUDFLARE_DB_ID" \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY" \
| jq

# Create D1 Database
curl \
  --silent \
  --location \
  --request POST \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/d1/database" \
  --header 'Content-Type: application/json; charset=UTF-8' \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY" \
  --data '{
    "name": "truepass-db5",
    "primary_location_hint": "apac"
  }' \
| jq

# Update D1 Database
curl \
  --silent \
  --location \
  --request PUT \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/d1/database/$CLOUDFLARE_DB_ID" \
  --header 'Content-Type: application/json; charset=utf-8' \
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
  --header 'Content-Type: application/json; charset=utf-8' \
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
  --header 'Content-Type: application/json; charset=utf-8' \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY" \
  --data '{}' \
| jq

# Delete D1 Database
curl \
  --silent \
  --location \
  --request DELETE \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/d1/database/$CLOUDFLARE_DB_ID" \
  --header 'Content-Type: application/json; charset=utf-8' \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY" \
| jq

# Query D1 Database
# Select record(s) from the table.
curl \
  --silent \
  --location \
  --request POST \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/d1/database/$CLOUDFLARE_DB_ID/query" \
  --header 'Content-Type: application/json; charset=utf-8' \
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
  --header 'Content-Type: application/json; charset=utf-8' \
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
  --header 'Content-Type: application/json; charset=utf-8' \
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
  --header 'Content-Type: application/json; charset=utf-8' \
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
  --header 'Content-Type: application/json; charset=utf-8' \
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
  --header 'Content-Type: application/json; charset=utf-8' \
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
  --header 'Content-Type: application/json; charset=utf-8' \
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
  --header 'Content-Type: application/json; charset=utf-8' \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY" \
  --data "{
    \"action\": \"ingest\",
    \"etag\": \"$ETAG\",
    \"filename\": \"employee.sql\"
  }" \
| jq

curl \
  --silent \
  --location \
  --request 'GET' \
  --url 'https://httpbin.org/cookies/set?sessionid=12345' \
  --cookie-jar 'cookies.txt' \
  --cookie 'cookies.txt'

curl \
  --silent \
  --location \
  --request 'GET' \
  --url 'https://httpbin.org/cookies' \
  --cookie-jar 'cookies.txt' \
  --cookie 'cookies.txt'
