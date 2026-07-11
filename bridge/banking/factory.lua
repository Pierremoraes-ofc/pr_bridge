return function(resourceName, methods)
    local banking = {}
    local api = resourceName == "framework" and nil or exports[resourceName]
    local function call(method, ...)
        if resourceName == "framework" then
            local fn = Bridge.framework and Bridge.framework[method]
            return type(fn) == "function" and fn(...) or nil
        end
        local exportName = methods[method]
        if not exportName then return nil end
        local args = table.pack(...)
        local ok, result = pcall(function() return api[exportName](api, table.unpack(args, 1, args.n)) end)
        if ok then return result end
        if Debug then Debug("WARNING", ("[banking:%s] %s failed: %s"):format(resourceName, exportName, tostring(result))) end
    end
    function banking.GetResourceName() return resourceName end
    function banking.GetPlayerAccountBalance(player, accountType)
        if resourceName == "framework" then return tonumber(call("GetPlayerAccountBalance", player, accountType or "bank")) or 0 end
        return tonumber(call("GetPlayerAccountBalance", player)) or 0
    end
    function banking.AddPlayerAccountBalance(player, accountType, amount, reason)
        if type(accountType) == "number" then reason, amount, accountType = amount, accountType, "bank" end
        if resourceName == "framework" then return call("AddPlayerAccountBalance", player, accountType or "bank", amount, reason or "pr_bridge") ~= false end
        return call("AddPlayerAccountBalance", player, amount, reason or "pr_bridge") ~= false
    end
    function banking.RemovePlayerAccountBalance(player, accountType, amount, reason)
        if type(accountType) == "number" then reason, amount, accountType = amount, accountType, "bank" end
        if resourceName == "framework" then return call("RemovePlayerAccountBalance", player, accountType or "bank", amount, reason or "pr_bridge") ~= false end
        return call("RemovePlayerAccountBalance", player, amount, reason or "pr_bridge") ~= false
    end
    function banking.GetJobAccountBalance(account) return tonumber(call("GetJobAccountBalance", account)) or 0 end
    function banking.AddJobAccountBalance(account, amount, reason) return call("AddJobAccountBalance", account, amount, reason or "pr_bridge") ~= false end
    function banking.RemoveJobAccountBalance(account, amount, reason) return call("RemoveJobAccountBalance", account, amount, reason or "pr_bridge") ~= false end
    banking.GetAccountBalance=banking.GetPlayerAccountBalance
    banking.AddAccountBalance=banking.AddPlayerAccountBalance
    banking.RemoveAccountBalance=banking.RemovePlayerAccountBalance
    return banking
end