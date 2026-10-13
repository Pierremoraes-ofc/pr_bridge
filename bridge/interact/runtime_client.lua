local api = PRCore.load("bridge.interact.api")
local records = api._records()
local perspective = PRCore.load("bridge.interact.perspective")()

local nearby = {}
local selected = 1
local activeKey
local activeOptions
local nearbyRevision = -1
local lastVisible = false
local lastPayload
local interactKeybind
local interactKeyLabel = "E"
local scanInterval = math.max(100, GetConvarInt("pr_bridge:interact:scanInterval", 250))
local renderInterval = math.max(0, GetConvarInt("pr_bridge:interact:renderInterval", 16))

local function message(action, data)
    if action == "interact:clear" then lastPayload = nil end
    SendNUIMessage({ action = action, data = data })
end

-- Keep rendering moving anchors at the configured cadence, but do not ask CEF
-- to re-render the same screen position/selection while the camera is still.
local function samePresentation(a, b)
    if not a or a.key ~= b.key or math.abs(a.tiltY - b.tiltY) > 0.01 or #a.entries ~= #b.entries then return false end
    for i = 1, #a.entries do
        local old, new = a.entries[i], b.entries[i]
        if old.id ~= new.id or old.active ~= new.active or old.selected ~= new.selected
            or math.abs(old.x - new.x) > 0.0001 or math.abs(old.y - new.y) > 0.0001
            or #old.options ~= #new.options then return false end
        for j = 1, #old.options do
            if old.options[j].label ~= new.options[j].label or old.options[j].icon ~= new.options[j].icon then return false end
        end
    end
    return true
end

local function groupGrade(entry)
    if type(entry) == "table" then
        return tonumber(entry.grade and (entry.grade.level or entry.grade.grade) or entry.level or entry.rank) or 0
    end
    return tonumber(entry) or 0
end

local function playerGroups()
    local data = Bridge.framework and Bridge.framework.GetPlayerData and Bridge.framework.GetPlayerData() or {}
    local output = {}
    if type(data.groups) == "table" then
        for name, grade in pairs(data.groups) do output[tostring(name)] = groupGrade(grade) end
    end
    if type(data.job) == "table" and data.job.name then output[data.job.name] = groupGrade(data.job) end
    if type(data.gang) == "table" and data.gang.name then output[data.gang.name] = groupGrade(data.gang) end
    return output
end

local function hasGroup(filter)
    if filter == nil then return true end
    local groups = playerGroups()
    if type(filter) == "string" then return groups[filter] ~= nil end
    if type(filter) ~= "table" then return true end
    for key, grade in pairs(filter) do
        if type(key) == "number" then
            if groups[tostring(grade)] ~= nil then return true end
        elseif groups[tostring(key)] ~= nil and groups[tostring(key)] >= (tonumber(grade) or 0) then
            return true
        end
    end
    return false
end

local function isDisabled()
    local ped = PlayerPedId()
    local config = Bridge.settings.get("interface", {}).interact or {}
    if api._disabled() or LocalPlayer.state.interactionsDisabled then return true end
    if config.disableOnDeath ~= false and (IsPedDeadOrDying(ped, true) or LocalPlayer.state.isDead) then return true end
    if config.disableOnNuiFocus ~= false and IsNuiFocused() then return true end
    if config.disableInVehicle ~= false and IsPedInAnyVehicle(ped, false) then return true end
    if config.disableWhenCuffed ~= false and IsPedCuffed(ped) then return true end
    return false
end

local function entityFor(record)
    if record.kind == "networkEntity" or record.kind == "networkBone" then
        if record.netId and NetworkDoesNetworkIdExist(record.netId) then
            return NetworkGetEntityFromNetworkId(record.netId)
        end
        return 0
    end
    return record.entity or 0
end

local function interactionCoords(record, entity, effectiveOffset)
    if record.kind == "coords" then return record.coords end
    if not entity or entity == 0 or not DoesEntityExist(entity) then return nil end
    if record.bone then
        local bone = GetEntityBoneIndexByName(entity, record.bone)
        if bone == -1 then return nil end
        local coords = GetEntityBonePosition_2(entity, bone)
        return coords + (effectiveOffset or record.offset)
    end
    local offset = effectiveOffset or record.offset
    return GetOffsetFromEntityInWorldCoords(entity, offset.x, offset.y, offset.z)
