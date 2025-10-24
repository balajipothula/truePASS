# Analytics > Get user activity grouped by endpoint
curl \
  --silent \
  --location \
  --request 'GET' \
  --url 'https://openrouter.ai/api/v1/activity' \
  --header "Authorization: Bearer $OPENROUTER_PROVISIONING_KEY" \
| jq

# Credits > Get remaining credits
curl \
  --silent \
  --location \
  --request 'GET' \
  --url 'https://openrouter.ai/api/v1/credits' \
  --header "Authorization: Bearer $OPENROUTER_PROVISIONING_KEY" \
| jq

# Generations > Get request & usage metadata for a generation
curl \
  --silent \
  --location \
  --request 'GET' \
  --url 'https://openrouter.ai/api/v1/generation' \
  --header "Authorization: Bearer $OPENROUTER_PROVISIONING_KEY" \
  --get \
  --data-urlencode "id=gen-3bhGkxlo4XFrqiabUM7NDtwDzWwG" \
| jq

# Models > Get total count of available models
curl \
  --silent \
  --location \
  --request 'GET' \
  --url 'https://openrouter.ai/api/v1/models/count' \
  --header "Authorization: Bearer $OPENROUTER_PROVISIONING_KEY" \
| jq

# Models > List all models and their properties
curl \
  --silent \
  --location \
  --request 'GET' \
  --url 'https://openrouter.ai/api/v1/models' \
  --header "Authorization: Bearer $OPENROUTER_API_KEY" \
| jq

# Models > List models filtered by user provider preferences
curl \
  --silent \
  --location \
  --request 'GET' \
  --url 'https://openrouter.ai/api/v1/models/user' \
  --header "Authorization: Bearer $OPENROUTER_API_KEY" \
| jq

# Endpoints > List all endpoints for a model
curl \
  --silent \
  --location \
  --request 'GET' \
  --url 'https://openrouter.ai/api/v1/models/deepseek/deepseek-chat-v3.1/endpoints' \
  --header "Authorization: Bearer $OPENROUTER_API_KEY" \
| jq

# Endpoints > Preview the impact of ZDR on the available endpoints
curl \
  --silent \
  --location \
  --request 'GET' \
  --url 'https://openrouter.ai/api/v1/endpoints/zdr' \
  --header "Authorization: Bearer $OPENROUTER_API_KEY" \
| jq

# Parameters > Get a model's supported parameters and data about which are most popular
curl \
  --silent \
  --location \
  --request 'GET' \
  --url 'https://openrouter.ai/api/v1/parameters/deepseek/deepseek-chat-v3.1' \
  --header "Authorization: Bearer $OPENROUTER_API_KEY" \
| jq

# Providers > List all providers
curl \
  --silent \
  --location \
  --request 'GET' \
  --url 'https://openrouter.ai/api/v1/models' \
  --header "Authorization: Bearer $OPENROUTER_API_KEY" \
| jq --raw-output '.data[] | [.name, .id] | @tsv' | sort

# API Keys > List API keys
curl \
  --silent \
  --location \
  --request 'GET' \
  --url 'https://openrouter.ai/api/v1/keys' \
  --header "Authorization: Bearer $OPENROUTER_PROVISIONING_KEY" \
| jq

# API Keys > Create a new API key
curl \
  --location \
  --request 'POST' \
  --url https://openrouter.ai/api/v1/keys \
  --header "Content-Type: application/json" \
  --header "Authorization: Bearer $OPENROUTER_PROVISIONING_KEY" \
  --data '{
    "name": "OPENROUTER_API_KEY2",
    "limit": 1,
    "limit_reset": "daily",
    "include_byok_in_limit": true
  }'

# API Keys > Get a single API key
curl \
  --silent \
  --location \
  --request 'GET' \
  --url "https://openrouter.ai/api/v1/keys/$OPENROUTER_API_KEY" \
  --header "Authorization: Bearer $OPENROUTER_PROVISIONING_KEY" \
| jq

# API Keys > Delete an API key
curl \
  --silent \
  --location \
  --request 'DELETE' \
  --url "https://openrouter.ai/api/v1/keys/$OPENROUTER_API_KEY" \
  --header "Authorization: Bearer $OPENROUTER_PROVISIONING_KEY" \
| jq

# API Keys > Update an API key
curl \
  --silent \
  --location \
  --request 'PATCH' \
  -url "https://openrouter.ai/api/v1/keys/$OPENROUTER_API_KEY" \
  --header "Content-Type: application/json" \
  --header "Authorization: Bearer $OPENROUTER_PROVISIONING_KEY" \
  --data '{
    "name": "OPENROUTER_API_KEY2",
    "disabled": false,
    "limit": 2,
    "limit_reset": "daily",
    "include_byok_in_limit": true
}'

# API Keys > Get current API key
curl \
  --location \
  --request 'GET' \
  --url 'https://openrouter.ai/api/v1/key' \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $OPENROUTER_API_KEY"

