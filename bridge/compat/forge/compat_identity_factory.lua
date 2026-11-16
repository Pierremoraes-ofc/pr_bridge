-- Explicit metadata identity only. No framework discovery, version forgery or operational readiness claim.
local fields={name='forge_qbx_compat',forge_authority='forge-core',forge_compatibility='qbx',forge_compat_protocol='1'}
return function(ports)
    local state,metadata,count=assert(ports.getResourceState),assert(ports.getResourceMetadata),assert(ports.getNumResourceMetadata)
    local current=assert(ports.isCurrent);local phase,pending='open',0;local api={OperationalReady=false}
    local function valid()local ok,value=pcall(current);return phase=='open'and ok and value==true end
    local function check()assert(valid(),'compatibility identity closed')end
    local function inspect()
        check();assert(state('forge-core')=='started'and state('qbx_core')=='started','explicit Forge compatibility not started');check()
        local values={}
        for _,key in ipairs({'name','forge_authority','forge_compatibility','forge_compat_protocol','version'})do
            assert(count('qbx_core',key)==1,'single compatibility metadata value required: '..key);check()
            values[key]=metadata('qbx_core',key,0);check()
            if fields[key]then assert(values[key]==fields[key],'compatibility metadata mismatch: '..key)end
        end
        assert(type(values.version)=='string'and values.version:match('^%d+%.%d+%.%d+$'),'explicit compatibility version required')
        for key,value in pairs(values)do
            assert(count('qbx_core',key)==1 and metadata('qbx_core',key,0)==value,'compatibility metadata changed during read');check()
        end
        assert(state('forge-core')=='started'and state('qbx_core')=='started','compatibility state changed during read');check()
        return{framework='forge',authority='forge-core',publicResource='qbx_core',compatibility='qbx',protocol='1',
            publicVersion=values.version,nativeQbx=false,operationalReady=false}
    end
    function api.Probe()
        pending=pending+1;local out=table.pack(pcall(inspect));pending=pending-1
        if not out[1]then return nil,out[2]end;return out[2]
    end
    function api.Close()phase='closed';return pending==0 end
    function api.Progress()return{phase=phase,pending=pending,complete=phase=='closed'and pending==0}end
    return api
end
