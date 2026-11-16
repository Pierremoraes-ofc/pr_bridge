-- Revision222:installed consumer UI/streaming,owned by the existing99 event boundary;no second NUI host.
return function(ports)
    local pr,public,library=assert(ports.prCore),assert(ports.public),assert(ports.library)
    assert(pr.context=='client'and pr.resource=='forge-core','Forge client UI required')
    assert(pr.forgeClientUI==nil,'client UI already owned')
    local events,loadModule,owner=assert(ports.events),assert(ports.load),assert(ports.isCurrent)
    local env={};for k,v in pairs(assert(ports.environment))do env[k]=v end;setmetatable(env,{__index=ports.environment})
    local phase,pending,uncertain='allocated',0,false;local tokens={};local ui;local api={OperationalReady=false,Streaming={}}
    pr.forgeClientUI=api
    local function current()local ok,value=pcall(owner);return phase~='closed'and pr.forgeClientUI==api and ok and value==true end
    local tasks=assert(ports.createTasks)({isCurrent=current,running=assert(ports.running),onError=assert(ports.onError)})
    local scheduler=tasks.WrapNative({Wait=env.Wait,CreateThread=env.CreateThread,SetTimeout=env.SetTimeout})
    env.Wait,env.CreateThread,env.SetTimeout=scheduler.Wait,scheduler.CreateThread,scheduler.SetTimeout
    local function invoke(fn,...)
        assert(phase=='open'and current(),'native client UI unavailable');pending=pending+1
        local out=table.pack(pcall(fn,...));pending=pending-1;if not out[1]then error(out[2],0)end;return table.unpack(out,2,out.n)
    end
    local localPr={context='client'};setmetatable(localPr,{__index=pr})
    function localPr.load(path,target)return loadModule(path,target or env)end
    env.PRCore,env.Bridge,env.pr_lib=localPr,public,public
    env.AddEventHandler=function(name,fn)
        assert(phase=='opening'and current(),'UI registration outside Open')
        local token=events.listen(name,function(...)if phase=='open'and current()then return invoke(fn,...)end end)
        if token==nil or token==false then uncertain=true;error('UI registration handle missing',0)end
        tokens[#tokens+1]=token;return token
    end
    local aliases={registerContext='RegisterContext',showContext='ShowContext',hideContext='HideContext',getOpenContextMenu='GetOpenContextMenu',
        registerMenu='RegisterMenu',showMenu='ShowMenu',hideMenu='HideMenu',getOpenMenu='GetOpenMenu',inputDialog='InputDialog',alertDialog='AlertDialog',
        closeInputDialog='closeInputDialog',closeAlertDialog='closeAlertDialog',notify='Notify',showTextUI='ShowTextUI',hideTextUI='HideTextUI',isTextUIOpen='IsTextUIOpen',openVisualAdminMenu='OpenVisualAdminMenu'}
    local view={};for name,target in pairs(aliases)do view[name]=function(...)return invoke(assert(ui and ui[target],'UI method unavailable:'..target),...)end end
    setmetatable(view,{__index=library});api.Library=view
    function api.Open()
        if phase~='allocated'or not current()then return false end;phase='opening';assert(tasks.Open(),'UI task scope unavailable')
        local ok,problem=pcall(function()
            ui=localPr.load('@pr_bridge/interface/client/ui');assert(type(ui)=='table','native UI missing')
            local stream=localPr.load('@pr_bridge/bridge/fivem/streaming/client')
            for _,name in ipairs({'requestModel','requestAnimDict','createObject','createPed','createVehicle','deleteEntity','releaseModel','releaseAnimDict','playAnim','requestAnimSet','requestPtfxAsset'})do
                local fn=assert(stream[name]);api.Streaming[name]=function(...)return invoke(fn,...)end
            end
            assert(phase=='opening'and current(),'native UI opening cancelled')
        end)
        if not ok then api.Close();return false,problem end;phase='open';return true
    end
    function api.Close()
        if phase~='closed'then
            phase='closed';tasks.Close()
            if ui then for _,name in ipairs({'closeInputDialog','closeAlertDialog','HideContext','HideMenu','HideTextUI'})do
                if type(ui[name])=='function'then pcall(ui[name])end
            end end
        end
        local complete=not uncertain
        for i=#tokens,1,-1 do local r=tokens[i];if r then local ok,result=pcall(events.remove,r);if ok and result~=false then tokens[i]=false else complete=false end end end
        complete=complete and tasks.Snapshot().quiescent
        if complete and pending==0 and pr.forgeClientUI==api then pr.forgeClientUI=nil end
        return complete and pending==0
    end
    function api.Progress()local remaining=0;for _,v in pairs(tokens)do if v then remaining=remaining+1 end end
        local t=tasks.Snapshot();return{phase=phase,pending=pending,listeners=remaining,uncertain=uncertain,tasks=t,complete=phase=='closed'and pending==0 and remaining==0 and not uncertain and t.quiescent,operationalReady=false}
    end
    return api
end
