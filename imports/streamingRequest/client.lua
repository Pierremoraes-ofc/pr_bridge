local native = lib.__native('bridge/fivem/streaming/client')
function lib.streamingRequest(request, loaded, kind, asset, timeout, ...)
    local ok, value = native.requestAsset(request, loaded, asset, timeout or 30000, ...)
    if not ok then error(('failed to load %s %s'):format(kind, tostring(asset)), 2) end
    return value
end
return lib.streamingRequest
