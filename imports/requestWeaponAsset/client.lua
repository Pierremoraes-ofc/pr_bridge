-- Adapt the ox return value/timeout, never duplicate the native loader.
local native = lib.__native('bridge/fivem/streaming/client')
function lib.requestWeaponAsset(asset, timeout, ...)
    local ok, value = native.requestWeaponAsset(asset, timeout or 30000, ...)
    if not ok then error('failed to load requestWeaponAsset: ' .. tostring(asset), 2) end
    return asset
end
return lib.requestWeaponAsset
