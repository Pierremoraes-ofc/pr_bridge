-- Private Forge integration for the installed custom OX. Not loaded by a manifest.
return function(ports)
    local inventory,custom=assert(ports.inventory),assert(ports.custom)
    local current,state,resource=assert(ports.isCurrent),assert(ports.resourceState),assert(ports.executingResource)
    assert(ports.owner=='forge-core','preserve Forge hook owner')
    local register=assert(inventory.RegisterHook)
    local items=assert(inventory.Items)
    local remove=assert(custom.removeHooks)
    assert(type(register)=='function'and type(remove)=='function','custom hook provider required')
    local methods={'SetItemDefinition','DisableItemDefinition','RemoveItemDefinition','HasItemDefinition',
        'SetWeaponItem','DisableWeaponItem','RemoveWeaponItem','HasWeaponItem'}
    local captured={};for _,name in ipairs(methods)do captured[name]=assert(custom[name],name)end
    local phase,entered,publishing='prepared',0,0
    local records={};local api={OperationalReady=false,UniqueHookIdentity=false}
    local function ownsExecution()local ok,value=pcall(resource);return ok and value==ports.owner end
    function api.Check()
        local ok,ready=pcall(function()return current()==true and ownsExecution()and state('ox_inventory')=='started'end)
        return ok and ready==true
    end
    local function live()return phase=='open'and api.Check()end
    local function retire(r,exact)
        if r.removed then
            if exact and r.result then return table.unpack(r.result,2,r.result.n)end
            return true
        end
        if not r.token then return not r.unknown end
        if not ownsExecution()then r.error='wrong_execution_owner';return false,r.error end
        -- OX IDs are not generation-unique. Revoke all our aliases; never use nil/all-owner removal.
        for _,v in ipairs(records)do if v.token==r.token then v.fn=nil end end
        local result=table.pack(pcall(remove,custom,r.token))
        if not result[1]or result[2]==false then
            r.error=tostring(result[1]and result[3]or result[2])
            if exact then if not result[1]then error(result[2],0)end;return table.unpack(result,2,result.n)end
            return false
        end
        for _,v in ipairs(records)do if v.token==r.token then v.removed=true;v.error=nil;v.result=result end end
        if exact then return table.unpack(result,2,result.n)end;return true
    end
    function api.Open()
        if phase~='prepared'then return false,'inventory_scope_not_repeatable'end
        if not api.Check()or phase~='prepared'then return false,'inventory_provider_not_ready'end
        phase='open';return true
    end
    function api.RegisterHook(name,fn,options)
        if not live()then return nil,'inventory_scope_closed'end
        if type(name)~='string'or type(fn)~='function'then return nil end
        local r={fn=fn};records[#records+1]=r
        local function callback(...)
            local body=r.fn;if not body or not live()then return end -- Preserve nil, not a new veto policy.
            entered=entered+1;local result=table.pack(pcall(body,...));entered=entered-1
            if not result[1]then error(result[2],0)end;return table.unpack(result,2,result.n)
        end
        publishing=publishing+1;local result=table.pack(pcall(register,name,callback,options));publishing=publishing-1
        if not result[1]then r.fn=nil;r.unknown=true;r.error=tostring(result[2]);error(result[2],0)end
        local token=result[2]
        if token==false then r.fn=nil;r.refused=true
        elseif type(token)=='string'and token:sub(1,#ports.owner+1)==ports.owner..':'then r.token=token
        else r.fn=nil;r.unknown=true;r.error='unrecognized_custom_hook_id'end
        if not live()then r.fn=nil;retire(r)end
        return table.unpack(result,2,result.n)
    end
    function api.RemoveHooks(token)
        if token==nil then return false,'explicit_owned_hook_id_required'end
        for i=#records,1,-1 do local r=records[i]
            if r.token==token then r.fn=nil;return retire(r,true)end
        end
        return false,'foreign_inventory_hook'
    end
    function api.Close()
        phase='closed';for _,r in ipairs(records)do r.fn=nil end
        local ok=true;for i=#records,1,-1 do if not retire(records[i])then ok=false end end;return ok
    end
    function api.Progress()
        local out={phase=phase,entered=entered,publishing=publishing,records=#records,residual=0,unknown=0,removeFailed=0,
            uniqueHookIdentity=false}
        for _,r in ipairs(records)do
            if not r.removed and not r.refused then out.residual=out.residual+1 end
            if r.unknown then out.unknown=out.unknown+1 end
            if r.error then out.removeFailed=out.removeFailed+1 end
        end
        out.pending=entered+publishing;out.complete=phase=='closed'and out.pending==0 and out.residual==0
        return out
    end
    function api.InventoryReady()return live()end
    function api.InventoryState()return state('ox_inventory')end
    function api.Items(...)
        if not live()then return nil,'inventory_scope_closed'end
        entered=entered+1;local result=table.pack(pcall(items,...));entered=entered-1
        if not result[1]then error(result[2],0)end;return table.unpack(result,2,result.n)
    end
    for _,name in ipairs(methods)do local fn=captured[name]
        assert(type(fn)=='function','custom inventory export required: '..name)
        api[name]=function(...)
            if not live()then return nil,'inventory_scope_closed'end
            entered=entered+1;local result=table.pack(pcall(fn,custom,...));entered=entered-1
            if not result[1]then error(result[2],0)end;return table.unpack(result,2,result.n)
        end
    end
    return api
end
