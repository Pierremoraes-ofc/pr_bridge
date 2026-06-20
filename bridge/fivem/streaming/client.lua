local streaming = {}

local function debug(level, message)
    local debugApi = Bridge and Bridge.debug
    if not debugApi then return end

    local fn = debugApi[level]
    if type(fn) == "function" then
        fn(message)
    elseif type(debugApi) == "function" then
        debugApi(level, message)
    end
end

local function hash(value)
    if type(value) == "number" then return value end
    if type(value) == "string" then return joaat(value) end
    return nil
end

local function waitUntil(predicate, timeout)
    local expires = GetGameTimer() + (timeout or 5000)

    repeat
        if predicate() then return true end
        Wait(0)
    until GetGameTimer() >= expires

    return predicate() == true
end

local modelDimensionsCache = {}

function streaming.requestModel(model, timeout)
    local modelHash = hash(model)
    if not modelHash or not IsModelInCdimage(modelHash) then
        debug("warn", ("[pr_bridge] Model invalido: %s"):format(tostring(model)))
        return false, modelHash
    end

    if HasModelLoaded(modelHash) then return true, modelHash end

    RequestModel(modelHash)

    local loaded = waitUntil(function()
        return HasModelLoaded(modelHash)
    end, timeout)

    if not loaded then
        debug("warn", ("[pr_bridge] Timeout ao carregar model: %s"):format(tostring(model)))
    end

    return loaded, modelHash
end

function streaming.releaseModel(model)
    local modelHash = hash(model)
    if modelHash then SetModelAsNoLongerNeeded(modelHash) end
end

function streaming.getModelDimensions(model, timeout)
    local modelHash = hash(model)
    if not modelHash then return nil, nil, nil end

    local cached = modelDimensionsCache[modelHash]
    if cached then return cached.min, cached.max, modelHash end

    local loaded = HasModelLoaded(modelHash)
    if not loaded then
        loaded = streaming.requestModel(modelHash, timeout or 2000)
    end

    if not loaded then return nil, nil, modelHash end

    local ok, minDim, maxDim = pcall(function()
        return GetModelDimensions(modelHash)
    end)

    if not ok or not minDim or not maxDim then
        debug("warn", ("[pr_bridge] Falha ao ler dimensoes do model: %s"):format(tostring(model)))
        return nil, nil, modelHash
    end

    modelDimensionsCache[modelHash] = {
        min = minDim,
        max = maxDim,
    }

    return minDim, maxDim, modelHash
end

function streaming.getModelGroundOffset(model, timeout)
    local minDim = streaming.getModelDimensions(model, timeout)
    if not minDim then return 0.0 end

    return math.max(0.0, -(tonumber(minDim.z) or 0.0))
end

function streaming.requestAnimDict(animDict, timeout)
    if type(animDict) ~= "string" or animDict == "" then return false end
    if HasAnimDictLoaded(animDict) then return true end

    RequestAnimDict(animDict)

    local loaded = waitUntil(function()
        return HasAnimDictLoaded(animDict)
    end, timeout)

    if not loaded then
        debug("warn", ("[pr_bridge] Timeout ao carregar animDict: %s"):format(animDict))
    end

    return loaded
end

function streaming.releaseAnimDict(animDict)
    if type(animDict) == "string" and animDict ~= "" then
        RemoveAnimDict(animDict)
    end
end

function streaming.requestWeaponAsset(model, timeout)
    local weaponHash = hash(model)
    if not weaponHash then return false, nil end
    if HasWeaponAssetLoaded(weaponHash) then return true, weaponHash end

    RequestWeaponAsset(weaponHash, 31, 0)

    local loaded = waitUntil(function()
        return HasWeaponAssetLoaded(weaponHash)
    end, timeout)

    if not loaded then
        debug("warn", ("[pr_bridge] Timeout ao carregar weapon asset: %s"):format(tostring(model)))
    end

    return loaded, weaponHash
end

function streaming.releaseWeaponAsset(model)
    local weaponHash = hash(model)
    if weaponHash then RemoveWeaponAsset(weaponHash) end
end

