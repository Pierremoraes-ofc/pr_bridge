---Notify module (native UI notifications).
---@param Renderer table
return function(Renderer)
    local Notify = {}
    local nextId = 0
    local activeIds = {}

    ---@class NotifyData
    ---@field id? string|number
    ---@field title? string
    ---@field description? string
    ---@field type? string
    ---@field duration? number
    ---@field position? string
    ---@field icon? string
    ---@field iconColor? string
    ---@field showDuration? boolean

    ---@param data NotifyData|string
    function Notify.Notify(data)
        if type(data) == "string" then
            data = { description = data }
        end

        if type(data) ~= "table" then
            return false
        end

        nextId = nextId + 1
        local id = data.id or ("pr_notify_" .. nextId)
        local duration = tonumber(data.duration) or 5000

        if activeIds[id] then return false end
        activeIds[id] = true
        SetTimeout(duration, function() activeIds[id] = nil end)

        Renderer.send("notify:push", {
            id = id,
            title = data.title,
            description = data.description or "",
            type = data.type or "info",
            duration = duration,
            position = data.position,
            icon = data.icon,
            iconColor = data.iconColor,
            iconAnimation = data.iconAnimation,
            alignIcon = data.alignIcon,
            style = data.style,
            showDuration = data.showDuration,
        })

        local sound = data.sound
        if type(sound) == "table" and type(sound.name) == "string" and type(sound.set) == "string"
            and GetConvar("pr_bridge:ox_compat:notificationAudio", "false") == "true" then
            if sound.bank then
                local timeout = GetGameTimer() + 5000
                while not RequestScriptAudioBank(sound.bank, false) and GetGameTimer() < timeout do Wait(0) end
            end
            local soundId = GetSoundId()
            PlaySoundFrontend(soundId, sound.name, sound.set, true)
            ReleaseSoundId(soundId)
            if sound.bank then ReleaseNamedScriptAudioBank(sound.bank) end
        end

        return true
    end

    return Notify
end
