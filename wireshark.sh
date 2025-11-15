#!/bin/bash
 
# http and ip.addr in {34.236.82.201}

# tls and ip.addr in {104.19.192.29}

curl \
  --verbose \
  --silent \
  --location \
  --request 'GET' \
  --url https://httpbin.org/get

curl \
  --verbose \
  --silent \
  --location \
  --request 'POST' \
  --url 'https://httpbin.org/post' \
  --header 'Content-Type: application/json; charset=UTF-8' \
  --data '{
    "hello": "world"
  }' \
| jq

# List D1 Databases
curl \
  --verbose \
  --silent \
  --location \
  --request 'GET' \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/d1/database" \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY" \
| jq