# Chat > Create a chat completion - 1
curl \
  --silent \
  --location \
  --request POST \
  --url 'https://openrouter.ai/api/v1/chat/completions' \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $OPENROUTER_API_KEY" \
  --data '{
    "model": "deepseek/deepseek-chat-v3.1:free",
    "messages": [
      {
        "role": "system",
        "content": "You are an expert DevOps assistant. Output only working cURL commands for cloud infrastructure creation. Do not include any explanation or text."
      },
      {
        "role": "user",
        "content": "Provide a single, fully functional cURL command to create a Cloudflare D1 database, including all required headers and JSON payload. Only output the cURL command."
      }
    ]
  }' \
| jq -r '.choices[0].message.content'

# Chat > Create a chat completion - 2A
curl \
  --silent \
  --location \
  --request POST \
  --url 'https://openrouter.ai/api/v1/chat/completions' \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $OPENROUTER_API_KEY" \
  --data '{
    "model": "deepseek/deepseek-chat-v3.1:free",
    "messages": [
      {
        "role": "system",
        "content": "You are an expert DevOps assistant. Output only working cURL commands for cloud infrastructure creation. Do not include any explanation or text."
      },
      {
        "role": "developer",
        "content": "Output only working cURL commands for Cloudflare infrastructure creation. Do not include any explanation or text."
      },
      {
        "role": "user",
        "content": "Provide a single, fully functional cURL command to create a Cloudflare D1 database, including all required headers and JSON payload. Only output the cURL command."
      }
    ]
  }' \
| jq -r '.choices[0].message.content'

# Chat > Create a chat completion - 2B
curl \
  --silent \
  --location \
  --request POST \
  --url 'https://openrouter.ai/api/v1/chat/completions' \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $OPENROUTER_API_KEY" \
  --data '{
    "model": "deepseek/deepseek-chat-v3.1:free",
    "messages": [
      {
        "role": "system",
        "content": "You are an expert DevOps assistant. Output only working cURL commands for cloud infrastructure creation. Do not include any explanation or text."
      },
      {
        "role": "developer",
         "content": "Output only working cURL commands for Cloudflare infrastructure creation. Do not include any explanation or text."
      },
      {
        "role": "user",
        "content": "Provide a single, fully functional cURL command to create a Cloudflare D1 database, including all required headers and JSON payload. Only output the cURL command."
      },
      {
        "role": "assistant",
        "content": "curl -X POST \"https://api.cloudflare.com/client/v4/accounts/ACCOUNT_ID/d1/database\" \\\n  -H \"Authorization: Bearer API_TOKEN\" \\\n  -H \"Content-Type: application/json\" \\\n  -d '{\"name\":\"my-database\"}'<｜begin▁of▁sentence｜>"
      },
      {
        "role": "user",
        "content": "The previous cURL command returned this exact output, including the trailing marker '\<begin▁of▁sentence\>'. Make these corrections and output only the corrected cURL command:\\n\\n1. Replace ACCOUNT_ID with the shell variable $ACCOUNT_ID and API_TOKEN with $API_TOKEN (these environment variables are already configured).\\n2. Set the database name to 'truepass-db' in the JSON payload.\\n3. Remove the trailing marker '\<begin▁of▁sentence\>' or any other stray tokens.\\n5. Ensure the command is fully functional, copy-paste ready, includes all required headers, and outputs nothing but the corrected cURL command."
      }
    ]
  }' \
| jq -r '.choices[0].message.content'

# Chat > Create a chat completion - *experimental
curl \
  --silent \
  --location \
  --request POST \
  --url 'https://openrouter.ai/api/v1/chat/completions' \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $OPENROUTER_API_KEY" \
  --data '{
    "model": "deepseek/deepseek-chat-v3.1:free",
    "temperature": 0.2,
    "top_p": 0.95,
    "frequency_penalty": 0.3,
    "presence_penalty": 0.0,
    "max_tokens": 2048,
    "seed": 20251024,
    "response_format": {
      "type": "json_schema",
      "json_schema": {
        "name": "content_only",
        "description": "Fetching choices > message > content only.",
        "strict": true,
        "schema": {
          "type": "object",
          "properties": {
            "content": { "type": "string" }
          },
          "required": ["content"],
          "additionalProperties": false
        }
      }
    },
    "messages": [
      {
        "role": "system",
        "content": "You are an expert DevOps assistant. Output only working cURL commands for cloud infrastructure creation. Do not include any explanation or text."
      },
      {
        "role": "developer",
        "content": "Output only working cURL commands for Cloudflare infrastructure creation. Do not include any explanation or text."
      },
      {
        "role": "user",
        "content": "Provide a single, fully functional cURL command to create a Cloudflare D1 database, including all required headers and JSON payload. Only output the cURL command."
      }
    ]
  }' \
| jq -r '.choices[0].message.content'

# Completions > Create a completion
curl \
  --location \
  --request 'POST' \
  --url 'https://openrouter.ai/api/v1/completions' \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $OPENROUTER_API_KEY" \
  --data '{
    "model": "deepseek/deepseek-chat-v3.1:free",
    "prompt": "Provide a single, fully functional cURL command to create a Cloudflare D1 database, including all required headers and JSON payload. Only output the cURL command."
  }'
