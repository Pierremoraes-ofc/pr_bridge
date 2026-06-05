local weather = {}

if ActiveBridges["weather"] ~= "renewed" then return end

---This will toggle the players weather/time sync
---@param toggle boolean
function weather.ToggleSync(toggle)
    LocalPlayer.state.syncWeather = toggle
end

function weather.GetResourceName()
    return "renewed-weathersync"
end

return weather
