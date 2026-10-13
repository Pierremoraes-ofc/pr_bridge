-- Canonical full geometry/zone service. pr_lib.zones and legacy lib.zones
-- resolve this same registry; no parallel native zone implementation remains.
return function(api)
local cache = api.cache
--[[
    https://github.com/overextended/ox_lib

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright © 2025 Linden <https://github.com/thelindat>
]]

local glm = api.require('glm')

---@class ZoneProperties
---@field debug? boolean
---@field debugColour? vector4
---@field onEnter fun(self: CZone)?
---@field onExit fun(self: CZone)?
---@field inside fun(self: CZone)?
---@field [string] any

---@class CZone : PolyZone, BoxZone, SphereZone
---@field id number
---@field __type 'poly' | 'sphere' | 'box'
---@field remove fun(self: self)
---@field setDebug fun(self: CZone, enable?: boolean, colour?: vector)
---@field contains fun(self: CZone, coords?: vector3, updateDistance?: boolean): boolean

---@type table<number, CZone>
local Zones = {}
api.zoneRegistry = Zones
local nextId = 0

local function unableToSplit(polygon)
    print('The following polygon has failed to be split into triangles for debugging and may be malformed.')

    for k, v in pairs(polygon) do
        print(k, v)
    end
end

local function isCCW(a, b, c)
    return ((b.x - a.x) * (c.y - a.y) - (b.y - a.y) * (c.x - a.x)) > 0
end

