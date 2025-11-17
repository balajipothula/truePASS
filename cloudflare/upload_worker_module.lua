#!/bin/redbean -i

local boundary = "------------------------" .. tostring(math.random(1000000000, 9999999999))
local file_path = "src/index.js"

-- read file data
local f = assert(io.open(file_path, "rb"))
local file_data = f:read("*a")
f:close()

-- metadata json
local metadata = '{"main_module":"index.js"}'

-- build multipart body
local body = table.concat({
  "--" .. boundary,
  'Content-Disposition: form-data; name="metadata"',
  'Content-Type: application/json',
  "",
  metadata,
  "--" .. boundary,
  'Content-Disposition: form-data; name="index.js"; filename="index.js"',
  'Content-Type: application/javascript+module',
  "",
  file_data,
  "--" .. boundary .. "--",
  ""
}, "\r\n")

-- environment variables
local account_id   = os.getenv("CLOUDFLARE_ACCOUNT_ID")
local api_key      = os.getenv("CLOUDFLARE_API_KEY")
local url          = "https://api.cloudflare.com/client/v4/accounts/" .. account_id .. "/workers/scripts/truepass9"

-- perform request
local status, headers, res_body = Fetch(url, {
  method  = "PUT",
  headers = {
    ["Authorization"]    = "Bearer " .. api_key,
    ["Content-Type"]     = "multipart/form-data; boundary=" .. boundary,
    ["Content-Encoding"] = "br",
    ["Content-Length"]   = tostring(#body),
  },
  body = body,
})

print("Status:", status)
