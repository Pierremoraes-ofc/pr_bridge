-- All pending legacy signatures terminate at the active framework contract.
return function(E,C)
    local F=C.bridge.framework
    C.delegated=C.delegated or {}
    local function invoke(name,...)
        C.target();return C.invoke(F,name,...)
    end
    local function define(name,fn,operation)
        C.define(E,name,fn)
        C.delegated[name]=operation or name
    end
    E.GetCompatibilityCapabilities=function()
        C.target();return {framework=F.GetCompatibilityCapabilities and F.GetCompatibilityCapabilities() or {},
            inventory=C.bridge.inventory.GetCompatibilityCapabilities and C.bridge.inventory.GetCompatibilityCapabilities() or {}}
    end
    if C.context=='client' then
        define('PreviewContext',function(...) return invoke('PreviewContext',...) end)
        define('SpawnPlayer',function(skin,coords,callback)
            local delivered=false
            local function complete(...)
                if delivered or C.closed then return end
                delivered=true;if callback then callback(...) end
            end
            local result=table.pack(pcall(invoke,'SpawnPlayer',C.copy(skin),C.copy(coords),complete,C.owner))
            if not result[1] then complete(false,result[2]);error(result[2],2) end
            if result[2]==false then complete(false,result[3]) end
            return table.unpack(result,2,result.n)
        end)
        return
    end
    define('CreateJob',function(name,label,grades,kind)
        return invoke('CreateJob',{name=name,label=label,grades=C.copy(grades),type=kind})
    end)
    for _,name in ipairs({'RefreshJob','RefreshJobs','RefreshItems','CreateExtendedVehicle',
        'GetExtendedVehicleFromPlate','DiscordLog','DiscordLogFields'}) do
        define(name,function(...) return invoke(name,...) end)
    end
    define('AddItems',function(items)
        assert(type(items)=='table','Expected item definitions')
        local definitions={}
        for _,item in ipairs(items) do
            assert(type(item)=='table' and type(item.name)=='string' and item.name:match('^[%w_%-]+$'),'Invalid item name')
            assert(type(item.label)=='string' and item.label~='','Invalid item label')
            C.amount(item.weight or 1)
            local definition=C.copy(item);definition.weight=item.weight or 1
            if definition.stack==nil then definition.stack=true end
            definitions[#definitions+1]=definition
        end
        return invoke('AddItems',definitions)
    end)
    define('CreatePickup',function(kind,name,count,label,source,components,tint,coords,bucket)
        source=tonumber(source);assert(source and C.player(source),'Invalid pickup player')
        local request={kind=kind,name=name,count=C.amount(count),label=label,source=source,coords=coords,bucket=bucket}
        if kind=='item_account' then
            local mapped=(Config.compatPickupAccounts or {money='money'})[name]
            if not mapped then C.unsupported('CreatePickup','account has no inventory item mapping') end
            request.name=mapped
        elseif kind=='item_weapon' then
            local _,definition=E.GetWeapon(name)
            if not definition then C.unsupported('CreatePickup','unknown weapon') end
            request.name=definition.name;request.count=1
            request.metadata={ammo=C.amount(count),tint=C.amount(tint or 0),components={}}
            for _,alias in ipairs(components or {}) do
                local component=C.componentItem(name,alias)
                if not component then C.unsupported('CreatePickup','unknown weapon component') end
                request.metadata.components[#request.metadata.components+1]=component.name
            end
        elseif kind~='item_standard' then C.unsupported('CreatePickup','unknown pickup type') end
        -- ESX callers already remove the source item. Do not remove it twice.
        return invoke('CreatePickup',request)
    end)
    define('RegisterPlayerFunctionOverrides',function(index,overrides)
        return invoke('RegisterPlayerFunctionOverrides',index,overrides,C.owner)
    end)
    define('SetPlayerFunctionOverride',function(index) return invoke('SetPlayerFunctionOverride',index) end)
end
