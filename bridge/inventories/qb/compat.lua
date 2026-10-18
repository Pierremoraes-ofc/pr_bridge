local S=PRCore.load('@pr_bridge/bridge/runtime/compat_services',_ENV)
return function(I)
    local N={}
    N.AddItems=function()
        if ActiveBridges.frameworks~='qb' then return nil,'QB Shared.Items requires active qb-core; configure the selected inventory provider' end
        local add=S.exported('qb-core','AddItems')
        local get=S.exported('qb-core','GetCoreObject')
        if not add or not get then return nil,'qb-core AddItems/GetCoreObject unavailable' end
        return function(items)
            local definitions={}
            for _,item in ipairs(items) do
                if not I.Items(item.name) then
                    local definition={};for k,v in pairs(item) do definition[k]=v end
                    definition.type='item';definition.unique=item.stack==false
                    definition.image=definition.image or (item.name..'.png')
                    definitions[item.name]=definition
                end
            end
            if not next(definitions) then return true,0 end
            return add(definitions) -- native QB broadcasts Shared.Items updates
        end
    end
    return N
end
