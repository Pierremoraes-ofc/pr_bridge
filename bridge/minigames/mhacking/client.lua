local minigame = {}

if ActiveBridges["minigames"] ~= "mhacking" then return end

function minigame.Start(config, mode)
    config = config or {}
    local data = mode == "parked"
        and config.dificultMinigame and config.dificultMinigame.vehiParked
        or config.dificultMinigame and config.dificultMinigame.vehiCarjack
        or {}

    local game = (config.game or "lockpick"):lower()
    local mhacking = exports["mhacking"]

    if game == "lockpick" then return mhacking:Lockpick(data) == true end
    if game == "chopping" then return mhacking:Chopping(data) == true end
    if game == "pincracker" then return mhacking:PinCracker(data) == true end
    if game == "roofrunning" then return mhacking:RoofRunning(data) == true end
    if game == "thermite" then return mhacking:Thermite(data) == true end
    if game == "terminal" then return mhacking:Terminal(data) == true end

    return false
end

return minigame
