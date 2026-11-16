-- Native118 API contract; checked against real backend/catalog.
return function(side,contracts)
 assert(side=='client'or side=='server')
 return{framework=side=='server'and{'AddMoney','AddPlayerToGang','AddPlayerToJob','AddStatus','CreateUseableItem','GetMoney','GetOfflinePlayer','GetPlayer','GetPlayerByCitizenId','GetStatus','HasPermission','RemoveMoney','RemovePlayerFromGang','RemovePlayerFromJob','SetJob','SetJobDuty','SetPlayerPrimaryGang','SetPlayerPrimaryJob','SetStatus'}or{},
 core=side=='server'and{'GetVehiclesByHash','GetJobs','GetGangs','EnablePersistence','DisablePersistence'}or{'GetVehiclesByHash','GetJobs','GetGangs'},
 inventory=side=='server'and{'GetPlayer','GetPlayersData','CanUseItem','GetGroups','IsGradeBoss'}or{},
 native=contracts.qb==true and{'GetCoreObject'}or{}}
end

