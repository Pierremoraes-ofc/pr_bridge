-- Private owned delegation. Shared PR batch timers and accepted HTTP are not cancelled here.
return function(ports)
    local logger,http,current=assert(ports.logger),assert(ports.httpRequest),assert(ports.isCurrent)
    local phase,entered,pending,unknown='prepared',0,0,0
    local api={OperationalReady=false}
    local function live()local ok,value=pcall(current);return phase=='open'and ok and value==true end
    local function invoke(fn,...)
        if not live()then return nil,'log_delivery_closed'end
        entered=entered+1;local result=table.pack(pcall(fn,...));entered=entered-1
        if not result[1]then error(result[2],0)end;return table.unpack(result,2,result.n)
    end
    function api.LibraryLogger(...)return invoke(logger,...)end
    function api.HttpRequest(url,callback,...)
        return invoke(function(...)
            local waiting=true;pending=pending+1
            local function reply(...)
                if waiting then waiting=false;pending=pending-1 end
                if not live()then return end
                return callback(...)
            end
            local result=table.pack(pcall(http,url,reply,...))
            if not result[1]then
                if waiting then waiting=false;pending=pending-1;unknown=unknown+1 end
                error(result[2],0)
            end
            return table.unpack(result,2,result.n)
        end,...)
    end
    function api.Open()if phase~='prepared'or not current()then return false end;phase='open';return true end
    function api.Close()phase='closed';return true end
    function api.Progress()return{phase=phase,pendingCalls=entered,pendingHTTP=pending,unknownHTTP=unknown,
        complete=phase=='closed'and entered==0 and pending==0 and unknown==0,SharedBatchOwned=false}end
    return api
end
