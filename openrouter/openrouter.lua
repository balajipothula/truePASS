#!/bin/redbean -i

local openrouter_api_key = os.getenv("OPENROUTER_API_KEY")

local url      = "https://openrouter.ai/api/v1/chat/completions"
local method   = "POST"
local req_body = [[
{
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
}
]]

local status, headers, res_body = Fetch(url, {
  method  = method,
  body    = req_body,
  headers = {
    ["Content-Type"]  = "application/json",
    ["Authorization"] = "Bearer " .. openrouter_api_key,
  }
})

print("status: " .. status)

local res_body_tbl, err = DecodeJson(res_body)

local content = res_body_tbl.choices[1].message.content

print(content)
