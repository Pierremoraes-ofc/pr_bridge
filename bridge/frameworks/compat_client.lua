local S=PRCore.load('@pr_bridge/bridge/runtime/compat_services',_ENV)
return function(N)
    N.PreviewContext=N.PreviewContext or function()
        return S.exported('esx_context','Preview'), 'esx_context Preview unavailable; configure a readonly preview provider'
    end
    N.SpawnPlayer=N.SpawnPlayer or function()
        local appearance=S.exported('illenium-appearance','setPlayerAppearance')
        if not appearance then return nil,'appearance provider unavailable; configure SpawnPlayer adapter' end
        return function(skin,coords,callback,owner)
            assert(type(skin)=='table' and skin.model,'Legacy ESX skin requires a schema converter; configure SpawnPlayer provider')
            assert(coords and type(coords.x)=='number' and type(coords.y)=='number' and type(coords.z)=='number','Invalid spawn coords')
            if callback then assert(S.callable(callback),'Invalid spawn callback') end
            local heading=coords.heading or coords.w or 0
            local ped=PlayerPedId()
            local wasFrozen=IsEntityPositionFrozen(ped)
            local ok,reason=pcall(function()
                appearance(skin)
                ped=PlayerPedId();FreezeEntityPosition(ped,true)
                RequestCollisionAtCoord(coords.x,coords.y,coords.z)
                SetEntityCoordsNoOffset(ped,coords.x,coords.y,coords.z,false,false,true)
                SetEntityHeading(ped,heading)
                local started=GetGameTimer()
                while not HasCollisionLoadedAroundEntity(ped) and GetGameTimer()-started<5000 do
                    if owner and GetResourceState(owner)~='started' then error('Spawn owner stopped') end
                    Wait(0)
                end
                NetworkResurrectLocalPlayer(coords.x,coords.y,coords.z,heading,0,true)
            end)
            if DoesEntityExist(ped) then FreezeEntityPosition(ped,wasFrozen) end
            if not ok then if callback then callback(false,reason) end;error(reason) end
            TriggerEvent('playerSpawned',coords)
            if callback then callback() end
            return true
        end
    end
    return N
end
