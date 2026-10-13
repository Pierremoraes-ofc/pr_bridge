-- Signature adapters only. Implementations belong to the native PR APIs.
return function(native, context, contractVersion, originalRunning)
    local api = {}
    local properties = assert(native.fivem.vehicleProperties, 'Native vehicle properties unavailable')
    if context == 'client' then
        api.getVehicleProperties = properties.get
        api.setVehicleProperties = function(vehicle, props, fixVehicle)
            assert(DoesEntityExist(vehicle), ("Unable to set vehicle properties for '%s' (entity does not exist)"):format(vehicle))
            -- ox applies door locks only when this convar is enabled. Do not
            -- change the native API's default behavior to impose that policy.
            if props.lockState ~= nil and not GetConvarBool('ox:setLockState', false) then
                local copy = {}; for key, value in pairs(props) do copy[key] = value end
                copy.lockState = nil; props = copy
            end
            return properties.set(vehicle, props, fixVehicle)
        end
    else
        api.setVehicleProperties = function(vehicle, props)
            -- Preserve deferred application without a second property engine.
            properties.queue(vehicle, props, 'ox_lib:setVehicleProperties')
        end
        local ace = assert(native.fivem.ace, 'Native ACE unavailable')
        for _, name in ipairs({ 'addAce', 'removeAce', 'addPrincipal', 'removePrincipal' }) do api[name] = ace[name] end
        api.versionCheck = native.github.versionCheck
    end
    api.checkDependency = function(resource, minimum, printMessage)
        local version = resource == 'ox_lib' and not originalRunning('ox_lib') and contractVersion or nil
        return native.github.checkDependency(resource, minimum, printMessage, version)
    end
    return api
end
