-- Native IO ports owned by Forge through its installed PRCore. Existing persistence semantics remain in PR.
return function(ports)
    local n,core,codec=assert(ports.native),assert(ports.core),assert(ports.json)
    assert(n.GetCurrentResourceName()=='forge-core'and core.resource=='forge-core','resource-local Forge PRCore required')
    local side=n.IsDuplicityVersion()and'server'or'client';assert(core.context==side,'IO side mismatch')
    local current=assert(ports.isCurrent);local closed,pending=false,0;local refs={};local api={OperationalReady=false,Files={},JSON={},Codec={}}
    local function valid()
        local ok,value=pcall(current);if closed or not ok or value~=true or n.GetCurrentResourceName()~='forge-core'or core.context~=side then return false end
        for _,r in ipairs(refs)do if r.owner[r.key]~=r.value then return false end end;return true
    end
    local wrapped={};local function bind(owner,key,target)
        local fn=owner[key];if fn==nil then return end;assert(type(fn)=='function','native IO function required: '..key)
        refs[#refs+1]={owner=owner,key=key,value=fn}
        if not wrapped[fn]then wrapped[fn]=function(...)
            assert(valid(),'Forge native IO unavailable');pending=pending+1
            local result=table.pack(pcall(fn,...));pending=pending-1
            if not result[1]then error(result[2],0)end;return table.unpack(result,2,result.n)
        end end;target[key]=wrapped[fn]
    end
    assert(type(n.LoadResourceFile)=='function'and type(core.loadJson)=='function'and type(codec.decode)=='function'and type(codec.encode)=='function')
    for _,key in ipairs({'LoadResourceFile','SaveResourceFile'})do bind(n,key,api.Files)end
    for _,key in ipairs({'loadJson','readJson','saveJson','writeJson','updateJson','mergeJson','deleteJson','jsonExists',
        'loadJsonRecovery','saveJsonRecovery','saveJsonBatch','withJsonLock','jsonDraft','wrapJsonMutations','recordJsonIncident'})do bind(core,key,api.JSON)end
    for _,key in ipairs({'encode','decode'})do bind(codec,key,api.Codec)end
    function api.Close()closed=true;return pending==0 end
    function api.Progress()return{closed=closed,pending=pending,complete=closed and pending==0,operationalReady=false}end
    function api.Describe()local names={};for k in pairs(api.JSON)do names[#names+1]=k end;table.sort(names);return{side=side,resource='forge-core',json=names,operationalReady=false}end
    return api
end
