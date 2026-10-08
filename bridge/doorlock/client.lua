local api={}
local tracked, revisions, states = {}, {}, {}
function api.snapshot() return pr_lib.callback.await('ox_doorlock:getDoors',15000) end
function api.ensureRegistration(ids)
    CreateThread(function()
        Wait(200)
        local before={};for _,id in ipairs(ids) do tracked[id]=true;before[id]=revisions[id] or 0 end
        local snapshot=api.snapshot()
        for _,id in ipairs(ids) do
            local door=type(snapshot)=='table' and (snapshot[id] or snapshot[tostring(id)])
            if door and door.doorType~='slide' and door.doorType~='rotate' then
                for _,leaf in ipairs(door.doors or {door}) do
                    if leaf.hash and leaf.coords and leaf.model and not IsDoorRegisteredWithSystem(leaf.hash) then
                        local p=leaf.coords
                        AddDoorToSystem(leaf.hash,leaf.model,p.x,p.y,p.z,false,false,false)
                        local deadline=GetGameTimer()+5000
                        while not DoorSystemGetIsPhysicsLoaded(leaf.hash) and GetGameTimer()<deadline do Wait(50) end
                        local state=(revisions[id] or 0)~=before[id] and states[id] or door.state
                        DoorSystemSetDoorState(leaf.hash,state,false,true)
                    end
                end
            end
        end
    end)
end
RegisterNetEvent('ox_doorlock:setState',function(id,state)
    if source==65535 and tracked[id] then states[id]=state;revisions[id]=(revisions[id] or 0)+1 end
end)
return api
