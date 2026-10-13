local api, created = {}, {}
local function streaming() return Bridge.fivem.streaming end
function api.clear(serverId)
    local props=created[serverId]; created[serverId]=nil
    for _,object in ipairs(props or {}) do streaming().deleteEntity(object) end
end
function api.render(bagName, _, value)
    local player=GetPlayerFromStateBagName(bagName)
    if not player or player<0 then return end
    local serverId,ped=GetPlayerServerId(player),GetPlayerPed(player)
    api.clear(serverId)
    if type(value)~='table' or ped==0 then return end
    local props=value.model and {value} or value
    local objects={}; created[serverId]=objects
    for _,prop in ipairs(props) do
        local loaded,model=streaming().requestModel(prop.model,10000)
        if loaded and not IsModelAPed(model) and not IsModelAVehicle(model) then
            local min,max=GetModelDimensions(model); local size=max-min
            if math.max(size.x,size.y,size.z)<=2.5 and created[serverId]==objects then
                local object=streaming().createObject(model,GetEntityCoords(ped),{networked=false})
                if object and object~=0 then
                    local pos,rot=prop.pos,prop.rot
                    AttachEntityToEntity(object,ped,GetPedBoneIndex(ped,prop.bone or 60309),pos.x,pos.y,pos.z,rot.x,rot.y,rot.z,true,true,false,true,prop.rotOrder or 0,true)
                    objects[#objects+1]=object
                end
            end
            streaming().releaseModel(model)
        end
    end
end
AddStateBagChangeHandler('pr_bridge:progressProps',nil,api.render)
RegisterNetEvent('onPlayerDropped',api.clear)
AddEventHandler('onClientResourceStop',function(resource)
    if resource==GetCurrentResourceName() then for serverId in pairs(created) do api.clear(serverId) end end
end)
return api
