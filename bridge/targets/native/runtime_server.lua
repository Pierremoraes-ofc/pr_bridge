if ActiveBridges["target"] ~= "native" then return end

local tracked = {}

RegisterNetEvent("pr_bridge:target:setEntityHasOptions", function(netId)
    netId = tonumber(netId)
    if not netId or netId <= 0 then return end
    local entity = NetworkGetEntityFromNetworkId(netId)
    if not entity or entity == 0 or not DoesEntityExist(entity) then return end

    local state = Entity(entity).state
    state:set("prTargetOptions", true, true)
    tracked[netId] = entity
end)

RegisterNetEvent("pr_bridge:target:toggleEntityDoor", function(netId, door)
    local source = source
    netId, door = tonumber(netId), tonumber(door)
    if not netId or not door or door < 0 or door > 7 then return end

    local entity = NetworkGetEntityFromNetworkId(netId)
    if not entity or entity == 0 or not DoesEntityExist(entity) then return end
    local ped = GetPlayerPed(source)
    if ped == 0 or #(GetEntityCoords(ped) - GetEntityCoords(entity)) > 8.0 then return end

    local owner = NetworkGetEntityOwner(entity)
    if owner and owner > 0 then
        TriggerClientEvent("pr_bridge:target:toggleEntityDoor", owner, netId, door)
    end
end)

CreateThread(function()
    while true do
        Wait(10000)
        local removed = {}
        for netId, entity in pairs(tracked) do
            if not DoesEntityExist(entity) or Entity(entity).state.prTargetOptions ~= true then
                tracked[netId] = nil
                removed[#removed + 1] = netId
            end
        end
        if #removed > 0 then TriggerClientEvent("pr_bridge:target:removeEntity", -1, removed) end
    end
end)
