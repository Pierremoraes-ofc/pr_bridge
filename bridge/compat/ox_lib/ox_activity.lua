-- Global legacy progress/skill state, with owner-local props and cleanup.
return function(owner, uiForOwner)
    local active = {}
    local methods = {}
    local function run(kind, name, ...)
        local resource = owner()
        if kind == "progress" then
            while active[kind] do Wait(0) end
        elseif active[kind] then return nil end
        local ui = uiForOwner(resource)
        active[kind] = { resource = resource, ui = ui }
        local result = table.pack(pcall(ui[name], ...))
        active[kind] = nil
        if not result[1] then error(result[2], 2) end
        return table.unpack(result, 2, result.n)
    end
    methods.progressBar = function(...) return run("progress", "progressBar", ...) end
    methods.progressCircle = function(...) return run("progress", "progressCircle", ...) end
    methods.progressActive = function() return active.progress ~= nil end
    methods.cancelProgress = function()
        if not active.progress then error("No active progress bar", 2) end
        active.progress.ui.cancelProgress(true)
    end
    methods.skillCheck = function(...) return run("skill", "skillCheck", ...) end
    methods.skillCheckActive = function() return active.skill ~= nil end
    methods.cancelSkillCheck = function()
        if active.skill then return active.skill.ui.cancelSkillCheck() end
    end
    return methods
end