local function signedArea(vertices)
    local area = 0

    for i = 1, #vertices do
        local j = (i % #vertices) + 1
        area = area + (vertices[i].x * vertices[j].y - vertices[j].x * vertices[i].y)
    end

    return area * 0.5
end

local function getTriangles(polygon, height, type)
    if type == 'sphere' then return end

    local triangles = {}

    local _ <close> = defer(function()
        local thickness = vec(0, 0, height / 2)

        for i = 1, #triangles do
            local triangle = triangles[i]
            local copy = table.clone(triangle)

            for j = 1, 3 do
                copy[j] = triangle[j] - thickness
                triangle[j] = triangle[j] + thickness
            end

            table.insert(triangles, copy)
        end
    end)

    if type == 'box' then
        table.move({
            { polygon[1], polygon[2], polygon[3] }, { polygon[1], polygon[3], polygon[4] }
        }, 1, 2, 1, triangles)
        return triangles
    end

    local numPoints = #polygon

    if numPoints < 3 then
        unableToSplit(polygon)

        return triangles
    end

    if polygon:isConvex() then
        for i = 2, numPoints - 1 do
            triangles[#triangles + 1] = { polygon[1], polygon[i], polygon[i + 1] }
        end

        return triangles
    end

    if not polygon:isSimple() then
        unableToSplit(polygon)

        return triangles
    end

    local indices = table.create(numPoints, 0)
    local reverse = signedArea(polygon) < 0

    print(signedArea(polygon), isCCW(polygon[1], polygon[2], polygon[3]))

    for i = 1, numPoints do
        indices[i] = reverse and numPoints + 1 - i or i
    end

    while #indices > 2 do
        local foundEar = false

        for i = 1, #indices do
            local i1 = indices[(i - 2) % #indices + 1]
            local i2 = indices[(i - 1) % #indices + 1]
            local i3 = indices[i % #indices + 1]
            local a, b, c = polygon[i1], polygon[i2], polygon[i3]

            if isCCW(a, b, c) then
                local isEar = true
                local triangle = glm.polygon.new({ a, b, c })

                for j = 1, #indices do
                    local idx = indices[j]

                    if idx ~= i1 and idx ~= i2 and idx ~= i3 then
                        if triangle:contains(polygon[idx]) then
                            isEar = false
                            break
                        end
                    end
                end

                if isEar then
                    table.insert(triangles, { a, b, c })
                    table.remove(indices, (i - 1) % #indices + 1)

                    foundEar = true
                    break
                end
            end
        end

        if not foundEar then
            unableToSplit(polygon)
            break
        end
    end

    return triangles
end

local insideZones = api.context == 'client' and {} --[[@as table<number, CZone>]]
local exitingZones = api.context == 'client' and api.array:new() --[[@as Array<CZone>]]
local enteringZones = api.context == 'client' and api.array:new() --[[@as Array<CZone>]]
local nearbyZones = api.array:new() --[[@as Array<CZone>]]
local glm_polygon_contains = glm.polygon.contains
local tick
local lastCellX, lastCellY

---@param zone CZone
local function removeZone(zone)
    if zone.nativeZone and zone.insideZone and zone.onExit then zone:onExit() end
    zone.insideZone=false
    Zones[zone.id] = nil

    api.grid.removeEntry(zone)

    if api.context == 'server' then return end

    insideZones[zone.id] = nil

    local exitingIndex = exitingZones:indexOf(zone)
    if exitingIndex then
        table.remove(exitingZones, exitingIndex)
    end

    local enteringIndex = enteringZones:indexOf(zone)
    if enteringIndex then
        table.remove(enteringZones, enteringIndex)
    end
end

CreateThread(function()
    if api.context == 'server' then return end

    while true do
        local coords = GetEntityCoords(cache.ped)
        local zones = api.grid.getNearbyEntries(coords, function(entry) return entry.remove == removeZone end) --[[@as Array<CZone>]]
        local cellX, cellY = api.grid.getCellPosition(coords)
        cache.coords = coords

        if cellX ~= lastCellX or cellY ~= lastCellY then
            for i = 1, #nearbyZones do
                local zone = nearbyZones[i]

                if zone.insideZone then
                    local contains = zone:contains(coords, true)

                    if not contains then
                        zone.insideZone = false
                        insideZones[zone.id] = nil

                        if zone.onExit then
                            exitingZones:push(zone)
                        end
                    end
                end
            end

            lastCellX = cellX
            lastCellY = cellY
        end

        nearbyZones = zones

        for i = 1, #zones do
            local zone = zones[i]
            local contains = zone:contains(coords, true)

            if contains then
                if not zone.insideZone then
                    zone.insideZone = true

                    if zone.onEnter then
                        enteringZones:push(zone)
                    end

                    if zone.inside or zone.debug then
                        insideZones[zone.id] = zone
                    end
                end
            else
                if zone.insideZone then
                    zone.insideZone = false
                    insideZones[zone.id] = nil

                    if zone.onExit then
                        exitingZones:push(zone)
                    end
                end

                if zone.debug then
                    insideZones[zone.id] = zone
                end
            end
        end

        local exitingSize = #exitingZones
        local enteringSize = #enteringZones

        if exitingSize > 0 then
            table.sort(exitingZones, function(a, b)
                return a.distance < b.distance
            end)

            for i = exitingSize, 1, -1 do
                exitingZones[i]:onExit()
            end

            table.wipe(exitingZones)
        end

        if enteringSize > 0 then
            table.sort(enteringZones, function(a, b)
                return a.distance < b.distance
            end)

            for i = 1, enteringSize do
                enteringZones[i]:onEnter()
            end

            table.wipe(enteringZones)
        end

        if not tick then
            if next(insideZones) then
                tick = api.module('bridge/tasks/interval').set(function()
                    for _, zone in pairs(insideZones) do
                        if zone.debug then
                            zone:debug()

                            if zone.inside and zone.insideZone then
                                zone:inside()
                            end
                        else
                            zone:inside()
                        end
                    end
                end)
            end
        elseif not next(insideZones) then
            api.module('bridge/tasks/interval').clear(tick)
            tick = nil
        end

        Wait(300)
    end
end)

local DrawLine = DrawLine
local DrawPoly = DrawPoly

local function debugPoly(self)
    local rgba = self.debugColour
    local thickness = vec(0, 0, self.thickness / 2)

    for i = 1, #self.triangles do
        local a = self.triangles[i][1]
        local b = self.triangles[i][2]
        local c = self.triangles[i][3]

        DrawPoly(a.x, a.y, a.z, b.x, b.y, b.z, c.x, c.y, c.z, rgba.r, rgba.g, rgba.b, rgba.a)
        DrawPoly(b.x, b.y, b.z, a.x, a.y, a.z, c.x, c.y, c.z, rgba.r, rgba.g, rgba.b, rgba.a)
    end
    -- do return end
    for i = 1, #self.polygon do
        local a = self.polygon[i] + thickness
        local b = self.polygon[i] - thickness
        local c = (self.polygon[i + 1] or self.polygon[1]) + thickness
        local d = (self.polygon[i + 1] or self.polygon[1]) - thickness

        DrawLine(a.x, a.y, a.z, b.x, b.y, b.z, rgba.r, rgba.g, rgba.b, 225)
        DrawLine(a.x, a.y, a.z, c.x, c.y, c.z, rgba.r, rgba.g, rgba.b, 225)
        DrawLine(b.x, b.y, b.z, d.x, d.y, d.z, rgba.r, rgba.g, rgba.b, 225)

        DrawPoly(a.x, a.y, a.z, b.x, b.y, b.z, c.x, c.y, c.z, rgba.r, rgba.g, rgba.b, rgba.a)
        DrawPoly(c.x, c.y, c.z, b.x, b.y, b.z, a.x, a.y, a.z, rgba.r, rgba.g, rgba.b, rgba.a)
        DrawPoly(b.x, b.y, b.z, c.x, c.y, c.z, d.x, d.y, d.z, rgba.r, rgba.g, rgba.b, rgba.a)
        DrawPoly(d.x, d.y, d.z, c.x, c.y, c.z, b.x, b.y, b.z, rgba.r, rgba.g, rgba.b, rgba.a)
    end
end

local function debugSphere(self)
    DrawMarker(28, self.coords.x, self.coords.y, self.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, self.radius, self.radius,
        self.radius, self.debugColour.r,
        ---@diagnostic disable-next-line: param-type-mismatch
        self.debugColour.g, self.debugColour.b, self.debugColour.a, false, false, 0, false, false, false, false)
end

local function contains(self, coords, updateDistance)
    if updateDistance then self.distance = #(self.coords - coords); self.currentDistance=self.distance end
    if self.minZ or self.maxZ then
        local lower=self.minZ or self.coords.z-self.thickness/2
        local upper=self.maxZ or self.coords.z+self.thickness/2
        return coords.z>=lower and coords.z<=upper and glm_polygon_contains(self.polygon,vec3(coords.x,coords.y,self.coords.z),self.thickness/4)
    end

    return glm_polygon_contains(self.polygon, coords, self.thickness / 4)
end

local function insideSphere(self, coords, updateDistance)
    local distance = #(self.coords - coords)

    if updateDistance then self.distance = distance; self.currentDistance=distance end

    return distance < self.radius
end

local function convertToVector(coords)
    local _type = type(coords)

    if _type ~= 'vector3' then
        if _type == 'table' or _type == 'vector4' then
            return vec3(coords[1] or coords.x, coords[2] or coords.y, coords[3] or coords.z)
        end

        error(("expected type 'vector3' or 'table' (received %s)"):format(_type))
    end

    return coords
end

local function setDebug(self, bool, colour)
    if not bool and insideZones[self.id] and not (self.inside and self.insideZone) then
        insideZones[self.id] = nil
    end

    if not bool then self.debug = nil; self.triangles = nil; return end
    self.debugColour = bool and
        {
            r = glm.tointeger(colour?.r or self.debugColour?.r or 255),
            g = glm.tointeger(colour?.g or self.debugColour?.g or 42),
            b = glm.tointeger(colour?.b or
                self.debugColour?.b or 24),
            a = glm.tointeger(colour?.a or self.debugColour?.a or 100)
        } or nil

    if not bool and self.debug then
        self.triangles = nil
        self.debug = nil
        return
    end

    if bool and self.debug and self.debug ~= true then return end

    self.triangles = getTriangles(self.polygon, self.thickness, self.__type)
    self.debug = self.__type == 'sphere' and debugSphere or debugPoly or nil
end

---@param data ZoneProperties
---@return CZone
local function setZone(data)
    ---@cast data CZone
    data.remove = removeZone
    data.contains = data.contains or contains

    if api.context == 'client' then
        local coords = cache.coords or GetEntityCoords(cache.ped)
        data.distance = #(data.coords - coords)
        data.currentDistance=data.distance
        data.setDebug = setDebug

        if data.debug then
            data.debug = nil

            data:setDebug(true, data.debugColour)
        end
    else
        data.debug = nil
    end

    Zones[data.id] = data
    api.grid.addEntry(data)

    return data
end

api.zones = {}

---@class PolyZone : ZoneProperties
---@field points vector3[]
---@field thickness? number

---@param data PolyZone
---@return CZone
function api.zones.poly(data)
    nextId = nextId + 1
    data.id = nextId
    data.thickness = data.thickness or 4

    local pointN = #data.points
    local points = table.create(pointN, 0)

    for i = 1, pointN do
        points[i] = convertToVector(data.points[i])
    end
    if data.minZ or data.maxZ then
        local min,max=math.huge,-math.huge
        for _,point in ipairs(points) do min=math.min(min,point.z); max=math.max(max,point.z) end
        if pointN==0 then min,max=0,0 end
        min,max=tonumber(data.minZ) or min-data.thickness/2,tonumber(data.maxZ) or max+data.thickness/2
        if min>max then min,max=max,min end
        data.minZ,data.maxZ,data.thickness=min,max,max-min
        for i,point in ipairs(points) do points[i]=vec3(point.x,point.y,(min+max)/2) end
    end

    data.polygon = glm.polygon.new(points)

    if not data.polygon:isPlanar() then
        local zCoords = {}

        for i = 1, pointN do
            local zCoord = points[i].z

            if zCoords[zCoord] then
                zCoords[zCoord] += 1
            else
                zCoords[zCoord] = 1
            end
        end

        local coordsArray = {}

        for coord, count in pairs(zCoords) do
            coordsArray[#coordsArray + 1] = {
                coord = coord,
                count = count
            }
        end

        table.sort(coordsArray, function(a, b)
            return a.count > b.count
        end)

        local zCoord = coordsArray[1].coord
        local averageTo = 1

        for i = 1, #coordsArray do
            if coordsArray[i].count < coordsArray[1].count then
                averageTo = i - 1
                break
            end
        end

        if averageTo > 1 then
            for i = 2, averageTo do
                zCoord += coordsArray[i].coord
            end

            zCoord /= averageTo
        end

        for i = 1, pointN do
            ---@diagnostic disable-next-line: param-type-mismatch
            points[i] = vec3(data.points[i].xy, zCoord)
        end

        data.polygon = glm.polygon.new(points)
    end

    data.coords = data.polygon:centroid()
    data.__type = 'poly'
    data.radius = api.array.reduce(data.polygon, function(acc, point)
        local distance = #(point - data.coords)
        return distance > acc and distance or acc
    end, 0)

    return setZone(data)
end

---@class BoxZone : ZoneProperties
---@field coords vector3
---@field size? vector3
---@field rotation? number | vector3 | vector4 | matrix

---@param data BoxZone
---@return CZone
function api.zones.box(data)
    nextId = nextId + 1
    data.id = nextId
    data.coords = convertToVector(data.coords)
    data.size = data.size and convertToVector(data.size) / 2 or vec3(2)
    data.thickness = data.size.z * 2
    data.rotation = quat(data.rotation or 0, vec3(0, 0, 1))
    data.__type = 'box'
    data.width = data.size.x * 2
    data.length = data.size.y * 2
    data.polygon = (data.rotation * glm.polygon.new({
        vec3(data.size.x, data.size.y, 0),
        vec3(-data.size.x, data.size.y, 0),
        vec3(-data.size.x, -data.size.y, 0),
        vec3(data.size.x, -data.size.y, 0),
    }) + data.coords)

    return setZone(data)
end

---@class SphereZone : ZoneProperties
---@field coords vector3
---@field radius? number

---@param data SphereZone
---@return CZone
function api.zones.sphere(data)
    nextId = nextId + 1
    data.id = nextId
    data.coords = convertToVector(data.coords)
    data.radius = (data.radius or 2) + 0.0
    data.__type = 'sphere'
    data.contains = insideSphere

    return setZone(data)
end

function api.zones.getAllZones() return Zones end

function api.zones.getCurrentZones() return insideZones end

function api.zones.getNearbyZones() return nearbyZones end

return api.zones
end

