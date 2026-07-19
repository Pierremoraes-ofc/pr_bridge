local Renderer = {}
local resourceName = GetCurrentResourceName()

function Renderer.setFocus(keepInput)
    TriggerEvent("pr_bridge:ui:claim", resourceName)
    TriggerEvent("pr_bridge:ui:setFocus", keepInput == true)
end

function Renderer.clearFocus()
    TriggerEvent("pr_bridge:ui:clearFocus")
end

function Renderer.resetFocus()
    TriggerEvent("pr_bridge:ui:resetFocus")
end

function Renderer.send(action, data)
    TriggerEvent("pr_bridge:ui:claim", resourceName)
    TriggerEvent("pr_bridge:ui:send", action, data)
end

function Renderer.claim()
    TriggerEvent("pr_bridge:ui:claim", resourceName)
end

return Renderer