local function coordsOf(coords)
    if coords then return coords end

    local ped = PlayerPedId()
    return ped and DoesEntityExist(ped) and GetEntityCoords(ped) or vector3(0.0, 0.0, 0.0)
end

function streaming.findGroundZ(coords, options)
    coords = coordsOf(coords)
    options = options or {}

    local startOffset = tonumber(options.startOffset) or 60.0
    local endOffset = tonumber(options.endOffset) or -160.0
    local fallbackOffset = tonumber(options.fallbackOffset) or 1000.0
    local flags = tonumber(options.flags) or 1
    local ignoreEntity = options.ignoreEntity
    if ignoreEntity == nil then ignoreEntity = -1 end

    local rayHandle = StartShapeTestRay(
        coords.x,
        coords.y,
        coords.z + startOffset,
        coords.x,
        coords.y,
        coords.z + endOffset,
        flags,
        ignoreEntity,
        0
    )

    local _, hit, endCoords = GetShapeTestResult(rayHandle)
    if hit == 1 or hit == true then
        return endCoords.z, endCoords, true
    end

    local found, groundZ = GetGroundZFor_3dCoord(
        coords.x,
        coords.y,
        coords.z + fallbackOffset,
        options.includeWater == true
    )

    if found then
        return groundZ, vector3(coords.x, coords.y, groundZ), false
    end

    return coords.z, coords, false
end

local function safeCall(label, fn)
    local ok, result, extra = pcall(fn)
    if not ok then
        debug("warn", ("[pr_bridge] streaming.%s falhou: %s"):format(label, tostring(result)))
        return nil, extra
    end

    return result, extra
end

function streaming.configureEntity(entity, options)
    if not entity or entity == 0 or not DoesEntityExist(entity) then return false end

    options = options or {}

    safeCall("configureEntity:mission", function()
        if options.missionEntity ~= false then
            SetEntityAsMissionEntity(entity, true, true)
        end
    end)

    safeCall("configureEntity:alpha", function()
        if options.alpha then
            SetEntityAlpha(entity, tonumber(options.alpha) or 255, false)
        end
    end)

    safeCall("configureEntity:collision", function()
        if options.collision ~= nil then
            SetEntityCollision(entity, options.collision == true, options.keepPhysics == true)
        end
    end)

    safeCall("configureEntity:freeze", function()
        if options.freeze ~= nil then
            FreezeEntityPosition(entity, options.freeze == true)
        end
    end)

    safeCall("configureEntity:invincible", function()
        if options.invincible ~= nil then
            SetEntityInvincible(entity, options.invincible == true)
        end
    end)

    safeCall("configureEntity:visible", function()
        if options.visible ~= nil then
            SetEntityVisible(entity, options.visible == true, false)
        end
    end)

    safeCall("configureEntity:ped", function()
        if IsEntityAPed(entity) then
            SetBlockingOfNonTemporaryEvents(entity, options.blockingEvents ~= false)
        end
    end)

    return true
end

function streaming.placeEntityProperly(entity, placementType, options)
    if not entity or entity == 0 or not DoesEntityExist(entity) then return false end

    options = options or {}
    local restoreCollision = options.restoreCollision
    local restoreFreeze = options.restoreFreeze

    if restoreCollision ~= nil then
        safeCall("placeEntityProperly:collisionOn", function()
            SetEntityCollision(entity, true, false)
        end)
    end

    if restoreFreeze ~= nil then
        safeCall("placeEntityProperly:freezeOff", function()
            FreezeEntityPosition(entity, false)
        end)
    end

    local placed = false

    if placementType == "object" or placementType == "prop" then
        placed = safeCall("placeObjectProperly", function()
            if type(PlaceObjectOnGroundOrObjectProperly) == "function" then
                return PlaceObjectOnGroundOrObjectProperly(entity)
            end

            PlaceObjectOnGroundProperly(entity)
            return true
        end) == true
    elseif placementType == "vehicle" or placementType == "slots" then
        placed = safeCall("setVehicleOnGroundProperly", function()
            return SetVehicleOnGroundProperly(entity)
        end) == true
    end

    if restoreCollision ~= nil then
        safeCall("placeEntityProperly:collisionRestore", function()
            SetEntityCollision(entity, restoreCollision == true, false)
        end)
    end

    if restoreFreeze ~= nil then
        safeCall("placeEntityProperly:freezeRestore", function()
            FreezeEntityPosition(entity, restoreFreeze == true)
        end)
    end

    return placed
