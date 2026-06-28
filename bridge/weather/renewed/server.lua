local weather = {}

local resourceName = 'Renewed-Weathersync'

local function isStarted()
    return GetResourceState(resourceName) == 'started'
end

local function callExport(name, ...)
    if not isStarted() then return false, 'weather_resource_stopped' end

    local ok, result = pcall(function(...)
        return exports[resourceName][name](...)
    end, ...)

    if not ok then return false, result end
    return true, result
end

local function normalizeIndex(index)
    index = math.floor(tonumber(index) or 0)
    if index < 1 then return nil end
    return index
end

local function normalizeDuration(duration)
    duration = math.floor(tonumber(duration) or 0)
    if duration < 1 then return 1 end
    if duration > 1440 then return 1440 end
    return duration
end

local function normalizeHour(value)
    value = math.floor(tonumber(value) or 0)
    if value < 0 then return 0 end
    if value > 23 then return 23 end
    return value
end

local function normalizeMinute(value)
    value = math.floor(tonumber(value) or 0)
    if value < 0 then return 0 end
    if value > 59 then return 59 end
    return value
end

local function boolValue(value)
    if type(value) == 'boolean' then return value end

    local lowered = tostring(value):lower()
    return lowered == 'true' or lowered == '1' or lowered == 'yes' or lowered == 'sim'
end

local function getWeatherList()
    local ok, result = callExport('GetWeatherList')
    if not ok then return false, result end
    return true, type(result) == 'table' and result or {}
end

local function setCurrentWeather(weatherType, duration)
    GlobalState.weather = {
        weather = weatherType,
        time = normalizeDuration(duration or (GlobalState.weather and GlobalState.weather.time) or 10),
    }

    return true, weatherType
end

local function resolveIndex(index, match)
    index = normalizeIndex(index)
    local ok, weatherList = getWeatherList()
    if not ok then return false, weatherList end

    if index and weatherList[index] then return true, index end

    if type(match) == 'table' then
        for candidateIndex, event in ipairs(weatherList) do
            if event.weather == match.weather and tonumber(event.time) == tonumber(match.time) then
                return true, candidateIndex
            end
        end

        for candidateIndex, event in ipairs(weatherList) do
            if event.weather == match.weather then
                return true, candidateIndex
            end
        end
    end

    return false, 'weather_not_found'
end

function weather.GetResourceName()
    return resourceName
end

function weather.IsStarted()
    return isStarted()
end

function weather.GetWeatherList()
    return getWeatherList()
end

function weather.GetState()
    local ok, weatherList = getWeatherList()
    if not ok then return false, weatherList end

    return true, {
        weatherList = weatherList,
        currentWeather = GlobalState.weather,
        currentTime = GlobalState.currentTime or { hour = 0, minute = 0 },
        timeScale = tonumber(GlobalState.timeScale) or 0,
        freezeTime = GlobalState.freezeTime == true,
    }
end

function weather.SetWeatherType(index, weatherType, match)
    if normalizeIndex(index) == 1 then
        return setCurrentWeather(weatherType, type(match) == 'table' and match.time or nil)
    end

    local ok, resolvedIndex = resolveIndex(index, match)
    if not ok then
        local duration = type(match) == 'table' and normalizeDuration(match.time) or 10
        local addOk, added = callExport('AddWeatherEvent', weatherType, duration, normalizeIndex(index))
        if not addOk then return false, added end
        if not added then return false, 'add_failed' end
        return true, weatherType
    end

    local exportOk, result = callExport('SetWeatherType', resolvedIndex, weatherType)
    if not exportOk then return false, result end
    if not result then
        local duration = type(match) == 'table' and normalizeDuration(match.time) or 10
        local addOk, added = callExport('AddWeatherEvent', weatherType, duration, resolvedIndex)
        if not addOk then return false, added end
        if not added then return false, 'add_failed' end
        return true, weatherType
    end

    return true, result
end

function weather.SetEventTime(index, duration, match)
    if normalizeIndex(index) == 1 then
        local currentWeather = type(match) == 'table' and match.weather or (GlobalState.weather and GlobalState.weather.weather)
        if currentWeather then
            return setCurrentWeather(currentWeather, duration)
        end
    end

    local ok, resolvedIndex = resolveIndex(index, match)
    if not ok then
        if type(match) == 'table' and match.weather then
            local addOk, added = callExport('AddWeatherEvent', match.weather, normalizeDuration(duration), normalizeIndex(index))
            if not addOk then return false, added end
            if not added then return false, 'add_failed' end
            return true, normalizeDuration(duration)
        end

        return false, resolvedIndex
    end

    local exportOk, result = callExport('SetEventTime', resolvedIndex, normalizeDuration(duration))
    if not exportOk then return false, result end
    if not result then
        if type(match) == 'table' and match.weather then
            local addOk, added = callExport('AddWeatherEvent', match.weather, normalizeDuration(duration), resolvedIndex)
            if not addOk then return false, added end
            if not added then return false, 'add_failed' end
            return true, normalizeDuration(duration)
        end

        return false, 'weather_not_found'
    end

    return true, result
end

function weather.AddWeatherEvent(weatherType, duration, index)
    local ok, result = callExport('AddWeatherEvent', weatherType, normalizeDuration(duration), normalizeIndex(index))
    if not ok then return false, result end
    if not result then return false, 'add_failed' end

    return true, result
end

function weather.RemoveWeatherEvent(index, match)
    local ok, resolvedIndex = resolveIndex(index, match)
    if not ok then return true, 'already_removed' end

    local exportOk, result = callExport('RemoveWeatherEvent', resolvedIndex)
    if not exportOk then return false, result end
    if not result then return true, 'already_removed' end

    return true, result
end

function weather.SetTime(hour, minute)
    GlobalState.currentTime = {
        hour = normalizeHour(hour),
        minute = normalizeMinute(minute),
    }

    return true, GlobalState.currentTime
end

function weather.SetTimeScale(scale)
    scale = math.floor(tonumber(scale) or 0)
    if scale < 2000 then scale = 2000 end
    if scale > 60000 then scale = 60000 end

    GlobalState.timeScale = scale
    return true, scale
end

function weather.SetFreezeTime(enabled)
    GlobalState.freezeTime = boolValue(enabled)
    return true, GlobalState.freezeTime
end

weather.getResourceName = weather.GetResourceName
weather.isStarted = weather.IsStarted
weather.getWeatherList = weather.GetWeatherList
weather.getState = weather.GetState
weather.setWeatherType = weather.SetWeatherType
weather.setEventTime = weather.SetEventTime
weather.addWeatherEvent = weather.AddWeatherEvent
weather.removeWeatherEvent = weather.RemoveWeatherEvent
weather.setTime = weather.SetTime
weather.setTimeScale = weather.SetTimeScale
weather.setFreezeTime = weather.SetFreezeTime

if ActiveBridges["weather"] == "renewed" then
    Debug('SUCCESS', Lang:t('Debug.WeatherDetected', { weather = 'Renewed Weather' }))
end

return weather
