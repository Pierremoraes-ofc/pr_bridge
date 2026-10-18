local H=PRCore.load('@pr_bridge/bridge/frameworks/compat_helpers',_ENV)
local S=H.services
local contract=PRCore.load('@pr_bridge/bridge/frameworks/compat_contract',_ENV)
return function(F,context,inventory,backend,natives)
    natives=natives or {}
    if context=='client' then PRCore.load('@pr_bridge/bridge/frameworks/compat_client',_ENV)(natives)
    else PRCore.load('@pr_bridge/bridge/frameworks/compat_logging',_ENV)(natives) end
    PRCore.compatState=PRCore.compatState or {accounts={},overrides={}}
    local state=PRCore.compatState
    local automatic={}
    if backend=='qbx' then
        for _,name in ipairs({'CreateJob','RefreshJob','RefreshJobs','IsPaycheckEnabled','TogglePaycheck'}) do
            automatic[name]={{resource='forge-core',export='Compat'..name}}
        end
    end
    local function route(name,...)
        if context=='server' and (name=='AddItems' or name=='RefreshItems' or name=='CreatePickup') then
            assert(inventory and S.callable(inventory[name]),'Selected inventory adapter unavailable: '..name)
            return inventory[name](...)
        end
        return S.call('frameworks',backend,name,natives[name],automatic[name],...)
    end
    if context=='server' then
        for _,name in ipairs({'AddItems','RefreshItems','CreatePickup'}) do
            natives[name]=function()
                if inventory and S.callable(inventory[name]) then return inventory[name] end
                return nil,'selected inventory has no '..name..' adapter'
            end
        end
        -- These are ESX compatibility transaction guards, not replacements for
        -- the native bank's transaction/persistence/locking implementation.
        local function account(source)
            local id=assert(F.GetIdentifier(source),'Player identity unavailable')
            local entry=state.accounts[source]
            if not entry or entry.identifier~=id or entry.backend~=backend then entry={identifier=id,backend=backend,pending=0,closing=false};state.accounts[source]=entry end
            return entry
        end
        natives.BeginAccountOperation=natives.BeginAccountOperation or function() return function(source)
            local entry=account(source);if entry.closing then return false end;entry.pending=entry.pending+1;return true
        end end
        natives.BeginAccountShutdown=natives.BeginAccountShutdown or function() return function(source) account(source).closing=true end end
        natives.EndAccountOperation=natives.EndAccountOperation or function() return function(source) local entry=account(source);entry.pending=math.max(0,entry.pending-1) end end
        natives.GetPendingAccountOperations=natives.GetPendingAccountOperations or function() return function(source) return account(source).pending end end
        natives.RegisterPlayerFunctionOverrides=natives.RegisterPlayerFunctionOverrides or function() return function(index,overrides,owner)
            assert(type(index)=='string' and index~='' and type(overrides)=='table','Invalid overrides')
            owner=owner or GetInvokingResource() or GetCurrentResourceName()
            local previous=state.overrides[index]
            assert(not previous or previous.owner==owner,'Override belongs to another resource')
            for name,fn in pairs(overrides) do assert(type(name)=='string' and S.callable(fn),'Invalid override factory') end
            state.overrides[index]={owner=owner,functions=H.copy(overrides)}
            state.overrideRevision=(state.overrideRevision or 0)+1
        end end
        natives.SetPlayerFunctionOverride=natives.SetPlayerFunctionOverride or function() return function(index)
            assert(state.overrides[index],'Unknown override index');state.selected=index
            state.overrideRevision=(state.overrideRevision or 0)+1
        end end
        F.ApplyCompatibilityOverrides=function(player,owner,guard)
            local entry=state.selected and state.overrides[state.selected]
            if not entry then return end
            for name,factory in pairs(entry.functions) do
                local callback=factory(player)
                assert(S.callable(callback),'Override factory must return a function: '..name)
                rawset(player,name,function(...)
                    guard();assert(state.overrides[state.selected]==entry,'Override provider stopped or changed; reacquire xPlayer')
                    return callback(...)
                end)
            end
        end
        F.ReleaseCompatibilityOwner=function(owner)
            for index,entry in pairs(state.overrides) do if entry.owner==owner then
                state.overrides[index]=nil;state.overrideRevision=(state.overrideRevision or 0)+1
            end end
        end
        F.GetCompatibilityOverrideRevision=function() return state.overrideRevision or 0 end
        F.ReleaseCompatibilityPlayer=function(source) state.accounts[tonumber(source)]=nil end
    end
    for _,name in ipairs(contract[context]) do
        if not F[name] then F[name]=function(...) return route(name,...) end end
    end
    if context=='server' then
        for _,name in ipairs({'SetPlayerAccountMoney','SaveCompatibilityPlayer'}) do
            F[name]=function(...) return route(name,...) end
        end
    else
        F.DisplayInventoryMetadata=function(...)
            assert(inventory and S.callable(inventory.displayMetadata),'Selected inventory metadata adapter unavailable')
            return inventory.displayMetadata(...)
        end
    end
    F.GetCompatibilityCapabilities=function()
        local out={}
        for _,name in ipairs(contract[context]) do
            local fn,provider=S.resolve('frameworks',backend,name,natives[name],automatic[name])
            out[name]={available=fn~=nil,provider=provider}
        end
        if context=='server' and inventory and inventory.GetCompatibilityCapabilities then
            local capabilities=inventory.GetCompatibilityCapabilities()
            for _,name in ipairs({'AddItems','RefreshItems','CreatePickup'}) do
                out[name]=capabilities[name] or {available=false,provider='selected inventory adapter unavailable'}
            end
        end
        return out
    end
    -- Common read-only snapshot; no fake Functions table or second player store.
    F.GetCompatibilityPlayerData=F.GetCompatibilityPlayerData or function(source)
        local p=context=='client' and F.GetPlayerData() or F.GetPlayer(source);if not p then return end
        if p.PlayerData then return p.PlayerData end
        if p.citizenid then return p end
        local identifier=context=='server' and F.GetIdentifier(source) or F.GetPlayerIdentifier()
        if identifier==nil then return end
        local name=context=='server' and F.getPlayerName(source) or F.GetPlayerName()
        return {citizenid=identifier,source=source,charinfo={firstname=type(name)=='string' and name or name.fullName},
            job=F.GetPlayerJob(source),metadata=p.metadata or {},money={}}
    end
    return F
end
