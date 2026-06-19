local fivem = {}

local net = PRCore.load("@pr_bridge/bridge/fivem/net/server", _ENV) or {}
local vehicleCache = PRCore.load("@pr_bridge/bridge/fivem/vehicleCache/shared", _ENV) or {}
local blips = PRCore.load("@pr_bridge/bridge/fivem/blips/shared", _ENV) or {}
local streaming = PRCore.load("@pr_bridge/bridge/fivem/streaming/server", _ENV) or {}
local ace = PRCore.load("@pr_bridge/bridge/ace/server", _ENV) or {}
local addCommand = PRCore.load("@pr_bridge/bridge/addCommand/server", setmetatable({
    PRAce = ace,
}, {
    __index = _ENV,
}))
local objects = PRCore.load("@pr_bridge/bridge/fivem/objects/server", _ENV) or {}
local instructionalButtons = PRCore.load("@pr_bridge/bridge/fivem/instructionalButtons/server", _ENV) or {}
local drawtext = PRCore.load("@pr_bridge/bridge/fivem/drawtext/server", _ENV) or {}
local editorCamera = PRCore.load("@pr_bridge/bridge/fivem/editorCamera/server", _ENV) or {}
local gizmo = PRCore.load("@pr_bridge/bridge/fivem/gizmo/server", _ENV) or {}
local moduleEnv = setmetatable({
    PRFivemNet = net,
    PRVehicleCache = vehicleCache,
}, {
    __index = _ENV,
})
local vehicleProperties = PRCore.load("@pr_bridge/bridge/fivem/vehicleProperties/server", moduleEnv) or {}
moduleEnv.PRVehicleProperties = vehicleProperties
local tuning = PRCore.load("@pr_bridge/bridge/fivem/tuning/server", moduleEnv) or {}

fivem.net = net
fivem.vehicleCache = vehicleCache
fivem.blips = blips
fivem.streaming = streaming
fivem.ace = ace
fivem.permissions = ace
fivem.addCommand = addCommand
fivem.command = addCommand
fivem.commands = addCommand
fivem.objects = objects
fivem.instructionalButtons = instructionalButtons
fivem.buttons = instructionalButtons
fivem.drawtext = drawtext
fivem.drawText = drawtext
fivem.textui = drawtext
fivem.textUI = drawtext
fivem.editorCamera = editorCamera
fivem.editor_camera = editorCamera
fivem.gizmo = gizmo
fivem.vehicleProperties = vehicleProperties
fivem.tuning = tuning
fivem.setVehicleProperties = vehicleProperties.set

fivem.vehicle = {
    cache = vehicleCache,
    net = net,
    setProperties = vehicleProperties.set,
    getNetId = net.getNetId,
    getEntity = net.getEntity,
    getVehicle = net.getVehicle,
    resolve = net.resolveVehicle,
    getOwner = net.getOwner,
    findInRadius = objects.getVehiclesInRadius,
    findClosest = objects.getClosestVehicle,
    tuning = tuning,
}

fivem.vehicles = {
    findInRadius = objects.getVehiclesInRadius,
    findByModelInRadius = objects.getVehiclesByModelInRadius,
    findClosest = objects.getClosestVehicle,
    findClosestByModel = objects.getClosestVehicleByModel,
    tuning = tuning,
}

fivem.editor = {
    camera = editorCamera,
    gizmo = gizmo,
    drawtext = drawtext,
    drawText = drawtext,
}

return fivem
