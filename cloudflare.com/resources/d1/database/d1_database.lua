#!/bin/redbean -i

local config_file    = arg[1]
local d1_db_json     = io.open(config_file, 'r')
local d1_db_json_str = d1_db_json:read('*a')
local d1_db_tbl      = DecodeJson(d1_db_json_str)

d1_db_json:close()

local url          = d1_db_tbl['request']['url']
url                = url:gsub("%$([%w_]+)", os.getenv)
local method       = d1_db_tbl['request']['method']
local req_body_tbl = d1_db_tbl['request']['body']
local req_body     = EncodeJson(req_body_tbl)
local api_key      = os.getenv("CLOUDFLARE_API_KEY")

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
