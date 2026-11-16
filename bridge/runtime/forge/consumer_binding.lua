-- Private opt-in adapter installation. Does not select a framework or replace an occupied runtime slot.
return function(ports)
    assert(ports.side=='client'or ports.side=='server','explicit adapter side required')
    local owner,create=assert(ports.isCurrent),assert(ports.createAdapter)
    local slots={};local seen={}
    for i,s in ipairs(assert(ports.publications))do
        assert(type(s.object)=='table'and type(s.key)=='string','explicit publication slot required')
        seen[s.object]=seen[s.object]or{};assert(not seen[s.object][s.key],'duplicate adapter slot');seen[s.object][s.key]=true
        slots[i]={object=s.object,key=s.key,published=false}
    end;assert(#slots>0,'publication slots required')
    local phase,pending='allocated',0;local adapter,events;local eventOwner={};local leases={};local api={OperationalReady=false}
    local framework={};local backend=ports.backend;local callback=ports.callbacks
    local function current()
        if phase=='closed'or phase=='failed'then return false end
        local ok,value=pcall(owner);if not ok or value~=true then return false end
        for _,s in ipairs(slots)do if s.published and rawget(s.object,s.key)~=framework then return false end end
        return true
    end
    local function check()assert(current(),'forge_adapter_binding_closed')end
    local function tracked(fn,...)
        pending=pending+1;local result=table.pack(pcall(fn,...));pending=pending-1
        if not result[1]then error(result[2],0)end;return table.unpack(result,2,result.n)
    end
    local function guard(fn)return function(...)
        if phase~='installed'or not current()then return end;return tracked(fn,...)
    end end
    local function retire()
        local ok=true
        if events and events.State~='disposed'and events.State~='install-failed'then
            local called,result=pcall(events.Dispose);if not called or result~=true then ok=false end
        end
        for i=#leases,1,-1 do local record=leases[i];if not record.released then
            if record.binding then ok=false else
                local called,result=pcall(callback.Release,record.lease)
                if called and result==true then record.released=true else ok=false end
            end
        end end
        return ok
    end
    local p={};for k,v in pairs(assert(ports.adapter))do p[k]=v end;local prior=assert(p.isCurrent)
    p.isCurrent=function()return phase=='installed'and current()and prior()==true end
    if ports.side=='server'and callback then
        assert(callback.Protocol=='native'and callback.Side=='server','native PR server callback lease provider required')
        for _,name in ipairs({'IsReady','Reserve','Bind','Release'})do assert(type(callback[name])=='function','callback lease port required: '..name)end
        p.callback={register=function(name,fn)
            check();assert(phase=='installed'and callback.IsReady(),'adapter callback transport unavailable');check()
            local lease=callback.Reserve(name);local record={lease=assert(lease),released=false};leases[#leases+1]=record
            if phase~='installed'or not current()then retire();error('forge_adapter_binding_closed',0)end
            record.binding=true;local result=table.pack(pcall(callback.Bind,lease,guard(fn)));record.binding=false
            if phase~='installed'or not current()then retire();error('forge_adapter_binding_closed',0)end
            if not result[1]then error(result[2],0)end;assert(result[2]==true,'adapter callback bind rejected')
        end}
    elseif ports.side=='server'then p.callback=nil end
    adapter=create(p);assert(type(adapter)=='table'and type(adapter.Framework)=='table','adapter factory required');api.Adapter=adapter
    local wrapped={};for name,fn in pairs(adapter.Framework)do
        assert(type(fn)=='function','adapter method required');if not wrapped[fn]then wrapped[fn]=guard(fn)end;framework[name]=wrapped[fn]
    end;api.Framework=framework
    function api.Install()
        if phase~='allocated'then return false,'adapter_binding_not_repeatable'end
        check();for _,s in ipairs(slots)do assert(rawget(s.object,s.key)==nil,'occupied adapter publication: '..s.key)end
        phase='installing'
        local ok,problem=pcall(tracked,function()
            local descriptors={};for i,d in ipairs(adapter.Events or{})do descriptors[i]={owner='PR.ForgeAdapter',name=d.name,network=d.network,sourceFirst=false,handler=guard(d.handler)}end
            if #descriptors>0 then
                local ep=assert(ports.events);events=assert(ports.createEvents)({owner=eventOwner,side=ports.side,entries=descriptors,isCurrent=current},{
                    listen=function(...)check();return ep.listen(...)end,markNetwork=function(...)check();return ep.markNetwork(...)end,
                    remove=assert(ep.remove),source=function()end})
                local installed,reason=events.Install();assert(installed,reason);check()
            end
            for _,s in ipairs(slots)do check();assert(rawget(s.object,s.key)==nil,'adapter publication changed')
                rawset(s.object,s.key,framework);s.published=true
            end
            check()
        end)
        if not ok then api.Close();error(problem,0)end
        phase='installed';return true
    end
    function api.Close()
        phase='closed';adapter.Close();if backend then backend.Close()end
        for _,s in ipairs(slots)do if s.published and rawget(s.object,s.key)==framework then rawset(s.object,s.key,nil)end end
        return retire()
    end
    function api.Progress()
        local a=adapter.Progress();local b=backend and backend.Progress();local remaining=0
        for _,r in ipairs(leases)do if not r.released then remaining=remaining+1 end end
        local state=events and events.State or'absent';local retired=state=='absent'or state=='disposed'or state=='install-failed'
        return{phase=phase,pending=pending+a.pending+(b and b.pending or 0),events=state,callbackLeasesRemaining=remaining,
            complete=phase=='closed'and pending==0 and a.complete and(not b or b.complete)and retired and remaining==0}
    end
    return api
end
