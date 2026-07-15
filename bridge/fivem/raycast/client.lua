local raycast = {}
local function forwardVector(rotation)
    rotation = rotation or GetFinalRenderedCamRot(2)
    local pitch, yaw = math.rad(rotation.x), math.rad(rotation.z)
    return vector3(-math.sin(yaw) * math.abs(math.cos(pitch)), math.cos(yaw) * math.abs(math.cos(pitch)), math.sin(pitch))
end
function raycast.fromCoords(origin, destination, flags, ignoreFlags, ignoreEntity)
    if not origin or not destination then return false, 0, origin, vector3(0,0,0), 0 end
    local handle = StartShapeTestLosProbe(origin.x, origin.y, origin.z, destination.x, destination.y, destination.z, flags or 511, ignoreEntity or PlayerPedId(), ignoreFlags or 4)
    local status, hit, endCoords, normal, material, entity = 1
    local expires = GetGameTimer() + 1000
    repeat
        status, hit, endCoords, normal, material, entity = GetShapeTestResultIncludingMaterial(handle)
        if status ~= 1 then break end
        Wait(0)
    until GetGameTimer() >= expires
    return hit == 1 or hit == true, entity or 0, endCoords, normal, material
end
function raycast.fromCamera(distance, flags, ignoreFlags, ignoreEntity)
    local origin = GetFinalRenderedCamCoord()
    return raycast.fromCoords(origin, origin + forwardVector() * (tonumber(distance) or 10.0), flags, ignoreFlags, ignoreEntity)
end
raycast.FromCoords=raycast.fromCoords; raycast.FromCamera=raycast.fromCamera
return raycast