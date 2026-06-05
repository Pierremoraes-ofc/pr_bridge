local weather = {}

if ActiveBridges["weather"] ~= "cd_easytime" then return end

---This will toggle the players weather/time sync
---@param toggle boolean
function weather.ToggleSync(toggle)
    TriggerEvent('cd_easytime:PauseSync', toggle)
end

function weather.GetResourceName()
    return "cd_easytime"
end

return weather
