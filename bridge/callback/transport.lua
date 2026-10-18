-- Canonical RPC engine. Transports provide wire names/envelopes only; request
-- ownership, pending storage, deadlines, registration and nil slots live here.
return function(options)
    local pending, registered, sequence = {}, {}, 0
    local api = {}
    local function fail(entry, reason)
        if entry.promise then
            if options.rejectErrors then entry.promise:reject(reason)
            else entry.promise:resolve(table.pack(nil, reason)) end
        elseif options.onError then options.onError(reason) end
    end
    RegisterNetEvent(options.responseEvent, function(key, ...)
        local entry = pending[key]
        if not entry or not options.acceptResponse(source, entry.target) then return end
        pending[key] = nil
        local values = table.pack(...)
        if options.invalidResult and values[1] == options.invalidResult then
            fail(entry, ("callback '%s' does not exist"):format(entry.event))
        elseif entry.promise then entry.promise:resolve(values)
        else entry.callback(table.unpack(values, 1, values.n)) end
    end)
    function api.request(event, target, callback, timeout, ...)
        assert(type(event) == 'string' and event ~= '', 'Expected callback event')
        if options.validateTarget then options.validateTarget(target) end
        sequence = sequence + 1
        local key = ('%s:%s:%s:%s'):format(GetCurrentResourceName(), event, GetGameTimer(), sequence)
        local entry = {event=event, target=target, callback=callback, promise=not callback and promise.new() or nil}
        pending[key] = entry
        SetTimeout(timeout or options.timeout, function()
            if pending[key] ~= entry then return end
            pending[key] = nil
            fail(entry, options.rejectErrors and ("callback event '%s' timed out"):format(key) or 'timeout')
        end)
        options.send(event, target, key, ...)
        if entry.promise then
            local values = Citizen.Await(entry.promise)
            return table.unpack(values, 1, values.n)
        end
        return key
    end
    function api.register(name, callback)
        assert(type(name) == 'string' and name ~= '' and type(callback) == 'function', 'Invalid callback registration')
        if options.claim then options.claim(name) end
        if registered[name] then RemoveEventHandler(registered[name]) end
        local event = options.requestEvent(name)
        RegisterNetEvent(event)
        registered[name] = AddEventHandler(event, function(...)
            local player = source
            local owner, key, args = options.parseRequest(...)
            if not options.acceptRequest(player, owner, key) then return end
            local values
            if options.server then values = table.pack(pcall(callback, player, table.unpack(args,1,args.n)))
            else values = table.pack(pcall(callback, table.unpack(args,1,args.n))) end
            if not values[1] then
                if options.onError then options.onError(("Callback '%s': %s"):format(name,tostring(values[2]))) end
                options.reply(player, owner, key, nil)
            else options.reply(player, owner, key, table.unpack(values,2,values.n)) end
        end)
    end
    function api.unregister(name)
        local handler=registered[name]
        if handler then RemoveEventHandler(handler);registered[name]=nil end
        return handler~=nil
    end
    function api.cancel(key) local entry=pending[key]; pending[key]=nil; if entry then fail(entry,'cancelled') end end
    function api.getPending() return pending end
    if options.server then AddEventHandler('playerDropped', function()
        local player=tonumber(source)
        for key, entry in pairs(pending) do
            if tonumber(entry.target)==player then pending[key]=nil; fail(entry,'Target player disconnected') end
        end
    end) end
    AddEventHandler('onResourceStop', function(resource)
        if resource ~= GetCurrentResourceName() then return end
        for key, entry in pairs(pending) do pending[key]=nil; fail(entry,'Resource stopped') end
        for _, handler in pairs(registered) do RemoveEventHandler(handler) end
    end)
    return api
end
