return function(Q,C)
    local function define(name,fn) C.define(Q.Functions,name,fn);C.supported[name]=nil;C.supported['Functions.'..name]='adapted' end
    function C.sync()
        local snapshot=C.api().GetPlayerData(GetPlayerServerId(PlayerId())) or {}
        Q.PlayerData=C.copy(snapshot);return snapshot
    end
    define('GetPlayerData',function(callback) local data=C.copy(C.sync());if callback then callback(data) else return data end end)
    define('GetName',function() local info=(C.sync().charinfo or {});return (info.firstname or '')..' '..(info.lastname or '') end)
    define('GetCoords',function(entity) local p=GetEntityCoords(entity);return vector4(p.x,p.y,p.z,GetEntityHeading(entity)) end)
    define('GetVehicles',function() return Bridge.fivem.objects.getPool('CVehicle') end)
    define('GetObjects',function() return Bridge.fivem.objects.getPool('CObject') end)
    define('GetPlayers',GetActivePlayers)
    define('GetPlayersFromCoords',function(coords,radius)
        coords=coords or GetEntityCoords(PlayerPedId());local result={}
        for _,player in ipairs(GetActivePlayers()) do if #(GetEntityCoords(GetPlayerPed(player))-coords)<=(radius or 5) then result[#result+1]=player end end
        return result
    end)
    define('GetClosestPlayer',function(coords)
        coords=coords or GetEntityCoords(PlayerPedId());local closest,distance=-1,-1
        for _,player in ipairs(GetActivePlayers()) do if player~=PlayerId() then
            local d=#(GetEntityCoords(GetPlayerPed(player))-coords);if distance<0 or d<distance then closest,distance=player,d end
        end end;return closest,distance
    end)
    for name,pool in pairs({GetClosestVehicle='CVehicle',GetClosestObject='CObject',GetClosestPed='CPed'}) do
        define(name,function(coords,ignore)
            local excluded={};for _,entity in pairs(ignore or {}) do excluded[entity]=true end
            coords=coords or GetEntityCoords(PlayerPedId());local closest,distance=-1,-1
            for _,entity in ipairs(Bridge.fivem.objects.getPool(pool)) do if entity~=PlayerPedId() and not excluded[entity] then
                local d=#(GetEntityCoords(entity)-coords);if distance<0 or d<distance then closest,distance=entity,d end
            end end;return closest,distance
        end)
    end
    define('GetPeds',function(ignore)
        local excluded,result={},{};for _,entity in pairs(ignore or {}) do excluded[entity]=true end
        for _,entity in ipairs(Bridge.fivem.objects.getPool('CPed')) do if not excluded[entity] then result[#result+1]=entity end end;return result
    end)
    for name,native in pairs({LoadModel='requestModel',RequestAnimDict='requestAnimDict',LoadAnimSet='requestAnimSet',LoadParticleDictionary='requestNamedPtfxAsset'}) do
        define(name,function(value,timeout)
            local fn=Bridge.fivem.streaming[native];assert(C.callable(fn),'PR streaming capability unavailable: '..native)
            local ok,hash=fn(value,timeout);if not ok then error('QB asset load failed: '..tostring(value)) end;return hash or value
        end)
    end
    define('GetVehicleProperties',function(entity) return Bridge.fivem.getVehicleProperties(entity) end)
    define('SetVehicleProperties',function(entity,properties) return Bridge.fivem.setVehicleProperties(entity,properties) end)
    define('GetPlate',function(entity) return Q.Shared.Trim(GetVehicleNumberPlateText(entity)) end)
    define('DeleteVehicle',function(entity) SetEntityAsMissionEntity(entity,true,true);DeleteVehicle(entity) end)
    define('SpawnVehicle',function(model,callback,coords,networked,warp)
        assert(C.callable(callback),'Spawn callback required');coords=coords or GetEntityCoords(PlayerPedId())
        local ok,hash=Bridge.fivem.streaming.requestModel(model,5000)
        if not ok then callback(nil,'model_unavailable');return end
        if C.closed then Bridge.fivem.streaming.releaseModel(hash);return end
        local entity=CreateVehicle(hash,coords.x,coords.y,coords.z,coords.w or coords.heading or 0,networked~=false,false)
        Bridge.fivem.streaming.releaseModel(hash)
        if not entity or entity==0 then callback(nil,'spawn_failed');return end
        SetEntityAsMissionEntity(entity,true,true);SetVehicleNeedsToBeHotwired(entity,false)
        if warp then SetPedIntoVehicle(PlayerPedId(),entity,-1) end
        callback(entity)
    end)
    define('SpawnClear',function(coords,radius)
        for _,vehicle in ipairs(Bridge.fivem.objects.getPool('CVehicle')) do if #(GetEntityCoords(vehicle)-coords)<=(radius or 5) then return false end end;return true
    end)
    define('Progressbar',function(name,label,duration,useWhileDead,cancel,disable,animation,prop,propTwo,finish,aborted)
        local data={label=label,duration=duration,useWhileDead=useWhileDead,canCancel=cancel,
            disable={move=disable and disable.disableMovement,car=disable and disable.disableCarMovement,
                mouse=disable and disable.disableMouse,combat=disable and disable.disableCombat},
            anim=animation and {dict=animation.animDict,clip=animation.anim,flag=animation.flags},prop={}}
        for _,p in ipairs({prop or {},propTwo or {}}) do if p.model then
            data.prop[#data.prop+1]={model=p.model,bone=p.bone,pos=p.coords,rot=p.rotation}
        end end
        CreateThread(function()
            local result=Bridge.nativeProgress.progressBar(data)
            if not C.closed then local handler=result and finish or aborted;if handler then handler() end end
        end)
    end)
    for name,method in pairs({DrawText='show',ChangeText='change',HideText='hide',KeyPressed='keyPressed'}) do
        Q[name]=function(...) C.target();return Bridge.fivem.drawtext[method](...) end
    end
end
