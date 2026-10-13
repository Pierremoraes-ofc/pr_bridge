-- Adapt the ox return value/timeout, never duplicate the native loader.
local native = lib.__native('bridge/fivem/streaming/client')
function lib.requestModel(asset, timeout, ...)
    local ok, value = native.requestModel(asset, timeout or 30000, ...)
    if not ok then error('failed to load requestModel: ' .. tostring(asset), 2) end
    return value
end
return lib.requestModel
