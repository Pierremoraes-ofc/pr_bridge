local function round(value)
    return tonumber(("%.2f"):format(value))
end

local Timer = {}
Timer.__index = Timer

function Timer:getTimeLeft(format)
    local remaining = self.paused and self.currentTimeLeft
        or self.currentTimeLeft - (GetGameTimer() - self.startTime)
    remaining = math.max(0, remaining)
    if format == "ms" then return round(remaining) end
    local seconds = remaining / 1000
    if format == "s" then return round(seconds) end
    local minutes = seconds / 60
    if format == "m" then return round(minutes) end
    local hours = minutes / 60
    if format == "h" then return round(hours) end
    return { ms = round(remaining), s = round(seconds), m = round(minutes), h = round(hours) }
end

function Timer:isPaused() return self.paused end

function Timer:_run(generation)
    while generation == self.generation and (self.paused or self:getTimeLeft("ms") > 0) do Wait(0) end
    if generation ~= self.generation then return end
    self.running = false
    self.startTime = 0
    if self.triggerOnEnd and self.onEnd then self.onEnd(self) end
    self.triggerOnEnd = true
end

function Timer:start(async)
    if self.running then error("Cannot start a timer that is already running", 2) end
    self.running, self.paused, self.startTime = true, false, GetGameTimer()
    self.generation = self.generation + 1
    local generation = self.generation
    if not async then return self:_run(generation) end
    CreateThread(function() self:_run(generation) end)
    return self
end

function Timer:forceEnd(triggerOnEnd)
    if not self.running then return self end
    self.triggerOnEnd = triggerOnEnd == true
    self.currentTimeLeft, self.paused = 0, false
    return self
end

function Timer:pause()
    if self.running and not self.paused then
        self.currentTimeLeft, self.paused = self:getTimeLeft("ms"), true
    end
    return self
end

function Timer:play()
    if self.running and self.paused then
        self.startTime, self.paused = GetGameTimer(), false
    end
    return self
end

function Timer:restart(async)
    self.generation = self.generation + 1
    self.currentTimeLeft, self.startTime = self.initialTime, 0
    self.running, self.paused, self.triggerOnEnd = false, false, true
    self:start(async)
    return self
end

return function(duration, onEnd, async)
    assert(type(duration) == "number" and duration > 0, "time must be a positive number")
    assert(onEnd == nil or type(onEnd) == "function", "onEnd must be a function or nil")
    assert(async == nil or type(async) == "boolean", "async must be a boolean or nil")
    local instance = setmetatable({
        initialTime = duration, currentTimeLeft = duration, startTime = 0,
        paused = false, running = false, triggerOnEnd = true, generation = 0, onEnd = onEnd,
    }, Timer)
    instance:start(async)
    return instance
end
