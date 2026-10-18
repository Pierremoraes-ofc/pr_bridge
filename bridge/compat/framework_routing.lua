-- Resource aliases advertise compatibility, not a second native framework.
-- Multi-framework consumers must choose one adapter, preferring the real core.
return function(active, config)
    local routing, declarations = {}, {}
    local aliases = { ['qbx_core']='qbx', ['qbx-core']='qbx', qbxcore='qbx',
        ['qb-core']='qb', qbcore='qb', ['es_extended']='esx',
        ['nd_core']='nd', ['ox_core']='ox', core='tmc' }
    local function canonical(name)
        assert(type(name)=='string', '[PR Bridge] framework name must be a string')
        name=name:lower()
        return aliases[name] or name
    end
    function routing.getActive()
        return active.frameworks or 'default'
    end
    function routing.isNative(name)
        name=canonical(name)
        local backend=routing.getActive()
        return name==backend or name=='qb' and backend=='qbx'
    end
    function routing.select(supported)
        assert(type(supported)=='table', '[PR Bridge] supported frameworks must be a list')
        -- First pass is independent of list order: ESX's provided alias must
        -- never win against a native QB/QBX adapter in the same consumer.
        for _,name in ipairs(supported) do
            if canonical(name)==routing.getActive() then return canonical(name) end
        end
        for _,name in ipairs(supported) do
            if routing.isNative(name) then return canonical(name) end
        end
        if not config.compatFramework or config.compatFramework=='off' then return nil end
        for _,name in ipairs(supported) do
            name=canonical(name)
            if name=='esx' or name=='qb' and config.compatQBCore~=false then return name end
        end
    end
    function routing.assertAllowed(source, owner)
        source=canonical(source)
        if not owner or owner=='pr_bridge' then return end
        local supported=declarations[owner]
        if not supported then
            supported={}
            if GetNumResourceMetadata then
                for index=0,GetNumResourceMetadata(owner,'pr_bridge_framework')-1 do
                    supported[#supported+1]=GetResourceMetadata(owner,'pr_bridge_framework',index)
                end
            end
            declarations[owner]=supported
        end
        local selected=routing.select(supported)
        if selected and selected~=source and routing.isNative(selected) then
            error(('[PR Bridge] %s: %s compatibility blocked; this resource supports the native %s adapter (%s). Use frameworkRouting.select to choose one adapter.')
                :format(owner,source,selected,routing.getActive()),2)
        end
    end
    function routing.forget(owner) declarations[owner]=nil end
    return routing
end
