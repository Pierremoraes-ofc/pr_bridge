local factory = PRCore.load("@pr_bridge/bridge/banking/factory", _ENV)
return factory("framework", { GetPlayerAccountBalance="getPlayerMoney", AddPlayerAccountBalance="addPlayerMoney", RemovePlayerAccountBalance="removePlayerMoney", GetJobAccountBalance="getJobAccountBalance", AddJobAccountBalance="addJobAccountBalance", RemoveJobAccountBalance="removeJobAccountBalance" })
