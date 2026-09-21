local singletonKey = "__pr_bridge_native_target_pickups"
local existing = rawget(_G, singletonKey)
if existing then return existing end

local pickups = {}
local byPickup = {}
local byObject = {}
local traceHistory = {}
local traceCount = 0

local function trace(stage, handle, details)
    if GetConvarInt("pr_bridge:target:pickupDebug", 0) ~= 1 then return end
    if traceCount >= 256 then return end
    local message = ("stage=%s handle=%s %s"):format(stage, tostring(handle), details or "")
    if traceHistory[message] then return end
    traceHistory[message] = true
    traceCount = traceCount + 1
    print(("^3[pr_bridge:target:pickup] %s^0"):format(message))
end

local function nativeBoolean(callback, ...)
    if type(callback) ~= "function" then return false end
    local ok, result = pcall(callback, ...)
    if not ok then return false end
    if type(result) == "number" then return result ~= 0 end
    return result == true
end

local function invokeInteger(hash, ...)
    if not Citizen or type(Citizen.InvokeNative) ~= "function"
        or type(Citizen.ResultAsInteger) ~= "function" then return nil end

    local arguments = table.pack(...)
    arguments.n = arguments.n + 1
    arguments[arguments.n] = Citizen.ResultAsInteger()
    local ok, result = pcall(Citizen.InvokeNative, hash, table.unpack(arguments, 1, arguments.n))
    return ok and tonumber(result) or nil
end

local function invokeVector(hash, ...)
    if not Citizen or type(Citizen.InvokeNative) ~= "function"
        or type(Citizen.ResultAsVector) ~= "function" then return nil end

    local arguments = table.pack(...)
    arguments.n = arguments.n + 1
    arguments[arguments.n] = Citizen.ResultAsVector()
    local ok, result = pcall(Citizen.InvokeNative, hash, table.unpack(arguments, 1, arguments.n))
    return ok and result or nil
end

local function pickupExists(handle)
    if type(handle) ~= "number" or handle <= 0 then return false end
    local named = nativeBoolean(DoesPickupExist, handle)
    trace("exists:named", handle, ("result=%s"):format(tostring(named)))
    if named then return true end

    local rawResult = invokeInteger(0xAFC1CA75AD4074D1, handle)
    trace("exists:typed", handle, ("result=%s"):format(tostring(rawResult)))
    if rawResult ~= nil then return rawResult ~= 0 end

    return false
end

local function validEntity(entity)
    if type(entity) ~= "number" or entity <= 0 or not nativeBoolean(DoesEntityExist, entity) then return false end
    local ok, entityType = pcall(GetEntityType, entity)
    return ok and tonumber(entityType) and entityType > 0
end

local function entityData(entity)
    if not validEntity(entity) then return nil end
    local typeOk, entityType = pcall(GetEntityType, entity)
    local modelOk, model = pcall(GetEntityModel, entity)
    local coordsOk, coords = pcall(GetEntityCoords, entity)
    return {
        entity = entity,
        entityType = typeOk and tonumber(entityType) or 3,
        model = modelOk and tonumber(model) ~= 0 and tonumber(model) or nil,
        coords = coordsOk and coords or nil,
    }
end

local function pickupObject(handle)
    local ok, object
    if type(GetPickupObject) == "function" then
        ok, object = pcall(GetPickupObject, handle)
        object = ok and tonumber(object) or 0
        trace("object:named", handle, ("result=%s valid=%s"):format(tostring(object), tostring(validEntity(object))))
        if validEntity(object) then return object end
    end

    object = invokeInteger(0x5099BC55630B25AE, handle) or 0
    trace("object:typed", handle, ("result=%s valid=%s"):format(tostring(object), tostring(validEntity(object))))
    if validEntity(object) then return object end

    return 0
end

local function pickupCoords(handle, object)
    local data = entityData(object)
    if data then return data.coords end

    local ok, coords
    if type(GetPickupCoords) == "function" then
        ok, coords = pcall(GetPickupCoords, handle)
        if ok and coords then return coords end
    end

    coords = invokeVector(0x225B8B35C88029B3, handle)
    if coords then return coords end
end

local function pickupType(handle)
    local ok, value
    if type(GetPickupHash) == "function" then
        ok, value = pcall(GetPickupHash, handle)
        value = ok and tonumber(value) or nil
        if value and value ~= 0 then return value end
    end

    value = invokeInteger(0x5EAAD83F8CFB4575, handle)
    if value and value ~= 0 then return value end
end

local function inferWeaponPickupType(model, knownTypes)
    if not model or type(knownTypes) ~= "table" or type(GetWeaponTypeFromPickupType) ~= "function"
        or type(GetWeapontypeModel) ~= "function" then return nil end

    for candidate, options in pairs(knownTypes) do
        if type(options) == "table" and #options > 0 then
            local weaponOk, weapon = pcall(GetWeaponTypeFromPickupType, candidate)
            local modelOk, weaponModel = false, nil
            if weaponOk then modelOk, weaponModel = pcall(GetWeapontypeModel, weapon) end
            if modelOk and tonumber(weaponModel) == model then return tonumber(candidate) end
        end
    end
