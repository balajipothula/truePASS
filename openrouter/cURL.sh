curl \
  --location \
  --request POST \
  --url 'https://openrouter.ai/api/v1/chat/completions' \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $OPENROUTER_API_KEY" \
  -data '{
    "model": "google/gemini-2.0-flash-exp:free",
    "messages": [
      {
        "role": "user",
        "content": "Hello world!"
      }
    ]
  }'
