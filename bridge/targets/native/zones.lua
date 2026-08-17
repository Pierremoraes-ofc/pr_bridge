local Zones = {}

local CELL_SIZE = math.max(16.0, tonumber(GetConvar("pr_bridge:target:zoneCellSize", "32")) or 32.0)
local DEFAULT_DISTANCE = math.max(1.0, tonumber(GetConvar("pr_bridge:target:distance", "7")) or 7.0)
local entries = {}
local names = {}
local grid = {}
local nextId = 0

local function number(value, fallback)
    value = tonumber(value)
    return value or fallback or 0.0
end

local function xyz(value)
    if not value then return 0.0, 0.0, 0.0 end
    return number(value.x or value[1]), number(value.y or value[2]), number(value.z or value[3])
end

local function cell(value)
    return math.floor(value / CELL_SIZE)
end

local function cellKey(x, y)
    return ("%d:%d"):format(x, y)
end

local function registerCells(zone, minX, minY, maxX, maxY)
    local padding = math.max(DEFAULT_DISTANCE, number(zone.distance, DEFAULT_DISTANCE))
    local fromX, toX = cell(minX - padding), cell(maxX + padding)
    local fromY, toY = cell(minY - padding), cell(maxY + padding)
    zone.cells = {}

    for x = fromX, toX do
        for y = fromY, toY do
            local key = cellKey(x, y)
            local bucket = grid[key]
            if not bucket then
                bucket = {}
                grid[key] = bucket
            end
            bucket[zone.id] = true
            zone.cells[#zone.cells + 1] = key
        end
    end
end

local function unregisterCells(zone)
    for i = 1, #(zone.cells or {}) do
        local key = zone.cells[i]
        local bucket = grid[key]
        if bucket then
            bucket[zone.id] = nil
            if not next(bucket) then grid[key] = nil end
        end
    end
    zone.cells = nil
end

local function remove(zone)
    if not zone or not entries[zone.id] then return false end
    unregisterCells(zone)
    entries[zone.id] = nil
    if zone.name and names[zone.name] == zone.id then names[zone.name] = nil end
    return true
end

local function pointInPolygon(px, py, points)
    local inside = false
    local previous = #points

    for current = 1, #points do
        local ax, ay = xyz(points[current])
        local bx, by = xyz(points[previous])
        if ((ay > py) ~= (by > py)) and (px < (bx - ax) * (py - ay) / ((by - ay) + 0.0) + ax) then
            inside = not inside
        end
        previous = current
    end

    return inside
end

local function makeZone(kind, data)
    data = type(data) == "table" and data or {}
    nextId = nextId + 1

    local zone = {
        id = nextId,
        kind = kind,
        name = type(data.name) == "string" and data.name or nil,
        resource = data.resource or GetInvokingResource() or GetCurrentResourceName(),
        coords = data.coords,
        options = data.options or {},
        distance = number(data.distance, DEFAULT_DISTANCE),
        debug = data.debug == true,
        drawSprite = data.drawSprite ~= false,
    }

    if zone.name and names[zone.name] then
        remove(entries[names[zone.name]])
    end

    if kind == "sphere" then
        zone.radius = math.max(0.01, number(data.radius, 2.0))
        local x, y = xyz(zone.coords)
        registerCells(zone, x - zone.radius, y - zone.radius, x + zone.radius, y + zone.radius)
    elseif kind == "box" then
        zone.size = data.size or vector3(2.0, 2.0, 2.0)
        zone.rotation = number(data.rotation, 0.0)
        local x, y = xyz(zone.coords)
        local sx, sy = xyz(zone.size)
        local extent = math.sqrt((sx * 0.5) ^ 2 + (sy * 0.5) ^ 2)
        registerCells(zone, x - extent, y - extent, x + extent, y + extent)
    elseif kind == "poly" then
        zone.points = data.points or {}
        zone.thickness = math.max(0.01, number(data.thickness, 4.0))
        local minX, minY, maxX, maxY
        local centerX, centerY, centerZ = 0.0, 0.0, 0.0
        for i = 1, #zone.points do
            local x, y, z = xyz(zone.points[i])
            minX, maxX = math.min(minX or x, x), math.max(maxX or x, x)
            minY, maxY = math.min(minY or y, y), math.max(maxY or y, y)
            centerX, centerY, centerZ = centerX + x, centerY + y, centerZ + z
        end
        local count = math.max(1, #zone.points)
        zone.coords = data.coords or vector3(centerX / count, centerY / count, centerZ / count)
        registerCells(zone, minX or 0.0, minY or 0.0, maxX or 0.0, maxY or 0.0)
    end

    function zone:contains(point)
        local px, py, pz = xyz(point)
        local cx, cy, cz = xyz(self.coords)

        if self.kind == "sphere" then
            local dx, dy, dz = px - cx, py - cy, pz - cz
            return (dx * dx + dy * dy + dz * dz) <= self.radius * self.radius
        end

        if self.kind == "box" then
            local sx, sy, sz = xyz(self.size)
            local angle = math.rad(-(self.rotation or 0.0))
            local dx, dy = px - cx, py - cy
            local localX = dx * math.cos(angle) - dy * math.sin(angle)
            local localY = dx * math.sin(angle) + dy * math.cos(angle)
            return math.abs(localX) <= sx * 0.5
                and math.abs(localY) <= sy * 0.5
                and math.abs(pz - cz) <= sz * 0.5
        end

        return math.abs(pz - cz) <= self.thickness * 0.5 and pointInPolygon(px, py, self.points)
    end

    function zone:remove()
        return remove(self)
    end

    entries[zone.id] = zone
    if zone.name then names[zone.name] = zone.id end
    return zone
end

function Zones.sphere(data) return makeZone("sphere", data) end
function Zones.box(data) return makeZone("box", data) end
function Zones.poly(data) return makeZone("poly", data) end

function Zones.get(id)
    if type(id) == "string" then id = names[id] end
    return entries[tonumber(id)]
end

function Zones.exists(id)
    return Zones.get(id) ~= nil
end

function Zones.remove(id)
    return remove(Zones.get(id))
end

function Zones.getNearby(coords)
    local x, y = xyz(coords)
    local bucket = grid[cellKey(cell(x), cell(y))]
    local output = {}
    if not bucket then return output end

    for id in pairs(bucket) do
        local zone = entries[id]
        if zone then output[#output + 1] = zone end
    end
    table.sort(output, function(a, b) return a.id < b.id end)
    return output
end

function Zones.getAll()
    return entries
end

function Zones.removeResource(resource)
    local removeIds = {}
    for id, zone in pairs(entries) do
        if zone.resource == resource then removeIds[#removeIds + 1] = id end
    end
    for i = 1, #removeIds do Zones.remove(removeIds[i]) end
end

return Zones
