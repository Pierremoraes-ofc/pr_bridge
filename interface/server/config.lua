local CONFIG_PATH = "interface/data/config.json"

local defaults = {
    palette = {
        primary = "#ff7a1a",
        primaryHover = "#ff8c2a",
        success = "#10b981",
        warning = "#f59e0b",
        error = "#ef4444",
        info = "#3b82f6",
        text = "#ffffff",
        textMuted = "#8e8e9f",
        surface = "#0c0c0f",
        surfaceOpacity = 0.82,
        border = "#2d2d35",
    },
    layout = {
        registerContext = "right",
        metadata = "right",
        alertDialog = "center",
        inputDialog = "center",
        registerMenu = "right",
        notify = "top-right",
        progressBar = "bottom-center",
        showTextUI = "right-center",
    },
}

local allowedLayout = {
    registerContext = { left = true, right = true },
    metadata = { left = true, right = true },
    alertDialog = { left = true, center = true, right = true },
    inputDialog = { left = true, center = true, right = true },
    registerMenu = { left = true, right = true },
    notify = {
        ["top-left"] = true, ["top-center"] = true, ["top-right"] = true,
        ["center-left"] = true, ["center-right"] = true,
        ["bottom-left"] = true, ["bottom-center"] = true, ["bottom-right"] = true,
    },
    progressBar = { ["top-center"] = true, ["bottom-center"] = true },
    showTextUI = {
        ["left-center"] = true, ["right-center"] = true,
        ["top-center"] = true, ["bottom-center"] = true,
    },
}

local function clone(value)
    if type(value) ~= "table" then return value end
    local copy = {}
    for key, entry in pairs(value) do copy[key] = clone(entry) end
    return copy
end

local function validColor(value)
    return type(value) == "string" and value:match("^#%x%x%x%x%x%x$") ~= nil
end

local function sanitize(input)
    input = type(input) == "table" and input or {}
    local output = clone(defaults)
    local palette = type(input.palette) == "table" and input.palette or {}

    for key, fallback in pairs(defaults.palette) do
        if key == "surfaceOpacity" then
            output.palette[key] = math.max(0.15, math.min(1.0, tonumber(palette[key]) or fallback))
        elseif validColor(palette[key]) then
            output.palette[key] = palette[key]:lower()
        end
    end

    local layout = type(input.layout) == "table" and input.layout or {}
    for key, fallback in pairs(defaults.layout) do
        local value = tostring(layout[key] or fallback)
        output.layout[key] = allowedLayout[key][value] and value or fallback
    end

    return output
end

local function loadConfig()
    local raw = LoadResourceFile(GetCurrentResourceName(), CONFIG_PATH)
    if not raw or raw == "" then return clone(defaults) end

    local ok, decoded = pcall(json.decode, raw)
    return ok and sanitize(decoded) or clone(defaults)
end

local function saveConfig(config)
    local encoded = json.encode(config)
    if not encoded then return false end
    return SaveResourceFile(GetCurrentResourceName(), CONFIG_PATH, encoded, #encoded) ~= false
end

local function isAdmin(source)
    if source == 0 then return true end
    return IsPlayerAceAllowed(source, "command.pr_ui_admin")
        or IsPlayerAceAllowed(source, "pr_bridge.ui.admin")
        or IsPlayerAceAllowed(source, "group.admin")
end

local current = loadConfig()
GlobalState.pr_bridge_ui_config = current

PRCore.callback.register("pr_bridge:ui:isAdmin", function(source)
    return isAdmin(source)
end)

PRCore.callback.register("pr_bridge:ui:saveConfig", function(source, input)
    if not isAdmin(source) then return false, "no_permission" end

    local nextConfig = sanitize(input)
    if not saveConfig(nextConfig) then return false, "save_failed" end

    current = nextConfig
    GlobalState.pr_bridge_ui_config = current
    return true, current
end)

PRCore.callback.register("pr_bridge:ui:resetConfig", function(source)
    if not isAdmin(source) then return false, "no_permission" end

    local nextConfig = clone(defaults)
    if not saveConfig(nextConfig) then return false, "save_failed" end

    current = nextConfig
    GlobalState.pr_bridge_ui_config = current
    return true, current
end)

local commandApi = PRCore.load("@pr_bridge/bridge/addCommand/server", _ENV)
commandApi.add("pr_ui_admin", {
    help = "Abre as configuracoes visuais globais do pr_bridge",
    restricted = { "group.admin" },
}, function(source)
    TriggerClientEvent("pr_bridge:ui:openAdmin", source)
end)