end

function streaming.setEntityTransform(entity, coords, heading, options)
    if not entity or entity == 0 or not DoesEntityExist(entity) or not coords then return false end

    options = options or {}

    safeCall("setEntityTransform:coords", function()
        if options.noOffset ~= false then
            SetEntityCoordsNoOffset(entity, coords.x, coords.y, coords.z, false, false, false)
        else
            SetEntityCoords(entity, coords.x, coords.y, coords.z, false, false, false, false)
        end
    end)

    if heading then
        safeCall("setEntityTransform:heading", function()
            SetEntityHeading(entity, heading)
        end)
    end

    if options.placeProperly then
        streaming.placeEntityProperly(entity, options.placementType, {
            restoreCollision = options.restoreCollision,
            restoreFreeze = options.restoreFreeze,
        })
    end

    return true
end

function streaming.deleteEntity(entity)
    if not entity or entity == 0 or not DoesEntityExist(entity) then return false end

    local deleted = safeCall("deleteEntity", function()
        SetEntityAsMissionEntity(entity, true, true)
        DeleteEntity(entity)
        return not DoesEntityExist(entity)
    end)

    return deleted == true or not DoesEntityExist(entity)
end

local function loadForCreate(model, timeout)
    local loaded, modelHash = safeCall("requestModel", function()
        return streaming.requestModel(model, timeout)
    end)

    if not loaded then return false, modelHash end
    return true, modelHash
end

local function finishCreatedEntity(entity, modelHash, options)
    if entity and entity ~= 0 then
        streaming.configureEntity(entity, options)
        if options.placeProperly then
            streaming.placeEntityProperly(entity, options.placementType, {
                restoreCollision = options.collision,
                restoreFreeze = options.freeze,
            })
        end
    end

    if options.releaseModel ~= false then
        streaming.releaseModel(modelHash)
    end

    return entity
end

function streaming.createObject(model, coords, options)
    options = options or {}
    coords = coordsOf(coords)

    local loaded, modelHash = loadForCreate(model, options.timeout or options.modelTimeout)
    if not loaded then return nil, modelHash end

    local entity = safeCall("createObject", function()
        local creator = options.noOffset == false and CreateObject or CreateObjectNoOffset
        return creator(modelHash, coords.x, coords.y, coords.z, options.networked == true, options.missionEntity ~= false, options.doorFlag == true)
    end)

    return finishCreatedEntity(entity, modelHash, options), modelHash
end

function streaming.createPed(model, coords, heading, options)
    options = options or {}
    coords = coordsOf(coords)

    local loaded, modelHash = loadForCreate(model, options.timeout or options.modelTimeout)
    if not loaded then return nil, modelHash end

    local entity = safeCall("createPed", function()
        return CreatePed(options.pedType or 4, modelHash, coords.x, coords.y, coords.z, heading or 0.0, options.networked == true, options.scriptHostPed == true)
    end)

    return finishCreatedEntity(entity, modelHash, options), modelHash
end

function streaming.createVehicle(model, coords, heading, options)
    options = options or {}
    coords = coordsOf(coords)

    local loaded, modelHash = loadForCreate(model, options.timeout or options.modelTimeout)
    if not loaded then return nil, modelHash end

    local entity = safeCall("createVehicle", function()
        return CreateVehicle(modelHash, coords.x, coords.y, coords.z, heading or 0.0, options.networked == true, options.missionEntity ~= false)
    end)

    return finishCreatedEntity(entity, modelHash, options), modelHash
end

function streaming.createEntity(placementType, model, coords, heading, options)
    if placementType == "vehicle" or placementType == "slots" then
        return streaming.createVehicle(model, coords, heading, options)
    end

    if placementType == "ped" or placementType == "npc" or placementType == "cloneped" then
        return streaming.createPed(model, coords, heading, options)
    end

    return streaming.createObject(model, coords, options)
end

