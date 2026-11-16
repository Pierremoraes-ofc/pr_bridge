-- Native destination identity; compatibility aliases do not determine Forge availability.
return function(p)
    local current=assert(p.isCurrent)
    local closed=false
    local api={OperationalReady=false}
    function api.Probe()
        if closed or current()~=true then return nil,'Forge identity closed'end
        if p.getResourceState('forge-core')~='started'then return nil,'Forge is not started'end
        if p.getResourceMetadata('forge-core','forge_kernel_bootstrap',0)~='owned/1'then
            return nil,'Forge native bootstrap identity mismatch'
        end
        return{framework='forge',authority='forge-core',publicResource='forge-core',protocol='1',operationalReady=false}
    end
    function api.Close()closed=true;return true end
    function api.Progress()return{phase=closed and'closed'or'open',pending=0,complete=closed}end
    return api
end
