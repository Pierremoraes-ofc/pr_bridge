-- Preserve the legacy point facade; native PR owns the scheduler/registry.
local native = lib.__native('bridge/fivem/spatial/client').points
lib.points = {}
function lib.points.new(data, distance, extra)
    local point
    if type(data) == 'table' and data.coords then
        for key, value in pairs(extra or {}) do data[key] = value end
        data.distance = data.distance or distance
        point = native.new(data)
    else
        local properties = extra or {}
        properties.coords, properties.distance = data, properties.distance or distance
        point = native.new(properties)
    end
    local coords = point.coords
    point.coords = vec3(coords.x or coords[1], coords.y or coords[2], coords.z or coords[3])
    return point
end
function lib.points.getAllPoints() return native.getAllPoints(true) end
lib.points.getNearbyPoints = native.getNearbyPoints
function lib.points.getClosestPoint() return native.getClosestPoint(nil,true) end
lib.points.closest = lib.points.getClosestPoint
return lib.points
