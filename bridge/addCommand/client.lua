local commandApi = {}

local function debug(level, message)
    local debugApi = Bridge and Bridge.debug
    if not debugApi then return end

    local fn = debugApi[level]
    if type(fn) == "function" then
        fn(message)
    elseif type(debugApi) == "function" then
        debugApi(level, message)
    end
end

local function cloneParam(param)
    local cloned = {}

    for key, value in pairs(param or {}) do
        cloned[key] = value
    end

    return cloned
end

local function convertValue(rawValue, param, index, paramsCount, raw)
    local valueType = param.type or "string"

    if rawValue == nil or rawValue == "" then return nil end

    if valueType == "number" then return tonumber(rawValue) end

    if valueType == "boolean" or valueType == "bool" then
        local lowered = tostring(rawValue):lower()
        if lowered == "true" or lowered == "yes" or lowered == "1" or lowered == "on" then return true end
        if lowered == "false" or lowered == "no" or lowered == "0" or lowered == "off" then return false end
        return nil
    end

    if valueType == "playerId" or valueType == "player" then
        if rawValue == "me" then return GetPlayerServerId(PlayerId()) end
        return tonumber(rawValue)
    end

    if valueType == "longString" and index == paramsCount then
        local start = raw:find(rawValue, 1, true)
        return start and raw:sub(start) or rawValue
    end

    if valueType == "string" then return tostring(rawValue) end

    return rawValue
end

local function parseParams(args, raw, definitions)
    local parsed = {
        values = {},
        raw = raw,
    }

    if not definitions or #definitions == 0 then
        for i = 1, #args do
            parsed[i] = {
                name = tostring(i),
                type = "string",
                rawValue = args[i],
                value = args[i],
                valid = true,
                provided = args[i] ~= nil,
            }
        end

        return parsed
    end

    local paramsCount = #definitions

    for i = 1, paramsCount do
        local definition = cloneParam(definitions[i])
        local rawValue = args[i]
        local value = convertValue(rawValue, definition, i, paramsCount, raw)
        local provided = rawValue ~= nil and rawValue ~= ""
        local valid = value ~= nil or definition.optional == true and not provided

        definition.index = i
        definition.rawValue = rawValue
        definition.value = value
        definition.valid = valid
        definition.provided = provided
        definition.missing = not provided

        if not valid then
            return nil, ("Parametro invalido #%s (%s). Esperado: %s | Recebido: %s"):format(
                i,
                definition.name or "unknown",
                definition.type or "string",
                tostring(rawValue)
            )
        end

        parsed[i] = definition

        if definition.name then
            parsed[definition.name] = definition
            parsed.values[definition.name] = value
        end
    end

    return parsed
end

local function addSuggestion(commandName, properties)
    properties = properties or {}

    local params = {}
    local definitions = properties.params or {}

    for i = 1, #definitions do
        local param = definitions[i]
        local help = param.help

        if param.type then
            help = help and ("%s (type: %s)"):format(help, param.type) or ("type: %s"):format(param.type)
        end

        if param.optional then
            help = help and ("%s | optional"):format(help) or "optional"
        end

        params[i] = {
            name = param.name or tostring(i),
            help = help,
        }
    end

    TriggerEvent("chat:addSuggestion", "/" .. commandName, properties.help, params)
end

local function createCommand(commandName, properties, cb)
    if type(commandName) ~= "string" or commandName == "" then return false, "missing_name" end
    if type(properties) == "function" and cb == nil then
        cb = properties
        properties = {}
    end

    if type(cb) ~= "function" then return false, "missing_callback" end
    if properties == false then properties = {} end
    if type(properties) ~= "table" then return false, "invalid_properties" end

    RegisterCommand(commandName, function(_, args, raw)
        if type(properties.canAccess) == "function" and properties.canAccess(commandName, properties) ~= true then
            TriggerEvent("chat:addMessage", {
                color = { 255, 80, 80 },
                args = { "pr_bridge", "Voce nao tem permissao para usar este comando." },
            })
            return
        end

        local params, err = parseParams(args or {}, raw or "", properties.params or {})
        if not params then
            TriggerEvent("chat:addMessage", {
                color = { 255, 80, 80 },
                args = { "pr_bridge", err },
            })
            return
        end

        local ok, result = pcall(cb, params, raw, params.values)
        if not ok then
            debug("warn", ("[pr_bridge] Comando client '%s' falhou: %s"):format(commandName, tostring(result)))
            TriggerEvent("chat:addMessage", {
                color = { 255, 80, 80 },
                args = { "pr_bridge", ("Comando '%s' falhou."):format(commandName) },
            })
        end
    end, false)

    addSuggestion(commandName, properties)

    return true
end

function commandApi.add(commandName, properties, cb)
    if type(commandName) == "table" then
        local results = {}

        for i = 1, #commandName do
            local ok, err = createCommand(commandName[i], properties, cb)
            results[commandName[i]] = ok == true and true or err
        end

        return results
    end

    return createCommand(commandName, properties, cb)
end

commandApi.register = commandApi.add
commandApi.addCommand = commandApi.add

return setmetatable(commandApi, {
    __call = function(_, commandName, properties, cb)
        return commandApi.add(commandName, properties, cb)
    end,
})
