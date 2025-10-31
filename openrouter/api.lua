#!/bin/redbean -i

sqlite3 = require('lsqlite3')

filename    = '/home/balaji/messages.sqlite3'
flags       = sqlite3.OPEN_READWRITE
messages_db = sqlite3.open(filename, flags)

-- insert user or assistant content into respective sqlite table.
local function insert_content(table_name, content)
  local sql       = 'INSERT INTO ' .. table_name .. ' (content) VALUES (?);'
  local statement = messages_db:prepare(sql)
  assert(statement, 'Prepare insert failed for `' .. table_name .. '`')
  assert(statement:bind_values(content) == sqlite3.OK, 'Bind values failed for `' .. table_name .. '`')
  assert(statement:step() == sqlite3.DONE, 'Step failed for ' .. table_name .. '`')
  statement:finalize()
end

-- fetch user or assistant content from respective sqlite table.
local function fetch_content(table_name)
  local content_tbl = {}
  local sql         = 'SELECT content FROM ' .. table_name .. ' ORDER BY rowid ASC'
  for row in messages_db:nrows(sql) do
    table.insert(content_tbl, row.content)
  end
  return content_tbl
end

-- build messages lua table in the respective order from user lua table and assistant lua table.
local function build_messages_tbl(messages_tbl, user_tbl, assistant_tbl)
  local user_tbl_idx,  assistant_tbl_idx  = 1, 1
  local user_tbl_size, assistant_tbl_size = #user_tbl, #assistant_tbl
  local messages_tbl = messages_tbl
  while user_tbl_idx <= user_tbl_size or assistant_tbl_idx <= assistant_tbl_size do
    if user_tbl_idx <= user_tbl_size then
      table.insert(messages_tbl, { role = 'user', content = user_tbl[user_tbl_idx] })
      user_tbl_idx = user_tbl_idx + 1
    end
    if assistant_tbl_idx <= assistant_tbl_size then
      table.insert(messages_tbl, { role = 'assistant', content = assistant_tbl[assistant_tbl_idx] })
      assistant_tbl_idx = assistant_tbl_idx + 1
    end
  end
  return messages_tbl
end

-- call openrouter.ai API
local function call_openrouter_api(messages_tbl)
  local url = 'https://openrouter.ai/api/v1/chat/completions'
  local req_body = EncodeJson({
    model    = 'deepseek/deepseek-chat-v3.1:free',
    messages = messages_tbl
  })
  local api_key = os.getenv('OPENROUTER_API_KEY')
  local status, headers, res_body = Fetch(url, {
    method  = 'POST',
    body    = req_body,
    headers = {
      ['Content-Type']  = 'application/json',
      ['Authorization'] = 'Bearer ' .. api_key,
    }
  })
  local res_body_tbl = DecodeJson(res_body)
  return res_body_tbl.choices[1].message.content
end

-- call cloudflare.com API
local function call_cloudflare_api(assistant_content)
  local handle = io.popen(assistant_content .. " -s -o /dev/null -w '%{http_code}'")
  local status_code = handle:read('*a')
  handle:close()
  return tonumber(status_code)
end

-- main block start
local iteration = 1
local messages_tbl = {
  {
    role = 'system',
    content = 'You are an expert Cloudflare cloud infrastructure engineer. Output only working cURL commands for cloud infrastructure creation. Do not include any explanation or text.'
  },
  { 
    role = 'developer',
    content = 'Output only working cURL commands for Cloudflare infrastructure creation. Do not include any explanation or text.'
  }
}
local user_content = arg[1]
insert_content('user', user_content)
local user_tbl = fetch_content('user')
local assistant_tbl = fetch_content('assistant')

while iteration < 3 do
  messages_tbl = build_messages_tbl(messages_tbl, user_tbl, assistant_tbl)
  local assistant_content = call_openrouter_api(messages_tbl)
  print('assistant content:' .. assistant_content)
  insert_content('assistant', assistant_content)
  local http_code = call_cloudflare_api(assistant_content)
  print('http code: ' .. http_code)
  if http_code == 200 then break end
  iteration = iteration + 1
end
