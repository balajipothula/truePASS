#!/bin/redbean -i

local function get_cloudflare_credentials()
  local account_id = os.getenv("CLOUDFLARE_ACCOUNT_ID")
  local api_key    = os.getenv("CLOUDFLARE_API_KEY")

  if not account_id or not api_key then
    error("Unable to fetch Cloudflare credentials from environment")
  end

  return account_id, api_key
end

local CLOUDFLARE_ACCOUNT_ID, CLOUDFLARE_API_KEY = get_cloudflare_credentials()

local URL <const> = "https://api.cloudflare.com/client/v4/accounts/" .. CLOUDFLARE_ACCOUNT_ID .. "/d1/database"

local status, headers, body = Fetch(URL, {
  method  = "POST",
  headers = {
    ["Authorization"] = "Bearer " .. CLOUDFLARE_API_KEY
  }
})

local status, headers, body = Fetch(URL, {
  method  = "POST",
  body    = '{"name":"truepass-db", "primary_location_hint":"apac"}',
  headers = {
    ["Content-Type"]  = "application/json",
    ["Authorization"] = "Bearer " .. CLOUDFLARE_API_KEY
  }
})

print("Status: ", status)
print("Headers: ", headers)
print("Body: ", body)
