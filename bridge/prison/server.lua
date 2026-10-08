-- Optional prison provider. Consumers do not depend on provider exports directly.
local resource = 'xt-prison'
local api = {}
function api.isAvailable() return GetResourceState(resource) == 'started' end
local function invoke(name, ...)
    if not api.isAvailable() then return nil, 'prison_unavailable' end
    local args = table.pack(...)
    local ok, result, reason = pcall(function()
        return exports[resource][name](exports[resource], table.unpack(args, 1, args.n))
    end)
    if not ok then return nil, tostring(result) end
    return result, reason
end
function api.getStatus(src) return invoke('GetPrisonStatus', src) end
function api.jail(src, sentence) return invoke('JailPlayer', src, sentence) end
function api.release(src) return invoke('ReleasePlayer', src) end
return api
