if ActiveBridges["target"] ~= "native" then return end

local api = PRCore.load("bridge.targets.native.api")
local Zones = api._zones()
local collections = api._collections()
local state = api._state()

local current = { entity = 0, coords = vector3(0.0, 0.0, 0.0), distance = 0.0 }
local currentMenu
local menuHistory = {}
local activeGroups = {}
local activeZones = {}
local nuiFocused = false
local lastSignature
local renderNearby = {}
local renderHasOptions = false
local markerEntities = {}
local markerZones = {}
local backOptions = {
    {
        name = "pr_bridge:target:back",
        icon = "fa-solid fa-circle-chevron-left",
        label = "Voltar",
        openMenu = "home",
    },
}

local toggleHotkey = GetConvarInt("pr_bridge:target:toggleHotkey", GetConvarInt("ox_target:toggleHotkey", 0)) == 1
local leftClick = GetConvarInt("pr_bridge:target:leftClick", GetConvarInt("ox_target:leftClick", 1)) == 1
local debugEnabled = GetConvarInt("pr_bridge:target:debug", GetConvarInt("ox_target:debug", 0)) == 1
local defaultDistance = tonumber(GetConvar("pr_bridge:target:distance", "7")) or 7.0
local drawSpriteLimit = math.max(0, GetConvarInt("pr_bridge:target:drawSprite", GetConvarInt("ox_target:drawSprite", 24)))
local markerUpdateInterval = math.max(0, GetConvarInt("pr_bridge:target:markerInterval", 16))
local markerModelOffsets = {}

local function targetMessage(action, data)
    SendNUIMessage({ action = action, data = data })
end

local function setFocus(value)
    nuiFocused = value == true
    if nuiFocused then SetCursorLocation(0.5, 0.5) end
    SetNuiFocus(nuiFocused, nuiFocused)
    SetNuiFocusKeepInput(nuiFocused)
end

local function setActive(value)
    value = value == true and not state.disabled
    if state.active == value then return end
    state.active = value
    targetMessage("target:visible", { state = value })
    if not value then setFocus(false) end
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
    local groups = playerGroups()
    if type(filter) == "string" then return groups[filter] ~= nil end
    if type(filter) ~= "table" then return true end

    for key, value in pairs(filter) do
        if type(key) == "number" then
            if groups[tostring(value)] ~= nil then return true end
        else
            if groups[tostring(key)] ~= nil and groups[tostring(key)] >= (tonumber(value) or 0) then return true end
        end
    end
    return false
end

local function itemCount(name)
    local inventory = Bridge.inventory
    if inventory and inventory.GetItemCount then
        local ok, count = pcall(inventory.GetItemCount, name)
        return ok and (tonumber(count) or 0) or 0
    end
    if inventory and inventory.HasItem then
        local ok, result = pcall(inventory.HasItem, name, 1)
        return ok and result and 1 or 0
    end
    return 0
end

local function hasItems(filter, anyItem)
    if type(filter) == "string" then return itemCount(filter) > 0 end
    if type(filter) ~= "table" then return true end
    local found = false
    for key, value in pairs(filter) do
        local name, amount
        if type(key) == "number" then name, amount = value, 1 else name, amount = key, tonumber(value) or 1 end
        local has = itemCount(name) >= amount
        if anyItem and has then return true end
        if not anyItem and not has then return false end
        found = true
    end
    return not anyItem
end

local function closestBone(option, entity, endCoords)
    if not option.bones then return nil, true end
    local bones = type(option.bones) == "table" and option.bones or { option.bones }
    local closest, closestDistance
    for i = 1, #bones do
        local bone = GetEntityBoneIndexByName(entity, bones[i])
        if bone ~= -1 then
            local distance = #(endCoords - GetEntityBonePosition_2(entity, bone))
            if distance <= (closestDistance or 2.0) then closest, closestDistance = bone, distance end
        end
    end
    return closest, closest ~= nil
