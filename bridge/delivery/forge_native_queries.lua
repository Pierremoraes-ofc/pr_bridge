-- Exact public query bodies from installed PR init.lua;explicit local native/objects inputs.
return function(ports)
    local n=assert(ports.native)
    local GetEntityCoords,PlayerPedId,GetActivePlayers,PlayerId,GetPlayerPed=n.GetEntityCoords,n.PlayerPedId,n.GetActivePlayers,n.PlayerId,n.GetPlayerPed
    local public={fivem={objects=assert(ports.objects)}}
    public.getClosestVehicle = function(coords, radius, includePlayers)
        local options = type(includePlayers) == "table" and includePlayers or nil
        local closest = public.fivem.objects.getClosestVehicle(coords, radius or 2.0, options)
        return closest and closest.entity or nil, closest and closest.coords or nil
    end
    public.getClosestPlayer = function(coords, radius, includePlayer)
        coords = coords or GetEntityCoords(PlayerPedId())
        radius = tonumber(radius) or 2.0
        local closestPlayer, closestPed, closestCoords, closestDistance
        for _, playerId in ipairs(GetActivePlayers()) do
            if playerId ~= PlayerId() and playerId ~= includePlayer then
                local ped = GetPlayerPed(playerId)
                local pedCoords = GetEntityCoords(ped)
                local distance = #(coords - pedCoords)
                if distance <= radius and (not closestDistance or distance < closestDistance) then
                    closestPlayer, closestPed, closestCoords, closestDistance = playerId, ped, pedCoords, distance
                end
            end
        end
        return closestPlayer, closestPed, closestCoords
    end
    public.getNearbyPlayers = function(coords, radius, includePlayer)
        coords = coords or GetEntityCoords(PlayerPedId())
        radius = tonumber(radius) or 2.0
        local nearby = {}
        for _, playerId in ipairs(GetActivePlayers()) do
            if playerId ~= PlayerId() and playerId ~= includePlayer then
                local ped = GetPlayerPed(playerId)
                local pedCoords = GetEntityCoords(ped)
                local distance = #(coords - pedCoords)
                if distance <= radius then
                    nearby[#nearby + 1] = { id = playerId, ped = ped, coords = pedCoords, distance = distance }
                end
            end
        end
        table.sort(nearby, function(a, b) return a.distance < b.distance end)
        return nearby
    end

    return public
end
