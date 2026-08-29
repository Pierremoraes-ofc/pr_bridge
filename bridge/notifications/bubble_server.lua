local broadcastOwners = {}
local lastBroadcast = {}

local function clamp(value, minimum, maximum)
    return math.max(minimum, math.min(maximum, value))
end

local function cleanText(value, maximum)
    if value == nil then return nil end
    return tostring(value):sub(1, maximum)
end

RegisterNetEvent("pr_bridge:notifyBubble:broadcast", function(input)
    local playerSource = source
    if type(input) ~= "table" or playerSource <= 0 then return end

    local now = GetGameTimer()
    if now - (lastBroadcast[playerSource] or 0) < 350 then return end
    lastBroadcast[playerSource] = now

    local payload = {}
    for key, value in pairs(input) do payload[key] = value end
    local id = cleanText(payload.id, 120)
    local description = cleanText(payload.description or payload.text or payload.message, 220)
    local title = cleanText(payload.title, 80)
    if not id or id == "" or ((not description or description == "") and (not title or title == "")) then return end

    payload.id = id
    payload.description = description
    payload.title = title
    payload.serverId = playerSource
    payload.playerId = nil
    payload.entity = nil
    payload.ped = nil
    payload.netId = nil
    payload.netid = nil
    payload.visibility = "all"
    payload.broadcast = true
    payload.duration = clamp(tonumber(payload.duration) or 5000, 500, 30000)

    broadcastOwners[id] = playerSource
    TriggerClientEvent("pr_bridge:notifyBubble", -1, payload)

    SetTimeout(payload.duration + 1000, function()
        if broadcastOwners[id] == playerSource then broadcastOwners[id] = nil end
    end)
end)

RegisterNetEvent("pr_bridge:notifyBubble:hideBroadcast", function(id)
    local playerSource = source
    id = cleanText(id, 120)
    if not id or broadcastOwners[id] ~= playerSource then return end
    broadcastOwners[id] = nil
    TriggerClientEvent("pr_bridge:notifyBubble:hideNet", -1, id)
end)

AddEventHandler("playerDropped", function()
    local playerSource = source
    lastBroadcast[playerSource] = nil
    for id, owner in pairs(broadcastOwners) do
        if owner == playerSource then
            broadcastOwners[id] = nil
            TriggerClientEvent("pr_bridge:notifyBubble:hideNet", -1, id)
        end
    end
end)