end

local function shouldShow(option, distance, endCoords, entity, model)
    if option.menuName ~= currentMenu then return false end
    if distance > (tonumber(option.distance) or defaultDistance) then return false end
    if option.groups and not hasGroup(option.groups) then return false end
    if option.items and not hasItems(option.items, option.anyItem == true) then return false end

    local bone
    if model and option.bones then
        local valid
        bone, valid = closestBone(option, entity, endCoords)
        if not valid then return false end
    end

    local offset = model and (option.offset or option.offsetAbsolute) or nil
    if offset then
        if not option.absoluteOffset and not option.offsetAbsolute then
            local min, max = GetModelDimensions(model)
            offset = (max - min) * offset + min
        end
        local world = GetOffsetFromEntityInWorldCoords(entity, offset.x, offset.y, offset.z)
        if #(endCoords - world) > (tonumber(option.offsetSize) or 1.0) then return false end
    end

    if option.canInteract then
        local ok, result = pcall(option.canInteract, entity, distance, endCoords, option.name, bone)
        if not ok then
            print(("^1[pr_bridge:target] canInteract '%s' falhou: %s^0"):format(tostring(option.name), tostring(result)))
            return false
        end
        if not result then return false end
    end
    return true
end

local function uiOption(option, groupIndex, optionIndex, zoneIndex)
    return {
        groupIndex = groupIndex,
        optionIndex = optionIndex,
        zoneIndex = zoneIndex,
        name = option.name,
        label = option.label or option.name or "Interagir",
        icon = option.icon or "fa-solid fa-circle",
        iconColor = option.iconColor,
    }
end

