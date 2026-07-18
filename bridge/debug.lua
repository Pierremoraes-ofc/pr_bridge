local debugApi = PRDebug or {}

local levels = {
    DEBUG = { label = "DEBUG", color = "^5" },
    INFO = { label = "INFO", color = "^3" },
    SUCCESS = { label = "SUCCESS", color = "^2" },
    WARNING = { label = "WARNING", color = "^4" },
    ERROR = { label = "ERROR", color = "^1" },
}

local aliases = {
    debug = "DEBUG",
    log = "DEBUG",
    info = "INFO",
    success = "SUCCESS",
    warn = "WARNING",
    warning = "WARNING",
    error = "ERROR",
}

local function isEnabled()
    return Config and Config.Debug == true
end

local function normalizeLevel(level)
    if type(level) ~= "string" then return "DEBUG" end

    local normalized = aliases[level:lower()] or level:upper()
    return levels[normalized] and normalized or "DEBUG"
end

local function emit(level, ...)
    if not isEnabled() then return end

    local info = levels[normalizeLevel(level)] or levels.DEBUG
    print(("%s[PR DEBUG %s]:^0"):format(info.color, info.label), ...)
end

function debugApi.isEnabled()
    return isEnabled()
end

function debugApi.setEnabled(state)
    if Config then
        Config.Debug = state == true
    end

    return isEnabled()
end

function debugApi.log(...)
    emit("DEBUG", ...)
end

function debugApi.info(...)
    emit("INFO", ...)
end

function debugApi.success(...)
    emit("SUCCESS", ...)
end

function debugApi.warn(...)
    emit("WARNING", ...)
end

debugApi.warning = debugApi.warn

function debugApi.error(...)
    emit("ERROR", ...)
end

setmetatable(debugApi, {
    __call = function(_, ...)
        emit("DEBUG", ...)
    end,
})

function Debug(level, ...)
    local normalized = normalizeLevel(level)

    if type(level) == "string" and (levels[level:upper()] or aliases[level:lower()]) then
        emit(normalized, ...)
        return
    end

    emit("DEBUG", level, ...)
end

PRDebug = debugApi

return debugApi
