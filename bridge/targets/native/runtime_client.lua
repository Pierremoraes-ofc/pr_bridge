if ActiveBridges["target"] ~= "native" then return end

local api = PRCore.load("bridge.targets.native.api")
local Zones = api._zones()
local Pickups = PRCore.load("bridge.targets.native.pickups")
local collections = api._collections()
local state = api._state()

local current = { entity = 0, pickup = nil, pickupType = nil, model = nil, coords = vector3(0.0, 0.0, 0.0), distance = 0.0 }
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
local sessionGeneration = 0
local lastMarkerCount, lastMarkerAt = 0, 0
local visibility = {}
local function entityTypeOf(entity)
    if type(entity) ~= "number" or entity <= 0 or not DoesEntityExist(entity) then return 0 end
    local ok, entityType = pcall(GetEntityType, entity)
    entityType = ok and tonumber(entityType) or 0
    return entityType and entityType > 0 and entityType or 0
end

local function hasKeyedOptions(collection)
    for _, options in pairs(collection or {}) do
        if type(options) == "table" and #options > 0 then return true end
    end
    return false
end

local function pickupDiscoveryNeeded()
    return #collections.pickupsGlobal > 0 or hasKeyedOptions(collections.pickupTypes)
end

local function pickupTrackingNeeded()
    return pickupDiscoveryNeeded() or hasKeyedOptions(collections.pickups)
end
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
    value = value == true
    -- A late target close must not release the UI opened by the selected action.
    if nuiFocused == value then return end
    nuiFocused = value
    if nuiFocused then SetCursorLocation(0.5, 0.5) end
    SetNuiFocus(nuiFocused, nuiFocused)
    SetNuiFocusKeepInput(nuiFocused)
end

local function setActive(value)
    value = value == true and not state.disabled
    if state.active == value then return end
    sessionGeneration = sessionGeneration + 1
    state.active = value
    targetMessage("target:visible", { state = value })
    if not value then
        setFocus(false)
        markerEntities, markerZones, visibility = {}, {}, {}
        activeGroups, activeZones = {}, {}
        renderNearby, renderHasOptions = {}, false
        targetMessage("target:markers", { markers = {} })
        targetMessage("target:left")
    end
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

local function markerWorldPoint(entity)
    local model = GetEntityModel(entity)
    local offset = markerModelOffsets[model]
    if not offset then
        local minimum, maximum = GetModelDimensions(model)
        offset = (minimum + maximum) * 0.5
        markerModelOffsets[model] = offset
    end
    return GetOffsetFromEntityInWorldCoords(entity, offset.x, offset.y, offset.z)
end

-- The same probes gate markers, options and dispatch. Never move zone coordinates
-- toward the viewer: doing so can move a wall-mounted target through its wall.
-- Coordinate targets are often placed exactly on a wall/furniture surface by
-- the placement laser. Hitting that endpoint is not a wall BEFORE the target.
-- Never use zone size/contains here: job boxes can straddle an entire wall.
local function reachesTargetSurface(zone, endpoint, hitCoords)
    return zone ~= nil and hitCoords ~= nil and #(hitCoords - endpoint) <= 0.025
end

local function visibilitySettings()
    local config = (GlobalState.pr_bridge_ui_config or {}).target or {}
    return config.wallDetection ~= false,
        math.max(1, math.min(511, math.floor(tonumber(config.wallRayFlags) or 277))) & ~12
end

-- This check must finish in the same tick. The client capture showed only
-- invalid asynchronous handles (no clear/blocked results), suppressing all UI.
-- Keep synchronous probes bounded: two background checks per update, plus the
-- explicit user click. Do not relax collision flags on a failed native result.
local function probeVisibility(entity, zone, flags)
    if not zone and (not entity or entity == 0 or not DoesEntityExist(entity)) then return 'blocked' end
    local point = zone and zone.coords or markerWorldPoint(entity)
    local ped = PlayerPedId()
    local origin = GetPedBoneCoords(ped, 31086, 0.0, 0.0, 0.0)
    local handle = StartExpensiveSynchronousShapeTestLosProbe(
        origin.x, origin.y, origin.z, point.x, point.y, point.z, flags, ped, 4)
    local status, hit, hitCoords, _, hitEntity = GetShapeTestResult(handle)
    if status ~= 2 then return 'invalid', status end
    return (hit == false or hit == 0 or (not zone and hitEntity == entity)
        or reachesTargetSurface(zone, point, hitCoords)) and 'clear' or 'blocked', status
