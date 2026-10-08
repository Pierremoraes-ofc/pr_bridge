-- Session-scoped emote cleanup. Never delete arbitrary player/world objects.
local api={}
function api.play(command)
    if GetResourceState('scully_emotemenu')~='started' then return false end
    exports.scully_emotemenu:playEmoteByCommand(command)
    return true
end
function api.beginSession(models)
    local session={ped=PlayerPedId(),models={},baseline={}}
    for _,name in ipairs(models or {}) do session.models[joaat(name)]=true end
    for _,entity in ipairs(GetGamePool('CObject')) do session.baseline[entity]=true end
    return session
end
function api.finishSession(session)
    if not session or session.finished then return end
    session.finished=true
    if session.emoteStarted and GetResourceState('scully_emotemenu')=='started' then
        local ok,err=pcall(function() exports.scully_emotemenu:cancelEmote() end)
        if not ok then print('[pr_bridge:emotes] '..tostring(err)) end
    end
    for _,entity in ipairs(GetGamePool('CObject')) do
        if not session.baseline[entity] and DoesEntityExist(entity)
            and session.models[GetEntityModel(entity)] and IsEntityAttachedToEntity(entity,session.ped) then
            DetachEntity(entity,true,true)
            SetEntityAsMissionEntity(entity,true,true)
            DeleteEntity(entity)
        end
    end
end
return api
