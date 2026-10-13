-- One validation/publishing implementation for native and legacy transports.
local api = {}
local maxProps = math.max(1, math.min(16, GetConvarInt('pr_bridge:progressPropLimit', GetConvarInt('ox:progressPropLimit', 2))))
local function finite(value) return type(value)=='number' and value==value and math.abs(value)<math.huge end
local function vector(value, limit)
    local ok, valid = pcall(function()
        return finite(value.x) and finite(value.y) and finite(value.z)
            and math.abs(value.x)<=limit and math.abs(value.y)<=limit and math.abs(value.z)<=limit
    end)
    return ok and valid
end
local function sanitize(prop)
    if type(prop)~='table' then return end
    local model = prop.model
    if not ((type(model)=='string' and #model>0 and #model<=128) or finite(model)) then return end
    if not vector(prop.pos,5) or not vector(prop.rot,3600) then return end
    if prop.bone~=nil and (not finite(prop.bone) or prop.bone%1~=0) then return end
    local order = prop.rotOrder or prop.rotationOrder
    if order~=nil and (not finite(order) or order%1~=0 or order<0 or order>5) then return end
    return {model=model,pos=prop.pos,rot=prop.rot,bone=prop.bone,rotOrder=order}
end
function api.publish(playerId, props, key)
    playerId = tonumber(playerId)
    if not playerId or playerId<=0 then return false end
    local value
    if props~=nil then
        if type(props)~='table' then return false end
        if props.model then value=sanitize(props); if not value then return false end
        else
            value={}
            for i=1,math.min(maxProps,#props) do
                local prop=sanitize(props[i]); if not prop then return false end
                value[#value+1]=prop
            end
        end
    end
    Player(playerId).state:set(key or 'pr_bridge:progressProps',value,true)
    return true
end
RegisterNetEvent('pr_bridge:progressProps',function(props) api.publish(source,props) end)
return api
