-- Generic, authorized state writes. Protocol adapters supply their policy;
-- entity ownership and payload validation are enforced here for every caller.
local state = {}
function state.requestSet(playerId,bag,key,value,mode,authorize)
    if type(bag)~='string' or type(key)~='string' or #key>128 or (mode~=0 and mode~=1 and mode~=2) then return false end
    local kind,id=bag:match('^(%a+):(%d+)$'); id=tonumber(id)
    if not id or (kind~='entity' and kind~='player') then return false end
    local entity=kind=='entity' and NetworkGetEntityFromNetworkId(id) or nil
    if kind=='entity' and (not entity or entity==0 or not DoesEntityExist(entity) or NetworkGetEntityOwner(entity)~=playerId) then return false end
    if kind=='player' and id~=playerId then return false end
    local payload={playerId=playerId,targetId=id,entityId=entity,type=kind,bag=bag,key=key,value=value,mode=mode}
    if type(authorize)~='function' or not authorize(payload) then return false end
    local ok,packed=pcall(msgpack.pack,value)
    if not ok or #packed>65536 then return false end
    SetStateBagValue(bag,key,packed,#packed,mode==1)
    return true
end
return state
