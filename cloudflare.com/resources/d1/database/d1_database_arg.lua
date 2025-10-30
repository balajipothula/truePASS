#!/bin/redbean -i

local url      = arg[1]
local method   = arg[2] or "GET"
local req_body = arg[3] or nil

local api_key = os.getenv("CLOUDFLARE_API_KEY")

local status, headers, res_body = Fetch(url, {
  method  = method,
  body    = req_body,
  headers = {
    ["Content-Type"]  = "application/json",
    ["Authorization"] = "Bearer " .. api_key,
  }
})

local res_body_tbl, err = DecodeJson(res_body)

print("status : " .. status)
print("success: " .. tostring(res_body_tbl["success"]))
