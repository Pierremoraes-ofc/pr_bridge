local factory = PRCore.load("@pr_bridge/bridge/banking/factory", _ENV)
return factory("Renewed-Banking", {
    GetPlayerAccountBalance = "getAccountMoney",
    AddPlayerAccountBalance = "addAccountMoney",
    RemovePlayerAccountBalance = "removeAccountMoney",
    GetJobAccountBalance = "getAccountMoney",
    AddJobAccountBalance = "addAccountMoney",
    RemoveJobAccountBalance = "removeAccountMoney",
})
