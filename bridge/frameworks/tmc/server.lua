local framework = {}
if ActiveBridges["frameworks"] ~= "tmc" then return end
local TMC = exports.core:getCoreObject()
function framework.GetResourceName() return "core" end
function framework.GetPlayer(source) return TMC.Functions.GetPlayer(tonumber(source)) end
framework.getPlayerFromId=framework.GetPlayer
function framework.GetPlayerData(source) local player=framework.GetPlayer(source); return player and player.PlayerData or nil end
function framework.GetIdentifier(source) local player=framework.GetPlayer(source); return player and player.PlayerData and player.PlayerData.citizenid end
function framework.getPlayerName(source) local player=framework.GetPlayer(source); local info=player and player.PlayerData and player.PlayerData.charinfo or {}; return ((info.firstname or "").." "..(info.lastname or "")):match("^%s*(.-)%s*$") end
function framework.GetCoords(source,withHeading) local ped=GetPlayerPed(source); local coords=GetEntityCoords(ped); return withHeading and vector4(coords.x,coords.y,coords.z,GetEntityHeading(ped)) or coords end
function framework.getPlayerDOB(source) local player=framework.GetPlayer(source); return player and player.PlayerData.charinfo.birthdate end
function framework.getPlayerSex(source) local player=framework.GetPlayer(source); return player and player.PlayerData.charinfo.gender end
function framework.getPlayerJob(source,dataType) local player=framework.GetPlayer(source); local job=player and (player.PlayerData.job or player.PlayerData.jobs and player.PlayerData.jobs[1]); if not job then return nil end; local values={name=job.name,label=job.label,grade=job.grade and (job.grade.level or job.grade) or 0,gradeLabel=job.grade and job.grade.name}; return dataType and values[dataType] or values end
function framework.GetPlayerJob(source) return framework.getPlayerJob(source) end
function framework.SetPlayerJob(source,jobName,grade) local player=framework.GetPlayer(source); if not player or not player.Functions or not player.Functions.SetJob then return false,"invalid_player" end; local ok,success,result=pcall(function() return player.Functions.SetJob(jobName,tonumber(grade) or 0) end); if not ok then return false,success end; return success~=false,result end
function framework.SetPlayerDuty(source,onDuty) local player=framework.GetPlayer(source); if not player or not player.Functions or not player.Functions.SetJobDuty then return false,"invalid_player" end; local ok,result=pcall(function() return player.Functions.SetJobDuty(onDuty==true) end); if not ok then return false,result end; return result~=false,result end
function framework.PlayerHasJob(source,jobName,grade) local job=framework.GetPlayerJob(source); if not job or tostring(job.name or ""):lower()~=tostring(jobName or ""):lower() then return false end; if grade==nil then return true end; return (tonumber(job.grade) or 0)>=(tonumber(grade) or 0) end
function framework.getPlayerMoney(source,account) local player=framework.GetPlayer(source); account=account=="money" and "cash" or account; return player and player.PlayerData.money and player.PlayerData.money[account] or 0 end
function framework.addPlayerMoney(source,account,amount,reason) local player=framework.GetPlayer(source); return player and player.Functions.AddMoney(account=="money" and "cash" or account,amount,reason or "pr_bridge") or false end
function framework.removePlayerMoney(source,account,amount,reason) local player=framework.GetPlayer(source); return player and player.Functions.RemoveMoney(account=="money" and "cash" or account,amount,reason or "pr_bridge") or false end
function framework.setPlayerMetadata(source,key,value) local player=framework.GetPlayer(source); if not player then return false end; if player.Functions.SetMetaData then return player.Functions.SetMetaData(key,value) end; if player.Functions.SetMeta then return player.Functions.SetMeta(key,value) end; return false end
function framework.getPlayerMetadata(source,key) local player=framework.GetPlayer(source); return player and player.PlayerData.metadata and player.PlayerData.metadata[key] end
function framework.getPlayerGroup() return "user" end
function framework.RegisterUsableItem() return false end
return framework
