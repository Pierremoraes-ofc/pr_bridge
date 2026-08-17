local api = PRCore.load("bridge.interact.api")
local records = api._records()

local nearby = {}
local selected = 1
local activeKey
local lastVisible = false
local interactKeybind
local interactKeyLabel = "E"
local scanInterval = math.max(100, GetConvarInt("pr_bridge:interact:scanInterval", 250))
local renderInterval = math.max(0, GetConvarInt("pr_bridge:interact:renderInterval", 16))

local function message(action, data)
    SendNUIMessage({ action = action, data = data })
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
    local config = (GlobalState.pr_bridge_ui_config or {}).interact or {}
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

local function interactionCoords(record, entity)
    if record.kind == "coords" then return record.coords end
    if not entity or entity == 0 or not DoesEntityExist(entity) then return nil end
    if record.bone then
        local bone = GetEntityBoneIndexByName(entity, record.bone)
        if bone == -1 then return nil end
        local coords = GetEntityBonePosition_2(entity, bone)
        return coords + (record.offset or vector3(0.0, 0.0, 0.0))
    end
    local offset = record.offset or vector3(0.0, 0.0, 0.0)
    return GetOffsetFromEntityInWorldCoords(entity, offset.x, offset.y, offset.z)
end

local function visibleThroughWalls(record, coords, entity, config)
    if record.ignoreLos or config.wallDetection == false then return true end
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
    output[#output + 1] = {
        key = ("%s:%s"):format(tostring(record.id), tostring(entity or 0)),
        record = record,
        entity = entity or 0,
        coords = coords,
        distance = distance,
        options = options,
    }
end

local function containsHash(list, hash)
    for i = 1, #(list or {}) do if list[i] == hash then return true end end
    return false
end

local function refreshNearby()
    if interactKeybind then interactKeyLabel = interactKeybind.currentKey or interactKeyLabel end
    if isDisabled() then nearby = {} return end
    local playerCoords = GetEntityCoords(PlayerPedId())
    local config = (GlobalState.pr_bridge_ui_config or {}).interact or {}
    local output = {}
    local modelRecords, globalVehicles, globalPlayers = {}, {}, {}

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
    nearby = output
end

local function cameraEntity()
    local hit, entity = Bridge.raycast.fromCamera(4.0, 511, 4, PlayerPedId())
    return hit and entity or 0
end

local function activeCandidate()
    local aimed = cameraEntity()
    local closest
    for i = 1, #nearby do
        local candidate = nearby[i]
        if candidate.distance <= candidate.record.interactDst then
            if candidate.entity == 0 or candidate.entity == aimed then return candidate end
            closest = closest or candidate
        end
    end
    return closest
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
        local candidate = activeCandidate()
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
    while true do
        if isDisabled() or #nearby == 0 then
            if lastVisible then message("interact:clear"); lastVisible = false end
            Wait(200)
        else
            local active = activeCandidate()
            if active and active.key ~= activeKey then selected, activeKey = 1, active.key end
            if not active then activeKey, selected = nil, 1 end

            if active and #active.options > 1 then
                if IsControlJustPressed(0, 172) or IsControlJustPressed(0, 15) then
                    selected = selected > 1 and selected - 1 or #active.options
                elseif IsControlJustPressed(0, 173) or IsControlJustPressed(0, 14) then
                    selected = selected < #active.options and selected + 1 or 1
                end
            end

            local showUi = (((GlobalState.pr_bridge_ui_config or {}).interact or {}).showUI ~= false)
            if showUi then
                local entries = {}
                for i = 1, #nearby do
                    local candidate = nearby[i]
                    local visible, x, y = GetScreenCoordFromWorldCoord(candidate.coords.x, candidate.coords.y, candidate.coords.z)
                    if visible then
                        local item = { id = candidate.key, x = x, y = y, active = active == candidate, options = {}, selected = selected }
                        if item.active then
                            for optionIndex = 1, #candidate.options do
                                item.options[#item.options + 1] = { label = candidate.options[optionIndex].source.label or candidate.options[optionIndex].source.name or "Interagir" }
                            end
                        end
                        entries[#entries + 1] = item
                    end
                end
                message("interact:set", { entries = entries, key = interactKeyLabel })
                lastVisible = true
                Wait(renderInterval)
            else
                if lastVisible then message("interact:clear"); lastVisible = false end
                Wait(50)
            end
        end
    end
end)

AddEventHandler("pr_bridge:interact:stateChanged", function(state)
    if state then nearby = {}; message("interact:clear"); lastVisible = false end
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        if interactKeybind and interactKeybind.destroy then interactKeybind:destroy() end
        message("interact:clear")
    end
end)
