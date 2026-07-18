local minigame = {}

if ActiveBridges["minigames"] ~= "ox_lib" then return end

function minigame.Start(config, mode)
    config = config or {}
    local difficulties = config.difficulties or config.difficulty
    local keys = config.keys

    if config.dificultMinigame then
        local data = mode == "parked" and config.dificultMinigame.vehiParked or config.dificultMinigame.vehiCarjack
        difficulties = data and data.difficulty or difficulties
        keys = data and data.keys or keys
    end

    return lib.skillCheck(difficulties or { "easy", "easy", "hard" }, keys or { "w", "a", "s", "d" }) == true
end

return minigame
