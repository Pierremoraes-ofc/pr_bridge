local factory = PRCore.load("@pr_bridge/bridge/banking/factory", _ENV)
return factory("kartik-banking", { GetPlayerAccountBalance="GetAccountBalance", AddPlayerAccountBalance="AddAccountBalance", RemovePlayerAccountBalance="RemoveAccountBalance", GetJobAccountBalance="GetAccountBalance", AddJobAccountBalance="AddAccountBalance", RemoveJobAccountBalance="RemoveAccountBalance" })
