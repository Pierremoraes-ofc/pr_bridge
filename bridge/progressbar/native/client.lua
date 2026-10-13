-- Single native progress engine, shared by PR callers and legacy adapters.
local progress, active = {}, nil
local state = LocalPlayer.state
local function send(action, data) TriggerEvent("pr_bridge:ui:send", action, data) end
local function streaming() return (Bridge or pr_lib).fivem.streaming end
local function interrupted(data, ped)
    return (not data.useWhileDead and IsEntityDead(ped))
        or (not data.allowRagdoll and IsPedRagdoll(ped))
        or (not data.allowCuffed and IsPedCuffed(ped))
        or (not data.allowFalling and IsPedFalling(ped))
        or (not data.allowSwimming and IsPedSwimming(ped))
end
local groups = { mouse={1,2,106}, move={21,22,30,31,36}, sprint={21}, car={59,60,63,64,71,72,75}, combat={24,25,37} }
local function disableControls(disable)
    for group, controls in pairs(groups) do
        if disable and disable[group] then
            for _, control in ipairs(controls) do DisableControlAction(0, control, true) end
            if group == "combat" then DisablePlayerFiring(PlayerId(), true) end
        end
    end
end
function progress.progressActive() return active ~= nil end
function progress.cancelProgress(force, owner)
    if active and (not owner or active.owner == owner) and (force == true or active.data.canCancel) then active.cancelled = true end
end
local function cleanup(entry)
    if entry.cleaned then return end
    entry.cleaned = true
    send("progress:hide")
    if entry.props then TriggerServerEvent("pr_bridge:progressProps", nil) end
    local anim = entry.data.anim
    if entry.animStarted and anim then
        if anim.dict then StopAnimTask(entry.ped, anim.dict, anim.clip, 1.0)
        elseif anim.scenario then ClearPedTasks(entry.ped) end
    end
    state.invBusy = entry.invBusy
    if active == entry then active = nil end
end
local function runProgress(data, style)
    if active or type(data) ~= "table" or type(data.duration) ~= "number" or data.duration <= 0 then return false end
    local ped = PlayerPedId()
    if interrupted(data, ped) then return nil end
    local entry = { data=data, ped=ped, owner=GetInvokingResource() or GetCurrentResourceName(), invBusy=state.invBusy }
    active, state.invBusy = entry, true
    local ok, result = pcall(function()
        if data.prop then
            local props = data.prop.model and {data.prop} or data.prop
            for _, prop in ipairs(props) do
                local loaded, model = streaming().requestModel(prop.model, 10000)
                if not loaded or IsModelAPed(model) or IsModelAVehicle(model) then error("Invalid progress prop") end
                local min, max = GetModelDimensions(model)
                local size = max - min
                streaming().releaseModel(model)
                if math.max(size.x, size.y, size.z) > 2.5 then error("Progress prop is too large") end
            end
            entry.props = true
            TriggerServerEvent("pr_bridge:progressProps", data.prop)
        end
        local anim = data.anim
        if anim and anim.dict then
            if not streaming().requestAnimDict(anim.dict, 10000) then error("Unable to load progress animation") end
            TaskPlayAnim(ped, anim.dict, anim.clip, anim.blendIn or 3.0, anim.blendOut or 1.0, anim.duration or -1,
                anim.flag or 49, anim.playbackRate or 0.0, anim.lockX == true, anim.lockY == true, anim.lockZ == true)
            streaming().releaseAnimDict(anim.dict)
            entry.animStarted = true
        elseif anim and anim.scenario then
            TaskStartScenarioInPlace(ped, anim.scenario, 0, anim.playEnter ~= false)
            entry.animStarted = true
        end
        local started = GetGameTimer()
        local settings = (Bridge or pr_lib).settings
        local layout = settings and settings.get("interface", {}).layout or {}
        send("progress:show", { label=data.label, duration=data.duration, style=style,
            position=data.position or (layout and layout.progressBar) or "bottom-center", color=data.color, canCancel=data.canCancel })
        while not entry.cancelled and GetGameTimer() - started < data.duration do
            disableControls(data.disable)
            if interrupted(data, ped) then entry.cancelled = true end
            if data.canCancel and (IsControlJustPressed(0,177) or IsControlJustPressed(0,202) or IsControlJustPressed(0,73)) then entry.cancelled = true end
            Wait(0)
        end
        return not entry.cancelled
    end)
    cleanup(entry)
    if not ok then error(result, 2) end
    return result
end
function progress.progressBar(data) return runProgress(data, "bar") end
function progress.progressCircle(data) return runProgress(data, "circle") end
function progress.doProgressbar(duration, label, anim)
    return progress.progressBar({duration=duration,label=label,canCancel=true,disable={move=true},anim=anim and {dict=anim[1],clip=anim[2]}})
end
function progress.doProgressCircle(duration, label, anim)
    return progress.progressCircle({duration=duration,label=label,canCancel=true,disable={move=true},anim=anim and {dict=anim[1],clip=anim[2]}})
end
if GetCurrentResourceName() == 'pr_bridge' then
    RegisterCommand("pr_bridge_cancelprogress", function() progress.cancelProgress() end, false)
    RegisterKeyMapping("pr_bridge_cancelprogress", "Cancelar progresso", "keyboard", "x")
end
AddEventHandler("onClientResourceStop", function(resource)
    if active and (resource == active.owner or resource == GetCurrentResourceName()) then
        active.cancelled = true
        if resource == GetCurrentResourceName() then cleanup(active) end
    end
end)
return progress
