local commandApi = {}
local registeredSuggestions = {}
local shouldSendSuggestions = false

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

local function getCommandName(raw)
    local command = raw and raw:match("^%S+") or nil
    if not command then return "unknown" end

    return command:gsub("^/", "")
end

local function sendChatMessage(source, message)
    if source and source > 0 then
        TriggerClientEvent("chat:addMessage", source, {
            color = { 255, 80, 80 },
            args = { "pr_bridge", message },
        })
    else
        print(message)
    end
end

local function playerExists(source)
    return source and source > 0 and DoesPlayerExist(tostring(source))
end

local function isWhitelistName(value)
    return type(value) == "string" and value:sub(1, 10) == "pr_bridge:"
end

local function canRunCommand(source, commandName, properties)
    if source == 0 then return true end

    if type(properties.canAccess) == "function" then
        return properties.canAccess(source, commandName, properties) == true
    end

    local aceApi = PRAce or Bridge and Bridge.ace

    if aceApi and properties.whitelist and aceApi.isWhitelisted(source, properties.whitelist) then return true end
    if aceApi and isWhitelistName(properties.restricted) and aceApi.isWhitelisted(source, properties.restricted) then return true end

    if properties.ace and IsPlayerAceAllowed(source, properties.ace) then return true end
    if properties.restricted and not isWhitelistName(properties.restricted) then
        if IsPlayerAceAllowed(source, ("command.%s"):format(commandName)) then return true end
    end

    if properties.groups or properties.jobs or properties.permission then
        return aceApi and aceApi.hasFrameworkAccess(source, properties) == true
    end

    return not properties.restricted and not properties.whitelist and not properties.ace
end

local function convertValue(source, rawValue, param, index, paramsCount, raw)
    local valueType = param.type or "string"

    if rawValue == nil or rawValue == "" then
        return nil
    end

    if valueType == "number" then
        return tonumber(rawValue)
    end

    if valueType == "boolean" or valueType == "bool" then
        local lowered = tostring(rawValue):lower()
        if lowered == "true" or lowered == "yes" or lowered == "1" or lowered == "on" then return true end
        if lowered == "false" or lowered == "no" or lowered == "0" or lowered == "off" then return false end
        return nil
    end

    if valueType == "playerId" or valueType == "player" then
        local playerId = rawValue == "me" and source or tonumber(rawValue)
        if playerExists(playerId) then return playerId end
        return nil
    end

    if valueType == "longString" and index == paramsCount then
        local start = raw:find(rawValue, 1, true)
        return start and raw:sub(start) or rawValue
    end

    if valueType == "string" then
        return tostring(rawValue)
    end

    return rawValue
end

local function parseParams(source, args, raw, definitions)
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
        local value = convertValue(source, rawValue, definition, i, paramsCount, raw)
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

local function buildSuggestion(commandName, properties)
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

    return {
        name = "/" .. commandName,
        help = properties.help,
        params = params,
    }
end

local function addAce(restricted, commandName)
    if restricted == true then return end
    if not restricted then return end
    if isWhitelistName(restricted) then return end

    local ace = ("command.%s"):format(commandName)
    local aceApi = PRAce or Bridge and Bridge.ace

    if type(restricted) == "table" then
        for i = 1, #restricted do
            local principal = restricted[i]
            if aceApi and type(principal) == "string" then
                aceApi.ensureAce(principal, ace)
            elseif type(principal) == "string" and not IsPrincipalAceAllowed(principal, ace) then
                ExecuteCommand(("add_ace %s %s allow"):format(principal, ace))
            end
        end
    elseif aceApi and type(restricted) == "string" then
        aceApi.ensureAce(restricted, ace)
    elseif type(restricted) == "string" and not IsPrincipalAceAllowed(restricted, ace) then
        ExecuteCommand(("add_ace %s %s allow"):format(restricted, ace))
    end
end

local function registerSuggestion(suggestion)
    registeredSuggestions[#registeredSuggestions + 1] = suggestion

    if shouldSendSuggestions then
        TriggerClientEvent("chat:addSuggestion", -1, suggestion.name, suggestion.help, suggestion.params)
    end
end

SetTimeout(1000, function()
    shouldSendSuggestions = true

    for i = 1, #registeredSuggestions do
        local suggestion = registeredSuggestions[i]
        TriggerClientEvent("chat:addSuggestion", -1, suggestion.name, suggestion.help, suggestion.params)
    end
end)

AddEventHandler("playerJoining", function()
    local source = source

    for i = 1, #registeredSuggestions do
        local suggestion = registeredSuggestions[i]
        TriggerClientEvent("chat:addSuggestion", source, suggestion.name, suggestion.help, suggestion.params)
    end
end)

local function createCommand(commandName, properties, cb)
    if type(commandName) ~= "string" or commandName == "" then return false, "missing_name" end
    if type(properties) == "function" and cb == nil then
        cb = properties
        properties = {}
    end

    if type(cb) ~= "function" then return false, "missing_callback" end
    if properties == false then properties = {} end
    if type(properties) ~= "table" then return false, "invalid_properties" end

    local restricted = properties.restricted
    local definitions = properties.params or {}
    local registerRestricted = restricted and not isWhitelistName(restricted) and true or false

    RegisterCommand(commandName, function(source, args, raw)
        if not canRunCommand(source, commandName, properties) then
            sendChatMessage(source, "Voce nao tem permissao para usar este comando.")
            return
        end

        local params, err = parseParams(source, args or {}, raw or "", definitions)

        if not params then
            sendChatMessage(source, err)
            if type(properties.onError) == "function" then
                properties.onError(source, err, args, raw)
            end
            return
        end

        local ok, result = pcall(cb, source, params, raw, params.values)
        if not ok then
            local message = ("Comando '%s' falhou: %s"):format(getCommandName(raw), tostring(result))
            debug("warn", ("[pr_bridge] %s"):format(message))
            sendChatMessage(source, message)
        end
    end, registerRestricted)

    addAce(restricted, commandName)
    registerSuggestion(buildSuggestion(commandName, properties))

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
