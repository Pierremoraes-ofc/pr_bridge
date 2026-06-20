local ace = {}

local function trim(value)
    return (tostring(value or ""):gsub("^%s+", ""):gsub("%s+$", ""))
end

local function normalizeIdentifier(value)
    value = trim(value):lower()
    if value == "" then return nil end
    return value
end

local function addIdentifier(identifiers, value, prefixes)
    value = normalizeIdentifier(value)
    if not value then return end

    if not identifiers[value] then
        identifiers[#identifiers + 1] = value
        identifiers[value] = true
    end

    local suffix = value:match("^[%w_%-]+:(.+)$")
    if suffix and suffix ~= "" and not identifiers[suffix] then
        identifiers[#identifiers + 1] = suffix
        identifiers[suffix] = true
    end

    if type(prefixes) == "table" then
        for i = 1, #prefixes do
            local prefixed = ("%s:%s"):format(prefixes[i], value)
            if not identifiers[prefixed] then
                identifiers[#identifiers + 1] = prefixed
                identifiers[prefixed] = true
            end
        end
    end
end

local function addTableIdentifiers(identifiers, data)
    if type(data) ~= "table" then return end

    addIdentifier(identifiers, data.citizenid or data.citizenId, { "citizenid", "identifier" })
    addIdentifier(identifiers, data.charid or data.charId or data.characterId, { "charid", "identifier" })
    addIdentifier(identifiers, data.identifier or data.Identifier, { "identifier" })

    if type(data.PlayerData) == "table" then
        addTableIdentifiers(identifiers, data.PlayerData)
    end

    if type(data.charinfo) == "table" then
        addTableIdentifiers(identifiers, data.charinfo)
    end
end

local function addFrameworkIdentifiers(identifiers, source)
    local framework = Bridge and Bridge.framework
    if not framework then return end

    if type(framework.GetIdentifier) == "function" then
        local ok, identifier = pcall(framework.GetIdentifier, source)
        if ok then
            addIdentifier(identifiers, identifier, { "identifier", "citizenid", "charid" })
        end
    end

    if type(framework.GetPlayer) == "function" then
        local ok, player = pcall(framework.GetPlayer, source)
        if ok then
            addTableIdentifiers(identifiers, player)
        end
    end
end

function ace.parseConvarList(raw)
    local values = {}
    raw = trim(raw)
    if raw == "" then return values end

    for quoted in raw:gmatch("[\"']([^\"']+)[\"']") do
        local value = normalizeIdentifier(quoted)
        if value then values[value] = true end
    end

    if next(values) then return values end

    raw = raw:gsub("[%[%]{}]", "")
    for value in raw:gmatch("[^,%s]+") do
        local parsedValue = normalizeIdentifier(value)
        if parsedValue then values[parsedValue] = true end
    end

    return values
end

function ace.getIdentifiers(source)
    local identifiers = {}

    if type(source) ~= "number" or source <= 0 then return identifiers end

    for _, identifier in ipairs(GetPlayerIdentifiers(source)) do
        addIdentifier(identifiers, identifier)
    end

    addFrameworkIdentifiers(identifiers, source)

    return identifiers
end

function ace.hasIdentifier(source, identifier)
    identifier = normalizeIdentifier(identifier)
    if not identifier then return false end

    local identifiers = ace.getIdentifiers(source)
    return identifiers[identifier] == true
end

function ace.isWhitelisted(source, whitelistName)
    if source == 0 then return true end
    if type(whitelistName) ~= "string" or whitelistName == "" then return false end

    local convarName = whitelistName:find(":", 1, true) and whitelistName or ("pr_bridge:%s"):format(whitelistName)
    local allowed = ace.parseConvarList(GetConvar(convarName, ""))
    local identifiers = ace.getIdentifiers(source)

    for _, identifier in ipairs(identifiers) do
        if allowed[identifier] then return true end
    end

    return false
end

function ace.isPlayerAceAllowed(source, aceName)
    if source == 0 then return true end
    if type(aceName) ~= "string" or aceName == "" then return false end

    return IsPlayerAceAllowed(source, aceName) == true
end

function ace.isCommandAllowed(source, commandName)
    if type(commandName) ~= "string" or commandName == "" then return false end
    return ace.isPlayerAceAllowed(source, ("command.%s"):format(commandName:gsub("^/", "")))
end

function ace.ensureAce(principal, aceName)
    if type(principal) ~= "string" or principal == "" then return false end
    if type(aceName) ~= "string" or aceName == "" then return false end

    if not IsPrincipalAceAllowed(principal, aceName) then
        ExecuteCommand(("add_ace %s %s allow"):format(principal, aceName))
    end

    return true
end

function ace.ensureCommandAce(principal, commandName)
    if type(commandName) ~= "string" or commandName == "" then return false end
    return ace.ensureAce(principal, ("command.%s"):format(commandName:gsub("^/", "")))
end

local function listContains(list, value)
    if value == nil then return false end

    if type(list) == "string" then
        return list == value
    end

    if type(list) == "table" then
        if list[value] ~= nil then return true end

        for i = 1, #list do
            if list[i] == value then return true end
        end
    end

    return false
end

function ace.hasFrameworkAccess(source, options)
    options = options or {}

    if source == 0 then return true end

    local framework = Bridge and Bridge.framework
    if not framework then return false end

    if type(options.permission) == "function" then
        return options.permission(source, framework) == true
    end

    if options.groups and framework.getPlayerGroup then
        local group = framework.getPlayerGroup(source)
        if listContains(options.groups, group) then return true end
    end

    if options.jobs and framework.getPlayerJob then
        local jobName = framework.getPlayerJob(source, "name")
        local jobGrade = tonumber(framework.getPlayerJob(source, "grade")) or 0
        local jobs = options.jobs

        if type(jobs) == "string" then
            return jobName == jobs
        end

        if type(jobs) == "table" then
            if listContains(jobs, jobName) then return true end

            local minGrade = tonumber(jobs[jobName])
            if minGrade then return jobGrade >= minGrade end
        end
    end

    return false
end

function ace.canAccess(source, options)
    options = options or {}
    if source == 0 then return true end

    if type(options.canAccess) == "function" then
        return options.canAccess(source, options) == true
    end

    if options.whitelist and ace.isWhitelisted(source, options.whitelist) then return true end
    if options.ace and ace.isPlayerAceAllowed(source, options.ace) then return true end
    if options.command and ace.isCommandAllowed(source, options.command) then return true end
    if options.groups or options.jobs or options.permission then return ace.hasFrameworkAccess(source, options) end

    return false
end

ace.hasAce = ace.isPlayerAceAllowed
ace.hasCommandAce = ace.isCommandAllowed
ace.inWhitelist = ace.isWhitelisted

return ace
