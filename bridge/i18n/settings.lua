local context = PRCore.context
local settings = {}
function settings.getKey()
    local stored = context == 'client' and GetResourceKvpString('pr_bridge:locale')
    return stored or (context == 'client' and GetResourceKvpString('ox_compat:locale'))
        or GetConvar('ox:locale', GetConvar('pr_bridge:locale', 'en'):sub(1, 2))
end
function settings.setKey(key)
    assert(type(key) == 'string' and key:match('^[%w_-]+$'), 'Invalid locale key')
    if context == 'client' then SetResourceKvp('pr_bridge:locale', key) end
    TriggerEvent('pr_bridge:setLocale', key)
end
return settings
