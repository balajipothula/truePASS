#!/bin/redbean -i

local CLOUDFLARE_ACCOUNT_ID <const> = os.getenv("CLOUDFLARE_ACCOUNT_ID")
local CLOUDFLARE_API_KEY    <const> = os.getenv("CLOUDFLARE_API_KEY")

if not CLOUDFLARE_ACCOUNT_ID or not CLOUDFLARE_API_KEY then
  error("Unable to fetch Cloudflare credentials from environment")
  return
end

local URL <const> = "https://api.cloudflare.com/client/v4/accounts/" .. CLOUDFLARE_ACCOUNT_ID .. "/d1/database"

local status, headers, body = Fetch(URL, {
  method  = "GET",
  headers = {
    ["Authorization"] = "Bearer " .. CLOUDFLARE_API_KEY
  }
})

if not status then 
  error("Empty HTTP status code: " .. tostring(headers))
  return
end

if status ~= 200 then
  error("HTTP status code not OK: " .. tostring(status))
  return
end

if not headers then
  error("Empty HTTP headers")
  return
end

if not body or body == "" then
  error("Empty HTTP body")
  return
end

local bodytable, err = DecodeJson(body)
if err then
  error("Failed to decode JSON: " .. tostring(err))
  return
end

if not bodytable or type(bodytable) ~= "table" or not next(bodytable) then
  error("Decoded JSON is `nil` or `~table` or an `[]table`")
  return
end

if not bodytable["success"] then
  error("API `success` field is `false`")
  return
end
