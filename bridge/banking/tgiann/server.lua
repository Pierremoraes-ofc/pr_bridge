local factory = PRCore.load("@pr_bridge/bridge/banking/factory", _ENV)
return factory("tgiann-bank", { GetPlayerAccountBalance="GetAccountBalance", AddPlayerAccountBalance="AddMoney", RemovePlayerAccountBalance="RemoveMoney", GetJobAccountBalance="GetJobAccountBalance", AddJobAccountBalance="AddJobMoney", RemoveJobAccountBalance="RemoveJobMoney" })
