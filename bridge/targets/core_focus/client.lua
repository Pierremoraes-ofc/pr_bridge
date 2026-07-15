local target = {}
if ActiveBridges["target"] ~= "core_focus" then return end
local focus = exports.core_focus
local zones = {}

local function options(input)
    local output = {}
    for index, source in ipairs(input or {}) do
        local option = {}
        for key, value in pairs(source) do option[key] = value end
        option.num = option.num or index
        option.job = option.job or option.groups
        if option.serverEvent then option.type, option.event = "server", option.serverEvent elseif option.event then option.type = "client" end
        if option.onSelect and not option.action then
            option.action = function(entity) return option.onSelect({ entity = type(entity) == "table" and entity.entity or entity }) end
        end
        output[index] = option
    end
    return output
end
local function distance(list) local value=1.5; for _, option in ipairs(list or {}) do value=math.max(value, tonumber(option.distance) or 0) end; return value end
local function payload(list) local fixed=options(list); return { options=fixed, distance=distance(fixed) } end
function target.GetResourceName() return "core_focus" end
function target.disableTargeting() return false end
function target.addGlobalObject(list) return focus:AddGlobalObject(payload(list)) end
function target.removeGlobalObject(names) return focus:RemoveGlobalObject(names) end
function target.addGlobalPed(list) return focus:AddGlobalPed(payload(list)) end
function target.removeGlobalPed(names) return focus:RemoveGlobalPed(names) end
function target.addGlobalPlayer(list) return focus:AddGlobalPlayer(payload(list)) end
function target.removeGlobalPlayer(names) return focus:RemoveGlobalPlayer(names) end
function target.addGlobalVehicle(list) return focus:AddGlobalVehicle(payload(list)) end
function target.removeGlobalVehicle(names) return focus:RemoveGlobalVehicle(names) end
function target.addModel(models,list) return focus:AddTargetModel(models,payload(list)) end
function target.removeModel(models,names) return focus:RemoveTargetModel(models,names) end
function target.addLocalEntity(entities,list) return focus:AddTargetEntity(entities,payload(list)) end
function target.removeLocalEntity(entities,names) return focus:RemoveTargetEntity(entities,names) end
function target.addEntity(netIds,list)
    if type(netIds)=="number" then netIds={netIds} end; local entities={}
    for _,netId in ipairs(netIds or {}) do if NetworkDoesEntityExistWithNetworkId(netId) then entities[#entities+1]=NetworkGetEntityFromNetworkId(netId) end end
    return target.addLocalEntity(entities,list)
end
function target.removeEntity(netIds,names)
    if type(netIds)=="number" then netIds={netIds} end; local entities={}
    for _,netId in ipairs(netIds or {}) do if NetworkDoesEntityExistWithNetworkId(netId) then entities[#entities+1]=NetworkGetEntityFromNetworkId(netId) end end
    return target.removeLocalEntity(entities,names)
end
function target.addSphereZone(parameters)
    local name=parameters.name or ("pr_sphere_%s"):format(#zones+1); local fixed=options(parameters.options)
    focus:AddCircleZone(name,parameters.coords,parameters.radius,{name=name,debugPoly=parameters.debug==true},{options=fixed,distance=distance(fixed)}); zones[#zones+1]=name; return #zones
end
function target.addBoxZone(parameters)
    local name=parameters.name or ("pr_box_%s"):format(#zones+1); local fixed=options(parameters.options); local size=parameters.size
    focus:AddBoxZone(name,parameters.coords,size.x,size.y,{name=name,heading=parameters.rotation or 0.0,debugPoly=parameters.debug==true,minZ=parameters.coords.z-size.z/2,maxZ=parameters.coords.z+size.z/2},{options=fixed,distance=distance(fixed)}); zones[#zones+1]=name; return #zones
end
function target.addPolyZone(parameters)
    local name=parameters.name or ("pr_poly_%s"):format(#zones+1); local fixed=options(parameters.options); local points={}; local minZ,maxZ
    for _,point in ipairs(parameters.points or {}) do points[#points+1]=vector2(point.x,point.y); minZ=math.min(minZ or point.z,point.z); maxZ=math.max(maxZ or point.z,point.z) end
    local half=(parameters.thickness or 4.0)/2; focus:AddPolyZone(name,points,{name=name,debugPoly=parameters.debug==true,minZ=(minZ or 0)-half,maxZ=(maxZ or 0)+half},{options=fixed,distance=distance(fixed)}); zones[#zones+1]=name; return #zones
end
function target.removeZone(id) local name=type(id)=="number" and zones[id] or id; if not name then return false end; if focus.RemoveZone then return focus:RemoveZone(name) end; return false end
return target