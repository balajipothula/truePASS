curl \
  --location \
  --request 'POST' \
  --url 'https://openrouter.ai/api/v1/chat/completions' \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $OPENROUTER_API_KEY" \
  --data '{
    "model": "google/gemma-2-9b-it:free",
    "messages": [
      {
        "role": "user",
        "content": [
          {
            "type": "text",
            "text": "what is redbean lua webserver?"
          }
        ]
      }
    ]
  }'