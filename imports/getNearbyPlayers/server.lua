local native = lib.__native('bridge/fivem/proximity/shared')
function lib.getNearbyPlayers(coords, radius)
    return native.getNearbyPlayers(coords, radius, true)
end
return lib.getNearbyPlayers
