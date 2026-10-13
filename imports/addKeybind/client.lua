local native = lib.__native('bridge/addKeybind/client')
function lib.addKeybind(data)
    data.allowUnbound = true
    local bind, reason = native(data)
    assert(bind, reason)
    -- The old object exposes the primary command hash as well as methods.
    bind.hash = bind.combos[1].hashes[1]
    return bind
end
return lib.addKeybind
