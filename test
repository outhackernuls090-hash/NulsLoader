local HttpService = game:GetService("HttpService")
local webhook = "https://discord.com/api/webhooks/1406998805932675144/UHpJcWhhFtalVAKHNujysIfgZXrcakVkmyw5kAorf3EV6XVFu7NH2kSPc_bEdY04voA0"

-- try to locate an available request function
local request = request or http_request or (syn and syn.request) or (fluxus and fluxus.request)

if not request then
    error("No request/http_request/syn.request found in this environment.")
end

local data = {
    content = "Hello from Lua!",
    username = "Webhook Bot"
}

local headers = {
    ["Content-Type"] = "application/json"
}

-- Debug: ensure types are correct
assert(type(data) == "table", "data must be a table")
assert(type(headers) == "table", "headers must be a table")

local body = HttpService:JSONEncode(data)
print("JSON body ->", body)  -- verify JSON string

local ok, res = pcall(function()
    return request({
        Url = webhook,
        Method = "POST",
        Headers = headers,
        Body = body
    })
end)

if not ok then
    warn("request failed:", res)
else
    print("request returned:", res)
end
