local normalizer = {}

function normalizer.target(target, activeTarget)
    if type(target) ~= "table" then return target end
    local resources={ox="ox_target",qb="qb-target",core_focus="core_focus",default="standalone"}
    target.GetResourceName=target.GetResourceName or function() return resources[activeTarget] or activeTarget end
    target.FixOptions=target.FixOptions or function(options) return options end
    local aliases={GetResourceName="getResourceName",DisableTargeting="disableTargeting",AddGlobalObject="addGlobalObject",RemoveGlobalObject="removeGlobalObject",AddGlobalPed="addGlobalPed",RemoveGlobalPed="removeGlobalPed",AddGlobalPlayer="addGlobalPlayer",RemoveGlobalPlayer="removeGlobalPlayer",AddGlobalVehicle="addGlobalVehicle",RemoveGlobalVehicle="removeGlobalVehicle",AddModel="addModel",RemoveModel="removeModel",AddEntity="addEntity",RemoveEntity="removeEntity",AddLocalEntity="addLocalEntity",RemoveLocalEntity="removeLocalEntity",RemoveZone="removeZone"}
    for upper,lower in pairs(aliases) do target[upper]=target[upper] or target[lower] end
    if not target.AddSphereZone and target.addSphereZone then function target.AddSphereZone(name,coords,radius,options,debug) return target.addSphereZone({name=name,coords=coords,radius=radius,options=options,debug=debug}) end end
    if not target.AddBoxZone and target.addBoxZone then function target.AddBoxZone(name,coords,size,rotation,options,debug) return target.addBoxZone({name=name,coords=coords,size=size,rotation=rotation,options=options,debug=debug}) end end
    if not target.AddPolyZone and target.addPolyZone then function target.AddPolyZone(name,points,thickness,options,debug) return target.addPolyZone({name=name,points=points,thickness=thickness,options=options,debug=debug}) end end
    return target
end

function normalizer.notification(notification, context, resourceName)
    if type(notification) ~= "table" then return notification end
    local original=notification.Notify
    if type(original)=="function" then
        if context=="server" then
            notification.Notify=function(source,data,kind,duration)
                if type(data)~="table" then data={description=tostring(data or ""),type=kind,duration=duration} end
                return original(source,data)
            end
        else
            notification.Notify=function(data,kind,duration)
                if type(data)~="table" then data={description=tostring(data or ""),type=kind,duration=duration} end
                return original(data)
            end
        end
    end
    notification.GetResourceName=notification.GetResourceName or function() return resourceName end
    return notification
end

function normalizer.database(database)
    if type(database)~="table" then return database end
    database.Select=database.Select or database.query
    database.Execute=database.Execute or database.execute
    database.Scalar=database.Scalar or database.scalar
    database.Insert=database.Insert or database.insert
    database.Update=database.Update or database.update or database.execute
    database.Transaction=database.Transaction or database.transaction
    return database
end

function normalizer.textui(textui)
    if type(textui)~="table" then return textui end
    textui.Show=textui.Show or textui.show; textui.Hide=textui.Hide or textui.hide; textui.show=textui.show or textui.Show; textui.hide=textui.hide or textui.Hide
    return textui
end

function normalizer.banking(banking)
    if type(banking)~="table" then return banking end
    banking.GetAccountBalance=banking.GetAccountBalance or banking.GetPlayerAccountBalance
    banking.AddAccountBalance=banking.AddAccountBalance or banking.AddPlayerAccountBalance
    banking.RemoveAccountBalance=banking.RemoveAccountBalance or banking.RemovePlayerAccountBalance
    return banking
end

return normalizer