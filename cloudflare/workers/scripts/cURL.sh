#!/bin/bash

# List Workers / List Scripts
curl \
  --silent \
  --location \
  --request 'GET' \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/workers/scripts" \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY" \
| jq

curl \
  --silent \
  --location \
  --request 'GET' \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/workers/scripts?tags=truepass:no" \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY" \
| jq

curl \
  --silent \
  --location \
  --request 'GET' \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/workers/scripts" \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY" \
  --data-urlencode "tags=truepass:no" \
| jq

# Search Workers / Search Scripts
curl \
  --silent \
  --location \
  --request 'GET' \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/workers/scripts-search" \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY" \
| jq

curl \
  --silent \
  --location \
  --request 'GET' \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/workers/scripts-search?id=$CLOUDFLARE_SCRIPT_ID,name=$CLOUDFLARE_SCRIPT_NAME,order_by=name,page=1,per_page=10" \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY"
| jq

curl \
  --silent \
  --location \
  --request 'GET' \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/workers/scripts-search" \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY" \
  --data-urlencode "id=$CLOUDFLARE_SCRIPT_ID" \
  --data-urlencode "name=$CLOUDFLARE_SCRIPT_NAME" \
  --data-urlencode "order_by=name" \
  --data-urlencode "page=1" \
  --data-urlencode "per_page=10" \
| jq

# Download Worker / Download Script
curl \
  --silent \
  --location \
  --request 'GET' \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/workers/scripts/$CLOUDFLARE_SCRIPT_NAME" \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY"

curl \
  --silent \
  --location \
  --request 'GET' \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/workers/scripts/truepass9" \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY"

# Upload Worker Module / Upload Script Module
curl \
  --silent \
  --location \
  --request 'PUT' \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/workers/scripts/truepass9" \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY" \
  --form 'metadata={
    "assets": {
      "config": {
        "not_found_handling": "404-page"
      }
    },
    "bindings":[
      {
        "name": "truepass-db",
        "type": "d1",
        "id": "'"$CLOUDFLARE_DB_ID"'"
      }
    ],
    "logpush": false,
    "main_module": "index.js",
    "tags": [
      "truePASS",
      "Balaji Pothula"
    ],
    "usage_model": "standard"
  };type=application/json' \
  --form 'index.js=@index.js;type=application/javascript+module'

curl \
  --silent \
  --location \
  --request 'PUT' \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/workers/scripts/truepass9" \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY" \
  --form 'metadata={"body_part":"script.js"};type=application/json' \
  --form 'script.js=@script.js;type=application/javascript' \
| jq

# --form 'metadata={"main_module":"index.js"};type=application/json' \
# --form 'index.js=@index.js;type=application/javascript+module' \
# --form 'utils.js=@utils.js;type=application/javascript+module' \
# --form 'config.js=@config.js;type=application/javascript+module'

# Delete Worker / Delete Script
curl \
  --silent \
  --location \
  --request 'DELETE' \
  --url "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/workers/scripts/$CLOUDFLARE_SCRIPT_NAME" \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $CLOUDFLARE_API_KEY" \
| jq


bindings: Array<Optional
List of bindings attached to a Worker. You can find more about bindings on our docs: https://developers.cloudflare.com/workers/configuration/multipart-upload-metadata/#bindings.

D1 = {
id: string
Identifier of the D1 database to bind to.

name: string
A JavaScript variable name for the binding.


type: "d1"
The kind of resource that the binding provides.

}