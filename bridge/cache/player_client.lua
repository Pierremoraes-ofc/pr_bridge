-- Compatibility facade for local player state; inventory flags are provider-owned.
return function(api)
    local cache = api.cache
    local inventory = { invBusy=true, invOpen=true, invHotkeys=true, canUseWeapons=true,
        canSteal=true, dead=true, cuffed=true, instance=true }
    local function hydrate(data) cache.set('ox_inventory:self', data) end
    cache.OnResourceState('ox_inventory', 'player', hydrate)
    AddEventHandler('onClientResourceStart', function(resource)
        if resource == 'ox_inventory' then hydrate(cache.GetResourceState(resource, 'player')) end
    end)
    AddEventHandler('onClientResourceStop', function(resource)
        if resource == 'ox_inventory' then hydrate(nil) end
    end)
    hydrate(cache.GetResourceState('ox_inventory', 'player'))
    local function get(field)
        if inventory[field] then
            local data = cache.get('ox_inventory:self')
            if data then return data[field] end
            if field == 'invBusy' then return true end
            if field == 'instance' then return 0 end
            return false
        end
        return cache.get('player:local:' .. tostring(field))
    end
    local function set(field, value)
        if inventory[field] then
            if GetResourceState('ox_inventory') ~= 'started' then return false end
            return exports.ox_inventory:SetPlayerState(field, value)
        end
        return cache.set('player:local:' .. tostring(field), value)
    end
    return {
        new = function()
            return { get=function(_, field) return get(field) end,
                set=function(_, field, value) return set(field, value) end,
                setr=function(_, field, value) return set(field, value) end }
        end,
    }
end
