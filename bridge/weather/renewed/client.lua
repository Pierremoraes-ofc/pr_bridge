local weather = {}
if ActiveBridges['weather'] ~= 'renewed' then return end
local resource='Renewed-Weathersync'
local function invoke(name,...)
    if GetResourceState(resource)~='started' then return false,'weather_resource_stopped' end
    local ok,result=pcall(function(...) return exports[resource][name](...) end,...)
    return ok,result
end
function weather.ToggleSync(toggle) return invoke('ToggleSync',toggle==true) end
function weather.GetSnapshot() return invoke('GetSnapshot') end
function weather.GetCurrentRegion() return invoke('GetCurrentRegion') end
function weather.GetRegionFromCoords(coords) return invoke('GetRegionFromCoords',coords) end
function weather.GetRegionalWeather() return invoke('GetCurrentRegionWeather') end
function weather.OnChange(fn)
    assert(type(fn)=='function','Weather listener must be a function')
    return AddEventHandler('pr_bridge:weather:changed',fn)
end
function weather.GetResourceName() return resource end
return weather
