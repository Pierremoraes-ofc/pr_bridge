-- Prepared routing. Logical Forge contract availability is explicit; no active framework is changed.
return function(ports)
    local active,config=assert(ports.active),assert(ports.config);local owner,read=assert(ports.isCurrent),assert(ports.readDeclarations)
    local contracts=assert(ports.contracts);local aliases={['qbx_core']='qbx',['qbx-core']='qbx',qbxcore='qbx',
        ['qb-core']='qb',qbcore='qb',['es_extended']='esx',['nd_core']='nd',['ox_core']='ox',core='tmc'}
    if ports.resourceName then aliases[ports.resourceName:lower()]='forge'end
    local phase,pending='open',0;local declarations={};local api={OperationalReady=false}
    local function current()local ok,v=pcall(owner);return phase=='open'and ok and v==true end
    local function check()assert(current(),'forge_routing_closed')end
    local function canonical(name)
        assert(type(name)=='string','[PR Bridge] framework name must be a string');name=name:lower();return aliases[name]or name
    end
    function api.getActive()check();return active.frameworks or'default'end
    function api.isNative(name)
        check();name=canonical(name);local backend=api.getActive()
        if backend=='forge'then return name=='forge'or(name=='qb'or name=='qbx')and contracts[name]==true end
        return name==backend or name=='qb'and backend=='qbx'
    end
    function api.select(supported)
        check();assert(type(supported)=='table','[PR Bridge] supported frameworks must be a list')
        for _,name in ipairs(supported)do if canonical(name)==api.getActive()then return canonical(name)end end
        for _,name in ipairs(supported)do if api.isNative(name)then return canonical(name)end end
        if not config.compatFramework or config.compatFramework=='off'then return nil end
        for _,name in ipairs(supported)do
            name=canonical(name);if name=='esx'or name=='qb'and config.compatQBCore~=false then return name end
        end
    end
    function api.assertAllowed(source,resource)
        check();source=canonical(source);if not resource or resource=='pr_bridge'then return end
        local supported=declarations[resource]
        if not supported then
            pending=pending+1;local result=table.pack(pcall(read,resource));pending=pending-1
            if not result[1]then error(result[2],0)end;check();supported={}
            for i,name in ipairs(result[2]or{})do supported[i]=name end;declarations[resource]=supported
        end
        local selected=api.select(supported)
        if selected and selected~=source and api.isNative(selected)then
            error(('[PR Bridge] %s: %s compatibility blocked; this resource supports the native %s adapter (%s). Use frameworkRouting.select to choose one adapter.')
                :format(resource,source,selected,api.getActive()),2)
        end
    end
    function api.forget(resource)check();declarations[resource]=nil end
    function api.Close()phase='closed';return true end
    function api.Progress()return{phase=phase,pending=pending,complete=phase=='closed'and pending==0}end
    return api
end
