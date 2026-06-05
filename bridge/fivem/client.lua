local fivem = {}

local net = PRCore.load("@pr_bridge/bridge/fivem/net/client", _ENV) or {}
local vehicleCache = PRCore.load("@pr_bridge/bridge/fivem/vehicleCache/shared", _ENV) or {}
local blips = PRCore.load("@pr_bridge/bridge/fivem/blips/shared", _ENV) or {}
local streaming = PRCore.load("@pr_bridge/bridge/fivem/streaming/client", _ENV) or {}
local objects = PRCore.load("@pr_bridge/bridge/fivem/objects/client", _ENV) or {}
local instructionalButtons = PRCore.load("@pr_bridge/bridge/fivem/instructionalButtons/client", _ENV) or {}
local drawtext = PRCore.load("@pr_bridge/bridge/fivem/drawtext/client", _ENV) or {}
local editorCamera = PRCore.load("@pr_bridge/bridge/fivem/editorCamera/client", _ENV) or {}
local moduleEnv = setmetatable({
    PRFivemNet = net,
    PRVehicleCache = vehicleCache,
}, {
    __index = _ENV,
})
local vehicleProperties = PRCore.load("@pr_bridge/bridge/fivem/vehicleProperties/client", moduleEnv) or {}
moduleEnv.PRVehicleProperties = vehicleProperties
local tuning = PRCore.load("@pr_bridge/bridge/fivem/tuning/client", moduleEnv) or {}
local gizmo = PRCore.load("@pr_bridge/bridge/fivem/gizmo/client", setmetatable({
    PRInstructionalButtons = instructionalButtons,
    PRDrawText = drawtext,
    PRStreaming = streaming,
    PREditorCamera = editorCamera,
}, {
    __index = _ENV,
})) or {}
local devlaser = PRCore.load("@pr_bridge/bridge/fivem/devlaser/client", setmetatable({
    PRInstructionalButtons = instructionalButtons,
    PRDrawText = drawtext,
    PRGizmo = gizmo,
}, {
    __index = _ENV,
})) or {}
local devtools = PRCore.load("@pr_bridge/bridge/fivem/devtools/client", setmetatable({
    PRInstructionalButtons = instructionalButtons,
    PRDrawText = drawtext,
    PRStreaming = streaming,
    PREditorCamera = editorCamera,
}, {
    __index = _ENV,
})) or {}

fivem.net = net
fivem.vehicleCache = vehicleCache
fivem.blips = blips
fivem.streaming = streaming
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
fivem.devlaser = devlaser
fivem.devLaser = devlaser
fivem.devtools = devtools
fivem.devTools = devtools
fivem.developerTools = devtools
fivem.vehicleProperties = vehicleProperties
fivem.tuning = tuning
fivem.getVehicleProperties = vehicleProperties.get
fivem.setVehicleProperties = vehicleProperties.set

fivem.vehicle = {
    cache = vehicleCache,
    net = net,
    getProperties = vehicleProperties.get,
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
    devlaser = devlaser,
    devLaser = devlaser,
    devtools = devtools,
    devTools = devtools,
    drawtext = drawtext,
    drawText = drawtext,
}

return fivem
