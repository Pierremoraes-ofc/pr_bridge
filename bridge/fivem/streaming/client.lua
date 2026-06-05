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

streaming.loadModel = streaming.requestModel
streaming.loadAnimDict = streaming.requestAnimDict
streaming.loadWeaponAsset = streaming.requestWeaponAsset
streaming.createProp = streaming.createObject
streaming.delete = streaming.deleteEntity

return streaming
