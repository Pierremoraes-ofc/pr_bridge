local factory = PRCore.load("@pr_bridge/bridge/banking/factory", _ENV)
return factory("fd_banking", { GetPlayerAccountBalance="GetAccount", AddPlayerAccountBalance="AddMoney", RemovePlayerAccountBalance="RemoveMoney", GetJobAccountBalance="GetAccount", AddJobAccountBalance="AddMoney", RemoveJobAccountBalance="RemoveMoney" })
