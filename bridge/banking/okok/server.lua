local factory = PRCore.load("@pr_bridge/bridge/banking/factory", _ENV)
return factory("okokBanking", { GetPlayerAccountBalance="GetAccount", AddPlayerAccountBalance="AddMoney", RemovePlayerAccountBalance="RemoveMoney", GetJobAccountBalance="GetAccount", AddJobAccountBalance="AddMoney", RemoveJobAccountBalance="RemoveMoney" })
