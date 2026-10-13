-- Adapt the ox return value/timeout, never duplicate the native loader.
local native = lib.__native('bridge/fivem/streaming/client')
function lib.requestStreamedTextureDict(asset, timeout, ...)
    local ok, value = native.requestTextureDict(asset, timeout or 30000, ...)
    if not ok then error('failed to load requestStreamedTextureDict: ' .. tostring(asset), 2) end
    return asset
end
return lib.requestStreamedTextureDict
