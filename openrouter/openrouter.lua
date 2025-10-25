#!/bin/redbean -i

sqlite3 = require('lsqlite3')

filename    = '/home/balaji/messages.sqlite3'
flags       = sqlite3.OPEN_READWRITE
messages_db = sqlite3.open(filename, flags)

local function insert_content(table_name, content)
  local statement = messages_db:prepare('INSERT INTO ' .. table_name .. ' (content) VALUES (?);')
  assert(statement, 'Prepare insert failed for `' .. table_name .. '`')
  assert(statement:bind_values(content) == sqlite3.OK, 'Bind values failed for `' .. table_name .. '`')
  assert(statement:step() == sqlite3.DONE, 'Step failed for ' .. table_name .. '`')
  statement:finalize()
end

local function fetch_content(table_name)
  local content_tbl = {}
  for row in messages_db:nrows('SELECT content FROM ' .. table_name .. ' ORDER BY rowid ASC') do
    table.insert(content_tbl, row.content)
  end
  return content_tbl
end

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

local user_tbl      = fetch_content('user')
local assistant_tbl = fetch_content('assistant')

local user_tbl_idx,  assistant_tbl_idx  = 1, 1
local user_tbl_size, assistant_tbl_size = #user_tbl, #assistant_tbl

while user_tbl_idx <= user_tbl_size or assistant_tbl_idx <= assistant_tbl_size do
  if user_tbl_idx <= user_tbl_size then
    table.insert(messages, { role = 'user', content = user_tbl[user_tbl_idx] })
    user_tbl_idx = user_tbl_idx + 1
  end
  if assistant_tbl_idx <= assistant_tbl_size then
    table.insert(messages, { role = 'assistant', content = assistant_tbl[assistant_tbl_idx] })
    assistant_tbl_idx = assistant_tbl_idx + 1
  end
end


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

messages_db:exec("BEGIN;")
insert_content("user", user_content)
insert_content("assistant", assistant_content)
messages_db:exec("COMMIT;")

messages_db:close()
