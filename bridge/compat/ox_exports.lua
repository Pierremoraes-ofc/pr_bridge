-- FiveM discovers exports through these events. Returning the function itself
-- (not an exports.pr_bridge proxy) preserves GetInvokingResource and ownership.
return function(alias, methods, originalRunning)
    for name, method in pairs(methods) do
        if type(method) == "function" and name:sub(1, 1) ~= "_" then
            AddEventHandler(("__cfx_export_%s_%s"):format(alias, name), function(setCallback)
                if not originalRunning(alias) then setCallback(method) end
            end)
        end
    end
end
