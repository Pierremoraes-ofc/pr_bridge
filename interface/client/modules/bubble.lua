return function()
    local Bubble = {}
    local sequence = 0
    local resource = GetCurrentResourceName()
    local scopes = {}

    function Bubble.NotifyBubble(data, kind, duration)
        if type(data) == "string" then data = { description = data } end
        if type(data) ~= "table" then return false end

        sequence = sequence + 1
        local payload = {}
        for key, value in pairs(data) do payload[key] = value end
        payload.type = payload.type or kind
        payload.duration = payload.duration or duration
        local serverId = GetPlayerServerId(PlayerId())
        payload.id = tostring(payload.id or (resource .. ":bubble:" .. serverId .. ":" .. sequence))

        local visibility = tostring(payload.visibility or payload.scope or "self"):lower()
        local showForAll = payload.broadcast == true or visibility == "all" or visibility == "global"
        scopes[payload.id] = showForAll and "all" or "self"

        if showForAll then
            payload.visibility = "all"
            TriggerServerEvent("pr_bridge:notifyBubble:broadcast", payload)
        else
            payload.visibility = "self"
            TriggerEvent("pr_bridge:notifyBubble:show", resource, payload)
        end

        local duration = math.max(500, math.min(30000, tonumber(payload.duration) or 5000))
        SetTimeout(duration + 1000, function() scopes[payload.id] = nil end)
        return payload.id
    end

    function Bubble.HideNotifyBubble(id)
        if id == nil then return false end
        id = tostring(id)
        if scopes[id] == "all" then
            TriggerServerEvent("pr_bridge:notifyBubble:hideBroadcast", id)
        else
            TriggerEvent("pr_bridge:notifyBubble:hide", id)
        end
        scopes[id] = nil
        return true
    end

    Bubble.notifyBubble = Bubble.NotifyBubble
    Bubble.hideNotifyBubble = Bubble.HideNotifyBubble
    return Bubble
end