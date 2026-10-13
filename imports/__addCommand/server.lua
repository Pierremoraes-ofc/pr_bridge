-- Pre-v3 syntax becomes a native command definition; no second parser.
local native = lib.__native('bridge/addCommand/server')
local adapt = PRCore.load('@pr_bridge/bridge/compat/ox_command', _ENV)(native)
function lib.__addCommand(group, name, callback, parameters, help)
    local params = {}
    for i, spec in ipairs(parameters or {}) do
        local key, kind = spec:match('^([^:]+):?(.*)$')
        local optional = kind:sub(1,1) == '?'
        if optional then kind = kind:sub(2) end
        params[i] = {name=key, type=kind ~= '' and kind or 'raw', optional=optional,
            selfId=key == 'target', allowNumericString=true}
    end
    adapt(name, {restricted=group or 'builtin.everyone', params=params, help=help}, callback)
end
return lib.__addCommand