local vehicleAnchorAliases = {
    bonnet = "hood",
    front = "hood",
    engine = "hood",
    boot = "trunk",
    rear = "trunk",
    back = "trunk",
    driver = "driverDoor",
    driver_door = "driverDoor",
    driverDoor = "driverDoor",
    passenger = "passengerDoor",
    passenger_door = "passengerDoor",
    passengerDoor = "passengerDoor",
    driverRearDoor = "driverRearDoor",
    driver_rear_door = "driverRearDoor",
    passengerRearDoor = "passengerRearDoor",
    passenger_rear_door = "passengerRearDoor",
}

local vehicleAnchorBones = {
    hood = "bonnet",
    trunk = "boot",
    driverDoor = "door_dside_f",
    passengerDoor = "door_pside_f",
    driverRearDoor = "door_dside_r",
    passengerRearDoor = "door_pside_r",
}

local function vec3(value)
    if not value then return nil end
    if type(value) == "vector3" then return value end
    if type(value) == "vector4" then return vector3(value.x, value.y, value.z) end
    if type(value) == "table" then
        local x = value.x or value[1]
        local y = value.y or value[2]
        local z = value.z or value[3]
        if x and y and z then return vector3(x + 0.0, y + 0.0, z + 0.0) end
    end

    return nil
end

local function addVec3(a, b)
    if not b then return a end
    return vector3(a.x + b.x, a.y + b.y, a.z + b.z)
end

local function getHeadingToCoords(fromCoords, toCoords)
    return GetHeadingFromVector_2d(toCoords.x - fromCoords.x, toCoords.y - fromCoords.y)
end

local function inferEntityType(entity)
    if not entity or entity == 0 or not DoesEntityExist(entity) then return nil end
    if IsEntityAVehicle(entity) then return "vehicle" end
    if IsEntityAPed(entity) then return IsPedAPlayer(entity) and "player" or "ped" end
    if IsEntityAnObject(entity) then return "object" end
    return "entity"
end

local function resolveInteractionTarget(data)
    local targetType = data.type or data.targetType or data.interactionType or data.withType
    local target = data.target or data.entity or data.vehicle or data.object or data.ped or data.player or data.pickup or data.with

    if targetType == "player" then
        if data.serverId then
            target = GetPlayerPed(GetPlayerFromServerId(data.serverId))
        elseif target and not DoesEntityExist(target) then
            target = GetPlayerPed(target)
        elseif not target then
            target = PlayerPedId()
        end
    elseif not target and targetType == "ped" then
        target = PlayerPedId()
    end

    if targetType == "pickup" then
        return target, targetType
    end

    if target and target ~= 0 and DoesEntityExist(target) then
        return target, targetType or inferEntityType(target)
    end

    return nil, targetType
end

local function getVehicleAnchorOffset(entity, anchor, distance, zOffset)
    anchor = vehicleAnchorAliases[anchor] or anchor or "hood"

    local minDim, maxDim = streaming.getModelDimensions(GetEntityModel(entity), 1000)
    local minX = minDim and minDim.x or -1.0
    local maxX = maxDim and maxDim.x or 1.0
    local minY = minDim and minDim.y or -2.0
    local maxY = maxDim and maxDim.y or 2.0
    local midFrontY = maxY * 0.35
    local midRearY = minY * 0.35

    if anchor == "trunk" then return vector3(0.0, minY - distance, zOffset) end
    if anchor == "driverDoor" then return vector3(minX - distance, midFrontY, zOffset) end
    if anchor == "passengerDoor" then return vector3(maxX + distance, midFrontY, zOffset) end
    if anchor == "driverRearDoor" then return vector3(minX - distance, midRearY, zOffset) end
    if anchor == "passengerRearDoor" then return vector3(maxX + distance, midRearY, zOffset) end
    if anchor == "left" then return vector3(minX - distance, 0.0, zOffset) end
    if anchor == "right" then return vector3(maxX + distance, 0.0, zOffset) end
    if anchor == "center" then return vector3(0.0, 0.0, zOffset) end

    return vector3(0.0, maxY + distance, zOffset)
end

local function getEntityBoneCoords(entity, bone)
    if type(bone) ~= "string" or bone == "" then return nil end

    local boneIndex = GetEntityBoneIndexByName(entity, bone)
    if boneIndex == -1 then return nil end

    return GetWorldPositionOfEntityBone(entity, boneIndex)