end

local function removeRecord(handle)
    local record = byPickup[handle]
    if record and record.entity and byObject[record.entity] == record then byObject[record.entity] = nil end
    byPickup[handle] = nil
end

local function bindObject(record, object, knownTypes)
    local data = entityData(object)
    if not data then return record end

    if record.entity and record.entity ~= object and byObject[record.entity] == record then
        byObject[record.entity] = nil
    end

    record.entity = data.entity
    record.entityType = data.entityType
    record.model = data.model or record.model
    record.coords = data.coords or record.coords
    record.pickupType = record.pickupType or inferWeaponPickupType(record.model, knownTypes)
    record.pending = false
    byObject[object] = record
    trace("bind", record.pickup, ("object=%s model=%s type=%s"):format(
        tostring(object), tostring(record.model), tostring(record.pickupType)))
    return record
end

local function descriptorCoords(coords)
    if type(coords) ~= "table" then return nil end
    local x, y, z = tonumber(coords.x or coords[1]), tonumber(coords.y or coords[2]), tonumber(coords.z or coords[3])
    if not x or not y or not z then return nil end
    return vector3(x, y, z)
end

local function refreshExplicit(record, knownTypes)
    if not record or not record.explicit then return record end

    local entity = tonumber(record.entity) or 0
    if record.netId and record.netId > 0 and type(NetworkDoesEntityExistWithNetworkId) == "function"
        and NetworkDoesEntityExistWithNetworkId(record.netId) then
        entity = NetworkGetEntityFromNetworkId(record.netId)
    end

    if validEntity(entity) then
        bindObject(record, entity, knownTypes)
        record.explicit = true
        return record
    end

    if record.entity and byObject[record.entity] == record then byObject[record.entity] = nil end
    record.entity, record.entityType, record.pending = 0, 0, true
    return record
end

