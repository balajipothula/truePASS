#!/bin/redbean -i

local url = "https://httpbin.org/"
local status, headers, body = Fetch(url)
print(status)
