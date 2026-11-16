-- Private Renewed society extension. Existing public money semantics remain in the installed PR adapter.
return function(ports)
    local public,raw=assert(ports.banking),assert(ports.renewed)
    local state,current=assert(ports.resourceState),assert(ports.isCurrent)
    local resource=assert(public.GetResourceName)
    local get,create,transaction=assert(raw.GetJobAccount),assert(raw.CreateJobAccount),assert(raw.handleTransaction)
    assert(type(resource)=='function'and type(get)=='function'and type(create)=='function'and type(transaction)=='function','explicit Renewed functions required')
    local phase,entered='prepared',0
    local api={OperationalReady=false}
    local function owner()local ok,value=pcall(current);return ok and value==true end
    local function live()return phase=='open'and owner()end
    local function invoke(fn,...)
        if not live()then return nil,'banking_scope_closed'end
        entered=entered+1;local result=table.pack(pcall(fn,...));entered=entered-1
        if not result[1]then error(result[2],0)end;return table.unpack(result,2,result.n)
    end
    local function record(value,name)
        if value==nil then return nil end
        assert(type(value)=='table'and value.id==name,'unexpected Renewed job account record')
        return value
    end
    function api.JobAccountExists(name)
        return invoke(function()return record(get(raw,name),name)~=nil end)
    end
    function api.EnsureJobAccount(name,label,balance)
        return invoke(function()
            local existing=record(get(raw,name),name)
            if not live()then return nil,'banking_scope_closed'end
            if existing then return true,'exists'end
            local account=record(create(raw,{name=name,label=label},balance),name)
            assert(account,'Renewed account creation was not acknowledged')
            return true,'created'
        end)
    end
    function api.RecordJobTransaction(name,data)
        return invoke(function()
            assert(type(data)=='table','transaction data required')
            return transaction(raw,name,data.title,data.amount,data.message,data.issuer,data.receiver,data.type)
        end)
    end
    for _,name in ipairs({'GetJobAccountBalance','AddJobAccountBalance','RemoveJobAccountBalance'})do
        local fn=assert(public[name],'installed PR society operation required: '..name)
        assert(type(fn)=='function','PR function required: '..name)
        api[name]=function(...)return invoke(fn,...)end
    end
    function api.Open()
        if phase~='prepared'then return false,'banking_scope_not_repeatable'end
        if not owner()or state('Renewed-Banking')~='started'or resource()~='Renewed-Banking'or phase~='prepared'then
            return false,'renewed_provider_not_ready'
        end
        phase='open';return true
    end
    function api.Close()phase='closed';return true end
    function api.Progress()return{phase=phase,pending=entered,complete=phase=='closed'and entered==0}end
    return api
end
