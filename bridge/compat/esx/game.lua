return function(E,C)
    local define=function(name,fn) C.define(E,name,fn) end
    local function coords(p) return p or GetEntityCoords(PlayerPedId()) end
    local pools={Objects='CObject',Peds='CPed',Vehicles='CVehicle'}
    for plural,pool in pairs(pools) do
        define('Game.Get'..plural,function(onlyOthers)
            local r={};for _,entity in ipairs(GetGamePool(pool)) do if not onlyOthers or entity~=PlayerPedId() then r[#r+1]=entity end end;return r
        end)
        local singular=plural:sub(1,-2)
        define('Game.GetClosest'..singular,function(position,models)
            position=coords(position);local nearest,distance=-1,-1
            for _,entity in ipairs(GetGamePool(pool)) do
                if entity~=PlayerPedId() and (not models or models[GetEntityModel(entity)]) then
                    local d=#(GetEntityCoords(entity)-position);if distance==-1 or d<distance then nearest,distance=entity,d end
                end
            end;return nearest,distance
        end)
    end
    define('Game.GetClosestEntity',function(entities,isPlayerEntities,position,modelFilter)
        local nearest,distance=-1,-1;position=coords(position)
        for _,entity in pairs(entities) do local ped=isPlayerEntities and GetPlayerPed(entity) or entity
            if ped~=PlayerPedId() and (not modelFilter or modelFilter[GetEntityModel(ped)]) then
                local d=#(GetEntityCoords(ped)-position);if distance==-1 or d<distance then nearest,distance=entity,d end
            end
        end;return nearest,distance
    end)
    define('Game.StopRaycasting',function(ray) if ray and ray.active then ray:Stop() end end)
    define('Game.IsRaycastActive',function(ray) return ray and ray.active and ray:IsActive() or false end)
    define('Game.GetRaycastResult',function(ray) return ray and ray.active and ray.result or nil end)
    define('Game.GetPedMugshot',function(ped,transparent)
        local handle=transparent and RegisterPedheadshotTransparent(ped) or RegisterPedheadshot(ped)
        local deadline=GetGameTimer()+5000
        while not IsPedheadshotReady(handle) and GetGameTimer()<deadline do Wait(50) end
        if not IsPedheadshotValid(handle) or not IsPedheadshotReady(handle) then UnregisterPedheadshot(handle);return end
        return handle,GetPedheadshotTxdString(handle)
    end)
    define('Game.Utils.DrawText3D',function(p,text,size,font)
        local visible,x,y=World3dToScreen2d(p.x,p.y,p.z);if not visible then return end
        SetTextScale(size or 0.35,size or 0.35);SetTextFont(font or 4);SetTextCentre(true)
        SetTextColour(255,255,255,255);SetTextEntry('STRING');AddTextComponentSubstringPlayerName(text);DrawText(x,y)
    end)
    define('Game.GetPlayers',function() return GetActivePlayers() end)
    define('Game.GetClosestPlayer',function(position) return E.Game.GetClosestEntity(GetActivePlayers(),true,position) end)
    define('Game.GetPlayersInArea',function(position,radius)
        local r={};position=coords(position);for _,id in ipairs(GetActivePlayers()) do if #(GetEntityCoords(GetPlayerPed(id))-position)<=radius then r[#r+1]=id end end;return r
    end)
    define('Game.GetVehiclesInArea',function(position,radius)
        local r={};position=coords(position);for _,v in ipairs(GetGamePool('CVehicle')) do if #(GetEntityCoords(v)-position)<=radius then r[#r+1]=v end end;return r
    end)
    define('Game.IsSpawnPointClear',function(position,radius) return #E.Game.GetVehiclesInArea(position,radius)==0 end)
    define('Game.IsVehicleEmpty',function(vehicle) return GetPedInVehicleSeat(vehicle,-1)==0 and GetVehicleNumberOfPassengers(vehicle)==0 end)
    define('Game.GetVehicleInDirection',function()
        local hit,entity,coords=C.bridge.fivem.raycast.fromCamera(10,2,7,PlayerPedId())
        if hit and entity and IsEntityAVehicle(entity) then return entity,coords end
    end)
    define('Game.Teleport',function(entity,p,cb)
        SetEntityCoords(entity,p.x,p.y,p.z,false,false,false,false);if p.w or p.heading then SetEntityHeading(entity,p.w or p.heading) end;if cb then cb() end
    end)
    define('Game.DeleteVehicle',function(entity) SetEntityAsMissionEntity(entity,true,true);DeleteVehicle(entity) end)
    define('Game.DeleteObject',function(entity) SetEntityAsMissionEntity(entity,true,true);DeleteObject(entity) end)
    define('Game.GetVehicleProperties',function(vehicle) return C.bridge.fivem.vehicleProperties.get(vehicle) end)
    define('Game.SetVehicleProperties',function(vehicle,data) return C.bridge.fivem.vehicleProperties.set(vehicle,data) end)
    local function spawn(model,p,heading,cb,network,vehicle)
        CreateThread(function()
            if C.closed then return end
            local hash=type(model)=='number' and model or joaat(model)
            local ok=C.bridge.fivem.streaming.requestModel(hash,5000);if not ok then if not C.closed and cb then cb(nil) end;return end
            if C.closed then SetModelAsNoLongerNeeded(hash);return end
            local entity=vehicle and CreateVehicle(hash,p.x,p.y,p.z,heading or 0,network,true)
                or CreateObjectNoOffset(hash,p.x,p.y,p.z,network,true,false)
            SetModelAsNoLongerNeeded(hash);if not C.closed and cb then cb(entity~=0 and entity or nil) end
        end)
    end
    define('Game.SpawnVehicle',function(model,p,h,cb) spawn(model,p,h,cb,true,true) end)
    define('Game.SpawnLocalVehicle',function(model,p,h,cb) spawn(model,p,h,cb,false,true) end)
    define('Game.SpawnObject',function(model,p,cb) spawn(model,p,0,cb,true,false) end)
    define('Game.SpawnLocalObject',function(model,p,cb) spawn(model,p,0,cb,false,false) end)
    define('GetVehicleTypeClient',function(model)
        local hash=type(model)=='number' and model or joaat(model)
        if IsThisModelABike(hash) then return 'bike' end;if IsThisModelABoat(hash) then return 'boat' end
        if IsThisModelAHeli(hash) then return 'heli' end;if IsThisModelAPlane(hash) then return 'plane' end;return 'automobile'
    end)
    define('GetVehicleType',E.GetVehicleTypeClient)
    E.Streaming={}
    for legacy,native in pairs({RequestModel='requestModel',RequestAnimDict='requestAnimDict',RequestAnimSet='requestAnimSet',
        RequestStreamedTextureDict='requestTextureDict',RequestNamedPtfxAsset='requestPtfxAsset',RequestWeaponAsset='requestWeaponAsset'}) do
        define('Streaming.'..legacy,function(asset,cb)
            if cb then assert(C.callable(cb),'Expected asset callback') end
            local ok,loaded=C.bridge.fivem.streaming[native](asset,5000);if not ok then return end
            loaded=loaded or ((legacy=='RequestModel' or legacy=='RequestWeaponAsset') and type(asset)=='string' and joaat(asset) or asset)
            if cb then return cb(loaded) end;return loaded
        end)
    end
    PRCore.load('bridge.compat.esx.scaleform')(E,C)
end
