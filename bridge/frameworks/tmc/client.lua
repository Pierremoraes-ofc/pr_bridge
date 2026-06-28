local framework = {}
if ActiveBridges["frameworks"] ~= "tmc" then return end
local TMC=exports.core:getCoreObject()
function framework.GetResourceName() return "core" end
function framework.GetPlayer() return TMC.Functions.GetPlayerData() end
function framework.IsPlayerLoaded() return TMC.Functions.IsPlayerLoaded() end
function framework.GetMoney(account) local data=framework.GetPlayer(); account=account=="money" and "cash" or account; return data and data.money and data.money[account] or 0 end
function framework.GetJobInfo() local data=framework.GetPlayer(); local job=data and (data.job or data.jobs and data.jobs[1]); if not job then return nil end; return {name=job.name,label=job.label,grade=job.grade and (job.grade.level or job.grade) or 0,gradeLabel=job.grade and job.grade.name} end
function framework.getPlayerMetadata(key) local data=framework.GetPlayer(); return data and data.metadata and data.metadata[key] end
return framework