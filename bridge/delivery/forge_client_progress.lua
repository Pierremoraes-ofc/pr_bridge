-- Own one installed progress module per Forge PRCore;the existing engine keeps all progress semantics.
return function(ports)
    local pr=assert(ports.prCore);assert(pr.resource=='forge-core'and pr.context=='client','Forge client PRCore required')
    assert(pr.forgeProgressScope==nil,'progress scope already owned')
    local owner,events=assert(ports.isCurrent),assert(ports.events)
    local phase,pending,uncertain='allocated',0,false;local tokens={};local engine;local errors={};local api={Library={},OperationalReady=false}
    pr.forgeProgressScope=api
    local function current()local ok,v=pcall(owner);return phase~='closed'and pr.forgeProgressScope==api and ok and v==true end
    local function invoke(fn,...)
        assert(phase=='open'and current(),'client progress unavailable');pending=pending+1
        local out=table.pack(pcall(fn,...));pending=pending-1
        if not out[1]then error(out[2],0)end;return table.unpack(out,2,out.n)
    end
    local names={'progressBar','progressCircle','progressActive','cancelProgress','doProgressbar','doProgressCircle'}
    for _,name in ipairs(names)do api.Library[name]=function(...)return invoke(assert(engine and engine[name]),...)end end
    api.Library.progress=api.Library;api.Library.progressbar=api.Library;api.Library.nativeProgress=api.Library
    setmetatable(api.Library,{__call=function(_,data)return api.Library.progressBar(data)end})
    function api.CloseIngress()
        if phase=='closed'then return true end;phase='closing'
        if engine then
            -- The whole module is owned here,including calls invoked by another resource.
            local ok,err=pcall(engine.cancelProgress,true);if not ok then errors[#errors+1]=tostring(err);uncertain=true end
        end
        local done=not uncertain
        for i=#tokens,1,-1 do if tokens[i]then local ok,v=pcall(events.remove,tokens[i]);if ok and v~=false then tokens[i]=false else done=false end end end
        return done
    end
    function api.Close()
        local done=api.CloseIngress();if not done or pending~=0 then return false end
        phase='closed';if pr.forgeProgressScope==api then pr.forgeProgressScope=nil end;return true
    end
    function api.Open()
        if phase~='allocated'or not current()then return false end;phase='opening'
        local ok,err=pcall(function()
            local env={};for k,v in pairs(assert(ports.environment))do env[k]=v end
            assert(env.GetCurrentResourceName()=='forge-core','progress engine resource mismatch')
            env.Bridge={settings=assert(ports.settings),fivem={streaming=assert(ports.streaming)}};env.pr_lib=env.Bridge
            env.AddEventHandler=function(name,fn)
                assert(phase=='opening'and name=='onClientResourceStop','progress listener ownership required')
                local token=events.listen(name,function(...)if phase=='open'and current()then return fn(...)end end)
                if token==nil or token==false then uncertain=true;error('progress listener handle missing',0)end
                tokens[#tokens+1]=token;return token
            end
            engine=assert(ports.load)('@pr_bridge/bridge/progressbar/native/client',env)
            for _,name in ipairs(names)do assert(type(engine[name])=='function','installed progress method required:'..name)end
            assert(phase=='opening'and current(),'progress opening cancelled')
        end)
        if not ok then errors[#errors+1]=tostring(err);api.Close();return false,err end;phase='open';return true
    end
    function api.Progress()local count=0;for _,v in pairs(tokens)do if v then count=count+1 end end
        return{phase=phase,pending=pending,listeners=count,uncertain=uncertain,errors=errors,complete=phase=='closed'and pending==0 and count==0 and not uncertain,operationalReady=false}
    end
    function api.IsCurrent()return current()end
    return api
end
