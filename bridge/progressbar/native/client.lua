local progress = {}
local active

local function send(action, data)
    TriggerEvent("pr_bridge:ui:send", action, data)
end

local function requestAnim(dict)
    if not dict or HasAnimDictLoaded(dict) then return true end
    RequestAnimDict(dict)
    local timeout = GetGameTimer() + 5000
    while not HasAnimDictLoaded(dict) and GetGameTimer() < timeout do Wait(0) end
    return HasAnimDictLoaded(dict)
end

local function deleteProps(props)
    for i = 1, #props do
        if DoesEntityExist(props[i]) then DeleteEntity(props[i]) end
    end
end

local function createProps(data, ped)
    local input = data.prop
    if type(input) ~= "table" then return {} end
    if input.model then input = { input } end
    local props = {}
    for i = 1, #input do
        local item = input[i]
        local model = item and item.model
        if model then
            local hash = type(model) == "number" and model or joaat(model)
            RequestModel(hash)
            local timeout = GetGameTimer() + 5000
            while not HasModelLoaded(hash) and GetGameTimer() < timeout do Wait(0) end
            if HasModelLoaded(hash) then
                local entity = CreateObject(hash, 0.0, 0.0, 0.0, true, true, false)
                local pos, rot = item.pos or {}, item.rot or {}
                AttachEntityToEntity(entity, ped, GetPedBoneIndex(ped, item.bone or 60309), pos.x or 0.0, pos.y or 0.0, pos.z or 0.0, rot.x or 0.0, rot.y or 0.0, rot.z or 0.0, true, true, false, true, item.rotOrder or 0, true)
                props[#props + 1] = entity
                SetModelAsNoLongerNeeded(hash)
            end
        end
    end
    return props
end

local function disableControls(disable)
    if not disable then return end
    if disable.move then DisableControlAction(0, 30, true); DisableControlAction(0, 31, true); DisableControlAction(0, 21, true); DisableControlAction(0, 22, true) end
    if disable.car then DisableControlAction(0, 59, true); DisableControlAction(0, 60, true); DisableControlAction(0, 63, true); DisableControlAction(0, 64, true); DisableControlAction(0, 71, true); DisableControlAction(0, 72, true) end
    if disable.combat then DisablePlayerFiring(PlayerId(), true); DisableControlAction(0, 24, true); DisableControlAction(0, 25, true); DisableControlAction(0, 37, true) end
    if disable.mouse then DisableControlAction(0, 1, true); DisableControlAction(0, 2, true) end
    if disable.sprint then DisableControlAction(0, 21, true) end
end

function progress.progressActive()
    return active ~= nil
end

function progress.cancelProgress()
    if active and active.canCancel then active.cancelled = true end
end

function progress.progressBar(data)
    if active or type(data) ~= "table" or type(data.duration) ~= "number" or data.duration <= 0 then return false end
    local ped = PlayerPedId()
    if (IsEntityDead(ped) and not data.useWhileDead) or (IsPedRagdoll(ped) and not data.allowRagdoll) or (IsPedSwimming(ped) and not data.allowSwimming) or (IsPedCuffed(ped) and not data.allowCuffed) or (IsPedFalling(ped) and not data.allowFalling) then return false end

    active = { canCancel = data.canCancel == true, cancelled = false }
    local state = active
    local anim, props = data.anim or {}, createProps(data, ped)
    if anim.scenario then
        TaskStartScenarioInPlace(ped, anim.scenario, 0, anim.playEnter ~= false)
    elseif anim.dict and anim.clip and requestAnim(anim.dict) then
        TaskPlayAnim(ped, anim.dict, anim.clip, anim.blendIn or 3.0, anim.blendOut or 1.0, anim.duration or -1, anim.flag or 49, anim.playbackRate or 0.0, anim.lockX == true, anim.lockY == true, anim.lockZ == true)
    end

    local startedAt = GetGameTimer()
    send("progress:show", { label = data.label, duration = data.duration })
    while GetGameTimer() - startedAt < data.duration and not state.cancelled do
        disableControls(data.disable)
        if state.canCancel and (IsControlJustPressed(0, 177) or IsControlJustPressed(0, 202)) then state.cancelled = true end
        Wait(0)
    end

    send("progress:hide")
    ClearPedTasks(ped)
    deleteProps(props)
    local complete = not state.cancelled
    active = nil
    return complete
end

function progress.doProgressbar(duration, label, anim)
    return progress.progressBar({ duration = duration, label = label, canCancel = true, disable = { move = true }, anim = { dict = anim and anim[1], clip = anim and anim[2] } })
end

return progress