end

local function getInteractionCoords(entity, entityType, position)
    position = position or {}

    local coords = vec3(position.coords or position.coord)
    local heading = tonumber(position.heading)
    local lookAtCoords

    if coords then
        return coords, heading, coords
    end

    if entityType == "pickup" and entity and DoesPickupExist(entity) then
        coords = GetPickupCoords(entity)
        coords = addVec3(coords, vec3(position.offset))
        return coords, heading, coords
    end

    if not entity or entity == 0 or not DoesEntityExist(entity) then
        return nil, nil, nil
    end

    local anchor = position.anchor or position.point or position.bone
    local distance = tonumber(position.distance or position.spacing) or 0.65
    local zOffset = tonumber(position.zOffset) or 0.0
    local offset = vec3(position.offset)

    lookAtCoords = GetEntityCoords(entity)

    if entityType == "vehicle" then
        local normalizedAnchor = vehicleAnchorAliases[anchor] or anchor
        local boneCoords = getEntityBoneCoords(entity, position.bone or vehicleAnchorBones[normalizedAnchor])
        if boneCoords then lookAtCoords = boneCoords end

        local localOffset = offset or getVehicleAnchorOffset(entity, normalizedAnchor, distance, zOffset)
        coords = GetOffsetFromEntityInWorldCoords(entity, localOffset.x, localOffset.y, localOffset.z)
    else
        local boneCoords = getEntityBoneCoords(entity, position.bone)
        if boneCoords then lookAtCoords = boneCoords end

        if offset then
            coords = GetOffsetFromEntityInWorldCoords(entity, offset.x, offset.y, offset.z)
        else
            coords = GetOffsetFromEntityInWorldCoords(entity, 0.0, -distance, zOffset)
        end
    end

    if position.ground == true or position.groundZ == true then
        local groundZ, groundCoords = streaming.findGroundZ(coords, {
            ignoreEntity = entity,
            includeWater = position.includeWater,
        })

        coords = groundCoords or vector3(coords.x, coords.y, groundZ)
    end

    if not heading and position.faceTarget ~= false then
        heading = getHeadingToCoords(coords, lookAtCoords)
    end

    return coords, heading, lookAtCoords
end

local function movePedToInteractionCoords(ped, coords, heading, position)
    position = position or {}
    if position.moveTo == false then
        if heading then SetEntityHeading(ped, heading) end
        return true, 0.0
    end

    local arriveDistance = tonumber(position.arriveDistance or position.radius) or 0.65
    local timeout = tonumber(position.timeout) or 4500
    local speed = tonumber(position.speed) or 1.0
    local distance = #(GetEntityCoords(ped) - coords)

    if distance > arriveDistance then
        local expires = GetGameTimer() + timeout
        TaskGoStraightToCoord(ped, coords.x, coords.y, coords.z, speed, timeout, heading or GetEntityHeading(ped), 0.15)

        while #(GetEntityCoords(ped) - coords) > arriveDistance and GetGameTimer() < expires do
            Wait(50)
        end
    end

    if position.clearBeforeAnim ~= false then
        ClearPedTasks(ped)
    end

    if heading then SetEntityHeading(ped, heading) end
    Wait(tonumber(position.settleTime) or 150)

    local finalDistance = #(GetEntityCoords(ped) - coords)
    local maxDistance = tonumber(position.maxDistance) or math.max(arriveDistance + 0.65, 1.25)

    return finalDistance <= maxDistance or position.continueOnMoveTimeout == true, finalDistance
end

local function normalizeList(value)
    if value == nil then return {} end
    if type(value) == "table" then return value end
    return { value }
end

local function setVehicleDoors(vehicle, doors, open, options)
    options = options or {}

    for _, door in pairs(normalizeList(doors)) do
        door = tonumber(door)
        if door then
            if open then
                SetVehicleDoorOpen(vehicle, door, options.loose == true, options.instantly == true)
            else
                SetVehicleDoorShut(vehicle, door, options.instantly == true)
            end
        end
    end
end

