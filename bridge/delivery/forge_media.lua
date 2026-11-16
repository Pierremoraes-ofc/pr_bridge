-- Private PR boundary for server native sound and the installed legacy chat event.
return function(ports)
    local raw,state,send,current=assert(ports.nativeSound),assert(ports.resourceState),assert(ports.sendClient),assert(ports.isCurrent)
    local phase,entered='prepared',0
    local api={OperationalReady=false,Audio={}}
    local function live()local ok,value=pcall(current);return phase=='open'and ok and value==true end
    local function invoke(fn,...)
        if not live()then return nil,'media_scope_closed'end
        entered=entered+1;local result=table.pack(pcall(fn,...));entered=entered-1
        if not result[1]then error(result[2],0)end;return table.unpack(result,2,result.n)
    end
    for _,name in ipairs({'PlayNativeSound','PlayNativeSoundFromEntity','PlayNativeSoundFromCoords'})do
        local fn=assert(raw[name],'explicit native-sound export required: '..name)
        assert(type(fn)=='function','native-sound function required: '..name)
        api.Audio[name]=function(...)return invoke(fn,raw,...)end
    end
    function api.ResourceState(...)return invoke(state,...)end
    function api.ChatMessage(target,payload)return invoke(send,'chat:addMessage',target,payload)end
    function api.Open()if phase~='prepared'or not current()then return false end;phase='open';return true end
    function api.Close()phase='closed';return true end
    function api.Progress()return{phase=phase,pending=entered,complete=phase=='closed'and entered==0,DeliveryAcknowledged=false}end
    return api
end
