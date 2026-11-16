return {
    server={'CreateJob','RefreshJob','RefreshJobs','AddItems','RefreshItems','CreatePickup',
        'CreateExtendedVehicle','GetExtendedVehicleFromPlate','DiscordLog','DiscordLogFields',
        'RegisterPlayerFunctionOverrides','SetPlayerFunctionOverride','BeginAccountOperation',
        'BeginAccountShutdown','EndAccountOperation','GetPendingAccountOperations','GetPlayTime',
        'GetSSN','IsPaycheckEnabled','SetPlayerGroup','SetPlayerName','TogglePaycheck'},
    client={'PreviewContext','SpawnPlayer'},
    player={beginAccountOperation='BeginAccountOperation',beginAccountShutdown='BeginAccountShutdown',
        endAccountOperation='EndAccountOperation',getPendingAccountOperations='GetPendingAccountOperations',
        getPlayTime='GetPlayTime',getSSN='GetSSN',isPaycheckEnabled='IsPaycheckEnabled',
        setGroup='SetPlayerGroup',setName='SetPlayerName',togglePaycheck='TogglePaycheck'},
}
