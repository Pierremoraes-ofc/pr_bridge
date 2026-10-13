-- Private presentation sampler. It never reads controls, moves the camera or dispatches actions.
local function finite(value, fallback)
    value = tonumber(value)
    if not value or value ~= value or value == math.huge or value == -math.huge then return fallback end
    return value
end

local function bounded(value, fallback, minimum, maximum)
    return math.max(minimum, math.min(maximum, finite(value, fallback)))
end

return function()
    local originYaw, lastTime
    local angle, lastTarget = 0, 0
    local sampler = {}

    function sampler.reset()
        originYaw, lastTime, angle, lastTarget = nil, nil, 0, 0
        return 0
    end

    function sampler.update(config, yaw, now)
        if config.perspectiveEnabled ~= true then return sampler.reset() end
        yaw, now = finite(yaw), finite(now)
        if not yaw or not now then return sampler.reset() end
        if originYaw == nil then
            originYaw, lastTime = yaw, now
            return 0
        end

        local elapsed = now - lastTime
        -- A clock reset needs a fresh baseline; an idle camera or long frame
        -- does not. Large turns are handled by the angle cap below.
        if elapsed < 0 then
            originYaw, lastTime, angle, lastTarget = yaw, now, 0, 0
            return 0
        end

        local maximum = bounded(config.perspectiveMaxAngle, 25, 0, 35)
        local sensitivity = bounded(config.perspectiveSensitivity, 1, 0.1, 3)
        local smoothing = bounded(config.perspectiveSmoothing, 120, 0, 400)
        if elapsed == 0 then
            angle = math.max(-maximum, math.min(maximum, angle))
            return math.floor(angle * 1000 + 0.5) / 1000
        end
        lastTime = now
        -- GTA yaw decreases when looking right. Positive CSS rotateY brings the left edge forward.
        -- The initial camera direction is the neutral plane. 45 degrees of
        -- displacement at sensitivity 1 reaches the configurable +/- cap.
        local displacement = (originYaw - yaw + 180) % 360 - 180
        local target = math.max(-1, math.min(1, displacement / 45 * sensitivity)) * maximum
        if smoothing > 0 then
            local decay = math.exp(-elapsed / smoothing)
            -- Exact first-order response to a linearly changing target: the
            -- same camera path has the same result at different frame rates.
            angle = target + (angle - lastTarget) * decay
                - (target - lastTarget) * smoothing / elapsed * (1 - decay)
        else
            angle = target
        end
        lastTarget = target
        angle = math.max(-maximum, math.min(maximum, angle))
        if math.abs(angle) < 0.01 then angle = 0 end
        return math.floor(angle * 1000 + 0.5) / 1000
    end

    return sampler
end
