-- Native spatial queries. Entity enumeration/distance calculation remains in
-- objects; this facade adds exclusions and normalises result field names.
return function(objects, context, cache)
    local api = {}
    local function nearby(pool, kind, coords, radius, exclude)
        radius = radius or 2.0
        local result = {}
        for _, item in ipairs(objects.getPoolInRadius(pool, coords, radius)) do
            if item.distance < radius and (not exclude or not exclude(item.entity)) then
                item[kind] = item.entity
                result[#result + 1] = item
            end
        end
        return result
    end
    function api.getNearbyPeds(coords, radius)
        return nearby('CPed', 'ped', coords, radius, IsPedAPlayer)
    end
    function api.getNearbyObjects(coords, radius)
        return nearby('CObject', 'object', coords, radius)
    end
    function api.getNearbyVehicles(coords, radius, include)
        return nearby('CVehicle', 'vehicle', coords, radius, function(entity)
            return context == 'client' and not include and cache.vehicle and entity == cache.vehicle
        end)
    end
    for _, kind in ipairs({'Ped','Object','Vehicle'}) do
        local field = kind:lower()
        api['getClosest' .. kind] = function(...)
            local item = api['getNearby' .. kind .. 's'](...)[1]
            return item and item[field] or nil, item and item.coords or nil
        end
    end
    function api.getNearbyPlayers(coords, radius, include, ignore)
        local result, client = {}, context == 'client'
        radius = radius or 2.0
        coords = coords or (client and GetEntityCoords(PlayerPedId()))
        for _, rawId in ipairs(client and GetActivePlayers() or GetPlayers()) do
            local id = tonumber(rawId)
            if id ~= ignore and (not client or include or id ~= PlayerId()) then
                local ped = GetPlayerPed(id)
                if ped and ped ~= 0 then
                    local vehicle = client and GetVehiclePedIsIn(ped, false) or 0
                    local position = vehicle == 0 and GetEntityCoords(ped) or GetWorldPositionOfEntityBone(ped, 0)
                    local distance = #(coords - position)
                    if distance < radius then result[#result + 1] = {
                        id=id, player=id, serverId=client and GetPlayerServerId(id) or id,
                        ped=ped, entity=ped, coords=position, distance=distance, vehicle=client and vehicle or nil,
                    } end
                end
            end
        end
        table.sort(result, function(a,b) return a.distance < b.distance end)
        return result
    end
    function api.getClosestPlayer(coords, radius, include, ignore)
        local item = api.getNearbyPlayers(coords, radius, include, ignore)[1]
        return item and item.id or nil, item and item.ped or nil, item and item.coords or nil, item and item.vehicle or nil
    end
    return api
end