end

local function updateVisibility()
    local enabled, flags = visibilitySettings()
    if not enabled then return end
    local now, waiting = GetGameTimer(), {}
    for key, entry in pairs(visibility) do
        if now - entry.requested > 1000 then
            visibility[key] = nil
        else
            if entry.flags ~= flags then
                entry.allowed, entry.confirmed, entry.nextProbe = false, nil, 0
                entry.flags = flags
            end
            if now >= (entry.nextProbe or 0) then waiting[#waiting + 1] = entry end
        end
    end
    table.sort(waiting, function(a, b) return (a.nextProbe or 0) < (b.nextProbe or 0) end)
    for i = 1, math.min(2, #waiting) do
        local entry = waiting[i]
        local result, status = probeVisibility(entry.entity, entry.zone, flags)
        entry.result, entry.nativeStatus, entry.nextProbe = result, status, now + 100
        if result ~= 'invalid' then
            entry.allowed, entry.confirmed = result == 'clear', now
        end
    end
end

local function targetVisible(entity, zone, fresh)
    local enabled, flags = visibilitySettings()
    if not enabled then return true end
    if not zone and (not entity or entity == 0 or not DoesEntityExist(entity)) then return false end
    if fresh then return probeVisibility(entity, zone, flags) == 'clear' end
    local key, now = zone or entity, GetGameTimer()
    local entry = visibility[key]
    if not entry then
        entry = { entity = entity, zone = zone, flags = flags }
        visibility[key] = entry
    end
    entry.requested = now
    return entry.flags == flags and entry.allowed == true and entry.confirmed ~= nil
        and now - entry.confirmed <= 1000
end

local function collectEntityGroups(entity, entityType, model, distance, pickupRecord)
    activeGroups = {}
    local output = {}
    if currentMenu then
        backOptions[1].menuName = currentMenu
        addVisibleGroup(output, "back", backOptions, 0.0, entity, model)
    end
    addVisibleGroup(output, "global", collections.global, distance, entity, model)
    if entity and entity > 0 and entityType > 0 and targetVisible(entity) then
        local global = entityType == 1 and (IsPedAPlayer(entity) and collections.players or collections.peds)
            or entityType == 2 and collections.vehicles or collections.objects
        addVisibleGroup(output, "type", global, distance, entity, model)
        if pickupRecord then
            addVisibleGroup(output, "globalPickup", collections.pickupsGlobal, distance, entity, model)
        end
        addVisibleGroup(output, "model", collections.models[model], distance, entity, model)
        if pickupRecord then
            addVisibleGroup(output, "pickupType", collections.pickupTypes[pickupRecord.pickupType], distance, entity, model)
            addVisibleGroup(output, "pickup", collections.pickups[pickupRecord.key or pickupRecord.pickup], distance, entity, model)
        end
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
        if zone:contains(endCoords) and targetVisible(nil, zone) then
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
        return ok and not not allowed
    end
    return true
end

local function refreshMarkerEntities(playerCoords, markerDistance, targetConfig)
    markerEntities = {}
    if drawSpriteLimit == 0 then return end
    local candidates, seen, pickupEntities = {}, {}, {}
    for _, record in pairs(Pickups.list()) do
        if not record.pending and record.entity and record.entity > 0 then
            pickupEntities[record.entity] = record
        end
    end
    local ped = PlayerPedId()
    local function consider(entity)
        if seen[entity] or entity == ped or not DoesEntityExist(entity) then return end
        seen[entity] = true
        local coords = GetEntityCoords(entity)
        local distance = #(playerCoords - coords)
        if distance > markerDistance then return end
        local kind, model = entityTypeOf(entity), GetEntityModel(entity)
        local record = pickupEntities[entity]
        local netId = NetworkGetEntityIsNetworked(entity) and NetworkGetNetworkIdFromEntity(entity)
        local lists = {}
        local function add(options) if options then lists[#lists + 1] = options end end
        add(kind == 1 and (IsPedAPlayer(entity) and collections.players or collections.peds)
            or kind == 2 and collections.vehicles or collections.objects)
        add(collections.models[model])
        add(collections.localEntities[entity])
        add(netId and collections.entities[netId])
        if record then
            add(collections.pickupsGlobal)
            add(collections.pickupTypes[record.pickupType])
            add(collections.pickups[record.key or record.pickup])
        end
        for _, options in ipairs(lists) do
            for _, option in ipairs(options) do
                if markerOptionAllowed(option, entity, distance, coords) then
                    candidates[#candidates + 1] = { entity = entity, distance = distance }
                    return
                end
            end
        end
    end
    for _, pool in ipairs({ 'CObject', 'CPed', 'CVehicle' }) do
        for _, entity in ipairs(GetGamePool(pool)) do consider(entity) end
    end
    for entity in pairs(pickupEntities) do consider(entity) end
    table.sort(candidates, function(a, b)
        return a.distance == b.distance and a.entity < b.entity or a.distance < b.distance
    end)
    local scanLimit = math.min(#candidates, math.max(32, drawSpriteLimit * 3))
    for i = 1, scanLimit do markerEntities[i] = candidates[i].entity end
end

local function refreshMarkerZones(playerCoords, markerDistance, targetConfig)
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
    for _, candidate in ipairs(candidates) do markerZones[#markerZones + 1] = candidate.zone end
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
        if DoesEntityExist(entity) and targetVisible(entity) then
            local coords = GetEntityCoords(entity)
            if #(playerCoords - coords) <= markerDistance then
                local point = markerWorldPoint(entity)
                local visible, screenX, screenY = GetScreenCoordFromWorldCoord(point.x, point.y, point.z)
                if visible and #markers < drawSpriteLimit then
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
        if (#(playerCoords - coords) <= markerDistance or zone:contains(playerCoords)) and targetVisible(nil, zone) then
            local visible, screenX, screenY = GetScreenCoordFromWorldCoord(coords.x, coords.y, coords.z)
            if visible and #markers < drawSpriteLimit then
                markers[#markers + 1] = {
                    id = ("zone:%s"):format(zone.id), x = screenX, y = screenY,
                    targeted = targetedZones[zone.id] == true,
                }
            end
        end
    end
    lastMarkerCount, lastMarkerAt = #markers, GetGameTimer()
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
    output.pickup = current.pickup
    output.pickupType = current.pickupType
    output.model = current.model
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
    local session = sessionGeneration
    lastSignature = nil
    currentMenu = nil
    menuHistory = {}

    renderNearby, renderHasOptions = {}, false
    if pickupTrackingNeeded() then Pickups.refresh(pickupDiscoveryNeeded(), collections.pickupTypes) end
    CreateThread(function()
        while state.active and sessionGeneration == session do
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
        local nextMarkerScan, nextPickupScan = 0, 0
        while state.active and sessionGeneration == session do
            local playerCoords = GetEntityCoords(PlayerPedId())
            local config = GlobalState.pr_bridge_ui_config or {}
            local targetConfig = config.target or {}
            local markerDistance = tonumber(targetConfig.markerDistance) or 5.0
            local now = GetGameTimer()
            if now >= nextPickupScan and pickupTrackingNeeded() then
                Pickups.refresh(pickupDiscoveryNeeded(), collections.pickupTypes)
                nextPickupScan = now + 750
            end
            if now >= nextMarkerScan then
                refreshMarkerEntities(playerCoords, markerDistance, targetConfig)
                refreshMarkerZones(playerCoords, markerDistance, targetConfig)
                nextMarkerScan = now + 500
            end
            updateVisibility()
            sendScreenMarkers(playerCoords, markerDistance)
            Wait(markerUpdateInterval)
        end
        if sessionGeneration ~= session then return end
        markerEntities = {}
        markerZones = {}
        visibility = {}
        targetMessage("target:markers", { markers = {} })
    end)

    CreateThread(function()
        local flag = 511
        local lastEntity = 0
        while state.active and sessionGeneration == session do
            local ped = PlayerPedId()
            local playerCoords = GetEntityCoords(ped)
            flag = 511 -- A sondagem principal sempre inclui paredes, mesmo apos um fallback.
            local hit, entity, endCoords, distance
            local entityType, model = 0, nil
            local pickupRecord
            if nuiFocused then
                hit, entity, endCoords = true, current.entity, current.coords
                distance = #(playerCoords - endCoords)
                entityType, model = entityTypeOf(entity), current.model
                if current.pickup then
                    pickupRecord = { pickup = current.pickup, pickupType = current.pickupType,
                        entity = entity, entityType = entityType, model = model, coords = endCoords }
                end
            else
                hit, entity, endCoords = Bridge.raycast.fromCamera(20.0, flag, 4, ped)
                entity = entity or 0
                endCoords = endCoords or (playerCoords + GetEntityForwardVector(ped) * 20.0)
                distance = #(playerCoords - endCoords)
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


                if pickupTrackingNeeded() then
                    pickupRecord = Pickups.resolveHit(entity, endCoords, collections.pickupTypes, collections.pickups)
                end
                if pickupRecord and not pickupRecord.pending and pickupRecord.entity > 0 then
                    entity = pickupRecord.entity
                    endCoords = pickupRecord.coords or endCoords
                    distance = #(playerCoords - endCoords)
                    entityType = pickupRecord.entityType or 3
                    model = pickupRecord.model
                elseif entity > 0 then
                    entityType = entityTypeOf(entity)
                    if entityType > 0 then
                        local okModel, resultModel = pcall(GetEntityModel, entity)
                        model = okModel and resultModel or nil
                    else
                        entity = 0
                    end
                end

                if entityType > 0 and entity > 0 and DoesEntityExist(entity) and flag ~= 511 and not HasEntityClearLosToEntity(entity, ped, 7) then
                    entity = 0
                    pickupRecord = nil
                end

            end

            if sessionGeneration ~= session then return end
            current.entity, current.pickup, current.pickupType, current.model = entity,
                pickupRecord and pickupRecord.pickup or nil,
                pickupRecord and pickupRecord.pickupType or nil,
                model
            current.coords, current.distance = endCoords, distance
            local groups = collectEntityGroups(entity, entityType, model, distance, pickupRecord)
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
            Wait(hit and 40 or 80)
        end

        if sessionGeneration ~= session then return end
        if nuiFocused then setFocus(false) end
        targetMessage("target:visible", { state = false })
        targetMessage("target:left")
        current = { entity = 0, pickup = nil, pickupType = nil, model = nil, coords = vector3(0.0, 0.0, 0.0), distance = 0.0 }
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
    if not option or (zone and Zones.get(zone.id) ~= zone) then return end

    local selectedEntity, selectedSession = current.entity, sessionGeneration
    -- Recheck after the menu was opened (doors/player/camera can have moved).
    if zone or (current.entity and current.entity > 0) then
        if not targetVisible(current.entity, zone, true) then
            lastSignature = nil
            setFocus(false)
            return
        end
    end
    if not state.active or sessionGeneration ~= selectedSession or current.entity ~= selectedEntity then return end
    if zone and (Zones.get(zone.id) ~= zone or activeZones[tonumber(data.zoneIndex)] ~= zone) then return end
    if not zone then
        local selectedOptions = activeGroups[tonumber(data.groupIndex)]
        if not selectedOptions or selectedOptions[tonumber(data.optionIndex)] ~= option then return end
    end
    local coords = zone and zone.coords or current.coords
    local distance = #(GetEntityCoords(PlayerPedId()) - coords)
    if not shouldShow(option, distance, coords, current.entity, zone and nil or current.model) then return end

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
    if state.disabled then stopTargeting() end
end)

-- Opt-in capture for client-native failures that cannot be reproduced outside
-- FiveM. One summary only; normal targeting never spams the console.
if Bridge.addCommand then
    Bridge.addCommand('pr_targetdiag', { help = 'Captura o target por 5 segundos; mantenha ALT pressionado.' }, function()
        CreateThread(function()
            local samples, active, rendered, clear, blocked, invalid, pending = 0, 0, 0, 0, 0, 0, 0
            local expires = GetGameTimer() + 5000
            while GetGameTimer() < expires do
                samples = samples + 1
                if state.active then active = active + 1 end
                if state.active and GetGameTimer() - lastMarkerAt < 250 then rendered = math.max(rendered, lastMarkerCount) end
                for _, entry in pairs(visibility) do
                    if not entry.result then pending = pending + 1 end
                    if entry.result == 'clear' then clear = clear + 1
                    elseif entry.result == 'blocked' then blocked = blocked + 1
                    elseif entry.result == 'invalid' then invalid = invalid + 1 end
                end
                Wait(100)
            end
            local nearby = Zones.getNearby(GetEntityCoords(PlayerPedId()))
            print(('[pr_bridge:target:diag] mode=sync samples=%s active=%s zonesNearby=%s entityCandidates=%s zoneCandidates=%s maxRendered=%s clear=%s blocked=%s invalid=%s pending=%s'):format(
                samples, active, #nearby, #markerEntities, #markerZones, rendered, clear, blocked, invalid, pending))
        end)
    end)
end

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
