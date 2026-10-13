local waitFor = lib.__native('bridge/utils/waitFor')
function lib.waitFor(callback, message, timeout)
    return waitFor(callback, message, timeout, true)
end
return lib.waitFor
