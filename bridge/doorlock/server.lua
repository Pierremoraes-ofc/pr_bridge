-- Provider contract used by housing: persisted group, geometry and custom types.
local api = {}
local function invoke(method, ...)
    if GetResourceState('ox_doorlock') ~= 'started' then return nil, 'provider_unavailable' end
    local args = table.pack(...)
    local ok, result = pcall(function()
        return exports.ox_doorlock[method](exports.ox_doorlock, table.unpack(args, 1, args.n))
    end)
    if not ok then return nil, tostring(result) end
    return result
end
function api.getByName(name) return invoke('getDoorFromName', name) end
function api.catalog() return invoke('getAllDoors') end
function api.ensure(name, definition, group, access)
    local door, err = api.getByName(name)
    if err then return nil, err end
    if door then
        if door.doorGroup and door.doorGroup~='' and door.doorGroup~=group then return nil,'door_owned_by_other_group' end
        -- Keep existing geometry, animation transforms, permissions and door type.
        local patch={doorGroup = group, distance = 80}
        if access then
            patch.groups=access.groups
            patch.characters,patch.items,patch.passcode='', '', ''
            patch.lockpick=false
        end
        local _, editError = invoke('editDoor', door.id, patch)
        if editError then return nil, editError end
        return door.id
    end
    if type(definition) ~= 'table' then return nil, 'missing_door_geometry' end
    -- A started resource can still be loading its database. Do not duplicate a
    -- persisted name whose in-memory door is not available yet.
    local ok, rows = pcall(pr_lib.database.query, 'SELECT id FROM ox_doorlock WHERE name = ? LIMIT 1', {name})
    if not ok or type(rows) ~= 'table' then return nil, 'database_unavailable' end
    if rows[1] then return nil, 'provider_loading' end
    local function clone(value)
        if type(value)~='table' then return value end
        local result={};for k,v in pairs(value) do result[k]=clone(v) end;return result
    end
    local payload = clone(definition)
    local function vectors(leaf)
        for _,key in ipairs({'coords','rotation','slideDirection'}) do
            local p=leaf[key];if p then leaf[key]=vec3(p.x,p.y,p.z) end
        end
        for _,key in ipairs({'closed','open'}) do if leaf[key] then vectors(leaf[key]) end end
    end
    vectors(payload)
    if payload.doors then
        for _,leaf in ipairs(payload.doors) do vectors(leaf) end
        local a,b=payload.doors[1].coords,payload.doors[2].coords
        payload.coords=vec3((a.x+b.x)/2,(a.y+b.y)/2,(a.z+b.z)/2)
    end
    payload.id = nil
    payload.name, payload.doorGroup = name, group
    payload.state, payload.distance = 1, 80
    payload.maxDistance = payload.maxDistance or 2.5
    if access then
        payload.groups=access.groups
        payload.characters,payload.items,payload.passcode=nil,nil,nil
        payload.lockpick=false
    end
    if not payload.coords and not payload.doors then return nil, 'missing_door_geometry' end
    return invoke('createDoor', payload)
end
function api.setState(name, locked)
    local door, err = api.getByName(name)
    if not door then return false, err or 'door_not_found' end
    local target=locked and 1 or 0
    -- Local server dispatch supplies a server origin rather than an inherited
    -- player/zero source. Network requests still use the provider's own ACL.
    local ok,reason=pcall(TriggerEvent,'ox_doorlock:setState',door.id,target)
    if not ok then return false,tostring(reason) end
    local current,readError=api.getByName(name)
    if not current then return false,readError or 'door_not_found' end
    if current.state~=target then return false,'door_state_not_applied' end
    return true
end
return api