end

local function visibleThroughWalls(record, coords, entity, config)
    if record.ignoreLos or (record.wallDetection ~= true and config.wallDetection == false) then return true end
    local origin = GetPedBoneCoords(PlayerPedId(), 31086, 0.0, 0.0, 0.0)
    local flags = math.max(1, math.min(511, math.floor(tonumber(config.wallRayFlags) or 277)))
    local ray = StartShapeTestLosProbe(origin.x, origin.y, origin.z, coords.x, coords.y, coords.z, flags, PlayerPedId(), 7)
    local expires = GetGameTimer() + 50
    repeat
        local status, hit, hitCoords, _, hitEntity = GetShapeTestResult(ray)
        if status ~= 1 then
            return hit == 0 or hit == false or hitEntity == entity or (hitCoords and #(hitCoords - coords) <= 0.35)
        end
        Wait(0)
    until GetGameTimer() >= expires
    return false
end

local function allowedOptions(record, entity, coords)
    if not hasGroup(record.groups) then return {} end
    local output = {}
    for index = 1, #(record.options or {}) do
        local option = record.options[index]
        local allowed = hasGroup(option.groups)
        if allowed and option.canInteract then
            local ok, result = pcall(option.canInteract, entity, coords, option.args)
            allowed = ok and result == true
            if not ok then
                print(("^1[pr_bridge:interact] canInteract '%s' falhou: %s^0"):format(tostring(option.name or option.label), tostring(result)))
            end
        end
        if allowed then output[#output + 1] = { source = option, sourceIndex = index } end
    end
    return output
end

local function addCandidate(output, record, entity, playerCoords, config)
    local coords = interactionCoords(record, entity)
    if not coords then return end
    local distance = #(playerCoords - coords)
    if distance > record.distance then return end
    if not visibleThroughWalls(record, coords, entity, config) then return end
    local options = allowedOptions(record, entity, coords)
    if #options == 0 then return end
    local uiOptions = {}
    for i = 1, #options do
        local source = options[i].source
        uiOptions[i] = { label = source.label or source.name or "Interagir", icon = type(source.icon) == "string" and source.icon or nil }
    end
    output[#output + 1] = {
        key = ("%s:%s"):format(tostring(record.id), tostring(entity or 0)),
        record = record,
        entity = entity or 0,
        coords = coords,
        distance = distance,
        options = options,
        uiOptions = uiOptions,
        -- Model registrations temporarily substitute their per-model offset in
        -- the scan; retain it for subsequent live transform updates.
        offset = record.offset,
    }
end

local function refreshTransforms()
    if #nearby == 0 then return end
    local playerCoords = GetEntityCoords(PlayerPedId())
    for i = 1, #nearby do
        local candidate = nearby[i]
        candidate.coords = interactionCoords(candidate.record, candidate.entity, candidate.offset)
        candidate.distance = candidate.coords and #(playerCoords - candidate.coords) or math.huge
    end
end

local function containsHash(list, hash)
    for i = 1, #(list or {}) do if list[i] == hash then return true end end
    return false
end

local function refreshNearby()
    local revision = api._revision()
    if interactKeybind then interactKeyLabel = interactKeybind.currentKey or interactKeyLabel end
    if isDisabled() then nearby, nearbyRevision = {}, revision; return end
    local playerCoords = GetEntityCoords(PlayerPedId())
    local config = Bridge.settings.get("interface", {}).interact or {}
    local output = {}
    local modelRecords, globalVehicles, globalPlayers = {}, {}, {}

    -- Temporary item menus take precedence without globally disabling Interact.
    for _, record in pairs(records) do
        if record.exclusive then addCandidate(output, record, entityFor(record), playerCoords, config) end
    end
    for i = #output, 1, -1 do
        if output[i].distance > output[i].record.interactDst then table.remove(output, i) end
    end
    if #output > 0 then
        table.sort(output, function(a, b) return a.distance < b.distance end)
        -- LOS/canInteract may yield while another thread adds/removes a menu.
        if revision ~= api._revision() then return end
        nearby, nearbyRevision = { output[1] }, revision
        return
    end

    for _, record in pairs(records) do
        if record.kind == "model" then modelRecords[#modelRecords + 1] = record
        elseif record.kind == "globalVehicle" then globalVehicles[#globalVehicles + 1] = record
        elseif record.kind == "globalPlayer" then globalPlayers[#globalPlayers + 1] = record
        else addCandidate(output, record, entityFor(record), playerCoords, config) end
    end

    if #modelRecords > 0 then
        for _, poolName in ipairs({ "CObject", "CVehicle", "CPed" }) do
            local pool = GetGamePool(poolName)
            for i = 1, #pool do
                local entity = pool[i]
                if DoesEntityExist(entity) and #(playerCoords - GetEntityCoords(entity)) <= 25.0 then
                    local hash = GetEntityModel(entity)
                    for index = 1, #modelRecords do
                        local record = modelRecords[index]
                        if containsHash(record.modelHashes, hash) then
                            local oldOffset = record.offset
                            record.offset = record.modelOffsets and record.modelOffsets[hash] or oldOffset
                            addCandidate(output, record, entity, playerCoords, config)
                            record.offset = oldOffset
                        end
                    end
                end
            end
        end
    end

    if #globalVehicles > 0 then
        local pool = GetGamePool("CVehicle")
        for i = 1, #pool do
            local entity = pool[i]
            if DoesEntityExist(entity) and #(playerCoords - GetEntityCoords(entity)) <= 25.0 then
                for index = 1, #globalVehicles do addCandidate(output, globalVehicles[index], entity, playerCoords, config) end
            end
        end
    end

    if #globalPlayers > 0 then
        for _, playerId in ipairs(GetActivePlayers()) do
            if playerId ~= PlayerId() then
                local entity = GetPlayerPed(playerId)
                for index = 1, #globalPlayers do addCandidate(output, globalPlayers[index], entity, playerCoords, config) end
            end
        end
    end

    table.sort(output, function(a, b) return a.distance < b.distance end)
    if revision ~= api._revision() then return end
    nearby, nearbyRevision = output, revision
end

local function cameraEntity()
    local hit, entity = Bridge.raycast.fromCamera(4.0, 511, 4, PlayerPedId())
    return hit and entity or 0
end

local function wheelPressed(control)
    -- Some consumers suppress the game's weapon wheel without taking NUI focus.
    return IsControlJustPressed(0, control) or IsDisabledControlJustPressed(0, control)
end

local function activeCandidate()
    if nearbyRevision ~= api._revision() then refreshNearby() end
    if nearbyRevision ~= api._revision() then return end
    local closest, eligible = nil, 0
    for i = 1, #nearby do
        local candidate = nearby[i]
        if candidate.distance <= candidate.record.interactDst then
            if candidate.record.exclusive then return candidate end
            eligible = eligible + 1
            if not closest or candidate.distance < closest.distance then closest = candidate end
        end
    end
    -- A ray cannot change the result when only one point is eligible. In
    -- particular a menu attached to our own ped needs no camera hit at all.
    if eligible <= 1 then return closest end
    local aimed = cameraEntity()
    for i = 1, #nearby do
        local candidate = nearby[i]
        if candidate.distance <= candidate.record.interactDst and (candidate.entity == 0 or candidate.entity == aimed) then return candidate end
    end
    return closest
end

local function syncSelection(candidate)
    local key = candidate and candidate.key
    local options = candidate and candidate.record.options
    if key ~= activeKey or options ~= activeOptions then selected = 1 end
    activeKey, activeOptions = key, options
end

local function dispatch(candidate, option)
    local data = option.source
    if data.action then
        local serverId
        if candidate.entity ~= 0 and IsEntityAPed(candidate.entity) and IsPedAPlayer(candidate.entity) then
            local player = NetworkGetPlayerIndexFromPed(candidate.entity)
            serverId = player ~= -1 and GetPlayerServerId(player) or nil
        end
        local ok, err = pcall(data.action, candidate.entity, candidate.coords, data.args, serverId)
        if not ok then print(("^1[pr_bridge:interact] action falhou: %s^0"):format(tostring(err))) end
    elseif data.serverEvent then
        TriggerServerEvent(data.serverEvent, data.args)
    elseif data.event then
        TriggerEvent(data.event, data)
    elseif data.command then
        ExecuteCommand(data.command)
    end
end

interactKeybind = Bridge.addKeybind({
    name = "pr_bridge_interact",
    description = "Interact",
    defaultMapper = "keyboard",
    defaultKey = GetConvar("pr_bridge:interact:defaultKey", "E"),
    onPressed = function()
        if isDisabled() then return end
        refreshTransforms()
        local candidate = activeCandidate()
        syncSelection(candidate)
        if candidate then dispatch(candidate, candidate.options[selected] or candidate.options[1]) end
    end,
})
CreateThread(function()
    while true do
        refreshNearby()
        Wait(scanInterval)
    end
end)

CreateThread(function()
    local active, activeNearby
    local nextActiveAt, nextMessageAt, lastTickAt = 0, 0, 0
    while true do
        if nearbyRevision ~= api._revision() then
            refreshNearby()
            nextActiveAt, nextMessageAt = 0, 0
        end
        if isDisabled() or #nearby == 0 then
            active, activeNearby, nextActiveAt, nextMessageAt = nil, nil, 0, 0
            perspective.reset()
            if lastVisible then message("interact:clear"); lastVisible = false end
            Wait(200)
        else
            local now = GetGameTimer()
            if now < lastTickAt then nextActiveAt, nextMessageAt = 0, 0 end
            lastTickAt = now
            -- Scans replace candidate tables. Rebind by stable key without another camera raycast.
            if activeNearby ~= nearby and active then
                local previousKey = active.key
                active = nil
                for i = 1, #nearby do
                    if nearby[i].key == previousKey then active = nearby[i]; break end
                end
            end
            activeNearby = nearby
            -- Read transient wheel pulses every frame, but keep raycasts on the existing cadence.
            if now >= nextActiveAt then
                refreshTransforms()
                active = activeCandidate()
                nextActiveAt = now + renderInterval
            end
            syncSelection(active)

            local hasChoices = active and #active.options > 1
            local selectionChanged = false
            if hasChoices then
                -- OR aliases so a single wheel pulse cannot move two rows.
                if IsControlJustPressed(0, 172) or wheelPressed(241) or wheelPressed(15) then
                    selected = selected > 1 and selected - 1 or #active.options
                    selectionChanged = true
                elseif IsControlJustPressed(0, 173) or wheelPressed(242) or wheelPressed(14) then
                    selected = selected < #active.options and selected + 1 or 1
                    selectionChanged = true
                end
            end

            local config = Bridge.settings.get("interface", {}).interact or {}
            local showUi = config.showUI ~= false
            if showUi then
                if now >= nextMessageAt or selectionChanged then
                    local entries = {}
                    for i = 1, #nearby do
                        local candidate = nearby[i]
                        local visible, x, y = false, 0.0, 0.0
                        if candidate.coords and candidate.distance <= candidate.record.distance and not candidate.record.hide then
                            visible, x, y = GetScreenCoordFromWorldCoord(candidate.coords.x, candidate.coords.y, candidate.coords.z)
                        end
                        if visible then
                            local item = { id = candidate.key, x = x, y = y, active = active == candidate, options = {}, selected = selected }
                            if item.active then item.options = candidate.uiOptions end
                            entries[#entries + 1] = item
                        end
                    end
                    local tiltY = 0
                    if config.perspectiveEnabled == true and #entries > 0 then
                        local rotation = GetFinalRenderedCamRot(2)
                        tiltY = perspective.update(config, rotation and rotation.z, now)
                    else
                        perspective.reset()
                    end
                    local payload = { entries = entries, key = interactKeyLabel, tiltY = tiltY }
                    if not samePresentation(lastPayload, payload) then
                        message("interact:set", payload)
                        lastPayload = payload
                    end
                    lastVisible = true
                    nextMessageAt = now + renderInterval
                end
                Wait(hasChoices and 0 or renderInterval)
            else
                nextMessageAt = 0
                perspective.reset()
                if lastVisible then message("interact:clear"); lastVisible = false end
                Wait(hasChoices and 0 or 50)
            end
        end
    end
end)

AddEventHandler("pr_bridge:interact:stateChanged", function(state)
    if state then nearby = {}; perspective.reset(); message("interact:clear"); lastVisible = false end
end)

AddEventHandler("pr_bridge:ui:ready", function()
    lastPayload = nil
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        if interactKeybind and interactKeybind.destroy then interactKeybind:destroy() end
        message("interact:clear")
    end
end)
