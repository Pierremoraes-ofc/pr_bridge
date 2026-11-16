-- Resource-local stable API wrappers. Native caller identity is supplied by Cfx at the Forge endpoint.
return function(ports)
    local current,proxy=assert(ports.isCurrent),assert(ports.proxy);local side=assert(ports.side)
    assert(side=='client'or side=='server','explicit proxy side required')
    local expected=assert(ports.expected);local phase,pending='allocated',0;local generation
    local api={OperationalReady=false,API={}}
    local function valid()local ok,value=pcall(current);return phase~='closed'and ok and value==true end
    local function entered(fn,...)
        pending=pending+1;local out=table.pack(pcall(fn,...));pending=pending-1
        if not out[1]then error(out[2],0)end;return table.unpack(out,2,out.n)
    end
    for group,names in pairs(expected)do api.API[group]={};for _,name in ipairs(names)do
        assert(type(name)=='string'and api.API[group][name]==nil,'unique expected API methods required')
        api.API[group][name]=function(...)
            assert(phase=='prepared'and valid(),'Forge native API proxy unavailable')
            return entered(function(...)return proxy:ForgePrCall(generation,group,name,...)end,...)
        end
    end end
    api.API.getCoreObject=api.API.native and api.API.native.GetCoreObject or nil
    function api.Prepare()
        if phase~='allocated'or not valid()then return false end;phase='preparing'
        local ok,problem=pcall(entered,function()
            local d=proxy:ForgePrDescribe();assert(phase=='preparing'and valid(),'proxy closed during handshake')
            assert(d.protocol=='forge-pr-native/1'and d.authority=='forge-core'and d.side==side and type(d.generation)=='string'and d.generation~='','Forge native API contract mismatch')
            for group,names in pairs(expected)do
                local supplied=assert(d.groups[group]);local have={};for _,name in ipairs(supplied)do assert(not have[name]);have[name]=true end
                assert(#supplied==#names,'Forge native API capacity mismatch');for _,name in ipairs(names)do assert(have[name],'Forge native API method missing')end
            end
            for group in pairs(d.groups)do assert(expected[group],'unexpected Forge native API group')end
            generation=d.generation
        end)
        if not ok then api.Close();return false,problem end;phase='prepared';return true
    end
    function api.Close()phase='closed';return pending==0 end
    function api.Progress()return{phase=phase,pending=pending,complete=phase=='closed'and pending==0}end
    return api
end
