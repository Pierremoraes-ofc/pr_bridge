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

    api.getNearbyVehicles = function(coords, radius, includePlayerVehicle)
        coords = coords or GetEntityCoords(PlayerPedId())
        local results = objects.getVehiclesInRadius(coords, radius or 2.0)
        local currentVehicle = api.cache and api.cache.vehicle or false
        if includePlayerVehicle or not currentVehicle then return results end

        local filtered = {}
        for i = 1, #results do
            if results[i].vehicle ~= currentVehicle then filtered[#filtered + 1] = results[i] end
        end
        return filtered
    end

    api.getClosestVehicle = function(coords, radius, includePlayerVehicle)
        local results = api.getNearbyVehicles(coords, radius, includePlayerVehicle)
        local closest = results[1]
        return closest and closest.vehicle or nil, closest and closest.coords or nil
    end

    api.getNearbyPlayers = function(coords, radius, includePlayer)
        coords = coords or GetEntityCoords(PlayerPedId())
        radius = tonumber(radius) or 2.0
        local currentPlayer = PlayerId()
        local nearby = {}

        for _, playerId in ipairs(GetActivePlayers()) do
            if includePlayer or playerId ~= currentPlayer then
                local ped = GetPlayerPed(playerId)
                local vehicle = GetVehiclePedIsIn(ped, false)
                local pedCoords = vehicle == 0 and GetEntityCoords(ped) or GetWorldPositionOfEntityBone(ped, 0)
                local distance = #(coords - pedCoords)
                if distance < radius then
                    nearby[#nearby + 1] = {
                        id = playerId,
                        player = playerId,
                        serverId = GetPlayerServerId(playerId),
                        ped = ped,
                        entity = ped,
                        coords = pedCoords,
                        distance = distance,
                        vehicle = vehicle,
                    }
                end
            end
        end

        table.sort(nearby, function(left, right) return left.distance < right.distance end)
        return nearby
    end

    api.getClosestPlayer = function(coords, radius, includePlayer)
        local closest = api.getNearbyPlayers(coords, radius, includePlayer)[1]
        return closest and closest.id or nil, closest and closest.ped or nil, closest and closest.coords or nil
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
