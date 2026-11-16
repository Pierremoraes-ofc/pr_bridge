-- Select installed PR utilities only;no public init,framework discovery or listener bootstrap.
return function(ports)
    local loadModule,environment,owner=assert(ports.load),assert(ports.environment),assert(ports.isCurrent)
    local closed,pending=false,0;local api={OperationalReady=false,Library={}}
    local function current()local ok,value=pcall(owner);return not closed and ok and value==true end
    local function guard(fn)return function(...)
        assert(current(),'native utilities closed');pending=pending+1
        local out=table.pack(pcall(fn,...));pending=pending-1;if not out[1]then error(out[2],0)end;return table.unpack(out,2,out.n)
    end end
    local function module(name)return loadModule('@pr_bridge/'..name,environment)end
    for key,path in pairs({math='numbers',table='tables',string='strings'})do
        local raw=module('bridge/utils/'..path);local view={};local inherited=environment[key]or{}
        for k,v in pairs(raw)do view[k]=type(v)=='function'and guard(v)or v end
        setmetatable(view,{__index=inherited});api.Library[key]=view
    end
    api.Library.waitFor=guard(module('bridge/utils/waitFor'))
    local streaming=module('bridge/fivem/streaming/client');local objects=module('bridge/fivem/objects/client')
    local queries=module('bridge/delivery/forge_native_queries')({native=environment,objects=objects})
    for name,fn in pairs(queries)do if type(fn)=='function'then api.Library[name]=guard(fn)end end
    for name,target in pairs({requestModel='requestModel',requestAnimDict='requestAnimDict',requestAnimSet='requestAnimSet',
        requestNamedPtfxAsset='requestPtfxAsset',playAnim='playAnim'})do api.Library[name]=guard(assert(streaming[target]))end
    function api.Close()closed=true;return pending==0 end
    function api.Progress()return{closed=closed,pending=pending,complete=closed and pending==0,operationalReady=false}end
    return api
end
