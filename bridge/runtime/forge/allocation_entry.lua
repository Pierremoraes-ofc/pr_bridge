-- Candidate executed in each external PR consumer environment. No handshake,core read or Attach during construction.
return function(pr,public,config,activation)
    assert(type(activation)=='table','explicit Forge activation ports required before PR selection')
    local resource=GetCurrentResourceName();local side=IsDuplicityVersion()and'server'or'client'
    assert(resource~='forge-core'and resource~='qbx_core','core/compat must use their raw/internal PR bootstrap')
    assert(pr.forgeConsumerEntry==nil,'Forge consumer entry already owned')
    local instance=assert(activation.instance,'fresh consumer instance required');assert(type(instance)=='string'and instance~='')
    assert(type(activation.isExportAvailable)=='function','consumer export namespace required')
    local closed=false;local binding,proxy,token;local epoch;local nativeForge=exports['forge-core'];local api={OperationalReady=false};pr.forgeConsumerEntry=api
    local function current()return not closed and pr.forgeConsumerEntry==api and activation.isCurrent()==true end
    local function module(name)return pr.load('@pr_bridge/'..name)end
    local function retire()
        local ok=true;if binding then ok=binding.Close()and ok end;if proxy then ok=proxy.Close()and ok end
        if token then local called,value=pcall(RemoveEventHandler,token);if called and value~=false then token=nil else ok=false end end
        if ok and pr.forgeConsumerEntry==api then pr.forgeConsumerEntry=nil end;return ok
    end
    function api.Close()closed=true;return retire()end
    function api.Describe()return{protocol='forge-pr-consumer/1',resource=resource,side=side,instance=instance,current=current(),
        phase=binding and binding.Progress().phase or'allocated',proxyReady=proxy and proxy.Progress().phase=='prepared'or false}end
    local ok,problem=pcall(function()
        assert(type(activation.isCurrent)=='function'and type(activation.isReady)=='function'and type(activation.readProviders)=='function')
        local expected=module('bridge/frameworks/forge/native_api_schema')(side,assert(activation.contracts))
        local transport={ForgePrDescribe=function()local d=nativeForge:ForgePrDescribe();epoch=d and d.generation;return d end,
            ForgePrCall=function(_,...)return nativeForge:ForgePrCall(...)end}
        proxy=module('bridge/frameworks/forge/native_api_factory')({side=side,expected=expected,isCurrent=current,proxy=transport})
        local native={};for _,name in ipairs(module('bridge/runtime/forge/native_names'))do native[name]=_ENV[name]end
        binding=module('bridge/runtime/forge/native_bindings_factory')({native=native,load=module,prCore=pr,public=public,config=config,
            contracts=activation.contracts,inventory=resource=='ox_inventory'and side=='server',api=proxy.API,
            isCurrent=current,isReady=activation.isReady,readDeclarations=assert(activation.readDeclarations),
            createEvents=module('bridge/runtime/forge/event_registration'),view=activation.view,cacheNamespace=activation.cacheNamespace,
            readSessionReady=activation.readSessionReady,getServices=function()return activation.readProviders(public)end})
        assert(binding.Prepare(),'Forge consumer allocation failed')
        assert(activation.isExportAvailable('ForgePrConsumerDescribe')==true,'consumer descriptor export occupied')
        exports('ForgePrConsumerDescribe',function()if current()then return api.Describe()end end)
        token=AddEventHandler(side=='server'and'onResourceStop'or'onClientResourceStop',function(name)if name==resource then api.Close()end end)
        assert(token~=nil and token~=false,'owned consumer stop token required')
        assert(current(),'consumer entry changed during preparation')
    end)
    if not ok then api.Close();error(problem,0)end
    function api.Attach()
        if not current()then return false end
        local out=table.pack(pcall(function()
            assert(proxy.Prepare());assert(nativeForge:ForgePrConsumerState(epoch,instance,'attaching'))
            assert(binding.Attach());return nativeForge:ForgePrConsumerState(epoch,instance,'committed')
        end))
        if not out[1]or out[2]~=true then api.Close();return false,out[1]and out[3]or out[2]end
        return true
    end
    function api.Progress()return{closed=closed,binding=binding and binding.Progress(),proxy=proxy and proxy.Progress(),stopTokenRetained=token~=nil,
        complete=closed and token==nil and(not binding or binding.Progress().complete)and(not proxy or proxy.Progress().complete)}end
    return api
end
