local minigame = {}

if ActiveBridges["minigames"] ~= "glitch" then return end

local function getResourceName()
    if GetResourceState("glitch-minigames"):find("start") then return "glitch-minigames" end
    return "glitch-minigame"
end

function minigame.Start(config, mode)
    config = config or {}
    local data = mode == "parked"
        and config.dificultMinigame and config.dificultMinigame.vehiParked
        or config.dificultMinigame and config.dificultMinigame.vehiCarjack
        or {}

    local game = config.game or "Lockpick"
    local glitch = exports[getResourceName()]

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
    if game == "FleecaDrilling" then return glitch:StartDrilling() == true end
    if game == "PlasmaDrilling" then return glitch:StartPlasmaDrilling(data.difficulty) == true end

    return false
end

return minigame