local function addVisibleGroup(output, key, options, distance, entity, model)
    if not options or #options == 0 then return end
    local group = { key = key, options = {} }
    local groupIndex = #activeGroups + 1
    activeGroups[groupIndex] = options
    for i = 1, #options do
        if shouldShow(options[i], key == "global" and 0.0 or distance, current.coords, entity, model) then
            group.options[#group.options + 1] = uiOption(options[i], groupIndex, i)
        end
    end
    if #group.options > 0 then output[#output + 1] = group end
end

local function collectEntityGroups(entity, entityType, model, distance)
    activeGroups = {}
    local output = {}
    if currentMenu then
        backOptions[1].menuName = currentMenu
        addVisibleGroup(output, "back", backOptions, 0.0, entity, model)
    end
    addVisibleGroup(output, "global", collections.global, distance, entity, model)
    if entity and entity > 0 then
        local global = entityType == 1 and (IsPedAPlayer(entity) and collections.players or collections.peds)
            or entityType == 2 and collections.vehicles or collections.objects
        addVisibleGroup(output, "type", global, distance, entity, model)
        addVisibleGroup(output, "model", collections.models[model], distance, entity, model)
        local netId = NetworkGetEntityIsNetworked(entity) and NetworkGetNetworkIdFromEntity(entity) or nil
        addVisibleGroup(output, "entity", netId and collections.entities[netId], distance, entity, model)
        addVisibleGroup(output, "localEntity", collections.localEntities[entity], distance, entity, model)
    end
    return output
end

local function collectZones(endCoords, distance, entity, markerCoords)
    activeZones = {}
    local output = {}
    local nearby = Zones.getNearby(endCoords)
    for i = 1, #nearby do
        local zone = nearby[i]
        if zone:contains(endCoords) then
            local zoneIndex = #activeZones + 1
            activeZones[zoneIndex] = zone
            local visible = { id = zone.id, options = {} }
            for optionIndex = 1, #zone.options do
                local option = zone.options[optionIndex]
                if shouldShow(option, distance, endCoords, entity, nil) then
                    visible.options[#visible.options + 1] = uiOption(option, nil, optionIndex, zoneIndex)
                end
            end
            if #visible.options > 0 then output[#output + 1] = visible end
        end
    end
    -- Interaction follows the camera ray, but nearby markers must follow the
    -- player. Using the ray endpoint for both made zone targets disappear
    -- until the crosshair was already inside the zone.
    return output, Zones.getNearby(markerCoords or endCoords)
end

local function signature(groups, zones)
    local values = { tostring(currentMenu or "home") }
    for i = 1, #groups do
        for j = 1, #groups[i].options do
            local option = groups[i].options[j]
            values[#values + 1] = ("g:%s:%s:%s"):format(option.groupIndex, option.optionIndex, option.label)
        end
    end
    for i = 1, #zones do
        for j = 1, #zones[i].options do
            local option = zones[i].options[j]
            values[#values + 1] = ("z:%s:%s:%s"):format(zones[i].id, option.optionIndex, option.label)
        end
    end
    return table.concat(values, "|")
end


local function drawNearbyZones(nearby)
    if not debugEnabled then return end
    for i = 1, #nearby do
        local zone = nearby[i]
        if zone.debug then
            DrawMarker(28, zone.coords.x, zone.coords.y, zone.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                0.3, 0.3, 0.3, 255, 42, 24, 120, false, false, 2, false, nil, nil, false)
        end
    end
end

local function markerOptionAllowed(option, entity, distance, coords)
    if option.menuName ~= currentMenu then return false end
    if option.groups and not hasGroup(option.groups) then return false end
    if option.items and not hasItems(option.items, option.anyItem == true) then return false end
    if option.canInteract then
        local ok, allowed = pcall(option.canInteract, entity, distance, coords, option.name, nil)
        return ok and allowed == true
    end
    return true
end

local function markerWorldPoint(entity)
    local model = GetEntityModel(entity)
    local markerOffset = markerModelOffsets[model]
    if not markerOffset then
        local _, maximum = GetModelDimensions(model)
        markerOffset = (maximum and maximum.z or 0.5) + 0.12
        markerModelOffsets[model] = markerOffset
    end
    return GetOffsetFromEntityInWorldCoords(entity, 0.0, 0.0, markerOffset)
end

local function filterVisibleMarkerEntities(entities, targetConfig)
    if targetConfig.wallDetection == false or #entities == 0 then return entities end

    local rayFlags = math.floor(tonumber(targetConfig.wallRayFlags) or 277)
    rayFlags = math.max(1, math.min(511, rayFlags))
    local origin = GetFinalRenderedCamCoord()
    local ped = PlayerPedId()
    local pending = {}
    local visible = {}

    for i = 1, #entities do
        local entity = entities[i]
        if DoesEntityExist(entity) then
            local point = markerWorldPoint(entity)
            pending[#pending + 1] = {
                index = i,
                entity = entity,
                handle = StartShapeTestLosProbe(
                    origin.x, origin.y, origin.z,
                    point.x, point.y, point.z,
                    rayFlags, ped, 7
                ),
            }
        end
    end

    local expires = GetGameTimer() + 100
    while #pending > 0 and GetGameTimer() < expires do
        for i = #pending, 1, -1 do
            local ray = pending[i]
            local status, hit, _, _, entityHit = GetShapeTestResult(ray.handle)
            if status ~= 1 then
                if hit == 0 or hit == false or entityHit == ray.entity then
                    visible[ray.index] = ray.entity
                end
                table.remove(pending, i)
            end
        end
        if #pending > 0 then Wait(0) end
    end

    local output = {}
    for i = 1, #entities do
        if visible[i] then output[#output + 1] = visible[i] end
    end
    return output
end

local function refreshMarkerEntities(playerCoords, markerDistance, targetConfig)
    if drawSpriteLimit == 0 then
        markerEntities = {}
        return
    end

    local candidates = {}
    local objects = GetGamePool("CObject")
    for i = 1, #objects do
        local entity = objects[i]
        if DoesEntityExist(entity) then
            local model = GetEntityModel(entity)
            local options = collections.models[model]
            if options and #options > 0 then
                local coords = GetEntityCoords(entity)
                local distance = #(playerCoords - coords)
                if distance <= markerDistance then
                    for optionIndex = 1, #options do
                        if markerOptionAllowed(options[optionIndex], entity, distance, coords) then
                            candidates[#candidates + 1] = { entity = entity, distance = distance }
                            break
                        end
                    end
                end
            end
        end
    end
    table.sort(candidates, function(a, b)
        if a.distance == b.distance then return a.entity < b.entity end
        return a.distance < b.distance
    end)

    -- Check more candidates than can be rendered. A hidden object must not
    -- consume the quota and suppress another valid target behind it in the
    -- unordered CObject pool.
    local scanLimit = math.min(#candidates, math.max(32, drawSpriteLimit * 3))
    local nextEntities = {}
    for i = 1, scanLimit do nextEntities[i] = candidates[i].entity end

    local visible = filterVisibleMarkerEntities(nextEntities, targetConfig)
    markerEntities = {}
    for i = 1, math.min(#visible, drawSpriteLimit) do
        markerEntities[i] = visible[i]
    end
end

local function refreshMarkerZones(playerCoords, markerDistance)
    if drawSpriteLimit == 0 then
        markerZones = {}
        return
    end

    local candidates = {}
    local nearby = Zones.getNearby(playerCoords)
    for i = 1, #nearby do
        local zone = nearby[i]
        if zone.drawSprite ~= false then
            local distance = #(playerCoords - zone.coords)
            if distance <= markerDistance or zone:contains(playerCoords) then
                for optionIndex = 1, #zone.options do
                    if markerOptionAllowed(zone.options[optionIndex], 0, distance, zone.coords) then
                        candidates[#candidates + 1] = { zone = zone, distance = distance }
                        break
                    end
                end
            end
        end
    end
    table.sort(candidates, function(a, b)
        return a.distance == b.distance and a.zone.id < b.zone.id or a.distance < b.distance
    end)

    markerZones = {}
    for i = 1, math.min(#candidates, drawSpriteLimit) do markerZones[i] = candidates[i].zone end
end

local function sendScreenMarkers(playerCoords, markerDistance)
    local markers = {}
    local targetedZones = {}
    if renderHasOptions then
        for i = 1, #activeZones do
            targetedZones[activeZones[i].id] = true
        end
    end

    for i = 1, #markerEntities do
        local entity = markerEntities[i]
        if DoesEntityExist(entity) then
            local coords = GetEntityCoords(entity)
            if #(playerCoords - coords) <= markerDistance then
                local point = markerWorldPoint(entity)
                local visible, screenX, screenY = GetScreenCoordFromWorldCoord(point.x, point.y, point.z)
                if visible then
                    markers[#markers + 1] = {
                        id = ("entity:%s"):format(entity), x = screenX, y = screenY,
                        targeted = entity == current.entity and renderHasOptions,
                    }
                end
            end
        end
    end

    for i = 1, #markerZones do
        local zone = markerZones[i]
        local coords = zone.coords
        if #(playerCoords - coords) <= markerDistance or zone:contains(playerCoords) then
            local visible, screenX, screenY = GetScreenCoordFromWorldCoord(coords.x, coords.y, coords.z)
            if visible then
                markers[#markers + 1] = {
                    id = ("zone:%s"):format(zone.id), x = screenX, y = screenY,
                    targeted = targetedZones[zone.id] == true,
                }
            end
        end
    end
    targetMessage("target:markers", { markers = markers })
end
local function response(option, server, zone)
    local output = {}
    for key, value in pairs(option) do
        if key ~= "icon" and key ~= "iconColor" and key ~= "groups" and key ~= "items"
            and key ~= "canInteract" and key ~= "onSelect" and key ~= "export" and key ~= "event"
            and key ~= "serverEvent" and key ~= "command" and key ~= "resource" then
            output[key] = value
        end
    end
    output.entity = current.entity
    output.zone = zone and zone.id or nil
    output.coords = current.coords
    output.distance = current.distance
    if server then
        output.entity = output.entity ~= 0 and NetworkGetEntityIsNetworked(output.entity)
            and NetworkGetNetworkIdFromEntity(output.entity) or 0
    end
    return output
end

local function dispatch(option, zone)
    if option.onSelect then
        local data = option.qtarget and current.entity or response(option, false, zone)
        local ok, err = pcall(option.onSelect, data)
        if not ok then print(("^1[pr_bridge:target] onSelect falhou: %s^0"):format(tostring(err))) end
    elseif option.export then
        local resource, exportName = option.resource or (zone and zone.resource), option.export
        local dot = type(exportName) == "string" and exportName:find("%.")
        if dot then resource, exportName = exportName:sub(1, dot - 1), exportName:sub(dot + 1) end
        local ok, err = pcall(function() return exports[resource][exportName](nil, response(option, false, zone)) end)
        if not ok then print(("^1[pr_bridge:target] export falhou: %s^0"):format(tostring(err))) end
    elseif option.event then
        TriggerEvent(option.event, response(option, false, zone))
    elseif option.serverEvent then
        TriggerServerEvent(option.serverEvent, response(option, true, zone))
    elseif option.command then
        ExecuteCommand(option.command)
    end
end

local function stopTargeting()
    setActive(false)
end

local function startTargeting()
    if state.disabled or state.active or IsNuiFocused() or IsPauseMenuActive() then return end
    setActive(true)
    lastSignature = nil
    currentMenu = nil
    menuHistory = {}

    renderNearby, renderHasOptions = {}, false
    CreateThread(function()
        while state.active do
            drawNearbyZones(renderNearby)
            DisablePlayerFiring(PlayerId(), true)
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 142, true)

            if nuiFocused then
                DisableControlAction(0, 1, true)
                DisableControlAction(0, 2, true)
                if not renderHasOptions or IsDisabledControlJustPressed(0, 25) then setFocus(false) end
            elseif renderHasOptions and IsDisabledControlJustPressed(0, leftClick and 24 or 25) then
                setFocus(true)
            end

            Wait(0)
        end
    end)

    CreateThread(function()
        local nextScan = 0
        while state.active do
            local playerCoords = GetEntityCoords(PlayerPedId())
            local config = GlobalState.pr_bridge_ui_config or {}
            local targetConfig = config.target or {}
            local markerDistance = tonumber(targetConfig.markerDistance) or 5.0
            local now = GetGameTimer()
            if now >= nextScan then
                refreshMarkerEntities(playerCoords, markerDistance, targetConfig)
                refreshMarkerZones(playerCoords, markerDistance)
                nextScan = now + 500
            end
            sendScreenMarkers(playerCoords, markerDistance)
            Wait(markerUpdateInterval)
        end
        markerEntities = {}
        markerZones = {}
        targetMessage("target:markers", { markers = {} })
    end)

    CreateThread(function()
        local flag = 511
        local lastEntity = 0
        while state.active do
            local ped = PlayerPedId()
            local playerCoords = GetEntityCoords(ped)
            local hit, entity, endCoords = Bridge.raycast.fromCamera(20.0, flag, 4, ped)
            entity = entity or 0
            endCoords = endCoords or (playerCoords + GetEntityForwardVector(ped) * 20.0)
            local distance = #(playerCoords - endCoords)
            local entityType, model = 0, nil
            if entity == 0 or not DoesEntityExist(entity) or GetEntityType(entity) == 0 then
                local alternateFlag = flag == 511 and 26 or 511
                local alternateHit, alternateEntity, alternateCoords = Bridge.raycast.fromCamera(20.0, alternateFlag, 4, ped)
                alternateEntity = alternateEntity or 0
                alternateCoords = alternateCoords or endCoords
                local alternateDistance = #(playerCoords - alternateCoords)

                if alternateEntity > 0 and DoesEntityExist(alternateEntity) and alternateDistance < distance then
                    flag, hit, entity, endCoords, distance = alternateFlag, alternateHit, alternateEntity, alternateCoords, alternateDistance
                end
            end


            if entity > 0 and DoesEntityExist(entity) then
                local okType, resultType = pcall(GetEntityType, entity)
                entityType = okType and resultType or 0
                local okModel, resultModel = pcall(GetEntityModel, entity)
                model = okModel and resultModel or nil
                if flag ~= 511 and not HasEntityClearLosToEntity(entity, ped, 7) then entity = 0 end
            end

            current.entity, current.coords, current.distance = entity, endCoords, distance
            local groups = collectEntityGroups(entity, entityType, model, distance)
            local zones, nearby = collectZones(endCoords, distance, entity, playerCoords)
            local nextSignature = signature(groups, zones)
            local hasOptions = #groups > 0 or #zones > 0
            renderNearby = nearby
            renderHasOptions = hasOptions

            if nextSignature ~= lastSignature or entity ~= lastEntity then
                if hasOptions then
                    targetMessage("target:set", { groups = groups, zones = zones })
                else
                    targetMessage("target:left")
                    if nuiFocused then setFocus(false) end
                end
                lastSignature, lastEntity = nextSignature, entity
            end

            if toggleHotkey and IsPauseMenuActive() then stopTargeting() end
            if not hasOptions then flag = flag == 511 and 26 or 511 end
            Wait(hit and 40 or 80)
        end

        if nuiFocused then setFocus(false) end
        targetMessage("target:visible", { state = false })
        targetMessage("target:left")
        current = { entity = 0, coords = vector3(0.0, 0.0, 0.0), distance = 0.0 }
        activeGroups, activeZones = {}, {}
        renderNearby, renderHasOptions = {}, false
        lastSignature = nil
    end)
end

RegisterNUICallback("target:select", function(data, cb)
    cb(1)
    if not state.active or type(data) ~= "table" then return end

    local zone = data.zoneIndex and activeZones[tonumber(data.zoneIndex)] or nil
    local options = zone and zone.options or activeGroups[tonumber(data.groupIndex)]
    local option = options and options[tonumber(data.optionIndex)]
    if not option then return end

    if option.openMenu then
        if option.name == "pr_bridge:target:back" then
            currentMenu = table.remove(menuHistory)
        else
            menuHistory[#menuHistory + 1] = currentMenu
            currentMenu = option.openMenu ~= "home" and option.openMenu or nil
        end
        lastSignature = nil
        setFocus(false)
        return
    end

    stopTargeting()
    dispatch(option, zone)
end)

RegisterNUICallback("target:closeFocus", function(_, cb)
    cb(1)
    setFocus(false)
end)

AddEventHandler("pr_bridge:target:stateChanged", function()
    if state.disabled and state.active then stopTargeting() end
end)

local bind = Bridge.addKeybind({
    name = "pr_bridge_native_target",
    defaultKey = GetConvar("pr_bridge:target:defaultHotkey", "RMENU"),
    defaultMapper = "keyboard",
    description = "Target",
    onPressed = function()
        if toggleHotkey and state.active then stopTargeting() else startTargeting() end
    end,
    onReleased = function()
        if not toggleHotkey then stopTargeting() end
    end,
})

if not bind then
    print("^1[pr_bridge:target] Falha ao registrar o keybind do target nativo.^0")
else
    print("^2[pr_bridge:target] Runtime nativo ativo; keybind '(pr_bridge) Target' registrado.^0")
end

AddEventHandler("onResourceStop", function(resource)
    if resource ~= GetCurrentResourceName() then return end
    if bind and bind.destroy then bind:destroy() end
    setActive(false)
end)
