return function(api)
    local objects = api.fivem and api.fivem.objects
    if type(objects) ~= "table" then return api end

    local function normalize(result, kind)
        if type(result) ~= "table" then return result end
        if kind == "vehicle" then result.vehicle = result.vehicle or result.entity end
        if kind == "ped" then result.ped = result.ped or result.entity end
        if kind == "object" then result.object = result.object or result.entity end
        return result
    end

    local function wrapList(name, kind)
        local original = objects[name]
        if type(original) ~= "function" then return end
        objects[name] = function(...)
            local results = original(...)
            for i = 1, #results do normalize(results[i], kind) end
            return results
        end
    end

    local function wrapSingle(name, kind)
        local original = objects[name]
        if type(original) ~= "function" then return end
        objects[name] = function(...) return normalize(original(...), kind) end
    end

    wrapList("getVehiclesInRadius", "vehicle")
    wrapList("getVehiclesInRadiusUsingPool", "vehicle")
    wrapList("getVehiclesByModelInRadius", "vehicle")
    wrapList("getPedsInRadius", "ped")
    wrapList("getObjectsInRadius", "object")
    wrapList("getObjectsInRadiusUsingPool", "object")
    wrapSingle("getClosestVehicle", "vehicle")
    wrapSingle("getClosestVehicleByModel", "vehicle")
    wrapSingle("getClosestObject", "object")
    wrapSingle("getClosestByModel", "object")

    local proximity = api.fivem.proximity
    api.getNearbyVehicles, api.getClosestVehicle = proximity.getNearbyVehicles, proximity.getClosestVehicle
    api.getNearbyPlayers = proximity.getNearbyPlayers
    api.getClosestPlayer = function(...)
        local id, ped, coords = proximity.getClosestPlayer(...)
        return id, ped, coords
    end

    objects.getNearbyVehicles = api.getNearbyVehicles
    if api.fivem.vehicle then
        api.fivem.vehicle.findInRadius = objects.getVehiclesInRadius
        api.fivem.vehicle.findClosest = objects.getClosestVehicle
    end
    if api.fivem.vehicles then
        api.fivem.vehicles.findInRadius = objects.getVehiclesInRadius
        api.fivem.vehicles.findByModelInRadius = objects.getVehiclesByModelInRadius
        api.fivem.vehicles.findClosest = objects.getClosestVehicle
        api.fivem.vehicles.findClosestByModel = objects.getClosestVehicleByModel
    end

    return api
end
