local vehicleCache = {
    statePrefix = "pr_bridge:vehicle:",
}

local store = {
    byNetId = {},
    byPlate = {},
    byEntity = {},
}

local function entityKey(entity)
    return type(entity) == "number" and entity > 0 and tostring(entity) or nil
end

local function compactMeta(meta)
    if type(meta) ~= "table" then return nil end

    return {
        id = meta.id,
        owner = meta.owner,
        citizenid = meta.citizenid,
        plate = meta.plate,
        type = meta.type,
        job = meta.job,
        garage = meta.garage,
        persistent = meta.persistent == true,
        version = meta.version,
    }
end

function vehicleCache.set(vehicleOrNetId, data)
    if type(data) ~= "table" then return false end

    local netId = data.netId
    local entity = data.entity

    if type(vehicleOrNetId) == "number" and vehicleOrNetId > 0 then
        if DoesEntityExist(vehicleOrNetId) then
            entity = vehicleOrNetId
        else
            netId = vehicleOrNetId
        end
    end

    if type(netId) == "number" and netId > 0 then
        store.byNetId[netId] = data
    end

    local key = entityKey(entity)
    if key then
        store.byEntity[key] = data
    end

    if type(data.plate) == "string" and data.plate ~= "" then
        store.byPlate[data.plate] = data
    end

    return true
end

function vehicleCache.get(vehicleOrNetId)
    if type(vehicleOrNetId) ~= "number" or vehicleOrNetId <= 0 then return nil end

    if DoesEntityExist(vehicleOrNetId) then
        return store.byEntity[tostring(vehicleOrNetId)]
    end

    return store.byNetId[vehicleOrNetId]
end

function vehicleCache.getByPlate(plate)
    return type(plate) == "string" and store.byPlate[plate] or nil
end

function vehicleCache.clear(vehicleOrNetId)
    if type(vehicleOrNetId) ~= "number" or vehicleOrNetId <= 0 then return end

    local data

    if DoesEntityExist(vehicleOrNetId) then
        local key = tostring(vehicleOrNetId)
        data = store.byEntity[key]
        store.byEntity[key] = nil
    else
        data = store.byNetId[vehicleOrNetId]
        store.byNetId[vehicleOrNetId] = nil
    end

    if data and data.plate then
        store.byPlate[data.plate] = nil
    end
end

function vehicleCache.clearAll()
    store.byNetId = {}
    store.byPlate = {}
    store.byEntity = {}
end

function vehicleCache.getStateKey(name)
    return ("%s%s"):format(vehicleCache.statePrefix, name)
end

function vehicleCache.setState(vehicle, name, value, replicated)
    if type(vehicle) ~= "number" or vehicle <= 0 or not DoesEntityExist(vehicle) or type(name) ~= "string" then return false end

    Entity(vehicle).state:set(vehicleCache.getStateKey(name), value, replicated == true)
    return true
end

function vehicleCache.getState(vehicle, name)
    if type(vehicle) ~= "number" or vehicle <= 0 or not DoesEntityExist(vehicle) or type(name) ~= "string" then return nil end

    return Entity(vehicle).state[vehicleCache.getStateKey(name)]
end

function vehicleCache.setPersistentMeta(vehicle, meta)
    local compact = compactMeta(meta)
    if not compact then return false end

    return vehicleCache.setState(vehicle, "meta", compact, true)
end

function vehicleCache.getPersistentMeta(vehicle)
    return vehicleCache.getState(vehicle, "meta")
end

return vehicleCache
