-- Include after @pr_bridge/init.lua in a consumer's shared_scripts.
-- Preserves the MDT calling convention while delegating to the Forge bridge.
assert(pr_lib and pr_lib.framework, 'pr_bridge must be initialized before police compatibility')
local api, server = {}, IsDuplicityVersion()
local framework = pr_lib.framework
pr_lib.police = api

-- Vehicle catalogue access stays in the bridge; QBX does not expose a QB core object.
function api.getVehicleDefinition(model)
    if type(model) == 'table' then model = model.model or model.vehicle or model.hash end
    if type(model) ~= 'string' and type(model) ~= 'number' then return nil end
    if GetResourceState('qbx_core') == 'started' then
        local ok, definition = pcall(function()
            if tonumber(model) then return exports.qbx_core:GetVehiclesByHash(tonumber(model)) end
            return exports.qbx_core:GetVehiclesByName(model:lower())
        end)
        if ok and type(definition) == 'table' and definition.name then return definition end
    elseif GetResourceState('qb-core') == 'started' then
        local ok, definition = pcall(function()
            local core = exports['qb-core']:GetCoreObject()
            return core.Shared.Vehicles[model]
        end)
        if ok and type(definition) == 'table' then return definition end
    end
end

local function log(level, ...)
    if level == 'debug' and not (Config and Config.Debug) then return end
    local parts = {}
    for i = 1, select('#', ...) do parts[i] = tostring(select(i, ...)) end
    print(('[%s:%s] %s'):format(GetCurrentResourceName(), level, table.concat(parts, ' ')))
end
for _, level in ipairs({'debug', 'info', 'warn', 'error'}) do
    api[level] = function(...) log(level, ...) end
end
api.registerCallback = function(name, handler) return pr_lib.callback.register(name, handler) end
api.callback = function(name, ...) return pr_lib.callback.await(name, 10000, ...) end

if server then
    function api.getPlayer(source)
        if type(source) == 'table' then return source end
        return framework.GetPlayer(tonumber(source))
    end
    function api.getPlayerByIdentifier(identifier)
        if type(identifier) ~= 'string' or identifier == '' then return nil end
        return framework.GetPlayerFromIdentifier(identifier) or exports.qbx_core:GetOfflinePlayer(identifier)
    end
    function api.getPlayerData(source)
        local player = api.getPlayer(source)
        if not player and type(source) == 'string' and not tonumber(source) then player = api.getPlayerByIdentifier(source) end
        return player and player.PlayerData or {}
    end
    function api.getAllPlayers()
        local result = {}
        for _, source in ipairs(GetPlayers()) do result[#result+1] = tonumber(source) end
        return result
    end
    function api.getPlayerNameByIdentifier(identifier)
        local player = api.getPlayerByIdentifier(identifier)
        local info = player and player.PlayerData and player.PlayerData.charinfo or {}
        return ((info.firstname or '') .. ' ' .. (info.lastname or '')):match('^%s*(.-)%s*$')
    end
    function api.getMetadata(source, key) return (api.getPlayerData(source).metadata or {})[key] end
    function api.getCharInfo(source, key) return (api.getPlayerData(source).charinfo or {})[key] end
    function api.addMoney(source, account, amount, reason)
        return framework.addPlayerMoney(source, account or 'cash', amount, reason)
    end
    function api.removeMoney(source, account, amount, reason)
        return framework.removePlayerMoney(source, account or 'cash', amount, reason)
    end
    function api.getSharedJob(name) return exports.qbx_core:GetJobs()[name] end
    function api.getSharedJobData(name, key) return (api.getSharedJob(name) or {})[key] end
    function api.getSharedJobGrade(name, grade)
        local grades = (api.getSharedJob(name) or {}).grades or {}
        return grades[tonumber(grade)] or grades[tostring(grade)]
    end
    function api.getSharedJobGradeData(name, grade, key) return (api.getSharedJobGrade(name, grade) or {})[key] end
    local function countJobs(value, field)
        local count = 0
        for _, source in ipairs(GetPlayers()) do
            local job = api.getJob(source)
            if job.onduty and job[field] == value then count = count + 1 end
        end
        return count
    end
    function api.getJobCount(name) return countJobs(name, 'name') end
    function api.getJobTypeCount(name) return countJobs(name, 'type') end
    function api.notify(source, message, kind, duration)
        TriggerClientEvent(GetCurrentResourceName() .. ':bridge:notify', source, message, kind, duration)
    end
else
    function api.getPlayerData() return framework.GetPlayerData() or {} end
    function api.getPlayer() return PlayerPedId() end
    function api.getMetadata(key) return (api.getPlayerData().metadata or {})[key] end
    function api.getCharInfo(key) return (api.getPlayerData().charinfo or {})[key] end
    function api.isDead()
        local metadata, ped = api.getPlayerData().metadata or {}, PlayerPedId()
        return metadata.isdead == true or metadata.inlaststand == true
            or IsEntityDead(ped) or IsPedFatallyInjured(ped) or GetEntityHealth(ped) <= 100
    end
    function api.addKeybind(key, command, description) RegisterKeyMapping(command, description, 'keyboard', key) end
    function api.requestModel(model)
        local ok = pcall(pr_lib.requestModel, model)
        return ok and HasModelLoaded(type(model) == 'string' and joaat(model) or model)
    end
    function api.requestAnim(dict)
        local ok = pcall(pr_lib.requestAnimDict, dict)
        return ok and HasAnimDictLoaded(dict)
    end
    function api.notify(message, kind, duration)
        local data = {title = 'Forge Police', description = tostring(message), type = kind == 'info' and 'inform' or kind, duration = duration}
        if pr_lib.menus and pr_lib.menus.notify then return pr_lib.menus.notify(data) end
        return pr_lib.Notify(data)
    end
    RegisterNetEvent(GetCurrentResourceName() .. ':bridge:notify', function(...)
        if source ~= 65535 then return end
        api.notify(...)
    end)
end
function api.getIdentifier(source) return api.getPlayerData(source).citizenid end
function api.getPlayerName(source)
    local info = api.getPlayerData(source).charinfo or {}
    return ((info.firstname or '') .. ' ' .. (info.lastname or '')):match('^%s*(.-)%s*$')
end
api.getName = api.getPlayerName
function api.getJob(source) return api.getPlayerData(source).job or {} end
function api.getJobName(source) return api.getJob(source).name end
function api.getJobType(source) return api.getJob(source).type end
function api.getJobDuty(source) return api.getJob(source).onduty == true end
function api.getJobData(source, key)
    if not server then key, source = source, nil end
    local job = api.getJob(source)
    if key == nil then return job end
    return job[key]
end
function api.isBoss(source) return api.getJob(source).isboss == true end
function api.getJobGradeName(source)
    local job = api.getJob(source)
    if type(job.grade) == 'table' then return job.grade.name end
    if server then return (api.getSharedJobGrade(job.name, job.grade) or {}).name end
end
function api.getJobGradePay(source) return api.getJob(source).payment or 0 end
