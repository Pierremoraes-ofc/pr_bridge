local minigame = {}
local activeCheck = nil
local sequence = 0

local presets = {
    easy = { areaSize = 72, speedMultiplier = 0.80 },
    medium = { areaSize = 50, speedMultiplier = 1.00 },
    hard = { areaSize = 34, speedMultiplier = 1.30 },
}

local function copyDifficulty(value)
    if type(value) == "string" then
        local label = value:lower()
        local preset = presets[label] or presets.medium
        return { label = label, areaSize = preset.areaSize, speedMultiplier = preset.speedMultiplier }
    end

    if type(value) == "table" then
        return {
            label = tostring(value.label or value.difficulty or "custom"),
            areaSize = math.max(10, math.min(90, tonumber(value.areaSize or value.zoneSize) or presets.medium.areaSize)),
            speedMultiplier = math.max(0.15, math.min(5.0, tonumber(value.speedMultiplier or value.speed) or 1.0)),
        }
    end

    return copyDifficulty("medium")
end

local function normalizeDifficulties(value)
    if type(value) == "string" or (type(value) == "table" and (value.areaSize or value.zoneSize)) then
        value = { value }
    end

    if type(value) ~= "table" or #value == 0 then value = { "easy", "easy", "hard" } end

    local rounds = {}
    for index = 1, #value do rounds[index] = copyDifficulty(value[index]) end
    return rounds
end

local function normalizeKeys(keys)
    if type(keys) == "string" then keys = { keys } end
    if type(keys) ~= "table" or #keys == 0 then keys = { "w", "a", "s", "d" } end

    local normalized = {}
    for index = 1, #keys do
        local key = tostring(keys[index] or ""):lower()
        if key ~= "" then normalized[#normalized + 1] = key end
    end
    return #normalized > 0 and normalized or { "w", "a", "s", "d" }
end

local function finish(check, result, reason)
    if activeCheck ~= check or check.finished then return end
    check.finished = true
    activeCheck = nil
    TriggerEvent("pr_bridge:ui:send", "skillcheck:close", { token = check.token })
    TriggerEvent("pr_bridge:ui:clearKeyboardFocus")
    check.promise:resolve(result == true)

    if reason and reason ~= "success" and Config and Config.debug then
        print(("[pr_bridge:minigame] encerrado reason=%s"):format(tostring(reason)))
    end
end

AddEventHandler("pr_bridge:ui:skillcheck:result", function(resource, token, result, reason)
    local check = activeCheck
    if not check or resource ~= check.resource or token ~= check.token then return end
    finish(check, result == true, reason)
end)

AddEventHandler("onResourceStop", function(resource)
    local check = activeCheck
    if check and resource == check.resource then finish(check, false, "resource_stop") end
end)

function minigame.SkillCheck(difficulties, keys, options)
    if activeCheck then return false end

    options = type(options) == "table" and options or {}
    sequence = sequence + 1

    local resource = GetCurrentResourceName()
    local check = {
        resource = resource,
        token = ("%s:%s:%s"):format(resource, GetGameTimer(), sequence),
        promise = promise.new(),
        finished = false,
    }
    activeCheck = check

    local timeout = math.max(3000, tonumber(options.timeout) or 60000)
    TriggerEvent("pr_bridge:ui:setKeyboardFocus")
    TriggerEvent("pr_bridge:ui:send", "skillcheck:open", {
        __resource = resource,
        token = check.token,
        rounds = normalizeDifficulties(difficulties),
        keys = normalizeKeys(keys),
        timeout = timeout,
        label = options.label or "TESTE DE HABILIDADE",
        position = options.position or ((((GlobalState.pr_bridge_ui_config or {}).layout or {}).skillCheck) or "bottom-center"),
    })

    SetTimeout(timeout + 1000, function() finish(check, false, "timeout") end)
    return Citizen.Await(check.promise) == true
end

function minigame.CancelSkillCheck()
    if not activeCheck then return false end
    finish(activeCheck, false, "cancelled")
    return true
end

function minigame.Start(config, mode)
    config = type(config) == "table" and config or {}
    local difficulties = config.difficulties or config.difficulty
    local keys = config.keys

    if type(config.dificultMinigame) == "table" then
        local selected = mode == "parked" and config.dificultMinigame.vehiParked or config.dificultMinigame.vehiCarjack
        if type(selected) == "table" then
            difficulties = selected.difficulties or selected.difficulty or difficulties
            keys = selected.keys or keys
        end
    end

    return minigame.SkillCheck(difficulties, keys, config)
end

minigame.skillCheck = minigame.SkillCheck
minigame.cancelSkillCheck = minigame.CancelSkillCheck

return minigame