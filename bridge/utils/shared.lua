local utils = {}

function utils.trim(value)
    if value == nil then return nil end
    return tostring(value):gsub("^%s+", ""):gsub("%s+$", "")
end

function utils.firstToUpper(value)
    value = utils.trim(value)
    if not value or value == "" then return value end
    return value:gsub("^%l", string.upper)
end

function utils.round(value, decimals)
    value = tonumber(value)
    if not value then return nil end

    decimals = tonumber(decimals)
    if not decimals or decimals <= 0 then return math.floor(value + 0.5) end

    local power = 10 ^ decimals
    return math.floor((value * power) + 0.5) / power
end

function utils.deepCopy(value, seen)
    if type(value) ~= "table" then return value end

    seen = seen or {}
    if seen[value] then return seen[value] end

    local copy = {}
    seen[value] = copy

    for key, item in pairs(value) do
        copy[utils.deepCopy(key, seen)] = utils.deepCopy(item, seen)
    end

    return setmetatable(copy, utils.deepCopy(getmetatable(value), seen))
end

function utils.dumpTable(value, depth, seen)
    depth = depth or 0

    if type(value) ~= "table" then
        return tostring(value)
    end

    seen = seen or {}
    if seen[value] then return "<recursive>" end
    seen[value] = true

    local indent = string.rep("    ", depth)
    local childIndent = string.rep("    ", depth + 1)
    local output = { "{" }

    for key, item in pairs(value) do
        output[#output + 1] = ("%s[%s] = %s,"):format(childIndent, tostring(key), utils.dumpTable(item, depth + 1, seen))
    end

    output[#output + 1] = ("%s}"):format(indent)
    seen[value] = nil

    return table.concat(output, "\n")
end

function utils.ensureTable(value)
    return type(value) == "table" and value or {}
end

function utils.hash(value)
    if type(value) == "number" then return value end
    if type(value) == "string" then return joaat(value) end
    return nil
end

return utils
