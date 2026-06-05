local weather = {}

---This will toggle the players weather/time sync
---@param toggle boolean
function weather.ToggleSync(toggle)
    -- Lógica simples usando nativas do jogo para o exemplo "default"
    -- Quando o sync é pausado, podemos fixar o tempo ou o clima localmente
    if toggle then
        -- Retomar sincronização (exemplo hipotético, nativas puras apenas controlam localmente)
        if Debug then
            Debug("INFO", "Weather Sync Enabled (Default Logic)")
        end
        NetworkClearClockTimeOverridden()
        ClearOverrideWeather()
    else
        -- Pausar/Override localmente
        if Debug then
            Debug("INFO", "Weather Sync Disabled (Default Logic)")
        end
        -- Fixa o tempo localmente em 12:00 como exemplo de "pausar"
        NetworkOverrideClockTime(12, 0, 0)
        SetWeatherTypeNowPersist("EXTRASUNNY")
    end
end

function weather.GetResourceName()
    return "default"
end

return weather
