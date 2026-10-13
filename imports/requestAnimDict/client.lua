-- Adapt the ox return value/timeout, never duplicate the native loader.
local native = lib.__native('bridge/fivem/streaming/client')
function lib.requestAnimDict(asset, timeout, ...)
    local ok, value = native.requestAnimDict(asset, timeout or 30000, ...)
    if not ok then error('failed to load requestAnimDict: ' .. tostring(asset), 2) end
    return asset
end
return lib.requestAnimDict
