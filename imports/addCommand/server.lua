local native = lib.__native('bridge/addCommand/server')
local adapt = PRCore.load('@pr_bridge/bridge/compat/ox_lib/ox_command', _ENV)(native)
function lib.addCommand(name, properties, callback, ...)
    if properties and (select('#', ...) > 0 or type(properties) ~= 'table' or table.type(properties) ~= 'hash') then
        return lib.__addCommand(name, properties, callback, ...)
    end
    adapt(name, properties, callback)
end
return lib.addCommand
