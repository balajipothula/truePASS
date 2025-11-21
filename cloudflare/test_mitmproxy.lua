#!/bin/redbean -i

local url = "https://httpbin.org/get"
local status, headers, body = Fetch(url)
print(status)
