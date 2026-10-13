local native = lib.__native('bridge/fivem/raycast/client')
lib.raycast = { fromCoords = native.fromCoords }
function lib.raycast.fromCamera(flags, ignore, distance)
    return native.fromCamera(distance or 10, flags or 511, ignore or 4)
end
lib.raycast.cam = lib.raycast.fromCamera
return lib.raycast
