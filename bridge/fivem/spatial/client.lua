-- Canonical native points/zones engine, extracted from init.lua.
-- The legacy points import delegates here instead of running another loop.
local public = {}
local activePoints, nextId = {}, 0
public.points = {}

function public.points.new(data, distance, extraData)
    local point
    if extraData ~= nil then
        point = extraData
        point.coords = data
        point.distance = distance
    else
        point = data or {}
    end
    nextId = nextId + 1
    point.id = nextId
    point.distance = tonumber(point.distance) or 1.0
    point.radius = point.distance
    point.currentDistance = math.huge
    point.inside = false
    function point:remove()
        self.removed = true
        if self.inside and self.onExit then self:onExit() end
        self.inside = false
    end
    activePoints[#activePoints + 1] = point
    return point
end

function public.points.getAllPoints(indexed)
    local points = {}
    for i = 1, #activePoints do
        if not activePoints[i].removed then points[indexed and activePoints[i].id or #points + 1] = activePoints[i] end
    end
    return points
end

function public.points.getNearbyPoints()
    local nearby = {}
    for _, point in ipairs(activePoints) do
        if not point.removed and point.currentDistance <= point.distance then nearby[#nearby + 1] = point end
    end
    return nearby
end

function public.points.getClosestPoint(filter, onlyNearby)
    local closest
    for i = 1, #activePoints do
        local point = activePoints[i]
        if not point.removed and point.currentDistance < math.huge and (not onlyNearby or point.currentDistance <= point.distance) and (not filter or filter(point)) then
            if not closest or point.currentDistance < closest.currentDistance then
                closest = point
            end
        end
    end
    return closest
end
-- Resolve the complete canonical zone service lazily. Points retain their
-- native scheduler; zone geometry/queries/debugging have only one owner.
public.zones = setmetatable({}, {__index=function(self,key)
    local owner = rawget(_ENV,'pr_lib') or rawget(_ENV,'Bridge')
    owner = owner or {context='client',cache=rawget(_ENV,'cache') or {ped=PlayerPedId(),resource=GetCurrentResourceName()}}
    local library = PRCore.load('@pr_bridge/bridge/library/init',_ENV)(owner,_ENV)
    local method=library.zones[key]
    if key=='sphere' or key=='box' or key=='poly' then
        local facade=function(data)
            data=data or {}
            -- Preserve the existing native facade's defaults/callback name.
            -- Geometry, indexing and scheduling remain in the canonical service.
            data.nativeZone=true
            data.inside=data.nearby or data.inside
            if key=='sphere' then data.radius=data.radius or data.distance or 1.0 end
            if key=='box' then data.size=data.size or vector3(1,1,1) end
            return method(data)
        end
        rawset(self,key,facade)
        return facade
    end
    rawset(self,key,method)
    return method
end})
CreateThread(function()
    while true do
        local sleep = 250
        local coords = GetEntityCoords(PlayerPedId())
        local closestPoint = public.points.getClosestPoint()
        for i = #activePoints, 1, -1 do
            local point = activePoints[i]
            point.isClosest = point == closestPoint
            if point.removed then
                table.remove(activePoints, i)
            elseif point.coords then
                point.currentDistance = #(coords - vector3(point.coords.x, point.coords.y, point.coords.z))
                local inside
                if point.contains then
                    inside = point:contains(coords)
                else
                    inside = point.currentDistance <= point.distance
                end
                if inside then
                    sleep = 0
                    if not point.inside then
                        point.inside = true
                        if point.onEnter then point:onEnter() end
                    end
                    if point.nearby then point:nearby() end
                elseif point.inside then
                    point.inside = false
                    if point.onExit then point:onExit() end
                end
            end
        end
        Wait(sleep)
    end
end)
return public
