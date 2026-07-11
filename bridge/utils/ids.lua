local ids = {}
local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
function ids.createUniqueId(registry, length, pattern)
    registry = registry or {}; length = tonumber(length) or 8; pattern = pattern or alphabet
    if length < 1 or length % 1 ~= 0 then error("length must be a positive integer", 2) end
    local id
    repeat
        local output = {}
        for index = 1, length do local position = math.random(1, #pattern); output[index] = pattern:sub(position, position) end
        id = table.concat(output)
    until registry[id] == nil
    return id
end
ids.CreateUniqueId = ids.createUniqueId
return ids