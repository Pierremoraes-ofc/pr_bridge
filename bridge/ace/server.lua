local ace = {}
local permissionRegistry = {}

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

local function isAceAllowedResult(value)
    return value == true or value == 1
end

local function playerAceAllowed(source, aceName)
    local principal = ('player.%s'):format(tostring(tonumber(source) or source or ''))
    if principal ~= 'player.' then
        local ok, allowed = pcall(IsPrincipalAceAllowed, principal, aceName)
        if ok and isAceAllowedResult(allowed) then return true end
    end

    local numericSource = tonumber(source)
    if numericSource then
        local ok, allowed = pcall(IsPlayerAceAllowed, numericSource, aceName)
        if ok and isAceAllowedResult(allowed) then return true end
    end

    local textSource = tostring(source or '')
    if textSource ~= '' then
        local ok, allowed = pcall(IsPlayerAceAllowed, textSource, aceName)
        if ok and isAceAllowedResult(allowed) then return true end
    end

    return false
end

function ace.isPlayerAceAllowed(source, aceName)
    if source == 0 then return true end
    if type(aceName) ~= "string" or aceName == "" then return false end

    return playerAceAllowed(source, aceName)
end

function ace.isIdentifierAceAllowed(source, aceName)
    if source == 0 then return true end
    if type(aceName) ~= "string" or aceName == "" then return false end

    local identifiers = ace.getIdentifiers(source)
    for _, identifier in ipairs(identifiers) do
        if type(identifier) == "string" and identifier:find(":", 1, true) then
            local ok, allowed = pcall(IsPrincipalAceAllowed, ("identifier.%s"):format(identifier), aceName)
            if ok and isAceAllowedResult(allowed) then return true end

            ok, allowed = pcall(IsPrincipalAceAllowed, identifier, aceName)
            if ok and isAceAllowedResult(allowed) then return true end
        end
    end

    return false
end

function ace.isCommandAllowed(source, commandName)
    if type(commandName) ~= "string" or commandName == "" then return false end
    return playerAceAllowed(source, ("command.%s"):format(commandName:gsub("^/", "")))
end

function ace.ensureAce(principal, aceName)
    if type(principal) ~= "string" or principal == "" then return false end
    if type(aceName) ~= "string" or aceName == "" then return false end

    if not isAceAllowedResult(IsPrincipalAceAllowed(principal, aceName)) then
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
ace.hasIdentifierAce = ace.isIdentifierAceAllowed
ace.hasCommandAce = ace.isCommandAllowed
ace.inWhitelist = ace.isWhitelisted

local function allowAce(allow)
    return allow == false and 'deny' or 'allow'
end

function ace.addAce(principal, aceName, allow)
    if type(principal) == 'number' then
        principal = 'player.' .. principal
    end
    ExecuteCommand(('add_ace %s %s %s'):format(principal, aceName, allowAce(allow)))
end

function ace.removeAce(principal, aceName, allow)
    if type(principal) == 'number' then
        principal = 'player.' .. principal
    end
    ExecuteCommand(('remove_ace %s %s %s'):format(principal, aceName, allowAce(allow)))
end

function ace.addPrincipal(child, parent)
    if type(child) == 'number' then
        child = 'player.' .. child
    end
    ExecuteCommand(('add_principal %s %s'):format(child, parent))
end

function ace.removePrincipal(child, parent)
    if type(child) == 'number' then
        child = 'player.' .. child
    end
    ExecuteCommand(('remove_principal %s %s'):format(child, parent))
end

PRCore.callback.register('pr_bridge:checkPlayerAce', function(source, aceName)
    return ace.isPlayerAceAllowed(source, aceName)
end)

local function normalizePermissionName(value)
    value = trim(value)
    if value == '' or value:find('%s') or not value:match('^[%w_%.:%-]+$') then return nil end
    return value
end

local function permissionLabel(value)
    local label = tostring(value or ''):gsub('^group%.', 'Grupo '):gsub('^command%.', 'Comando ')
    label = label:gsub('[_%.%-]+', ' ')
    return (label:gsub('(%a)([%w]*)', function(first, rest)
        return first:upper() .. rest
    end))
end

