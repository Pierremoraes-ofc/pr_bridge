local minigame = {}

-- Also usable explicitly by consumers requiring GTA-native Glitch games.

local function getResourceName()
    if GetResourceState("glitch-minigames")=="started" then return "glitch-minigames" end
    if GetResourceState("glitch-minigame")=="started" then return "glitch-minigame" end
end
local function startDrill(glitch,game,difficulty)
    pr_lib.requestAnimDict('anim@heists@fleeca_bank@drilling')
    pr_lib.requestModel('hei_prop_heist_drill')
    -- Fleeca's installed Init only allows short scaleform retries. Warm the GTA
    -- movie before calling the export so a cold client does not fail immediately.
    local movieName=game=='PlasmaDrilling' and 'VAULT_LASER' or 'DRILLING'
    local movie=RequestScaleformMovie(movieName)
    local deadline=GetGameTimer()+10000
    while not HasScaleformMovieLoaded(movie) and GetGameTimer()<deadline do Wait(50) end
    if not HasScaleformMovieLoaded(movie) then
        SetScaleformMovieAsNoLongerNeeded(movie)
        error('Não foi possível carregar o scaleform '..movieName..'.',2)
    end
    local ok,result=pcall(function()
        if game=='FleecaDrilling' then return glitch:StartDrilling() end
        return glitch:StartPlasmaDrilling(difficulty)
    end)
    SetScaleformMovieAsNoLongerNeeded(movie)
    if not ok then error(result,2) end
    return result==true
end

function minigame.Start(config, mode)
    config = config or {}
    local data = mode == "parked"
        and config.dificultMinigame and config.dificultMinigame.vehiParked
        or config.dificultMinigame and config.dificultMinigame.vehiCarjack
        or {}

    local game = config.game or "Lockpick"
    local resource=getResourceName()
    if not resource then error('Glitch minigames indisponível: aguarde o recurso iniciar.',2) end
    local glitch = exports[resource]

    if game == "BarHit" then return glitch:StartBarHitGame(data.rounds, data.speed, data.zoneSize, data.maxFailures, data.timeLimit) == true end
    if game == "SkillCheck" then return glitch:StartSkillCheckGame(data.speed, data.timeLimit, data.zoneSize, data.perfectZoneSize, data.maxFailures, data.randomizeZone) == true end
    if game == "NumberUp" then return glitch:StartNumberUpGame(data.count, data.timeLimit, data.gridCols, data.maxMistakes) == true end
    if game == "ComboInput" then return glitch:StartComboInputGame(data.rounds, data.comboLength, data.timePerCombo, data.maxFailures, data.lengthIncrease) == true end
    if game == "HoldZone" then return glitch:StartHoldZoneGame("E", data.rounds, data.speed, data.zoneSize, data.perfectZoneSize, data.maxFailures, math.max(3, math.floor(((data.timeLimit or 10000) / 1000)))) == true end
    if game == "WireConnect" then return glitch:StartWireConnectGame(data.wireCount, data.timeLimit) == true end
    if game == "SimonSays" then return glitch:StartSimonSaysGame(data.rounds, data.flashSpeed, data.flashGap, data.timeLimit, data.maxMistakes) == true end
    if game == "AimTest" then return glitch:StartAimTestGame(data.targetsToHit, data.maxMisses, data.targetLifetime, data.targetSize, data.timeLimit) == true end
    if game == "CircleClick" then return glitch:StartCircleClickGame(data.rounds, data.rotationSpeed, data.targetZoneSize, data.maxFailures, data.speedIncrease, data.randomizeDirection) == true end
    if game == "Lockpick" then return glitch:StartLockpickGame(data.rounds, data.sweetSpotSize, data.maxFailures, data.shakeRange, data.lockTime) == true end
    if game == "Keymash" then return glitch:StartSurgeOverride(data.keyPressValue, data.decayRate) == true end
    if game == "Untangle" then return glitch:StartUntangleGame(data.nodeCount, data.timeLimit) == true end
    if game == "Pairs" then return glitch:StartPairsGame(data.gridSize, data.timeLimit, data.maxAttempts) == true end
    if game == "MemoryColors" then return glitch:StartMemoryColorsGame(data.gridSize, data.memorizeTime, data.answerTime, data.rounds) == true end
    if game == "Fingerprint" then return glitch:StartFingerprintGame(data.timeLimit, data.showAlignedCount, data.showCorrectIndicator) == true end
    if game == "CodeCrack" then return glitch:StartCodeCrackGame(data.timeLimit, data.digitCount, data.maxAttempts) == true end
    if game == "FirewallPulse" then return glitch:StartFirewallPulse(data.requiredHacks, data.initialSpeed, data.maxSpeed, data.timeLimit) == true end
    if game == "BackdoorSequence" then return glitch:StartBackdoorSequence(data.totalStages, data.keysPerStage, data.timeLimit) == true end
    if game == "Rhythm" then return glitch:StartCircuitRhythm(data.lanes, data.noteSpeed, data.noteSpawnRate, data.requiredNotes, data.maxWrongKeys, data.maxMissedNotes) == true end
    if game == "Memory" then return glitch:StartMemoryGame(data.gridSize, data.squareCount, data.rounds, data.showTime, data.maxWrongPresses) == true end
    if game == "SequenceMemory" then return glitch:StartSequenceMemoryGame(data.gridSize, data.rounds, data.showTime, data.delayBetween, data.maxWrongPresses) == true end
    if game == "VerbalMemory" then return glitch:StartVerbalMemoryGame(data.maxStrikes, data.wordsToShow, data.wordDuration) == true end
    if game == "NumberedSequence" then return glitch:StartNumberedSequenceGame(data.gridSize, data.sequenceLength, data.rounds, data.showTime, data.guessTime, data.maxWrongPresses) == true end
    if game == "SymbolSearch" then return glitch:StartSymbolSearchGame(data.gridSize, data.shiftInterval, data.timeLimit, data.minKeyLength, data.maxKeyLength) == true end
    if game == "VarHack" then return glitch:StartVarHack(data.blocks, data.speed) == true end
    if game == "PipePressure" then return glitch:StartPipePressureGame(data.gridSize, data.timeLimit) == true end
    if game == "WordCrack" then return glitch:StartWordCrackGame(data.timeLimit, data.wordLength, data.maxAttempts) == true end
    if game == "Balance" then return glitch:StartBalanceGame(data.timeLimit, data.driftSpeed, data.sensitivity, data.greenZoneWidth, data.yellowZoneWidth, data.driftRandomness, data.maxDangerTime) == true end
    if game == "BruteForce" then return glitch:StartBruteForce(data.numLives) == true end
    if game == "DataCrack" then return glitch:StartDataCrack(data.difficulty) == true end
    if game == "CircuitBreaker" then return glitch:StartCircuitBreaker(data.levelNumber, data.difficultyLevel, data.delayStartMs, data.minFailureDelayTimeMs, data.maxFailureDelayTimeMs, data.disconnectChance, data.disconnectCheckRateMs, data.minReconnectTimeMs, data.maxReconnectTimeMs) == true end
    -- Fleeca owns its model, animation, scaleform and awaited result. Keep this
    -- identical to its documented zero-argument export, without a second init.
    if game == "FleecaDrilling" then return glitch:StartDrilling() == true end
    if game == "PlasmaDrilling" then return startDrill(glitch,game,math.max(1,math.min(10,tonumber(data.difficulty) or 5))) end

    return false
end

return minigame
