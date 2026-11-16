local progress = {}

if ActiveBridges["progressbar"] ~= "qb" then return end

local QBCore = PRCore.load('@pr_bridge/bridge/runtime/native_object',_ENV)(function()return exports['qb-core']:GetCoreObject()end)

function progress.doProgressbar(duration, label, anim)
    QBCore.Functions.Progressbar(label, label, duration, false, true, {
            disableMovement = true,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        },
        {
            animDict = anim[1],
            anim = anim[2],
        }, {}, {}, function()
            return true
        end, function()
            return false
        end)
end

return progress
