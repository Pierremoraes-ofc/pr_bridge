local factory = PRCore.load("@pr_bridge/bridge/banking/factory", _ENV)
return factory("qb-banking", { GetPlayerAccountBalance="GetAccountBalance", AddPlayerAccountBalance="AddMoney", RemovePlayerAccountBalance="RemoveMoney", GetJobAccountBalance="GetAccountBalance", AddJobAccountBalance="AddMoney", RemoveJobAccountBalance="RemoveMoney" })
