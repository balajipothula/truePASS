#!/bin/redbean -i

local url     = arg[1]
local method  = arg[2] or "GET"
local body    = arg[3] or nil

local api_key = os.getenv("CLOUDFLARE_API_KEY")

local status, headers, body = Fetch(url, {
  method  = method,
  body    = body,
  headers = {
    ["Content-Type"]  = "application/json",
    ["Authorization"] = "Bearer " .. api_key,
  }
})

print("body: " .. tostring(body))

local body_table, err = DecodeJson(body)

print("status: " .. status)
print("success: " .. tostring(body_table["success"]))

for _, result in ipairs(body_table["result"] or {}) do
  print(tostring(result["uuid"]) .. "\t" .. tostring(result["name"]))
end