local function distanceBetween(left, right)
    if not left or not right then return nil end
    local ok, distance = pcall(function() return #(left - right) end)
    return ok and distance or nil
end

local function closestTracked(coords, model, radius)
    local closest, closestDistance
    for _, record in pairs(byPickup) do
        if not record.poolObject and record.coords and (not model or not record.model or record.model == model) then
            local distance = distanceBetween(record.coords, coords)
            if distance and distance <= radius and (not closestDistance or distance < closestDistance) then
                closest, closestDistance = record, distance
            end
        end
    end
    return closest
end

function pickups.exists(handle)
    return pickupExists(handle)
end

function pickups.remember(descriptor, knownTypes, resource)
    if type(descriptor) ~= "table" then return nil end
    local handle = tonumber(descriptor.pickup or descriptor.handle)
    if not handle or handle <= 0 then return nil end

    resource = tostring(resource or descriptor.resource or "unknown")
    local key = descriptor.key or ("%s:%s"):format(resource, handle)
    local record = byPickup[key] or {
        key = key,
        pickup = handle,
        resource = resource,
        kind = "pickup",
        explicit = true,
    }

    record.key = key
    record.pickup = handle
    record.resource = resource
    record.explicit = true
    record.poolObject = false
    record.netId = tonumber(descriptor.netId) or record.netId or 0
    record.networked = descriptor.networked == true or record.netId > 0
    record.model = tonumber(descriptor.model) or record.model
    record.pickupType = tonumber(descriptor.pickupType) or record.pickupType
    record.coords = descriptorCoords(descriptor.coords) or record.coords
    record.entity = tonumber(descriptor.entity) or record.entity or 0
    record.pending = true
    byPickup[key] = record

    refreshExplicit(record, knownTypes)
    trace("remember", key, ("pickup=%s entity=%s netId=%s model=%s type=%s pending=%s"):format(
        tostring(handle), tostring(record.entity), tostring(record.netId), tostring(record.model),
        tostring(record.pickupType), tostring(record.pending)))
    return record
end

function pickups.resolve(handle, knownTypes)
    handle = tonumber(handle)
    if not handle or handle <= 0 then return nil end

    -- Some OAL/runtime combinations report DoesPickupExist differently. An
    -- explicit pickup is still valid when GetPickupObject resolves its object.
    local exists = pickupExists(handle)
    local object = pickupObject(handle)
    trace("resolve", handle, ("exists=%s object=%s"):format(tostring(exists), tostring(object)))
    if not exists and object == 0 then
        removeRecord(handle)
        return nil
    end

    local record = byPickup[handle] or { pickup = handle, kind = "pickup" }
    record.poolObject = false
    if exists or object ~= 0 then
        record.pickupType = pickupType(handle) or record.pickupType
        record.coords = pickupCoords(handle, object) or record.coords
    end
    byPickup[handle] = record

    if object == 0 then
        record.entity = 0
        record.entityType = 0
        record.pending = true
        return record
    end

    return bindObject(record, object, knownTypes)
end

local function resolvePoolEntry(handle, knownTypes)
    if pickupExists(handle) then return pickups.resolve(handle, knownTypes) end
    local data = entityData(handle)
    if not data then return nil end

    local record = byObject[handle]
    if record then
        record.coords = data.coords or record.coords
        record.model = data.model or record.model
        record.pickupType = record.pickupType or inferWeaponPickupType(record.model, knownTypes)
        return record
    end

    record = closestTracked(data.coords, data.model, 1.25)
    if record then return bindObject(record, handle, knownTypes) end

    record = {
        pickup = handle,
        entity = handle,
        entityType = data.entityType,
        model = data.model,
        coords = data.coords,
        pickupType = inferWeaponPickupType(data.model, knownTypes),
        kind = "pickup",
        pending = false,
        poolObject = true,
    }
    byPickup[handle] = record
    byObject[handle] = record
    return record
end

-- Existing tracked handles are always retried. CPickup is scanned only when a
-- global-pickup or pickup-type registration needs discovery.
function pickups.refresh(discover, knownTypes)
    if discover and type(GetGamePool) == "function" then
        local pool = GetGamePool("CPickup") or {}
        for i = 1, #pool do resolvePoolEntry(tonumber(pool[i]), knownTypes) end
    end

    local tracked = {}
    for handle in pairs(byPickup) do tracked[#tracked + 1] = handle end
    for i = 1, #tracked do
        local handle = tracked[i]
        local record = byPickup[handle]
        if record and record.explicit then
            refreshExplicit(record, knownTypes)
        elseif record and record.poolObject then
            if validEntity(record.entity) then
                bindObject(record, record.entity, knownTypes)
                record.poolObject = true
            else
                removeRecord(handle)
            end
        elseif not pickups.resolve(handle, knownTypes) then
            removeRecord(handle)
        end
    end
    return byPickup
end

function pickups.get(handle)
    local key = type(handle) == "string" and handle or tonumber(handle)
    if not key then return nil end
    local record = byPickup[key]
    if record and record.explicit then return refreshExplicit(record) end
    return record or pickups.resolve(key)
end

function pickups.fromEntity(entity)
    if not validEntity(entity) then return nil end
    local record = byObject[entity]
    if not record then return nil end
    if record.explicit then return refreshExplicit(record) end
    if record.poolObject and validEntity(record.entity) then return record end
    if pickupExists(record.pickup) then return record end
    removeRecord(record.key or record.pickup)
end

function pickups.findClosest(coords, radius, entity, knownTypes)
    if not coords then return nil end
    radius = tonumber(radius) or 1.25
    local data = entityData(entity)
    local closest, closestDistance

    for _, record in pairs(byPickup) do
        if record.coords and (not data or not data.model or not record.model or record.model == data.model) then
            local distance = distanceBetween(record.coords, coords)
            if distance and distance <= radius and (not closestDistance or distance < closestDistance) then
                closest, closestDistance = record, distance
            end
        end
    end

    if closest and closest.pending and data then bindObject(closest, entity, knownTypes) end
    return closest, closestDistance
end

function pickups.resolveHit(entity, coords, knownTypes, registeredPickups)
    -- Explicit handles have priority over the opaque object handles discovered
    -- in CPickup, preserving the identifier supplied to addPickup/addLocalEntity.
    for handle, options in pairs(registeredPickups or {}) do
        if type(options) == "table" and #options > 0 then
            local explicit = pickups.get(handle)
            if explicit then refreshExplicit(explicit, knownTypes) end
            trace("hit:explicit", handle, ("rayEntity=%s resolvedEntity=%s pending=%s matched=%s"):format(
                tostring(entity), tostring(explicit and explicit.entity), tostring(explicit and explicit.pending),
                tostring(explicit and not explicit.pending and explicit.entity == entity)))
            if explicit and not explicit.pending and explicit.entity == entity then return explicit end
        end
    end

    local record = pickups.fromEntity(entity)
    if record then return record end
    if pickupExists(entity) then
        record = pickups.resolve(entity, knownTypes)
        if record and not record.pending then return record end
    end
    return pickups.findClosest(coords, 1.25, entity, knownTypes)
end

function pickups.remove(key)
    if type(key) == "table" then key = key.key end
    if key ~= nil then removeRecord(key) end
end

function pickups.removeResource(resource)
    resource = tostring(resource)
    local keys = {}
    for key, record in pairs(byPickup) do
        if record.resource == resource then keys[#keys + 1] = key end
    end
    for i = 1, #keys do removeRecord(keys[i]) end
end

function pickups.list()
    return byPickup
end

function pickups.clear()
    byPickup = {}
    byObject = {}
    traceHistory = {}
    traceCount = 0
end

rawset(_G, singletonKey, pickups)
return pickups