local function getVehicleInteractionOptions(data)
    local options = data.vehicleOptions or data.vehicleData or data.vehicleAction
    if type(options) == "table" then return options end

    if type(data.vehicle) == "table" then return data.vehicle end

    return {}
end

local function prepareInteractionTarget(entity, entityType, data)
    if entityType ~= "vehicle" or not entity or entity == 0 then return end

    local vehicleOptions = getVehicleInteractionOptions(data)
    local doors = vehicleOptions.doors or vehicleOptions.door
    if doors and vehicleOptions.openDoor ~= false then
        setVehicleDoors(entity, doors, true, vehicleOptions)
        Wait(tonumber(vehicleOptions.waitAfterOpen) or 0)
    end
end

local function cleanupInteractionTarget(entity, entityType, data)
    if entityType ~= "vehicle" or not entity or entity == 0 then return end

    local vehicleOptions = getVehicleInteractionOptions(data)
    local doors = vehicleOptions.doors or vehicleOptions.door
    if doors and vehicleOptions.closeDoor == true then
        setVehicleDoors(entity, doors, false, vehicleOptions)
    end
end

local function runInteractionCallback(callback, ...)
    if type(callback) ~= "function" then return true end

    local ok, result = pcall(callback, ...)
    if not ok then
        debug("warn", ("[pr_bridge] streaming.playInteraction callback falhou: %s"):format(tostring(result)))
        return false
    end

    return result ~= false
end

local function getAnimConfig(anim, fallbackDuration)
    if type(anim) ~= "table" then return false, "invalid_anim" end

    local dict = anim.dict or anim.animDict or anim.dictionary
    local clip = anim.clip or anim.name or anim.anim or anim.animName
    if not dict or not clip then return false, "missing_anim" end

    if not streaming.requestAnimDict(dict, anim.timeout or anim.dictTimeout or 5000) then
        return false, "anim_timeout"
    end

    return true, {
        dict = dict,
        clip = clip,
        duration = tonumber(anim.duration or fallbackDuration) or -1,
        flags = tonumber(anim.flags) or 0,
        blendIn = tonumber(anim.blendIn) or 8.0,
        blendOut = tonumber(anim.blendOut) or -8.0,
        playbackRate = tonumber(anim.playbackRate or anim.rate) or 0.0,
        lockX = anim.lockX == true,
        lockY = anim.lockY == true,
        lockZ = anim.lockZ == true,
    }
end

function streaming.playAnim(data, clip, duration, options)
    local anim
    local ped

    if type(data) == "table" then
        anim = data.anim or data.animation or data
        ped = data.pedEntity or data.actor or data.ped or PlayerPedId()
        duration = anim.duration or data.duration
    else
        options = options or {}
        anim = {
            dict = data,
            clip = clip,
            duration = duration,
            flags = options.flags,
            timeout = options.timeout,
            dictTimeout = options.dictTimeout,
            blendIn = options.blendIn,
            blendOut = options.blendOut,
            playbackRate = options.playbackRate,
            lockX = options.lockX,
            lockY = options.lockY,
            lockZ = options.lockZ,
        }
        ped = options.pedEntity or options.actor or options.ped or PlayerPedId()
    end

    if not ped or ped == 0 or not DoesEntityExist(ped) then return false, "invalid_ped" end

    local ok, cfg = getAnimConfig(anim, duration)
    if not ok then return false, cfg end

    TaskPlayAnim(
        ped,
        cfg.dict,
        cfg.clip,
        cfg.blendIn,
        cfg.blendOut,
        cfg.duration,
        cfg.flags,
        cfg.playbackRate,
        cfg.lockX,
        cfg.lockY,
        cfg.lockZ
    )

    if anim.wait ~= false and cfg.duration and cfg.duration > 0 then
        Wait(cfg.duration)
    end

    local cleanup = anim.cleanup or {}
    if cleanup.clearTasks == true or anim.clearTasks == true then
        ClearPedTasks(ped)
    end

    if anim.releaseDict == true then
        streaming.releaseAnimDict(cfg.dict)
    end

    return true, {
        ped = ped,
        dict = cfg.dict,
        clip = cfg.clip,
        duration = cfg.duration,
        flags = cfg.flags,
    }
end

