-- Concrete engine inputs;borrow LocalPlayer/settings and resolve the already owned UI streaming lazily.
local names={'GetCurrentResourceName','GetInvokingResource','GetGameTimer','Wait','PlayerPedId','PlayerId','IsEntityDead','IsPedRagdoll','IsPedCuffed','IsPedFalling','IsPedSwimming',
    'IsModelAPed','IsModelAVehicle','GetModelDimensions','DisableControlAction','DisablePlayerFiring','IsControlJustPressed','TaskPlayAnim','TaskStartScenarioInPlace','StopAnimTask','ClearPedTasks','TriggerEvent','TriggerServerEvent'}
local api={OperationalReady=false}
function api.Names()local out={};for i,n in ipairs(names)do out[i]=n end;return out end
function api.Build(ports)
    local execution=assert(ports.execution);assert(execution.IsCurrent()and not execution.Native.IsDuplicityVersion(),'current client execution required')
    local player,settings,getUI=assert(ports.localPlayer),assert(ports.settings),assert(ports.getUI)
    assert(player.state~=nil and type(settings.get)=='function'and type(getUI)=='function','existing player/settings/UI getter required')
    local env={};for k,v in pairs(assert(ports.environment))do env[k]=v end
    for name,fn in pairs(execution.Bind(names))do env[name]=fn end;env.LocalPlayer=player
    local streaming={};for _,name in ipairs({'requestModel','releaseModel','requestAnimDict','releaseAnimDict'})do
        streaming[name]=function(...)local ui=assert(getUI(),'owned UI not allocated');return assert(ui.Streaming[name],'owned UI streaming not open:'..name)(...)end
    end
    return{Environment=env,Streaming=streaming,Settings=settings,LocalPlayer=player,OperationalReady=false}
end
return api
