local progress = {}

if ActiveBridges["progressbar"] ~= "qb" then return end

local QBCore = exports["qb-core"]:GetCoreObject()

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
