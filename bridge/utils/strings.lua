local strings = {}

local random = math.random
local char = string.char
local generators = {
    ["1"] = function() return random(0, 9) end,
    A = function() return char(random(65, 90)) end,
    a = function() return char(random(97, 122)) end,
    ["."] = function() return random(0, 1) == 1 and char(random(65, 90)) or random(0, 9) end,
}

function strings.random(pattern, length)
    assert(type(pattern) == "string", "pattern must be a string")
    local targetLength = tonumber(length) or #pattern:gsub("%^", "")
    targetLength = math.max(0, math.floor(targetLength))
    local output, outputSize, patternIndex = {}, 0, 0

    while outputSize < targetLength do
        patternIndex = patternIndex + 1
        local value = pattern:sub(patternIndex, patternIndex)
        if value == "" then
            output[#output + 1] = string.rep(" ", targetLength - outputSize)
            break
        elseif value == "^" then
            patternIndex = patternIndex + 1
            value = pattern:sub(patternIndex, patternIndex)
            if value == "" then value = "^" end
        else
            local generator = generators[value]
            if generator then value = generator() end
        end
        outputSize = outputSize + 1
        output[#output + 1] = value
    end

    return table.concat(output)
end

strings.Random = strings.random
return strings
