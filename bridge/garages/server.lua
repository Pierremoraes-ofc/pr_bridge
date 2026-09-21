local function provider()
    local forced=GetConvar('pr_bridge:garage','auto')
    local supported={'forge-garage','jg-advancedgarages','qbx_garages','qb-garages'}
    for _,name in ipairs(supported) do
        if (forced=='auto' or forced==name) and GetResourceState(name)=='started' then return name end
    end
end
return function(api)
    return {
        getProvider=provider,
        registerProperty=function(options)
            if provider()~='qbx_garages' then return false end
            local c=options.data
            if not c or not c.x or not c.y or not c.z then return false end
            local coords=vec4(c.x,c.y,c.z,c.h or 0)
            exports.qbx_garages:RegisterGarage('housegarage-'..options.propertyId,{
                label=options.label,vehicleType='car',accessPoints={{coords=coords,spawn=coords}},
                canAccess=options.canAccess,
            })
            return true
        end,
        validateLink=function(propertyId,data)
            if type(data)~='table' then return false end
            local selected=provider()
            if data.provider~=selected then return false end
            if selected=='forge-garage' then
                local garages=exports['forge-garage']:Garage()
                local entry=garages and garages[data.name]
                return entry and entry.propertyGarage and tostring(entry.propertyGarage.id)==tostring(propertyId) or false
            end
            for _,axis in ipairs({'x','y','z','h'}) do
                local n=tonumber(data[axis])
                if not n or n~=n or math.abs(n)>20000 then return false end
            end
            return selected~=nil
        end,
    }
end
