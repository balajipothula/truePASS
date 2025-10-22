# List all providers
curl \
  --silent \
  --request 'GET' \
  --location 'https://openrouter.ai/api/v1/models' \
  --header "Authorization: Bearer $OPENROUTER_API_KEY" \
| jq -r '.data[] | [.name, .id] | @tsv' | sort

# List API keys
curl \
  --silent \
  --location \
  --request 'GET' \
  --url 'https://openrouter.ai/api/v1/keys' \
  --header "Authorization: Bearer $OPENROUTER_PROVISIONING_KEY" \
| jq

# Create a new API key
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

# Get current API key
curl \
  --location \
  --request 'GET' \
  --url 'https://openrouter.ai/api/v1/key' \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $OPENROUTER_API_KEY"

# Create a chat completion
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
