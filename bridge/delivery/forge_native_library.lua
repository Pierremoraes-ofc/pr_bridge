-- Assemble installed lazy PR library and passive cache,keeping native cache separate.
return function(ports)
    local n,pr,public,rpc=assert(ports.native),assert(ports.prCore),assert(ports.public),assert(ports.rpc)
    assert(n.GetCurrentResourceName()=='forge-core','Forge native library resource required')
    local side=n.IsDuplicityVersion()and'server'or'client';assert(rpc.Side==side,'native library side mismatch')
    assert(pr.forgeNativeLibrary==nil,'native library already owned')
    local slots={'cache','library','collections','entities','settings','Player','Entity','Mission','Property','GlobalState','LocalPlayer'}
    for _,key in ipairs(slots)do assert(rawget(public,key)==nil,'occupied native library slot:'..key)end
    local environment=assert(ports.environment);assert(rawget(environment,'__prCanonicalLibrary')==nil,'foreign canonical library')
    local owner,loadModule=assert(ports.isCurrent),assert(ports.load);local env={};for k,v in pairs(environment)do env[k]=v end;setmetatable(env,{__index=environment})
    local nativeCache=assert(ports.nativeCache);assert(type(nativeCache)=='table'and nativeCache.resource=='forge-core','native import cache required')
    local phase='allocated';local owned={};local api={OperationalReady=false,NativeCache=nativeCache};pr.forgeNativeLibrary=api
    local function current()
        if phase=='closed'or pr.forgeNativeLibrary~=api or owner()~=true then return false end
        for key,value in pairs(owned)do if rawget(public,key)~=value then return false end end;return true
    end
    local localPr={context=side,callback=rpc.Native};setmetatable(localPr,{__index=pr})
    function localPr.load(path,target,optional)
        assert(current(),'native PR library unavailable')
        assert(not path:find('/framework',1,true),'native core library cannot select a framework')
        return loadModule(path,target or env,optional)
    end
    env.PRCore,env.pr_lib,env.Bridge,env.cache=localPr,public,public,nativeCache
    local function module(path)return localPr.load('@pr_bridge/'..path)end
    local function capture()for _,key in ipairs(slots)do local value=rawget(public,key);if value~=nil then owned[key]=value end end end
    function api.Prepare()
        if phase~='allocated'or not current()or not rpc.Owners.native.IsReady()then return false end;phase='preparing'
        local ok,problem=pcall(function()
            public.cache=module('bridge/cache/shared')(public,{});capture()
            module('bridge/cache/state')(public,public.cache);capture()
            module('bridge/cache/central')(public.cache);module('bridge/cache/resources')(public.cache)
            api.Library=module('bridge/library/init')(public,env);capture()
            public.settings=module('bridge/settings')(public);capture()
            assert(public.cache~=nativeCache and api.Library.cache==public.cache,'passive/native cache identity mismatch')
            assert(phase=='preparing'and current(),'native library preparation cancelled')
        end)
        if not ok then api.Close();return false,problem end;phase='prepared';api.Cache=public.cache;return true
    end
    function api.Close()
        phase='closed';for key,value in pairs(owned)do if rawget(public,key)==value then rawset(public,key,nil)end end
        if pr.forgeNativeLibrary==api then pr.forgeNativeLibrary=nil end;return true
    end
    function api.IsCurrent()return current()end
    function api.Progress()return{phase=phase,complete=phase=='closed',operationalReady=false,retainedObjectsRevoked=false}end
    return api
end
