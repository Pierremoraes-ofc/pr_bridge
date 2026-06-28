return function(framework, context, inventory, banking, notify, textui, activeFramework)
    if type(framework) ~= "table" then return framework end

    local frameworkResources = { qb="qb-core", qbx="qbx_core", esx="es_extended", ox="ox_core", nd="ND_Core", tmc="core", default="standalone" }
    if not framework.GetResourceName then function framework.GetResourceName() return frameworkResources[activeFramework] or activeFramework end end

    local function alias(canonical, ...)
        if type(framework[canonical]) == "function" then return end
        for index = 1, select("#", ...) do
            local name = select(index, ...)
            if type(framework[name]) == "function" then framework[canonical] = framework[name]; return end
        end
    end

    alias("GetPlayer", "getPlayerFromId", "GetPlayerFromId", "GetPlayerData")
    alias("getPlayerFromId", "GetPlayer", "GetPlayerFromId")
    alias("GetPlayerFromId", "GetPlayer", "getPlayerFromId")
    alias("GetIdentifier", "GetPlayerIdentifier")
    alias("GetPlayerIdentifier", "GetIdentifier")
    alias("GetPlayerName", "getPlayerName")
    alias("getPlayerName", "GetPlayerName")
    alias("GetPlayerDob", "getPlayerDOB")
    alias("getPlayerDOB", "GetPlayerDob")
    alias("GetPlayerGender", "getPlayerSex")
    alias("getPlayerSex", "GetPlayerGender")
    alias("GetPlayerGroup", "getPlayerGroup")
    alias("getPlayerGroup", "GetPlayerGroup")
    alias("GetPlayerMetadata", "getPlayerMetadata")
    alias("getPlayerMetadata", "GetPlayerMetadata")
    alias("SetPlayerMetadata", "setPlayerMetadata")
    alias("setPlayerMetadata", "SetPlayerMetadata")
    alias("GetPlayerAccountBalance", "getPlayerMoney", "GetAccountBalance")
    alias("AddPlayerAccountBalance", "addPlayerMoney", "AddAccountBalance")
    alias("RemovePlayerAccountBalance", "removePlayerMoney", "RemoveAccountBalance")
    alias("GetAccountBalance", "GetPlayerAccountBalance")
    alias("AddAccountBalance", "AddPlayerAccountBalance")
    alias("RemoveAccountBalance", "RemovePlayerAccountBalance")
    alias("GetItemLabel", "GetItemlabel")
    alias("GetItemlabel", "GetItemLabel")

    if context == "server" then
        framework.GetPlayerData = framework.GetPlayerData or framework.GetPlayer
        if not framework.GetFrameworkJobs then
            function framework.GetFrameworkJobs()
                if activeFramework == "qb" then local core=exports["qb-core"]:GetCoreObject(); return core.Shared and core.Shared.Jobs or {} end
                if activeFramework == "qbx" then local ok,jobs=pcall(function() return exports.qbx_core:GetJobs() end); return ok and jobs or {} end
                if activeFramework == "esx" then local core=exports.es_extended:getSharedObject(); return core.GetJobs and core.GetJobs() or core.Jobs or {} end
                return {}
            end
        end
        if not framework.GetPlayerFromIdentifier then
            function framework.GetPlayerFromIdentifier(identifier)
                for _, source in ipairs(GetPlayers()) do
                    source = tonumber(source)
                    if framework.GetPlayerIdentifier and framework.GetPlayerIdentifier(source) == identifier then return framework.GetPlayer(source) end
                end
            end
        end

        local legacyGetJob = framework.getPlayerJob
        if not framework.GetPlayerJob and legacyGetJob then
            function framework.GetPlayerJob(source)
                local direct = legacyGetJob(source)
                if type(direct) == "table" then return direct end
                return {
                    name = legacyGetJob(source, "name"),
                    label = legacyGetJob(source, "label"),
                    grade = legacyGetJob(source, "grade") or 0,
                    gradeLabel = legacyGetJob(source, "gradeLabel"),
                }
            end
        end
        framework.getPlayerJob = framework.getPlayerJob or framework.GetPlayerJob

        if not framework.SetPlayerJob then
            function framework.SetPlayerJob(source, jobName, grade)
                local player = framework.GetPlayer and framework.GetPlayer(source)
                if not player then return false end
                if player.Functions and player.Functions.SetJob then return player.Functions.SetJob(jobName, grade or 0) ~= false end
                if player.setJob then player.setJob(jobName, grade or 0); return true end
                if player.setGroup then player.setGroup(jobName, grade or 0); return true end
                return false
            end
        end

        if not framework.PlayerHasJob then
            function framework.PlayerHasJob(source, jobName, grade)
                local job = framework.GetPlayerJob and framework.GetPlayerJob(source)
                return type(job) == "table" and job.name == jobName and (grade == nil or tonumber(job.grade or 0) >= tonumber(grade))
            end
        end

        if not framework.GetAllPlayers then function framework.GetAllPlayers() local result={}; for _,source in ipairs(GetPlayers()) do result[#result+1]=tonumber(source) end; return result end end
        if not framework.GetJobCount then function framework.GetJobCount(jobName) local count=0; for _,source in ipairs(framework.GetAllPlayers()) do local job=framework.GetPlayerJob and framework.GetPlayerJob(source); if type(job)=="table" and job.name==jobName and job.onduty~=false then count=count+1 end end; return count end end

        if inventory then
            framework.AddItem=framework.AddItem or inventory.AddItem
            framework.RemoveItem=framework.RemoveItem or inventory.RemoveItem
            framework.CanCarryItem=framework.CanCarryItem or inventory.CanCarryItem
            framework.GetItemCount=framework.GetItemCount or inventory.GetItemCount
            framework.HasItem=framework.HasItem or inventory.HasItem
            framework.GetItemData=framework.GetItemData or inventory.GetItem
            framework.GetItemByName=framework.GetItemByName or inventory.GetItem
            framework.GetItemBySlot=framework.GetItemBySlot or inventory.GetItemBySlot
            framework.GetPlayerInventory=framework.GetPlayerInventory or inventory.GetInventoryItems or inventory.GetInventory
            framework.ClearPlayerInventory=framework.ClearPlayerInventory or inventory.ClearInventory
            framework.SetMetadata=framework.SetMetadata or inventory.SetMetadata
            framework.GetItemLabel=framework.GetItemLabel or inventory.GetItemLabel
            framework.GetItemlabel=framework.GetItemlabel or framework.GetItemLabel
            framework.Items=framework.Items or inventory.Items
            framework.RegisterUsableItem=framework.RegisterUsableItem or inventory.RegisterUsableItem
        end

        local bankResource = banking and banking.GetResourceName and banking.GetResourceName()
        if banking and bankResource ~= "framework" then
            framework.GetJobAccountBalance=framework.GetJobAccountBalance or banking.GetJobAccountBalance
            framework.AddJobAccountBalance=framework.AddJobAccountBalance or banking.AddJobAccountBalance
            framework.RemoveJobAccountBalance=framework.RemoveJobAccountBalance or banking.RemoveJobAccountBalance
        end
    else
        alias("GetPlayerData", "GetPlayer")
        local function playerData() return framework.GetPlayerData and framework.GetPlayerData() or framework.GetPlayer and framework.GetPlayer() or {} end
        if not framework.GetPlayerIdentifier then function framework.GetPlayerIdentifier() local data=playerData(); return data.citizenid or data.identifier or data.charId end end
        if not framework.GetPlayerName then function framework.GetPlayerName() local data=playerData(); local info=data.charinfo or data.character or {}; local first=info.firstname or info.firstName or data.firstName or ""; local last=info.lastname or info.lastName or data.lastName or ""; return {fullName=(first.." "..last):match("^%s*(.-)%s*$"),firstName=first,lastName=last} end end
        if not framework.GetPlayerGender then function framework.GetPlayerGender() local data=playerData(); local info=data.charinfo or data.character or {}; local value=info.gender or info.sex or data.gender or data.sex; if value==0 or value=="m" or value=="M" or value=="male" then return "male" end; if value~=nil then return "female" end end end
        if not framework.GetPlayerDob then function framework.GetPlayerDob() local data=playerData(); local info=data.charinfo or data.character or {}; return info.birthdate or info.dateofbirth or data.dateofbirth or "" end end
        if not framework.IsPlayerLoaded then function framework.IsPlayerLoaded() return next(playerData()) ~= nil end end
        if not framework.IsPlayerDead then function framework.IsPlayerDead() local data=playerData(); return IsEntityDead(PlayerPedId()) or data.dead==true or data.metadata and (data.metadata.isdead==true or data.metadata.dead==true) end end
        if not framework.GetPlayerJob then function framework.GetPlayerJob() local data=playerData(); local job=data.job or data.jobs and data.jobs[1] or {}; return {name=job.name or "",label=job.label or "",grade=type(job.grade)=="table" and (job.grade.level or 0) or job.grade or 0,gradeLabel=type(job.grade)=="table" and job.grade.name or job.grade_label,onduty=job.onduty} end end
        framework.getPlayerJob=framework.getPlayerJob or function(dataType) local job=framework.GetPlayerJob(); return dataType and job[dataType] or job end
        if not framework.PlayerHasJob then function framework.PlayerHasJob(jobName,grade) local job=framework.GetPlayerJob(); return job.name==jobName and (grade==nil or tonumber(job.grade or 0)>=tonumber(grade)) end end
        if not framework.GetPlayerGroup then function framework.GetPlayerGroup() return playerData().group or "user" end end
        if not framework.GetClosestPlayer then function framework.GetClosestPlayer() local closest,distance=-1,-1; local coords=GetEntityCoords(PlayerPedId()); for _,player in ipairs(GetActivePlayers()) do if player~=PlayerId() then local current=#(GetEntityCoords(GetPlayerPed(player))-coords); if distance<0 or current<distance then closest,distance=player,current end end end; return closest,distance end end
        if not framework.GetClosestVehicle then function framework.GetClosestVehicle() local coords=GetEntityCoords(PlayerPedId()); local vehicle=GetClosestVehicle(coords.x,coords.y,coords.z,100.0,0,71); return vehicle, vehicle~=0 and #(GetEntityCoords(vehicle)-coords) or -1 end end
        if not framework.Notify then function framework.Notify(message,kind,duration) return notify and notify.Notify and notify.Notify({description=message,type=kind,duration=duration}) end end
        if not framework.ShowTextUI then function framework.ShowTextUI(text) return textui and textui.Show and textui.Show(text) end end
        if not framework.HideTextUI then function framework.HideTextUI() return textui and textui.Hide and textui.Hide() end end
        if not framework.GetAccountBalance then function framework.GetAccountBalance(account) if framework.GetMoney then return framework.GetMoney(account) end; local data=playerData(); account=account=="money" and "cash" or account; return data.money and data.money[account] or 0 end end
        local inventoryResource = inventory and inventory.GetResourceName and inventory.GetResourceName()
        if inventory and inventoryResource ~= "framework" then framework.GetItemCount=framework.GetItemCount or inventory.GetItemCount; framework.HasItem=framework.HasItem or inventory.HasItem; framework.GetPlayerInventory=framework.GetPlayerInventory or inventory.GetPlayerItems or inventory.GetPlayerInventory end
    end
    return framework
end