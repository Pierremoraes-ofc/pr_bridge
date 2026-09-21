local function provider()
    local forced=GetConvar('pr_bridge:garage','auto')
    local supported={'forge-garage','jg-advancedgarages','qbx_garages','qb-garages'}
    for _,name in ipairs(supported) do
        if (forced=='auto' or forced==name) and GetResourceState(name)=='started' then return name end
    end
end
return function(api)
    local garage={getProvider=provider}
    function garage.createPropertyGarage(options,done)
        local selected=provider()
        if selected=='forge-garage' then
            local completed=false
            local function finish(result)
                if completed then return end
                completed=true
                if result and result.draft then result.draft.provider=selected end
                done(result)
            end
            local listener
            listener=AddEventHandler('forge_garage:client:propertyGarageCreated',function(result)
                RemoveEventHandler(listener); finish(result)
            end)
            local started=exports[selected]:createPropertyGarage(options,function(result)
                RemoveEventHandler(listener); finish(result)
            end)
            if not started then RemoveEventHandler(listener) end
            return started
        end
        if not selected or type(options.placeCoords)~='function' then return false end
        local coords=options.placeCoords()
        if type(coords)~='table' then done({success=false,cancelled=true}); return true end
        done({success=true,draft={provider=selected,coords=coords,label=options.label}})
        return true
    end
    function garage.commitPropertyGarageDraft(options)
        local draft=options.draft or {}
        local selected=draft.provider or provider()
        if GetResourceState(selected or '')~='started' then return {success=false,message='O sistema de garagem selecionado não está iniciado.'} end
        if selected=='forge-garage' then
            local result=exports[selected]:commitPropertyGarageDraft(options)
            if result and result.success then result.data={provider=selected,name=result.garage,public=true} end
            return result
        end
        local c=draft.coords
        if not c or not tonumber(c.x) or not tonumber(c.y) or not tonumber(c.z) then return {success=false,message='Posição de garagem inválida.'} end
        return {success=true,data={provider=selected,name=('property-%s-garage'):format(options.propertyId),x=c.x,y=c.y,z=c.z,h=c.h or 0,length=c.length or 3,width=c.width or 5}}
    end
    function garage.registerProperty(options)
        local data=options.data or {}
        local selected=provider()
        if not selected or selected=='forge-garage' then return end -- Forge owns its saved zones.
        if not tonumber(data.x) or not tonumber(data.y) or not tonumber(data.z) then return end
        local coords=vec4(data.x,data.y,data.z,data.h or 0)
        local name=data.name or ('property-%s-garage'):format(options.propertyId)
        if selected=='jg-advancedgarages' then
            local target=api.target.addBoxZone({coords=vec3(coords.x,coords.y,coords.z),size=vec3(data.width or 5,data.length or 3,3.5),rotation=coords.w,
                options={
                    {name=name..':open',label='Abrir garagem',icon='fas fa-warehouse',distance=3,canInteract=options.canAccess,
                        onSelect=function() if options.canAccess() then TriggerEvent('jg-advancedgarages:client:open-garage',name,'car',coords) end end},
                    {name=name..':store',label='Guardar veículo',icon='fas fa-square-parking',distance=3,canInteract=options.canAccess,
                        onSelect=function() if options.canAccess() then TriggerEvent('jg-advancedgarages:client:store-vehicle',name,'car') end end},
                }})
            return {provider=selected,target=target}
        elseif selected=='qbx_garages' then
            if options.registerServer then options.registerServer() end
            return {provider=selected}
        end
        TriggerEvent('qb-garages:client:addHouseGarage',options.propertyId,{takeVehicle=coords,type='house',label=options.label})
        local zone=api.zones.box({coords=vec3(coords.x,coords.y,coords.z),size=vec3((data.length or 3)+5,(data.width or 5)+5,3.5),rotation=coords.w,
            onEnter=function() TriggerEvent('qb-garages:client:setHouseGarage',options.propertyId,true) end,
            onExit=function() TriggerEvent('qb-garages:client:setHouseGarage',options.propertyId,false) end})
        return {provider=selected,zone=zone,propertyId=options.propertyId}
    end
    function garage.unregisterProperty(handle)
        if not handle then return end
        if handle.target then api.target.removeZone(handle.target) end
        if handle.zone then handle.zone:remove() end
        if handle.provider=='qb-garages' then TriggerEvent('qb-garages:client:removeHouseGarage',handle.propertyId) end
    end
    return garage
end
