#!/bin/redbean -i

--- Loads Cloudflare credentials from environment variables.
-- @return account_id string Cloudflare account ID (from CLOUDFLARE_ACCOUNT_ID)
-- @return api_key string Cloudflare API key (from CLOUDFLARE_API_KEY)
local function load_cloudflare_credentials()
  local account_id = os.getenv("CLOUDFLARE_ACCOUNT_ID")
  local api_key = os.getenv("CLOUDFLARE_API_KEY")

  if not account_id or not api_key then
    error("Unable to fetch Cloudflare credentials from environment")
    return nil, nil
  end

  return account_id, api_key
end

--- Constructs a Cloudflare D1 API endpoint URL.
-- @param account_id string Cloudflare account ID (required)
-- @param[opt] database_id string D1 database ID (optional)
-- @param[opt] endpoint_type string Endpoint type (optional: "query", "raw", "export", "import")
-- @return string Fully constructed Cloudflare D1 API endpoint URL
local function get_api_endpoint(account_id, database_id, endpoint_type)
  if not account_id or account_id == "" then
    error("account_id is required")
    return nil
  end

  local api_endpoint = "https://api.cloudflare.com/client/v4/accounts/" .. account_id .. "/d1/database"

  if database_id and database_id ~= "" then
    api_endpoint = api_endpoint .. "/" .. database_id
    if endpoint_type and endpoint_type ~= "" then
      api_endpoint = api_endpoint .. "/" .. endpoint_type
    end
  end

  return api_endpoint
end

--- Sends an HTTP request to the Cloudflare API.
-- @param url string Full API endpoint URL
-- @param api_key string Cloudflare API key
-- @param[opt] method string HTTP method (default: "GET")
-- @param[opt] body string Request body (optional, for POST/PUT)
-- @return status number HTTP status code
-- @return headers table Response headers
-- @return response_body string Response body
local function get_database_list(url, api_key, method, request_body)
  if not url or url == "" then
    error("url is required")
    return nil, nil, nil
  end

  if not api_key or api_key == "" then
    error("api_key is required")
    return nil, nil, nil
  end

  local status, headers, response_body = Fetch(url, {
    method  = method or "GET",
    headers = {
      ["Authorization"] = "Bearer " .. api_key,
      ["Content-Type"]  = "application/json"
    },
    body = request_body
  })

  return status, headers, response_body
end

local CLOUDFLARE_ACCOUNT_ID <const>, CLOUDFLARE_API_KEY <const> = load_cloudflare_credentials()

if not CLOUDFLARE_ACCOUNT_ID or not CLOUDFLARE_API_KEY then
  return
end

local API_ENDPOINT <const> = get_api_endpoint(CLOUDFLARE_ACCOUNT_ID)

if not API_ENDPOINT then
  return
end

local status, headers, body = get_database_list(API_ENDPOINT, CLOUDFLARE_API_KEY)

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

local body_table, err = DecodeJson(body)
if err then
  error("Failed to decode JSON: " .. tostring(err))
  return
end

if not body_table or type(body_table) ~= "table" or not next(body_table) then
  error("Decoded JSON is `nil` or `~table` or an `[]table`")
  return
end

if not body_table["success"] then
  error("API `success` field is `false`")
  return
end

print(status)
print(body_table["success"])