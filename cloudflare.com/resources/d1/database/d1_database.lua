#!/bin/redbean -i

local config_file    = assert(arg[1], 'Usage is `redbean -i d1_database.lua action.json`')
local d1_db_json     = assert(io.open(config_file, 'r'))
local d1_db_json_str = d1_db_json:read('*a')
local d1_db_tbl      = DecodeJson(d1_db_json_str)

d1_db_json:close()

local url        = d1_db_tbl['request']['url']:gsub("%$([%w_]+)", os.getenv)
local method     = d1_db_tbl['request']['method'] or 'GET'
local req_body   = d1_db_tbl['request']['body'] and EncodeJson(d1_db_tbl['request']['body']) or nil
local cf_api_key = os.getenv('CLOUDFLARE_API_KEY')

local status, headers, res_body = Fetch(url, {
  method  = method,
  body    = req_body,
  headers = {
    ["Content-Type"]  = "application/json",
    ["Authorization"] = "Bearer " .. cf_api_key,
  }
})

local res_body_tbl, err = DecodeJson(res_body)

print("status : " .. status)
print("success: " .. tostring(res_body_tbl["success"]))