local function playInteractionAnim(ped, anim, coords, heading, duration)
    if type(anim) ~= "table" then return false, "invalid_anim" end

    if anim.scenario then
        if anim.atPosition == true and coords then
            TaskStartScenarioAtPosition(ped, anim.scenario, coords.x, coords.y, coords.z, heading or GetEntityHeading(ped), duration or -1, anim.sitting == true, anim.teleport == true)
        else
            TaskStartScenarioInPlace(ped, anim.scenario, duration or -1, anim.playEnterAnim == true)
        end

        return true
    end

    local ok, cfg = getAnimConfig(anim, duration)
    if not ok then return false, cfg end

    if coords and anim.advanced ~= false then
        TaskPlayAnimAdvanced(
            ped,
            cfg.dict,
            cfg.clip,
            coords.x,
            coords.y,
            coords.z,
            tonumber(anim.rotX) or 0.0,
            tonumber(anim.rotY) or 0.0,
            tonumber(anim.rotZ or heading) or GetEntityHeading(ped),
            cfg.blendIn,
            cfg.blendOut,
            cfg.duration,
            cfg.flags,
            cfg.playbackRate,
            cfg.lockX,
            cfg.lockY,
            cfg.lockZ
        )
    else
        TaskPlayAnim(ped, cfg.dict, cfg.clip, cfg.blendIn, cfg.blendOut, cfg.duration, cfg.flags, cfg.playbackRate, cfg.lockX, cfg.lockY, cfg.lockZ)
    end

    return true
end

function streaming.playInteraction(data)
    if type(data) ~= "table" then return false, "invalid_data" end

    local ped = data.pedEntity or data.actor or PlayerPedId()
    if not ped or ped == 0 or not DoesEntityExist(ped) then return false, "invalid_ped" end

    local entity, entityType = resolveInteractionTarget(data)
    local anim = data.anim or data.animation or {}
    local position = data.position or data.coords or {}
    if type(position) ~= "table" then position = { coords = position } end

    local coords, heading = getInteractionCoords(entity, entityType, position)
    if not coords and not anim.scenario then return false, "missing_target_coords" end

    local duration = tonumber(anim.duration or data.duration) or -1

    if not runInteractionCallback(data.onBeforeMove, ped, entity, coords, heading, entityType) then
        return false, "before_move_cancelled"
    end

    if coords then
        local moved, finalDistance = movePedToInteractionCoords(ped, coords, heading, position)
        if not moved then
            return false, ("move_timeout:%.2f"):format(finalDistance or -1.0)
        end
    end

    if not runInteractionCallback(data.onBeforeStart, ped, entity, coords, heading, entityType) then
        return false, "before_start_cancelled"
    end

    prepareInteractionTarget(entity, entityType, data)

    local played, reason = playInteractionAnim(ped, anim, coords, heading, duration)
    if not played then
        cleanupInteractionTarget(entity, entityType, data)
        return false, reason
    end

    runInteractionCallback(data.onStart, ped, entity, coords, heading, entityType)

    if anim.wait ~= false and duration and duration > 0 then
        Wait(duration)
    end

    local cleanup = data.cleanup or {}
    if cleanup.clearTasks ~= false and duration and duration > 0 then
        ClearPedTasks(ped)
    end

    cleanupInteractionTarget(entity, entityType, data)
    runInteractionCallback(data.onFinish, ped, entity, coords, heading, entityType)

    return true, {
        entity = entity,
        type = entityType,
        coords = coords,
        heading = heading,
        duration = duration,
    }
end

streaming.loadModel = streaming.requestModel
streaming.loadAnimDict = streaming.requestAnimDict
streaming.loadWeaponAsset = streaming.requestWeaponAsset
streaming.createProp = streaming.createObject
streaming.delete = streaming.deleteEntity
streaming.playAnimation = streaming.playAnim
streaming.PlayAnim = streaming.playAnim
streaming.PlayAnimation = streaming.playAnim
streaming.performAction = streaming.playInteraction
streaming.playAction = streaming.playInteraction
streaming.PlayInteraction = streaming.playInteraction
streaming.PerformAction = streaming.playInteraction
streaming.PlayAction = streaming.playInteraction

return streaming
