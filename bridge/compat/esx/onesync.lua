return function(E,C)
    local define=function(name,fn) C.define(E,'OneSync.'..name,fn) end
    local function spawn(cb,create,configure)
        local pending=not cb and promise.new()
        CreateThread(function()
            local entity
            local ok,result=pcall(function()
                assert(not C.closed,'ESX spawn cancelled: consumer stopped')
                entity=create();assert(entity and entity~=0,'ESX entity creation failed')
                local deadline=GetGameTimer()+5000
                while not C.closed and not DoesEntityExist(entity) and GetGameTimer()<deadline do Wait(50) end
                if C.closed then DeleteEntity(entity);error('ESX spawn cancelled: consumer stopped') end
                assert(DoesEntityExist(entity),'ESX entity streaming timed out')
                if configure then configure(entity) end
                return NetworkGetNetworkIdFromEntity(entity)
            end)
            if not ok and entity and entity~=0 and not C.closed then DeleteEntity(entity) end
            if pending then if ok then pending:resolve(result) else pending:reject(result) end
            elseif cb and not C.closed then cb(ok and result or false) end
        end)
        if pending then return Citizen.Await(pending) end
    end
    local function position(value)
        if type(value)=='number' then return GetEntityCoords(GetPlayerPed(value)) end
        assert(value and value.x and value.y and value.z,'Expected player source or coordinates')
        return vector3(value.x,value.y,value.z)
    end
    local function players(source,radius,ignore,bucket,closest)
        local p=position(source);local result={};radius=radius or 100;ignore=ignore or {}
        for _,id in ipairs(GetPlayers()) do
            id=tonumber(id);local ped=GetPlayerPed(id)
            if ped~=0 and not ignore[id] and (not closest or id~=source)
                and (not bucket or GetPlayerRoutingBucket(id)==bucket) then
                local coords=GetEntityCoords(ped);local distance=#(coords-p)
                if distance<=radius then
                    local entry={id=id,ped=NetworkGetNetworkIdFromEntity(ped),coords=coords,dist=distance}
                    if closest then if not result.dist or distance<result.dist then result=entry end
                    else result[#result+1]=entry end
                end
            end
        end;return result
    end
    define('GetPlayersInArea',function(source,radius,ignore,bucket) return players(source,radius,ignore,bucket,false) end)
    define('GetClosestPlayer',function(source,radius,ignore,bucket) return players(source,radius,ignore,bucket,true) end)
    for singular,pool in pairs({Ped='GetAllPeds',Object='GetAllObjects',Vehicle='GetAllVehicles'}) do
        local function eligible(entity,filter) return DoesEntityExist(entity) and (singular~='Ped' or not IsPedAPlayer(entity))
            and (not filter or filter[GetEntityModel(entity)]) end
        define('Get'..singular..'sInArea',function(coords,radius,filter)
            local p=position(coords);local result={}
            for _,entity in pairs(_ENV[pool]()) do if eligible(entity,filter) and (not radius or #(GetEntityCoords(entity)-p)<=radius) then
                result[#result+1]=NetworkGetNetworkIdFromEntity(entity)
            end end;return result
        end)
        define('GetClosest'..singular,function(coords,filter)
            local p=position(coords);local nearest,distance,location=0,100,vector3(0,0,0)
            for _,entity in pairs(_ENV[pool]()) do if eligible(entity,filter) then
                local current=GetEntityCoords(entity);local d=#(current-p)
                if d<distance then nearest,distance,location=entity,d,current end
            end end
            return nearest==0 and 0 or NetworkGetNetworkIdFromEntity(nearest),distance,location
        end)
    end
    define('SpawnObject',function(model,p,h,cb)
        local hash=type(model)=='number' and model or joaat(model)
        return spawn(cb,function() return CreateObjectNoOffset(hash,p.x,p.y,p.z,true,true,false) end,function(entity) SetEntityHeading(entity,h or 0) end)
    end)
    define('SpawnPed',function(model,p,h,cb)
        return spawn(cb,function() return CreatePed(4,type(model)=='number' and model or joaat(model),p.x,p.y,p.z,h or 0,true,true) end)
    end)
    define('SpawnPedInVehicle',function(model,vehicle,seat,cb)
        return spawn(cb,function() return CreatePedInsideVehicle(vehicle,4,type(model)=='number' and model or joaat(model),seat,true,true) end)
    end)
    define('SpawnVehicle',function(model,p,h,properties,cb,kind)
        if type(cb)=='string' and not kind then kind,cb=cb,nil end
        return spawn(cb,function()
            kind=kind or E.GetVehicleType(model)
            return CreateVehicleServerSetter(type(model)=='number' and model or joaat(model),kind,p.x,p.y,p.z,h or 0)
        end,function(entity)
            SetEntityOrphanMode(entity,2)
            if properties then
                -- queue() always publishes a state bag. set() honours the native
                -- cache/owner policy and Config.Fivem's explicit replication flags.
                local deadline=GetGameTimer()+5000
                while not C.closed do
                    if C.invoke(C.bridge.fivem.vehicleProperties,'set',entity,properties) then return end
                    if GetGameTimer()>=deadline then error('ESX vehicle properties could not reach an owner within 5s') end
                    Wait(50)
                end
                DeleteEntity(entity);error('ESX spawn cancelled: consumer stopped')
            end
        end)
    end)
end
