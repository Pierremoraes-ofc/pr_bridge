-- Publish a local control entry; connect to Forge only after an explicit request.
return function(p)
    local e,pr=assert(p.environment),assert(p.prCore)
    assert(pr.forgeConsumerService==nil,'Forge consumer service already installed')
    local resource=e.GetCurrentResourceName()
    local side=e.IsDuplicityVersion()and'server'or'client'
    local env=p.callbackEnvironment or e
    local function module(path)return pr.load('@pr_bridge/'..path,env)end
    local public=p.public
    local closed,completed,preparing=false,false,false
    local runtime,dispatch
    local api={OperationalReady=false}
    pr.forgeConsumerService=api
    local function current()return not closed and pr.forgeConsumerService==api end
    local late={Inventory={},NativeHost={}}
    function api.Ensure()
        assert(current(),'Forge consumer service closed')
        if runtime then return runtime end
        assert(completed,'PR library initialization incomplete')
        assert(not preparing,'reentrant Forge consumer preparation')
        preparing=true
        local ok,result=pcall(function()
            local profile=module('bridge/frameworks/forge/profile')(e)
            assert(profile.Get(resource,side),'Forge integration unavailable for consumer: '..resource)
            local owner=module('bridge/runtime/forge/runtime_consumer')({environment=e,callbackEnvironment=env,
                prCore=pr,public=public,config=p.config,profile=profile,load=module,isCurrent=current,
                readCoreStatus=function()
                    local success,value=pcall(function()return e.exports['forge-core']:ForgeRuntimeStatus()end)
                    return success and value or nil
                end,
                readDeclarations=function(name)
                    local result={}
                    for i=0,e.GetNumResourceMetadata(name,'pr_bridge_framework')-1 do
                        result[#result+1]=e.GetResourceMetadata(name,'pr_bridge_framework',i)
                    end
                    return result
                end,
                registration={available=function(kind,name)
                    return kind=='export'and name=='ForgePrActivationControl'and dispatch==nil
                end,publishExport=function(name,fn)
                    assert(name=='ForgePrActivationControl'and not dispatch,'unexpected consumer publication')
                    dispatch=fn;return true
                end}})
            owner.Complete(public)
            public.forgeLateBinding=late
            return owner
        end)
        preparing=false
        if not ok then error(result,0)end
        runtime=result
        return runtime
    end
    function late.Attach()api.Ensure();return pr.forgeLateBinding.Attach()end
    for _,name in ipairs({'UseItem','setPlayerData','syncInventory','hasLicense','buyLicense','isPlayerBoss','getOwnedVehicleId'})do
        late.Inventory[name]=function(...)
            api.Ensure()
            return assert(pr.forgeLateBinding.Inventory[name],'Forge inventory operation unavailable')(...)
        end
    end
    late.NativeHost.GetCoreObject=function(...)
        api.Ensure()
        return assert(pr.forgeLateBinding.NativeHost.GetCoreObject,'Forge native QB getter unavailable')(...)
    end
    api.LateBinding=late
    function api.Complete(value)
        assert(current()and not completed,'PR library completion already recorded')
        public=assert(value)
        assert(public.forgeLateBinding==nil or public.forgeLateBinding==late,'foreign late binding')
        public.forgeLateBinding=late;completed=true
        return true
    end
    function api.IsReady()return current()and runtime~=nil and runtime.IsReady()end
    function api.Progress()
        if runtime then return runtime.Progress()end
        return{phase=closed and'closed'or'idle',complete=closed,publicReady=completed,operationalReady=false}
    end
    function api.Close()
        closed=true
        local clean=not runtime or runtime.Close()
        if clean and pr.forgeConsumerService==api then pr.forgeConsumerService=nil end
        return clean
    end
    e.exports('ForgePrActivationControl',function(op,generation,instance)
        if e.GetInvokingResource()~='forge-core'or not current()then return nil end
        local profile=module('bridge/frameworks/forge/profile')(e)
        local selected=profile.Get(resource,side)
        if not selected or generation~=profile.Generation or instance~=selected.instance then return nil end
        api.Ensure()
        return assert(dispatch,'Forge local control not prepared')(op,generation,instance)
    end)
    return api
end
