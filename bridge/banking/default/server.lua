local factory = PRCore.load("@pr_bridge/bridge/banking/factory", _ENV)
local frameworkBanking = factory("framework", {
    GetPlayerAccountBalance = "getPlayerMoney",
    AddPlayerAccountBalance = "addPlayerMoney",
    RemovePlayerAccountBalance = "removePlayerMoney",
    GetJobAccountBalance = "getJobAccountBalance",
    AddJobAccountBalance = "addJobAccountBalance",
    RemoveJobAccountBalance = "removeJobAccountBalance",
})

local banking = {}

local function renewedStarted()
    return GetResourceState("Renewed-Banking"):find("start") ~= nil
end

local function callRenewed(exportName, ...)
    if not renewedStarted() then return nil end

    local args = table.pack(...)
    local ok, result = pcall(function()
        return exports["Renewed-Banking"][exportName](exports["Renewed-Banking"], table.unpack(args, 1, args.n))
    end)

    if ok then return result end
    if Debug then Debug("WARNING", ("[banking:Renewed-Banking] %s failed: %s"):format(exportName, tostring(result))) end
end

function banking.GetResourceName()
    return renewedStarted() and "Renewed-Banking" or frameworkBanking.GetResourceName()
end

function banking.GetPlayerAccountBalance(player, accountType)
    return frameworkBanking.GetPlayerAccountBalance(player, accountType)
end

function banking.AddPlayerAccountBalance(player, accountType, amount, reason)
    return frameworkBanking.AddPlayerAccountBalance(player, accountType, amount, reason)
end

function banking.RemovePlayerAccountBalance(player, accountType, amount, reason)
    return frameworkBanking.RemovePlayerAccountBalance(player, accountType, amount, reason)
end

function banking.GetJobAccountBalance(account)
    if renewedStarted() then return tonumber(callRenewed("getAccountMoney", account)) or 0 end
    return frameworkBanking.GetJobAccountBalance(account)
end

function banking.AddJobAccountBalance(account, amount, reason)
    if renewedStarted() then return callRenewed("addAccountMoney", account, amount, reason or "pr_bridge") == true end
    return frameworkBanking.AddJobAccountBalance(account, amount, reason)
end

function banking.RemoveJobAccountBalance(account, amount, reason)
    if renewedStarted() then return callRenewed("removeAccountMoney", account, amount, reason or "pr_bridge") == true end
    return frameworkBanking.RemoveJobAccountBalance(account, amount, reason)
end

banking.GetAccountBalance = banking.GetPlayerAccountBalance
banking.AddAccountBalance = banking.AddPlayerAccountBalance
banking.RemoveAccountBalance = banking.RemovePlayerAccountBalance

return banking
