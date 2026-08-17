local target = {}

if ActiveBridges["target"] ~= "native" then return target end

function target.GetResourceName()
    return "pr_bridge"
end

return target
