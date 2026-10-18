local S=PRCore.load('@pr_bridge/bridge/runtime/compat_services',_ENV)
local H={services=S}
function H.copy(value)
    if type(value)~='table' or S.callable(value) then return value end
    local out={};for k,v in pairs(value) do out[k]=H.copy(v) end;return out
end
-- Common job contract: name/label/type and an ESX-shaped list of grades.
-- Native QB grades/payment/boss flags are preserved, not overwritten.
function H.qbJob(input,existing)
    assert(type(input)=='table' and type(input.name)=='string' and input.name:match('^[%w_%-]+$'),'Invalid job name')
    assert(type(input.label)=='string' and input.label~='' and type(input.grades)=='table','Invalid job definition')
    local job=H.copy(existing or {label=input.label,type=input.type or 'civ',defaultDuty=true,offDutyPay=false,grades={}})
    job.grades=job.grades or {};local added=false
    for _,grade in pairs(input.grades) do
        assert(type(grade)=='table' and type(grade.grade)=='number' and grade.grade>=0 and grade.grade%1==0,'Invalid job grade')
        assert(type(grade.name)=='string' and type(grade.salary or 0)=='number' and (grade.salary or 0)>=0,'Invalid grade data')
        local key=tostring(grade.grade)
        if job.grades[key]==nil and job.grades[grade.grade]==nil then
            job.grades[key]={name=grade.label or grade.name,payment=grade.salary or 0,isboss=grade.isboss==true};added=true
        end
    end
    return job,added
end
-- ESX setName changes the display name, not firstname/lastname identity.
function H.displayName(F)
    return function(source,name)
        assert(type(name)=='string' and #name>0 and #name<=128,'Invalid display name')
        local player=assert(F.GetPlayer(source),'Invalid player')
        assert(player.Functions and S.callable(player.Functions.SetPlayerData),'Player data setter unavailable')
        assert(S.callable(player.Functions.SetMetaData),'Persistent display-name metadata setter unavailable')
        player.Functions.SetMetaData('prCompatDisplayName',name)
        player.Functions.SetPlayerData('name',name)
        return true
    end
end
function H.metadataValue(F,key)
    return function(source)
        local player=assert(F.GetPlayer(source),'Invalid player')
        local data=player.PlayerData or player
        local value=(data.metadata or {})[key]
        assert(value~=nil,'No authoritative '..key..' metadata; configure a service adapter')
        return value
    end
end
return H
