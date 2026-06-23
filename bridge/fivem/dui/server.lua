local dui = {}

local resourceName = GetCurrentResourceName()
local sessions = {}
local currentId = 0

local function debug(level, message)
    local debugApi = Bridge and Bridge.debug
    if not debugApi then return end

    local fn = debugApi[level]
    if type(fn) == "function" then
        fn(message)
    elseif type(debugApi) == "function" then
        debugApi(level, message)
    end
end

local function sanitizeName(value, fallback)
    value = tostring(value or fallback or "dui")
    value = value:gsub("[^%w_]", "_")

    if value == "" then return fallback or "dui" end
    return value
end

local function nextId(id)
    if type(id) == "string" and id ~= "" then return sanitizeName(id) end

    currentId = currentId + 1
    return sanitizeName(("%s_server_%s"):format(resourceName, currentId))
end

local function normalizeTarget(target, fallback)
    if target == nil then return fallback or -1 end
    if target == "all" or target == "*" then return -1 end
    return target
end

local function normalizeTargetAndOptions(target, options)
    if type(target) == "table" then
        return -1, target
    end

    return normalizeTarget(target), options or {}
end

local function cloneConfig(config)
    if type(config) ~= "table" then return config end

    local copy = {}
    for key, value in pairs(config) do
        if type(value) == "table" then
            copy[key] = cloneConfig(value)
        else
            copy[key] = value
        end
    end

    return copy
end

local function storeSession(kind, id, options)
    sessions[id] = {
        kind = kind,
        id = id,
        options = cloneConfig(options),
    }
end

local function dispatch(eventName, target, ...)
    TriggerClientEvent(eventName, normalizeTarget(target), resourceName, ...)
end

local function create(kind, eventName, target, options)
    target, options = normalizeTargetAndOptions(target, options)
    options = cloneConfig(options or {})
    options.id = nextId(options.id or options.name)

    if options.persistent ~= false then
        storeSession(kind, options.id, options)
    end

    dispatch(eventName, target, options)

    return true, options.id
end

function dui.create(target, options)
    return create("create", "pr_bridge:client:dui:create", target, options)
end

function dui.createSprite(target, options)
    return create("createSprite", "pr_bridge:client:dui:createSprite", target, options)
end

function dui.createRenderTarget(target, options)
    return create("createRenderTarget", "pr_bridge:client:dui:createRenderTarget", target, options)
end

function dui.renderTarget(target, options)
    return dui.createRenderTarget(target, options)
end

function dui.createReplaceTexture(target, options)
    return create("createReplaceTexture", "pr_bridge:client:dui:createReplaceTexture", target, options)
end

function dui.replaceTexture(target, options)
    return dui.createReplaceTexture(target, options)
end

function dui.createPoly(target, options)
    return create("createPoly", "pr_bridge:client:dui:createPoly", target, options)
end

function dui.poly(target, options)
    return dui.createPoly(target, options)
end

function dui.destroy(target, id)
    if id == nil then
        id = target
        target = -1
    end

    if id == nil then return false, "invalid_id" end

    sessions[tostring(id)] = nil
    dispatch("pr_bridge:client:dui:destroy", target, tostring(id))

    return true
end

function dui.remove(target, id)
    return dui.destroy(target, id)
end

function dui.setUrl(target, id, url)
    if url == nil then
        url = id
        id = target
        target = -1
    end

    if url == nil then return false, "invalid_url" end
    if id == nil then return false, "invalid_id" end

    local session = sessions[tostring(id)]
    if session and session.options then
        session.options.url = url
    end

    dispatch("pr_bridge:client:dui:setUrl", target, tostring(id), url)

    return true
end

function dui.send(target, id, message)
    if message == nil then
        message = id
        id = target
        target = -1
    end

    if message == nil then return false, "invalid_message" end
    if id == nil then return false, "invalid_id" end

    dispatch("pr_bridge:client:dui:send", target, tostring(id), message)

    return true
end

dui.sendMessage = dui.send

function dui.startSprite(target, id, options)
    if type(id) == "table" and options == nil then
        options = id
        id = target
        target = -1
    end

    if id == nil then return false, "invalid_id" end
    dispatch("pr_bridge:client:dui:startSprite", target, tostring(id), options or {})

    return true
end

function dui.stopSprite(target, id)
    if id == nil then
        id = target
        target = -1
    end

    if id == nil then return false, "invalid_id" end
    dispatch("pr_bridge:client:dui:stopSprite", target, tostring(id))

    return true
end

function dui.stopRenderTarget(target, id)
    if id == nil then
        id = target
        target = -1
    end

    if id == nil then return false, "invalid_id" end
    dispatch("pr_bridge:client:dui:stopRenderTarget", target, tostring(id))

    return true
end

function dui.stopPoly(target, id)
    if id == nil then
        id = target
        target = -1
    end

    if id == nil then return false, "invalid_id" end
    dispatch("pr_bridge:client:dui:stopPoly", target, tostring(id))

    return true
end

function dui.sync(target)
    target = normalizeTarget(target)

    for _, session in pairs(sessions) do
        if session.kind == "createSprite" then
            dispatch("pr_bridge:client:dui:createSprite", target, session.options)
        elseif session.kind == "createRenderTarget" then
            dispatch("pr_bridge:client:dui:createRenderTarget", target, session.options)
        elseif session.kind == "createReplaceTexture" then
            dispatch("pr_bridge:client:dui:createReplaceTexture", target, session.options)
        elseif session.kind == "createPoly" then
            dispatch("pr_bridge:client:dui:createPoly", target, session.options)
        else
            dispatch("pr_bridge:client:dui:create", target, session.options)
        end
    end

    return true
end

function dui.clear(target)
    for id in pairs(sessions) do
        dispatch("pr_bridge:client:dui:destroy", target or -1, id)
        sessions[id] = nil
    end

    return true
end

function dui.get(id)
    return sessions[tostring(id)]
end

function dui.list()
    return sessions
end

RegisterNetEvent("pr_bridge:server:dui:ready", function(owner)
    if owner ~= resourceName then return end

    local source = source
    if not source or source <= 0 then return end

    debug("info", ("[pr_bridge:dui] Sincronizando DUIs persistentes para source=%s resource=%s"):format(source, resourceName))
    dui.sync(source)
end)

AddEventHandler("playerDropped", function()
    -- Sessions are persistent server definitions; clients destroy their own handles on resource stop.
end)

return dui
