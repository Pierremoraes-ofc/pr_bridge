-- Public ox_target return shapes without changing the native runtime's data.
-- Calls remain local functions, never a nested exports.pr_bridge call, so
-- native ownership still resolves to the actual legacy caller.
return function(native)
    local methods = {}
    for name, fn in pairs(native) do
        if type(fn) == "function" and name:sub(1, 1) ~= "_" then methods[name] = fn end
    end
    local void = {
        "addGlobalOption", "removeGlobalOption", "addGlobalPed", "removeGlobalPed",
        "addGlobalVehicle", "removeGlobalVehicle", "addGlobalObject", "removeGlobalObject",
        "addGlobalPlayer", "removeGlobalPlayer", "addModel", "removeModel",
        "addEntity", "removeEntity", "addLocalEntity", "removeLocalEntity", "disableTargeting", "removeZone",
    }
    for _, name in ipairs(void) do
        methods[name] = function(...) native[name](...) end
    end
    local aggregate = { __global = native._collections().global, size = 1 }
    function aggregate:wipe()
        self.globalTarget, self.model, self.entity, self.localEntity = nil, nil, nil, nil
        self.size = 1
        if self.__global[1] and self.__global[1].name == "builtin:goback" then table.remove(self.__global, 1) end
    end
    function aggregate:set(entity, entityType, model)
        if not entity then return end
        self:wipe()
        local selected = native.getTargetOptions(entity, entityType, model)
        self.globalTarget, self.model, self.entity, self.localEntity = selected.global, selected.model, selected.entity, selected.localEntity
        self.size = 1
        for _, name in ipairs({ "globalTarget", "model", "entity", "localEntity" }) do
            if self[name] then self.size = self.size + 1 end
        end
    end
    methods.getTargetOptions = function(entity, entityType, model)
        if not entity then return aggregate end
        return native.getTargetOptions(entity, entityType, model)
    end
    return methods
end
