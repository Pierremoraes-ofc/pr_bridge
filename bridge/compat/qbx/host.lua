-- Executes in the legacy resource context, preserving Cfx caller ownership.
assert(GetCurrentResourceName()=='pr_bridge','PR compatibility host context required')
local function module(path)
    local source=assert(LoadResourceFile('pr_bridge',path..'.lua'),'PR QBX module unavailable: '..path)
    return assert(load(source,'@@pr_bridge/'..path..'.lua','t',_ENV))()
end
local side=IsDuplicityVersion()and'server'or'client'
local names=module('bridge/compat/qbx/catalog')[side]
local transport=module('bridge/frameworks/forge/legacy_transport')(_ENV)
local alive,generation=true,nil
local timeout=GetConvarInt('forge:activationTimeout',120000)
assert(timeout>=1000 and timeout<=600000,'bounded QBX compatibility timeout required')
local qb=side=='server'and GetConvar('qbx:enablebridge','true')=='true'
local function validate(s)
    local d=transport.Describe()
    assert(type(d)=='table','QBX gateway descriptor unavailable')
    assert(d.protocol=='forge-qbx-compat/1'and d.authority=='forge-core'and d.side==side and d.generation==s.generation,'QBX gateway identity mismatch')
    assert(#d.names==#names,'QBX gateway surface mismatch')
    local found={}
    for _,name in ipairs(d.names)do assert(not found[name],'duplicate QBX operation');found[name]=true end
    for _,name in ipairs(names)do assert(found[name],'QBX operation unavailable: '..name)end
    local q=transport.DescribeQB()
    assert(type(q)=='table','QB extension descriptor unavailable')
    assert(q.protocol=='forge-qbx-qb/1'and q.side==side and q.generation==d.generation and q.setField==qb,'QB extension identity mismatch')
    generation=d.generation
end
local function awaitReady()
    local begin=GetGameTimer()
    while alive do
        local ok,s=pcall(transport.Status)
        assert(not ok or not s or s.phase~='failed','Forge activation failed')
        -- Physical compat exports are gated by ingress_ports until stage6, including catalog reads.
        if ok and s and s.ingressOpen==true and(s.stage or 0)>=6 then
            if generation~=s.generation then validate(s)end
            return
        end
        assert(GetGameTimer()-begin<timeout,'timeout awaiting Forge compatibility')
        Wait(25)
    end
    error('QBX compatibility stopped',0)
end
local function publish(name,isQB)
    local handler=function(...)
        local caller=GetInvokingResource()
        assert(type(caller)=='string'and caller~=''and caller~='qbx_core','identified external caller required')
        awaitReady()
        if isQB then return transport.CallQB(generation,name,caller,...)end
        return transport.Call(generation,name,caller,...)
    end
    AddEventHandler('__cfx_export_qbx_core_'..name,function(setCallback)if alive then setCallback(handler)end end)
end
for _,name in ipairs(names)do publish(name,false)end
if qb then publish('SetField',true)end
assert(PRCore and not PRCore.forgeLegacyCompatibility,'PR legacy compatibility already owned')
PRCore.forgeLegacyCompatibility={CallQB=function(name,...)
    local caller=GetInvokingResource()
    assert(type(caller)=='string'and caller~=''and caller~='qbx_core','identified external caller required')
    awaitReady()
    return transport.CallQB(generation,name,caller,...)
end}
AddEventHandler(side=='server'and'onResourceStop'or'onClientResourceStop',function(name)
    if name=='forge-core'or name=='pr_bridge'then alive=false end
end)
-- No startup thread, export probe, player lookup or wait. Calls initiate readiness checks.
