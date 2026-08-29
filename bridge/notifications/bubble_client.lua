local bubbles = {}
local sequence = 0
local running = false

local function clamp(value, minimum, maximum)
    return math.max(minimum, math.min(maximum, value))
end

local function shallowCopy(value)
    local copy = {}
    for key, entry in pairs(type(value) == "table" and value or {}) do copy[key] = entry end
    return copy
end

local function validColor(value, fallback)
    if type(value) == "string" and value:match("^#%x%x%x%x%x%x$") then return value:lower() end
    return fallback
end

local function resolveEntity(data)
    local entity = tonumber(data.entity or data.ped)
    if entity and entity > 0 and DoesEntityExist(entity) then return entity end

    local netId = tonumber(data.netId or data.netid)
    if netId and netId > 0 and NetworkDoesEntityExistWithNetworkId(netId) then
        entity = NetworkGetEntityFromNetworkId(netId)
        if entity > 0 and DoesEntityExist(entity) then return entity end
    end

    local playerId = tonumber(data.playerId)
    if playerId and NetworkIsPlayerActive(playerId) then
        entity = GetPlayerPed(playerId)
        if entity > 0 and DoesEntityExist(entity) then return entity end
    end

    local serverId = tonumber(data.serverId or data.source)
    if serverId then
        playerId = GetPlayerFromServerId(serverId)
        if playerId and playerId >= 0 and NetworkIsPlayerActive(playerId) then
            entity = GetPlayerPed(playerId)
            if entity > 0 and DoesEntityExist(entity) then return entity end
        end
    end

    entity = PlayerPedId()
    return entity > 0 and DoesEntityExist(entity) and entity or nil
end

local function sendItems(items)
    TriggerEvent("pr_bridge:ui:send", "bubble:sync", { items = items })
end

local function removeBubble(id)
    if not bubbles[id] then return false end
    bubbles[id] = nil
    return true
end

local function runLoop()
    if running then return end
    running = true

    CreateThread(function()
        while next(bubbles) do
            local now = GetGameTimer()
            local viewerPed = PlayerPedId()
            local viewerCoords = GetEntityCoords(viewerPed)
            local rendered = {}
            local entityStacks = {}

            for id, bubble in pairs(bubbles) do
                if now >= bubble.expiresAt then
                    bubbles[id] = nil
                else
                    local entity = resolveEntity(bubble)
                    if entity then
                        local coords = GetEntityCoords(entity)
                        local distance = #(viewerCoords - coords)
                        local hasLos = entity == viewerPed or bubble.wallDetection == false
                            or HasEntityClearLosToEntity(viewerPed, entity, bubble.losFlags)

                        if distance <= bubble.maxDistance and hasLos then
                            local boneCoords
                            if IsEntityAPed(entity) then
                                boneCoords = GetPedBoneCoords(entity, 31086, 0.0, 0.0, 0.0)
                                boneCoords = vector3(boneCoords.x, boneCoords.y, boneCoords.z + bubble.offsetZ)
                            else
                                boneCoords = GetOffsetFromEntityInWorldCoords(entity, 0.0, 0.0, bubble.offsetZ + 0.65)
                            end

                            local visible, screenX, screenY = GetScreenCoordFromWorldCoord(boneCoords.x, boneCoords.y, boneCoords.z)
                            if visible and screenX > 0.0 and screenX < 1.0 and screenY > 0.0 and screenY < 1.0 then
                                local stack = entityStacks[entity] or 0
                                entityStacks[entity] = stack + 1
                                rendered[#rendered + 1] = {
                                    id = id,
                                    text = bubble.text,
                                    title = bubble.title,
                                    icon = bubble.icon,
                                    color = bubble.color,
                                    textColor = bubble.textColor,
                                    background = bubble.background,
                                    opacity = bubble.opacity,
                                    borderColor = bubble.borderColor,
                                    borderOpacity = bubble.borderOpacity,
                                    x = screenX * 100.0,
                                    y = screenY * 100.0,
                                    scale = clamp((bubble.scale or 1.0) * (1.12 - distance / 50.0), 0.55, 1.5),
                                    stack = stack,
                                }
                            end
                        end
                    end
                end
            end

            sendItems(rendered)
            Wait(0)
        end

        sendItems({})
        running = false
    end)
end

local function showBubble(owner, input)
    if type(input) == "string" then input = { description = input } end
    if type(input) ~= "table" then return false end

    local text = tostring(input.description or input.text or input.message or "")
    local title = input.title and tostring(input.title) or nil
    if text == "" and (not title or title == "") then return false end

    sequence = sequence + 1
    local id = tostring(input.id or ((owner or "pr_bridge") .. ":bubble:" .. sequence))
    local duration = clamp(tonumber(input.duration) or 5000, 500, 30000)
    local now = GetGameTimer()
    local data = shallowCopy(input)

    local notifyType = tostring(input.type or "inform"):lower()
    local tones = {
        success = { color = "#10b981", icon = "check-circle-fill" },
        error = { color = "#ef4444", icon = "x-circle-fill" },
        warning = { color = "#f59e0b", icon = "exclamation-triangle-fill" },
        info = { color = "#3b82f6", icon = "info-circle-fill" },
        inform = { color = "#3b82f6", icon = "info-circle-fill" },
    }
    local tone = tones[notifyType] or tones.inform

    data.id = id
    data.owner = tostring(owner or "pr_bridge")
    data.text = text:gsub("\\n", "\n"):sub(1, 600)
    data.title = title and title:gsub("\\n", "\n"):sub(1, 100) or nil
    data.type = notifyType
    data.icon = tostring(input.icon or tone.icon)
    data.color = validColor(input.color or input.iconColor, tone.color)
    data.textColor = validColor(input.textColor, nil)
    data.background = validColor(input.background, nil)
    data.borderColor = validColor(input.borderColor or input.border, nil)
    data.opacity = input.opacity ~= nil and clamp(tonumber(input.opacity) or 0.96, 0.0, 1.0) or nil
    data.borderOpacity = input.borderOpacity ~= nil and clamp(tonumber(input.borderOpacity) or 1.0, 0.0, 1.0) or nil
    data.scale = clamp(tonumber(input.scale) or 1.0, 0.5, 2.0)
    data.offsetZ = clamp(tonumber(input.offsetZ) or 0.70, -1.0, 3.0)
    data.maxDistance = clamp(tonumber(input.maxDistance or input.distance) or 20.0, 1.0, 100.0)
    data.wallDetection = input.wallDetection ~= false
    data.losFlags = math.floor(clamp(tonumber(input.losFlags) or 277, 1, 511))
    data.expiresAt = now + duration

    bubbles[id] = data
    runLoop()
    return id
end

AddEventHandler("pr_bridge:notifyBubble:show", function(owner, data)
    showBubble(owner, data)
end)

AddEventHandler("pr_bridge:notifyBubble:hide", function(id)
    if id then removeBubble(tostring(id)) end
end)

RegisterNetEvent("pr_bridge:notifyBubble", function(data)
    showBubble("server", data)
end)

RegisterNetEvent("pr_bridge:notifyBubble:hideNet", function(id)
    if id then removeBubble(tostring(id)) end
end)

AddEventHandler("onResourceStop", function(resource)
    local changed = false
    for id, bubble in pairs(bubbles) do
        if bubble.owner == resource then bubbles[id] = nil; changed = true end
    end
    if changed and not next(bubbles) then sendItems({}) end
end)