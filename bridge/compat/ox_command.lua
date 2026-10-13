-- Syntax/result conversion only. Registration, parsing, permissions and chat
-- suggestions all run through the native PR command API.
return function(native)
    return function(name, properties, callback)
        local options = {}
        for key, value in pairs(properties or {}) do options[key] = value end
        options.strictAce = true
        local params = {}
        for i, definition in ipairs(options.params or {}) do
            local param = {}
            for key, value in pairs(definition) do param[key] = value end
            if param.type == 'string' and param.allowNumericString == nil then param.allowNumericString = false end
            params[i] = param
        end
        options.params = params
        native(name, options, function(playerId, parsed, raw, _, original)
            local values = {}
            for key, value in pairs(original or {}) do values[key] = value end
            for i, param in ipairs(params) do values[i], values[param.name] = nil, parsed[i].value end
            return callback(playerId, values, raw)
        end)
    end
end
