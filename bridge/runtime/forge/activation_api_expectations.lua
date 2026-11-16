--262: exact prepared native API118 capabilities;no dynamic self-approval from a handshake.
local groups={server={framework={"AddMoney","AddPlayerToGang","AddPlayerToJob","AddStatus","CreateUseableItem","GetMoney","GetOfflinePlayer","GetPlayer","GetPlayerByCitizenId","GetStatus","HasPermission","RemoveMoney","RemovePlayerFromGang","RemovePlayerFromJob","SetJob","SetJobDuty","SetPlayerPrimaryGang","SetPlayerPrimaryJob","SetStatus"},core={"DisablePersistence","EnablePersistence","GetGangs","GetJobs","GetVehiclesByHash"},inventory={"CanUseItem","GetGroups","GetPlayer","GetPlayersData","IsGradeBoss"}},client={framework={},core={"GetGangs","GetJobs","GetVehiclesByHash"},inventory={}}}
return function(side,qbEnabled)
 assert(type(qbEnabled)=='boolean','explicit QB capability required')
 local source=assert(groups[side],'API side required');local out={native={}}
 for group,names in pairs(source)do out[group]={};for i,name in ipairs(names)do out[group][i]=name end end
 if qbEnabled then out.native[1]='GetCoreObject'end
 return out
end
