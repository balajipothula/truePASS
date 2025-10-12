#!/bin/redbean -i

--[[
redbean -i database.lua \
  https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/d1/database
]]

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

body_table = DecodeJson(body)

print("status: " .. status)
print("success: " .. tostring(body_table["success"]))
