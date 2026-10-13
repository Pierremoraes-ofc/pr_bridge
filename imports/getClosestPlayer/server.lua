local native = lib.__native('bridge/fivem/proximity/shared')
function lib.getClosestPlayer(coords, radius, ignore)
    local id, ped, position = native.getClosestPlayer(coords, radius, true, ignore)
    return id, ped, position
end
return lib.getClosestPlayer
