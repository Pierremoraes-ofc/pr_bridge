local net = {}

local function now()
    return GetGameTimer()
end

local function waitUntil(timeout, cb)
    local expires = now() + (timeout or 1000)

    repeat
        local result = cb()
        if result then return result end
        Wait(0)
    until now() >= expires

    return nil
end

local function networkIdExists(netId)
    if NetworkDoesNetworkIdExist then
        return NetworkDoesNetworkIdExist(netId)
    end

    return NetworkDoesEntityExistWithNetworkId(netId)
end

local function isVehicleEntity(entity)
    return type(entity) == "number" and entity > 0 and DoesEntityExist(entity) and GetEntityType(entity) == 2
end

function net.isValidNetId(netId)
    return type(netId) == "number" and netId > 0 and networkIdExists(netId) and NetworkDoesEntityExistWithNetworkId(netId)
end

function net.getNetId(entity)
    if type(entity) ~= "number" or entity <= 0 or not DoesEntityExist(entity) or not NetworkGetEntityIsNetworked(entity) then
        return nil
    end

    local netId = NetworkGetNetworkIdFromEntity(entity)
    return netId and netId > 0 and netId or nil
end

function net.getEntity(netId, timeout)
    if type(netId) ~= "number" or netId <= 0 then return nil end
    if not networkIdExists(netId) then return nil end

    if NetworkDoesEntityExistWithNetworkId(netId) then
        local entity = NetworkGetEntityFromNetworkId(netId)
        return entity and entity > 0 and entity or nil
    end

    return waitUntil(timeout, function()
        if not networkIdExists(netId) then return nil end
        if not NetworkDoesEntityExistWithNetworkId(netId) then return nil end

        local entity = NetworkGetEntityFromNetworkId(netId)
        return entity and entity > 0 and entity or nil
    end)
end

function net.getVehicle(netId, timeout)
    local entity = net.getEntity(netId, timeout)
    if not isVehicleEntity(entity) then return nil end

    return entity
end

function net.resolveVehicle(vehicleOrNetId, timeout)
    if type(vehicleOrNetId) ~= "number" or vehicleOrNetId <= 0 then return nil, nil end

    if isVehicleEntity(vehicleOrNetId) then
        return vehicleOrNetId, net.getNetId(vehicleOrNetId)
    end

    local vehicle = net.getVehicle(vehicleOrNetId, timeout)
    return vehicle, vehicle and vehicleOrNetId or nil
end

function net.getOwner(entityOrNetId, timeout)
    local entity = entityOrNetId

    if type(entityOrNetId) == "number" and entityOrNetId > 0 and not DoesEntityExist(entityOrNetId) then
        entity = net.getEntity(entityOrNetId, timeout)
    end

    if type(entity) ~= "number" or entity <= 0 or not DoesEntityExist(entity) or not NetworkGetEntityIsNetworked(entity) then
        return nil
    end

    return NetworkGetEntityOwner(entity)
end

return net
