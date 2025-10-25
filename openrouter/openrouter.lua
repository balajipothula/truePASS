#!/bin/redbean -i

sqlite3 = require('lsqlite3')

local openrouter_api_key = os.getenv('OPENROUTER_API_KEY')

local messages = {
  {
    role = 'system',
    content = 'You are an expert DevOps assistant. Output only working cURL commands for cloud infrastructure creation. Do not include any explanation or text.'
  },
  { 
    role = 'developer',
    content = 'Output only working cURL commands for Cloudflare infrastructure creation. Do not include any explanation or text.'
  }
}

local user_content = arg[1]

table.insert(messages, { role = 'user', content = user_content })

local req_body = EncodeJson({
  model    = 'deepseek/deepseek-chat-v3.1:free',
  messages = messages
})

local url = 'https://openrouter.ai/api/v1/chat/completions'

local status, headers, res_body = Fetch(url, {
  method  = 'POST',
  body    = req_body,
  headers = {
    ['Content-Type']  = 'application/json',
    ['Authorization'] = 'Bearer ' .. openrouter_api_key,
  }
})

local res_body_tbl, err = DecodeJson(res_body)

local assistant_content = res_body_tbl.choices[1].message.content

print(assistant_content)
