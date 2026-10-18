-- Legacy lowercase facade over explicitly published cache data only.
return function(api)
    local cache=api.cache
    local inventory={invBusy=true,invOpen=true,invHotkeys=true,canUseWeapons=true,
        canSteal=true,dead=true,cuffed=true,instance=true}
    local function get(field)
        if inventory[field] then
            local data=cache.GetResourceState('ox_inventory','player') or cache.get('ox_inventory:self')
            if data then return data[field] end
            if field=='invBusy' then return true end -- Missing publication must not unlock item actions.
            if field=='instance' then return 0 end
            return false
        end
        return cache.get('player:local:'..tostring(field))
    end
    local function set(field,value)
        if inventory[field] then
            local data=cache.GetResourceState('ox_inventory','player') or cache.get('ox_inventory:self') or {}
            data[field]=value
            return cache.SetResourceState('ox_inventory','player',data)
        end
        return cache.set('player:local:'..tostring(field),value)
    end
    return {new=function()
        return {get=function(_,field) return get(field) end,
            set=function(_,field,value) return set(field,value) end,
            setr=function(_,field,value) return set(field,value) end}
    end}
end
