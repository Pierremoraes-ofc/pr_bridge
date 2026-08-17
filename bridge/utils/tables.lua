local tables = {}

function tables.contains(source, value)
    if type(source) ~= "table" then return false end
    if type(value) == "table" then
        for _, expected in pairs(value) do if not tables.contains(source, expected) then return false end end
        return true
    end
    if source[value] ~= nil then return source[value] ~= false end
    for _, item in pairs(source) do if item == value then return true end end
    return false
end

function tables.matches(left, right, seen)
    if left == right then return true end
    if type(left) ~= type(right) then return false end
    if type(left) ~= "table" then return false end

    seen = seen or {}
    if seen[left] == right then return true end
    seen[left] = right

    for key, value in pairs(left) do
        if not tables.matches(value, right[key], seen) then return false end
    end

    for key in pairs(right) do
        if left[key] == nil then return false end
    end

    return true
end

function tables.merge(target, source, override)
    if type(target) ~= "table" or type(source) ~= "table" then error("merge expects tables", 2) end
    if override == nil then override = true end
    for key, value in pairs(source) do
        if type(target[key]) == "table" and type(value) == "table" then
            tables.merge(target[key], value, override)
        elseif override or target[key] == nil then
            target[key] = type(value) == "table" and tables.clone(value) or value
        end
    end
    return target
end

function tables.clone(value, seen)
    if type(value) ~= "table" then return value end
    seen = seen or {}; if seen[value] then return seen[value] end
    local copy = {}; seen[value] = copy
    for key, item in pairs(value) do copy[tables.clone(key, seen)] = tables.clone(item, seen) end
    return setmetatable(copy, tables.clone(getmetatable(value), seen))
end

function tables.shuffle(source, copy, random)
    local result = copy and tables.clone(source) or source
    local rng = random or math.random
    for index = #result, 2, -1 do local other = rng(index); result[index], result[other] = result[other], result[index] end
    return result
end

function tables.map(source, callback)
    local result = {}; for key, value in pairs(source) do result[key] = callback(value, key) end; return result
end

function tables.count(source) local count=0; for _ in pairs(source or {}) do count=count+1 end; return count end

local readonly = "pr_bridge:readonly"

function tables.isfrozen(source)
    return type(source) == "table" and getmetatable(source) == readonly
end

function tables.freeze(source)
    assert(type(source) == "table", "freeze expects a table")
    if tables.isfrozen(source) then return source end

    local values = tables.clone(source)
    local originalMeta = getmetatable(source)
    for key in pairs(source) do source[key] = nil end

    setmetatable(source, {
        __index = originalMeta and setmetatable(values, originalMeta) or values,
        __newindex = function() error("cannot set values on a frozen table", 2) end,
        __len = function() return #values end,
        __pairs = function() return next, values end,
        __metatable = readonly,
    })

    return source
end

tables.Contains=tables.contains; tables.Matches=tables.matches; tables.Merge=tables.merge; tables.deepclone=tables.clone; tables.DeepClone=tables.clone; tables.Shuffle=tables.shuffle; tables.Map=tables.map; tables.Count=tables.count
tables.Freeze=tables.freeze; tables.IsFrozen=tables.isfrozen
return tables
