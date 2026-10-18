local S=PRCore.load('@pr_bridge/bridge/runtime/compat_services',_ENV)
return function(I)
    local N={}
    N.AddItems=function()
        local set=S.exported('ox_inventory','SetItemDefinition')
        if not set then return nil,'ox_inventory has no runtime item-definition export (not part of every version)' end
        return function(items)
            local count=0
            for _,item in ipairs(items) do
                if not I.Items(item.name) then
                    local ok,reason=set(item.name,item,true)
                    if ok~=true then return false,reason,count end
                    count=count+1
                end
            end
            return true,count -- runtime only; persistence requires a provider
        end
    end
    N.CreatePickup=function()
        local drop=S.exported('ox_inventory','CustomDrop')
        if not drop then return nil,'ox_inventory CustomDrop unavailable' end
        return function(request)
            assert(type(request)=='table' and type(request.name)=='string','Invalid pickup')
            assert(type(request.count)=='number' and request.count>0 and request.count%1==0,'Invalid pickup count')
            assert(I.Items(request.name),'Unknown pickup item')
            local coords=request.coords
            if not coords then coords=GetEntityCoords(GetPlayerPed(request.source)) end
            local bucket=request.bucket
            if bucket==nil then bucket=GetPlayerRoutingBucket(request.source) end
            return drop(request.label or 'ESX',{{request.name,request.count,request.metadata}},coords,nil,nil,bucket)
        end
    end
    return N
end
