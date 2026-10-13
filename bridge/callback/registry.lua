-- Host-owned callback namespace. Both protocol adapters share this registry.
local registry, api = {}, {}
function api.set(name, valid)
    assert(type(name)=='string' and name~='', 'Invalid callback name')
    local owner=GetInvokingResource() or GetCurrentResourceName()
    assert(not registry[name] or registry[name]==owner, ("Callback '%s' owned by '%s'"):format(name,tostring(registry[name])))
    registry[name] = valid and owner or nil
end
function api.valid(name) return registry[name]==(GetInvokingResource() or GetCurrentResourceName()) end
function api.exists(name) return registry[name]~=nil end
function api.removeOwner(resource)
    for name,owner in pairs(registry) do if owner==resource then registry[name]=nil end end
end
AddEventHandler('onResourceStop',function(resource)
    for name,owner in pairs(registry) do if owner==resource then registry[name]=nil end end
end)
return api
