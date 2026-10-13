local state={}
function state.setLocal(bag,key,value,replicated)
    local packed=msgpack.pack(value)
    SetStateBagValue(bag,key,packed,#packed,replicated==true)
    return true
end
state.get=GetStateBagValue
state.has=StateBagHasKey
state.keys=GetStateBagKeys
return state
