-- MySQL-compatible call/await shapes over the same installed PR provider. No SQL at construction.
return function(ports)
    local db,current=assert(ports.database),assert(ports.isCurrent)
    assert(db.driver=='oxmysql'and db.context=='server','installed server PR database required')
    local closed,pending=false,0;local refs={};local api={Database={},OperationalReady=false}
    local function valid()
        if closed then return false end;local ok,value=pcall(current);if not ok or value~=true then return false end
        for key,fn in pairs(refs)do if db[key]~=fn then return false end end;return true
    end
    local function call(fn,sql,params,callback)
        assert(valid(),'native PR database unavailable');pending=pending+1
        local callbackPending=false;local delivered=false
        local wrapped
        if type(callback)=='function'then
            callbackPending=true;pending=pending+1
            wrapped=function(...)
                local first=not delivered;delivered=true
                local out=table.pack(pcall(callback,...));if first then pending=pending-1 end
                if not out[1]then error(out[2],0)end;return table.unpack(out,2,out.n)
            end
        end
        local result=table.pack(pcall(fn,sql,params,wrapped));pending=pending-1
        if not result[1]then
            if callbackPending and not delivered then pending=pending-1;delivered=true end
            error(result[2],0)
        end
        return table.unpack(result,2,result.n)
    end
    for _,key in ipairs({'query','execute','insert','update','scalar','single','transaction','prepare','rawExecute'})do
        local fn=assert(db[key],'PR database method required:'..key);refs[key]=fn
        local method={await=function(sql,params)return call(fn,sql,params)end}
        setmetatable(method,{__call=function(_,sql,params,callback)
            if type(params)=='function'and callback==nil then callback,params=params,nil end
            return call(fn,sql,params,callback)
        end});api.Database[key]=method
    end
    local ready=assert(db.isReady);refs.isReady=ready
    function api.IsReady()assert(valid(),'native PR database unavailable');return ready()end
    api.Database.isReady=api.IsReady
    function api.Close()closed=true;return pending==0 end
    function api.Progress()return{closed=closed,pending=pending,complete=closed and pending==0,operationalReady=false}end
    return api
end
