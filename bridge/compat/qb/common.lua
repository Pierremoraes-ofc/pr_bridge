local S=PRCore.load('@pr_bridge/bridge/runtime/compat_services',_ENV)
local H=PRCore.load('@pr_bridge/bridge/frameworks/compat_helpers',_ENV)
return function(owner,context)
    local C={owner=owner,context=context,supported={},copy=H.copy,callable=S.callable}
    function C.target()
        assert(not C.closed,'[PR Bridge QB] consumer stopped')
        if C.routing then C.routing.assertAllowed('qb',owner) end
        local selected=Config.compatFramework
        assert(selected and selected~='off','[PR Bridge QB] framework compatibility disabled')
        local aliases={['qbx_core']='qbx',['qbx-core']='qbx',qbxcore='qbx',['qb-core']='qb',qbcore='qb',
            ['es_extended']='esx',['nd_core']='nd',ndcore='nd',['ox_core']='ox',oxcore='ox',['forge-core']='forge',core='tmc'}
        selected=tostring(selected):lower();selected=aliases[selected] or selected
        local active=ActiveBridges.frameworks
        if selected=='forge' or selected=='auto' then selected=active end
        assert(selected==active,'[PR Bridge QB] compatFramework does not match selected destination')
        assert(Bridge.framework.QBCore,'[PR Bridge QB] destination QB contract unavailable')
        return active
    end
    function C.api() C.target();return Bridge.framework.QBCore end
    function C.define(root,name,fn)
        root[name]=function(...) C.target();return fn(...) end
        C.supported[name]='adapted'
    end
    function C.missing(name,...)
        local backend=C.target()
        return S.call('frameworks',backend,'QBCore.'..name,nil,nil,...)
    end
    function C.fn(name,...) return C.api().Functions[name](...) end
    function C.method(name,...) return C.api().Player[name](...) end
    function C.finish(Q,catalog)
        for name in pairs(catalog[context]) do
            if not Q.Functions[name] then
                Q.Functions[name]=function(...) return C.fn(name,...) end
                C.supported['Functions.'..name]='delegated'
            end
        end
        for name in pairs(catalog.root) do if not Q[name] then Q[name]=function(...) return C.missing(name,...) end end end
        Q.GetCompatibilityCapabilities=function() return C.api().GetCapabilities() end
        Q.GetCompatibilityReport=function()
            local result=C.copy(C.supported)
            for name,capability in pairs(Q.GetCompatibilityCapabilities()) do
                if result[name]~='adapted' then result[name]=capability.available and 'delegated' or 'unsupported' end
            end
            return result
        end
    end
    return C
end
