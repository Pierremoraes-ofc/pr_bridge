-- ESX signatures at the boundary; real player/inventory state stays in PR backends.
return function(bridge, context, owner)
    local C = { bridge = bridge, context = context, owner = owner, supported = {} }
    function C.callable(value)
        return type(value) == 'function' or type(value) == 'table' and getmetatable(value)
            and getmetatable(value).__call ~= nil
    end
    function C.copy(value, seen)
        if type(value) ~= 'table' then return value end
        if C.callable(value) then return value end
        seen = seen or {}; if seen[value] then return seen[value] end
        local result = {}; seen[value] = result
        for key, item in pairs(value) do result[key] = C.copy(item, seen) end
        return result
    end
    function C.unsupported(name, detail)
        local active=ActiveBridges.frameworks or 'default'
        error(('[PR Bridge ESX] %s: unsupported on target %s (configured: %s)%s'):format(name, active, tostring(Config.compatFramework), detail and (' (' .. detail .. ')') or ''), 3)
    end
    local reported={}
    function C.report(operation,reason)
        local now=GetGameTimer()
        if reported[operation] and now-reported[operation]<30000 then return end
        reported[operation]=now
        reason=tostring(reason):gsub('https?://%S+','[url]'):sub(1,700)
        print(('[PR Bridge ESX] %s | caller=%s | framework=%s | inventory=%s | %s'):format(
            operation,owner,tostring(ActiveBridges.frameworks),tostring(ActiveBridges.inventories or ActiveBridges.inventory),reason))
    end
    local lastSelection,lastActive,lastTarget
    local aliases = { ['qbx_core']='qbx', ['qbx-core']='qbx', qbxcore='qbx',qbcore='qb', ['qb-core']='qb', ['es_extended']='esx', ['forge-core']='forge',
        ['nd_core']='nd',ndcore='nd',['ox_core']='ox',oxcore='ox',core='tmc' }
    local valid={qbx=true,qb=true,esx=true,nd=true,ox=true,tmc=true,custom=true,default=true}
    function C.target()
        local selection,active=Config.compatFramework,ActiveBridges.frameworks
        if lastTarget and selection==lastSelection and active==lastActive then return lastTarget end
        if C.routing then C.routing.assertAllowed('esx',owner) end
        local selected = selection
        if selected == false or selected == nil or selected == 'off' then C.unsupported('compat disabled') end
        assert(type(selected)=='string','[PR Bridge ESX] framework target must be a string or false')
        selected=selected:lower()
        selected = aliases[selected] or selected
        if selected == 'forge' or selected == 'auto' then selected = active end
        assert(valid[selected], '[PR Bridge ESX] invalid framework target')
        assert(selected == active, '[PR Bridge ESX] compatFramework does not match the active PR framework; refusing cross-core writes')
        lastSelection,lastActive,lastTarget=selection,active,selected
        return selected
    end
    function C.invoke(module, name, ...)
        local fn = module and module[name]
        if not C.callable(fn) then C.unsupported(name, 'backend capability unavailable') end
        return fn(...)
    end
    function C.amount(value)
        assert(type(value) == 'number' and value == value and value >= 0 and value < math.huge
            and value % 1 == 0, '[PR Bridge ESX] expected a nonnegative finite integer')
        return value
    end
    function C.account(name)
        local mapped = (Config.compatESXAccounts or { money='cash', bank='bank' })[name]
        if type(mapped) ~= 'string' then C.unsupported('account ' .. tostring(name), 'configure compatESXAccounts explicitly') end
        return mapped
    end
    function C.job(value)
        value = value or {}; local grade = value.grade or 0
        local level = type(grade) == 'table' and grade.level or grade
        local label = type(grade) == 'table' and grade.name or value.grade_label
        return { name=value.name, label=value.label, type=value.type, grade=tonumber(level) or 0,
            grade_name=label or tostring(level), grade_label=label or tostring(level),
            grade_salary=(type(grade)=='table' and grade.payment) or value.payment or 0,
            onDuty=value.onduty ~= false, skin_male={}, skin_female={} }
    end
    function C.readInventory(source)
        -- nil is normal before the selected inventory finishes loading. Lua's
        -- `server and result or client()` would invoke a client API on server.
        if context=='server' then return C.invoke(bridge.inventory,'GetInventoryItems',source) or {} end
        return C.invoke(bridge.inventory,'GetPlayerItems') or {}
    end
    function C.itemDefinition(name, cache)
        if cache and cache[name] then return cache[name] end
        local definition=C.invoke(bridge.inventory,'Items',name) or {}
        if cache then cache[name]=definition end
        return definition
    end
    function C.inventory(source, input, definitions)
        input=input or C.readInventory(source)
        local result, byName = {}, {}
        for _, item in pairs(input or {}) do
            local name = item.name
            if name then
                local entry = byName[name]
                if not entry then
                    local definition=C.itemDefinition(name,definitions)
                    entry={name=name,label=definition.label or item.label or name,count=0,weight=definition.weight or item.weight or 0,
                        usable=item.usable == true,rare=false,canRemove=true}; byName[name]=entry; result[#result+1]=entry
                end
                entry.count = entry.count + (item.count or item.amount or 0)
            end
        end
        return result
    end
    function C.define(root, name, fn)
        assert(C.callable(fn),'ESX adapter implementation missing: '..name)
        local target, final = root, name
        for part in name:gmatch('([^.]+)%.') do target[part]=target[part] or {}; target=target[part]; final=name:match('([^.]+)$') end
        target[final] = function(...) assert(not C.closed,'[PR Bridge ESX] owning resource stopped');return fn(...) end
        C.supported[name] = 'adapted'
    end
    function C.finish(root, catalog)
        for _, group in ipairs({ 'shared', context }) do
            for name in pairs(catalog[group]) do
                if not C.supported[name] then C.define(root, name, function() C.unsupported(name) end); C.supported[name]='unsupported' end
            end
        end
        root.GetCompatibilityReport = function()
            local result=C.copy(C.supported)
            local F=C.bridge.framework
            local capabilities=F.GetCompatibilityCapabilities and F.GetCompatibilityCapabilities() or {}
            for name,operation in pairs(C.delegated or {}) do
                local capability=capabilities[operation]
                local available=capability and capability.available or not capability and C.callable(F[operation])
                result[name]=available and 'delegated' or 'unsupported'
            end
            if context=='server' then
                local contract=PRCore.load('bridge.frameworks.compat_contract')
                for name in pairs(catalog.player) do
                    local operation=contract.player[name]
                    if operation then
                        local capability=capabilities[operation]
                        local available=capability and capability.available or not capability and C.callable(F[operation])
                        result['xPlayer.'..name]=available and 'delegated' or 'unsupported'
                    else result['xPlayer.'..name]=C.playerSupport and C.playerSupport[name] and 'adapted' or 'unsupported' end
                end
            end
            return result
        end
        return root
    end
    return C
end
