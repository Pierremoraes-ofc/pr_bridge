local numbers = {}

local function number(value, name)
    local parsed = tonumber(value)
    if not parsed then error(("%s must be a number"):format(name or "value"), 3) end
    return parsed
end

function numbers.round(value, places)
    value = number(value)
    places = tonumber(places) or 0
    local factor = 10 ^ math.max(0, places)
    return math.floor(value * factor + 0.5) / factor
end

function numbers.clamp(value, minimum, maximum)
    value, minimum, maximum = number(value), number(minimum, "minimum"), number(maximum, "maximum")
    if minimum > maximum then minimum, maximum = maximum, minimum end
    return math.max(minimum, math.min(maximum, value))
end

function numbers.toHex(value, upper)
    return (upper and "0x%X" or "0x%x"):format(number(value))
end

function numbers.hexToRGBA(value)
    if type(value) ~= "string" then error("value must be a string", 2) end
    local hex = value:gsub("#", "")
    if #hex == 3 or #hex == 4 then hex = hex:gsub(".", "%0%0") end
    if #hex ~= 6 and #hex ~= 8 then error("invalid hex color", 2) end
    return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16), #hex == 8 and tonumber(hex:sub(7, 8), 16) or 255
end

function numbers.hexToRGB(value)
    local r, g, b = numbers.hexToRGBA(value)
    return r, g, b
end

function numbers.parse(value, minimum, maximum, shouldRound)
    local parsed = number(value)
    if shouldRound then parsed = math.floor(parsed + 0.5) end
    if minimum ~= nil and parsed < minimum then error(("value must be >= %s"):format(minimum), 2) end
    if maximum ~= nil and parsed > maximum then error(("value must be <= %s"):format(maximum), 2) end
    return parsed
end

function numbers.toScalars(value, minimum, maximum, shouldRound)
    local result = {}
    for part in tostring(value):gmatch("[^,%s]+") do result[#result + 1] = numbers.parse(part, minimum, maximum, shouldRound) end
    return table.unpack(result)
end

function numbers.toVector(value, minimum, maximum, shouldRound)
    local values = {}
    if type(value) == "string" then
        for part in value:gmatch("[^,%s]+") do values[#values + 1] = numbers.parse(part, minimum, maximum, shouldRound) end
    elseif type(value) == "table" then
        values = { value.x or value[1], value.y or value[2], value.z or value[3], value.w or value[4] }
    else
        error(("cannot convert %s to vector"):format(type(value)), 2)
    end
    if values[4] ~= nil then return vector4(values[1], values[2], values[3], values[4]) end
    if values[3] ~= nil then return vector3(values[1], values[2], values[3]) end
    if values[2] ~= nil then return vector2(values[1], values[2]) end
    return number(values[1] or 0)
end

function numbers.normalToRotation(input)
    if type(input) ~= "vector3" then error("input must be vector3", 2) end
    return vector3(-math.asin(input.y) * 180 / math.pi, math.atan(input.x, input.z) * 180 / math.pi, 0.0)
end

local function lerpValue(startValue, finishValue, factor)
    factor = number(factor, "factor")
    if type(startValue) == "number" then return startValue + (finishValue - startValue) * factor end
    if type(startValue) == "table" then
        local result = {}
        for key, value in pairs(startValue) do result[key] = lerpValue(value, finishValue[key], factor) end
        return result
    end
    return startValue + (finishValue - startValue) * factor
end

function numbers.lerp(startValue, finishValue, factor)
    return lerpValue(startValue, finishValue, factor)
end

function numbers.Lerp(startValue, finishValue, duration)
    duration = math.max(0, tonumber(duration) or 0)
    local started = GetGameTimer and GetGameTimer() or 0
    local step
    return function()
        if step == nil then step = 0; return startValue, step end
        if step >= 1 then return nil end
        if Wait then Wait(0) end
        local elapsed = (GetGameTimer and GetGameTimer() or started) - started
        step = duration == 0 and 1 or math.min(elapsed / duration, 1)
        return lerpValue(startValue, finishValue, step), step
    end
end
function numbers.inverseLerp(startValue, finishValue, value)
    startValue, finishValue, value = number(startValue), number(finishValue), number(value)
    return startValue == finishValue and 0 or (value - startValue) / (finishValue - startValue)
end

function numbers.map(value, inMin, inMax, outMin, outMax)
    return lerpValue(number(outMin), number(outMax), numbers.inverseLerp(inMin, inMax, value))
end

function numbers.degToRad(value) return number(value) * math.pi / 180 end
function numbers.radToDeg(value) return number(value) * 180 / math.pi end
function numbers.sign(value) value=number(value); return value > 0 and 1 or value < 0 and -1 or 0 end
function numbers.almostEqual(a, b, epsilon) return math.abs(number(a) - number(b)) <= (tonumber(epsilon) or 1e-6) end
function numbers.length2(x, y) x,y=number(x),number(y); return math.sqrt(x*x+y*y) end
function numbers.length3(x, y, z) x,y,z=number(x),number(y),number(z); return math.sqrt(x*x+y*y+z*z) end
function numbers.distance2D(x1,y1,x2,y2) return numbers.length2(number(x2)-number(x1), number(y2)-number(y1)) end
function numbers.distance3D(x1,y1,z1,x2,y2,z2) return numbers.length3(number(x2)-number(x1), number(y2)-number(y1), number(z2)-number(z1)) end

numbers.Round=numbers.round; numbers.Clamp=numbers.clamp; numbers.ToHex=numbers.toHex; numbers.HexToRGB=numbers.hexToRGB; numbers.HexToRGBA=numbers.hexToRGBA
numbers.ParseNumber=numbers.parse; numbers.ToScalars=numbers.toScalars; numbers.ToVector=numbers.toVector; numbers.NormalToRotation=numbers.normalToRotation
numbers.InverseLerp=numbers.inverseLerp; numbers.Map=numbers.map; numbers.Deg2Rad=numbers.degToRad; numbers.Rad2Deg=numbers.radToDeg
numbers.Sign=numbers.sign; numbers.AlmostEqual=numbers.almostEqual; numbers.Length2=numbers.length2; numbers.Length3=numbers.length3; numbers.Distance2D=numbers.distance2D; numbers.Distance3D=numbers.distance3D
return numbers