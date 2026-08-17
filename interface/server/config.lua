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
    target = {
        x = 50.0,
        y = 50.0,
        optionsY = 48.4,
        offsetX = 24.0,
        width = 200.0,
        height = 29.33,
        eyeSize = 36.0,
        eyeScale = 1.0,
        eyeIcon = "fa-solid fa-eye",
        scale = 1.0,
        fontSize = 14.67,
        color = "#cfd2da",
        hoverColor = "#ffffff",
        eyeColor = "#000000",
        background = "#141414",
        hoverBackground = "#1e1e1e",
        backgroundOpacity = 0.70,
        backgroundFade = 0.60,
        markerColor = "#9b9b9b",
        markerHoverColor = "#6287ec",
        markerOpacity = 0.69,
        markerIcon = "bi bi-circle",
        markerTargetIcon = "bi bi-record-circle",
        markerChangeOnTarget = true,
        markerDistance = 5.0,
        markerSize = 30.0,
        markerScale = 1.0,
        markerTargetScale = 1.0,
        markerEffect = "pulse-glow",
        markerEffectSpeed = 1.2,
        markerEffectStrength = 1.25,
        wallDetection = true,
        wallRayFlags = 277,
    },
    interact = {
        style = "obtaizen_ui",
        scale = 1.0, pinSize = 32.0, keySize = 38.0, bulletSize = 17.0,
        optionWidth = 180.0, optionHeight = 30.0, optionGap = 3.0, fontSize = 14.0,
        pinColor = "#7656ff", keyColor = "#7656ff", selectedColor = "#7656ff",
        unselectedColor = "#777777", textColor = "#ffffff", backgroundOpacity = 0.92,
        wallDetection = true, wallRayFlags = 277,
        showUI = true,
        disableOnDeath = true, disableOnNuiFocus = true, disableInVehicle = true, disableWhenCuffed = true,
    },
}

local allowedInteractStyles = {
    blue_circle = true, gold_circle = true, green_square = true, glitch = true,
    obtaizen_ui = true,
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

local allowedTargetIcons = {
    ["fa-solid fa-eye"] = true,
    ["fa-solid fa-crosshairs"] = true,
    ["fa-solid fa-bullseye"] = true,
    ["fa-solid fa-location-crosshairs"] = true,
    ["fa-solid fa-hand-pointer"] = true,
    ["fa-solid fa-circle-dot"] = true,
}

local allowedMarkerIcons = {
    ["bi bi-circle"] = true, ["bi bi-record-circle"] = true,
    ["bi bi-crosshair"] = true, ["bi bi-bullseye"] = true,
    ["bi bi-geo-alt-fill"] = true, ["bi bi-cursor-fill"] = true,
    ["bi bi-diamond"] = true,
}

local allowedMarkerEffects = {
    none = true, pulse = true, ["pulse-glow"] = true, spin = true, breathe = true,
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

    local target = type(input.target) == "table" and input.target or {}
    local ranges = {
        x = { 0, 100 }, y = { 0, 100 }, optionsY = { 0, 100 }, offsetX = { -500, 500 },
        width = { 80, 800 }, height = { 18, 100 }, eyeSize = { 12, 120 }, eyeScale = { 0.25, 3 },
        scale = { 0.25, 3 }, fontSize = { 8, 40 }, backgroundOpacity = { 0, 1 },
        backgroundFade = { 0, 1 }, markerOpacity = { 0, 1 }, markerDistance = { 1, 25 },
        markerSize = { 12, 96 }, markerScale = { 0.25, 3 }, markerTargetScale = { 0.25, 3 },
        markerEffectSpeed = { 0.25, 5 }, markerEffectStrength = { 1, 2 }, wallRayFlags = { 1, 511 },
    }
    for key, range in pairs(ranges) do
        local value = tonumber(target[key]) or defaults.target[key]
        output.target[key] = math.max(range[1], math.min(range[2], value))
    end
    local eyeIcon = tostring(target.eyeIcon or defaults.target.eyeIcon)
    output.target.eyeIcon = allowedTargetIcons[eyeIcon] and eyeIcon or defaults.target.eyeIcon
    local markerIcon = tostring(target.markerIcon or defaults.target.markerIcon)
    local markerTargetIcon = tostring(target.markerTargetIcon or defaults.target.markerTargetIcon)
    local markerEffect = tostring(target.markerEffect or defaults.target.markerEffect)
    output.target.markerIcon = allowedMarkerIcons[markerIcon] and markerIcon or defaults.target.markerIcon
    output.target.markerTargetIcon = allowedMarkerIcons[markerTargetIcon] and markerTargetIcon or defaults.target.markerTargetIcon
    output.target.markerEffect = allowedMarkerEffects[markerEffect] and markerEffect or defaults.target.markerEffect
    output.target.markerChangeOnTarget = target.markerChangeOnTarget ~= false
    output.target.wallDetection = target.wallDetection ~= false
    local colors = {
        "color", "hoverColor", "eyeColor", "background", "hoverBackground",
        "markerColor", "markerHoverColor",
    }
    for i = 1, #colors do
        local key = colors[i]
        output.target[key] = validColor(target[key]) and target[key]:lower() or defaults.target[key]
    end

    local interact = type(input.interact) == "table" and input.interact or {}
    local interactRanges = {
        scale = { 0.25, 3 }, pinSize = { 10, 120 }, keySize = { 10, 120 }, bulletSize = { 8, 60 },
        optionWidth = { 80, 600 }, optionHeight = { 18, 80 }, optionGap = { 0, 30 }, fontSize = { 8, 36 },
        backgroundOpacity = { 0, 1 }, wallRayFlags = { 1, 511 },
    }
    for key, range in pairs(interactRanges) do
        local value = tonumber(interact[key]) or defaults.interact[key]
        output.interact[key] = math.max(range[1], math.min(range[2], value))
    end
    local style = tostring(interact.style or defaults.interact.style)
    if style == "green_obtaizen" then style = "obtaizen_ui" end
    output.interact.style = allowedInteractStyles[style] and style or defaults.interact.style
    for _, key in ipairs({ "pinColor", "keyColor", "selectedColor", "unselectedColor", "textColor" }) do
        output.interact[key] = validColor(interact[key]) and interact[key]:lower() or defaults.interact[key]
    end
    for _, key in ipairs({ "wallDetection", "showUI", "disableOnDeath", "disableOnNuiFocus", "disableInVehicle", "disableWhenCuffed" }) do
        output.interact[key] = interact[key] ~= false
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
