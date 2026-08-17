local native = exports.pr_bridge
local interact = {}

function interact.AddInteraction(data) return native:AddInteraction(data) end
function interact.AddLocalEntityInteraction(data) return native:AddLocalEntityInteraction(data) end
function interact.AddEntityInteraction(data) return native:AddEntityInteraction(data) end
function interact.AddEntityBoneInteraction(data) return native:AddEntityBoneInteraction(data) end
function interact.AddModelInteraction(data) return native:AddModelInteraction(data) end
function interact.AddGlobalVehicleInteraction(data) return native:AddGlobalVehicleInteraction(data) end
function interact.AddGlobalPlayerInteraction(data) return native:AddGlobalPlayerInteraction(data) end
interact.addGlobalPlayerInteraction = interact.AddGlobalPlayerInteraction
function interact.RemoveInteraction(id) return native:RemoveInteraction(id) end
function interact.RemoveInteractionByEntity(entity) return native:RemoveInteractionByEntity(entity) end
function interact.RemoveInteractionOption(id, name) return native:RemoveInteractionOption(id, name) end
function interact.UpdateInteraction(id, options) return native:UpdateInteraction(id, options) end
function interact.RemoveLocalEntityInteraction(entity, id) return native:RemoveLocalEntityInteraction(entity, id) end
function interact.RemoveEntityInteraction(netId, id) return native:RemoveEntityInteraction(netId, id) end
function interact.RemoveModelInteraction(models, id) return native:RemoveModelInteraction(models, id) end
function interact.RemoveGlobalVehicleInteraction(id) return native:RemoveGlobalVehicleInteraction(id) end
function interact.RemoveGlobalPlayerInteraction(id) return native:RemoveGlobalPlayerInteraction(id) end
function interact.Disable(state) return native:Disable(state) end

interact.addInteraction = interact.AddInteraction
interact.addLocalEntityInteraction = interact.AddLocalEntityInteraction
interact.addEntityInteraction = interact.AddEntityInteraction
interact.addEntityBoneInteraction = interact.AddEntityBoneInteraction
interact.addModelInteraction = interact.AddModelInteraction
interact.addGlobalVehicleInteraction = interact.AddGlobalVehicleInteraction
interact.removeInteraction = interact.RemoveInteraction
interact.removeInteractionByEntity = interact.RemoveInteractionByEntity
interact.removeInteractionOption = interact.RemoveInteractionOption
interact.updateInteraction = interact.UpdateInteraction
interact.disable = interact.Disable

return interact
