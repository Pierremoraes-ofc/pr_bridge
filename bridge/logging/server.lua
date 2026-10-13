-- Canonical PR library module. Shared by native users and legacy adapters.
-- Algorithms promoted only where no equivalent PR implementation existed.
return function(api)
local cache = api.cache
--[[
    https://github.com/overextended/ox_lib

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright © 2025 Linden <https://github.com/thelindat>
]]

local service = GetConvar('ox:logger', 'datadog')

local function removeColorCodes(str)
    -- replace ^[0-9] with nothing
    str = string.gsub(str, "%^%d", "")

    -- replace ^#[0-9A-F]{3,6} with nothing
    str = string.gsub(str, "%^#[%dA-Fa-f]+", "")

    -- replace ~[a-z]~ with nothing
    str = string.gsub(str, "~[%a]~", "")

    return str
end

local hostname = removeColorCodes(GetConvar('ox:logger:hostname', GetConvar('sv_projectName', 'fxserver')))

local function badResponse(endpoint, status, response)
    warn(('unable to submit logs to %s (status: %s)\n%s'):format(endpoint, status, json.encode(response, { indent = true })))
end

local playerData = {}

AddEventHandler('playerDropped', function()
    playerData[source] = nil
end)

local function formatTags(source, tags)
    if type(source) == 'number' and source > 0 then
        local data = playerData[source]

        if not data then
            local _data = {
                ('username:%s'):format(GetPlayerName(source))
            }

            local num = 1

            ---@cast source string
            for i = 0, GetNumPlayerIdentifiers(source) - 1 do
                local identifier = GetPlayerIdentifier(source, i)

                if not identifier:find('ip') then
                    num = num + 1
                    _data[num] = identifier
                end
            end

            data = table.concat(_data, ',')
            playerData[source] = data
        end

        tags = tags and ('%s,%s'):format(tags, data) or data
    end

    return tags
end

---@class LogContext
---@field hostname string
---@field formatTags fun(source: any, tags: string?): string?

---@class LogProvider
---@field endpoint string
---@field headers table<string, string>
---@field okStatus number
---@field append fun(buffer: table, source: any, event: string, message: string, ...): nil
---@field encode fun(buffer: table): string
---@field parseError fun(status: number, response: any, body: string): any|nil

local KNOWN = { datadog = true, fivemanage = true, loki = true }

if not KNOWN[service] then return function() end end

---@type fun(ctx: LogContext): LogProvider?
-- Provider integration: never read an external ox_lib installation.
local providerFactory = PRCore.load(('@pr_bridge/bridge/logging/providers/%s'):format(service), _ENV)
if not providerFactory then return function() end end

local provider = providerFactory({
    hostname = hostname,
    formatTags = formatTags,
})
if not provider then return function() end end

local buffer

function api.logger(source, event, message, ...)
    if not buffer then
        buffer = {}

        SetTimeout(500, function()
            local body = provider.encode(buffer)
            buffer = nil

            PerformHttpRequest(provider.endpoint, function(status, _, _, response)
                if status == provider.okStatus then return end

                local err = provider.parseError(status, response, body)
                if err == nil then return end

                badResponse(provider.endpoint, status, err)
            end, 'POST', body, provider.headers)
        end)
    end

    provider.append(buffer, source, event, message, ...)
end

return api.logger
end

