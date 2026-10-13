-- Adapt the ox return value/timeout, never duplicate the native loader.
local native = lib.__native('bridge/fivem/streaming/client')
function lib.requestScaleformMovie(asset, timeout, ...)
    local ok, value = native.requestScaleformMovie(asset, timeout or 1000, ...)
    if not ok then error('failed to load requestScaleformMovie: ' .. tostring(asset), 2) end
    return value
end
return lib.requestScaleformMovie