local function addPermission(catalog, value, data)
    value = normalizePermissionName(value)
    if not value then return false end
    data = type(data) == 'table' and data or {}
    local existing = catalog[value]
    if existing then
        if data.label and (not existing.label or existing.label == permissionLabel(value)) then existing.label = data.label end
        if data.description and not existing.description then existing.description = data.description end
        return false
    end
    local entry = {
        value = value,
        label = data.label or permissionLabel(value),
        description = data.description,
        kind = data.kind or (value:find('^group%.') and 'principal' or 'ace'),
        source = data.source or 'runtime',
    }
    catalog[value] = entry
    catalog[#catalog + 1] = entry
    return true
end

function ace.registerPermission(value, data)
    local catalog = {}
    if not addPermission(catalog, value, data) then return false end
    permissionRegistry[catalog[1].value] = catalog[1]
    return true
end

function ace.unregisterPermission(value)
    value = normalizePermissionName(value)
    if not value then return false end
    local existed = permissionRegistry[value] ~= nil
    permissionRegistry[value] = nil
    return existed
end

local function serverRootPath()
    local resourcePath = GetResourcePath(GetCurrentResourceName())
    if type(resourcePath) ~= 'string' then return nil end
    return resourcePath:match('^(.*)[/\\]resources[/\\]')
end

local function readServerConfig(relativePath, onLine)
    relativePath = trim(relativePath):gsub('\\', '/')
    if relativePath == '' or relativePath:find('..', 1, true) or relativePath:match('^[/\\]') or relativePath:match('^%a:') then return false end
    local root = serverRootPath()
    if not root or type(io) ~= 'table' or type(io.open) ~= 'function' then return false end
    local ok, file = pcall(io.open, root .. '/' .. relativePath, 'r')
    if not ok or not file then return false end
    local readOk = pcall(function()
        for line in file:lines() do onLine(line, relativePath) end
    end)
    file:close()
    return readOk
end

local function parseConfigLine(catalog, line, sourceName)
    line = tostring(line or ''):gsub('#.*$', ''):gsub('//.*$', '')
    local _, aceName, decision = line:match('^%s*add_ace%s+(%S+)%s+(%S+)%s+(%S+)')
    if aceName and tostring(decision):lower() == 'allow' then addPermission(catalog, aceName, { kind = 'ace', source = sourceName }) end
    local _, parent = line:match('^%s*add_principal%s+(%S+)%s+(%S+)')
    if parent and parent:find('^group%.') then addPermission(catalog, parent, { kind = 'principal', source = sourceName }) end
end

local function sortCatalog(left, right)
    local function weight(entry)
        if entry.value:find('^group%.') then return 1 end
        if entry.value:find('^command%.') then return 3 end
        return 2
    end
    local leftWeight, rightWeight = weight(left), weight(right)
    if leftWeight ~= rightWeight then return leftWeight < rightWeight end
    return tostring(left.label) < tostring(right.label)
end

function ace.getPermissionCatalog(options)
    options = type(options) == 'table' and options or {}
    local catalog = {}
    for _, entry in pairs(permissionRegistry) do addPermission(catalog, entry.value, entry) end
    for _, entry in ipairs(options.fallback or {}) do
        if type(entry) == 'string' then addPermission(catalog, entry, { source = 'fallback' })
        elseif type(entry) == 'table' then addPermission(catalog, entry.value or entry.name or entry.ace, entry) end
    end
    for _, fileName in ipairs(options.files or { 'server.cfg', 'permissions.cfg' }) do
        readServerConfig(fileName, function(line, sourceName) parseConfigLine(catalog, line, sourceName) end)
    end
    for value in GetConvar('pr_bridge:ace:catalog', ''):gmatch('[^,%s]+') do addPermission(catalog, value, { source = 'convar' }) end
    local hidden = options.hidden or {}
    local filtered = {}
    for i = 1, #catalog do
        local entry = catalog[i]
        if hidden[entry.value] ~= true then filtered[#filtered + 1] = entry end
    end
    table.sort(filtered, sortCatalog)
    return filtered
end

ace.discoverPermissions = ace.getPermissionCatalog
ace.listPermissions = ace.getPermissionCatalog

return ace
