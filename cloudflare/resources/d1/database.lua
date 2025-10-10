#!/bin/redbean -i

-- Cloudflare D1 Database Management Script
-- This script lists or creates D1 databases using the Cloudflare API.
-- It requires the environment variables CLOUDFLARE_ACCOUNT_ID and CLOUDFLARE_API_KEY to be set.

--- Constructs a Cloudflare D1 API endpoint URL.
-- @param account_id string Cloudflare account ID (required)
-- @param[opt] database_id string D1 database ID (optional)
-- @param[opt] endpoint_type string Endpoint type (optional: "query", "raw", "export", "import")
-- @return string Fully constructed Cloudflare D1 API endpoint URL
local function api_endpoint(database_id, endpoint_type)
  account_id = os.getenv("CLOUDFLARE_ACCOUNT_ID")

  if not account_id or account_id == "" then
    error("`account_id` is required")
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
-- @param method string HTTP method (default: "GET")
-- @param request_body string Request body  (for POST requests)
-- @param operation string Operation type ("list" or "create")
-- @return status number HTTP status code
-- @return headers table Response headers
-- @return response_body string Response body
local function api_call(api_endpoint, method, request_body, operation)
  local account_id = os.getenv("CLOUDFLARE_ACCOUNT_ID")
  local api_key = os.getenv("CLOUDFLARE_API_KEY")

  if not account_id or not api_key then
    error("Unable to fetch Cloudflare credentials from environment")
    return nil, nil, nil
  end

  if not api_endpoint or api_endpoint == "" then
    error("`api_endpoint` is required")
    return nil, nil, nil
  end

  if not method or method == "" then
    error("`method` is required")
    return nil, nil, nil
  end

  if not api_key or api_key == "" then
    error("`api_key` is required")
    return nil, nil, nil
  end

  if not operation or operation == "" then
    error("`operation` is required")
    return nil, nil, nil
  end

  local status, headers, response_body = Fetch(api_endpoint, {
      method  = method,
      body    = request_body,
      headers = {
        ["Content-Type"]  = "application/json",
        ["Authorization"] = "Bearer " .. api_key,
      }
    })
    return status, headers, response_body

end

-- Main execution
local api_endpoint = api_endpoint(account_id)

local status, headers, body = api_call(
  api_endpoint,
  "POST",
  EncodeJson({
    name = "truepass-db",
    primary_location_hint = "apac"
  }),
  "create"
)

-- local status, headers, body = d1_api_call("DELETE", nil, "delete", DATABASE_ID)

print(status)
print(body) 
