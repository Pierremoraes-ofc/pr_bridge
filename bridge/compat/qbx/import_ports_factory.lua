-- Opt-in consumer import ports. PR owns integrations; Forge remains the only core authority.
return function(ports)
    local env,side=assert(ports.environment),assert(ports.side)
    assert(type(env)=='table'and(side=='server'or side=='client'),'explicit consumer environment/side required')
    local resource=assert(ports.resource)
    assert(type(resource)=='string'and resource~=''and resource~='forge-core'and resource~='pr_bridge'and resource~='qbx_core','external consumer identity required')
    local owner,ready=assert(ports.isCurrent),assert(ports.isReady)
    local package,requireFn=assert(rawget(env,'package')),assert(rawget(env,'require'))
    assert(type(package.loaded)=='table'and type(package.searchers)=='table'and type(requireFn)=='function','consumer package/require required')
    local library,native,cache=assert(ports.library),assert(ports.native),assert(ports.cache)
    local audio,inventory,core=assert(ports.audio),assert(ports.inventory),assert(ports.core)
    assert(type(library.table.freeze)=='function'and type(library.string.random)=='function'and type(library.waitFor)=='function','PR helper library required')
    assert(type(library.print.warn)=='function'and type(inventory.Search)=='function','PR warning/inventory Search required')
    local phase,pending='allocated',0;local settings;local api={OperationalReady=false}
    local function valid()
        if phase=='closed'then return false end
        local ok,value=pcall(owner);if not ok or value~=true then return false end
        return rawget(env,'package')==package and rawget(env,'require')==requireFn and(phase~='installed'or rawget(env,'ForgeQbxConsumerPorts')==settings)
    end
    local function active()
        if phase~='installed'or not valid()then return false end
        local ok,value=pcall(ready);return ok and value==true and phase=='installed'and valid()
    end
    local function installed()return phase=='installed'and valid()end
    local function guard(fn,localOnly)
        assert(type(fn)=='function','explicit consumer integration delegate required')
        return function(...)
            assert(localOnly and installed()or active(),'PR consumer ports unavailable');pending=pending+1;local out=table.pack(pcall(fn,...));pending=pending-1
            if not out[1]then error(out[2],0)end;return table.unpack(out,2,out.n)
        end
    end
    local a={};local names=side=='server'and{'PlayNativeSound','PlayNativeSoundFromCoords','PlayNativeSoundFromEntity'}or{
        'PlayLocalNativeSound','PlayLocalNativeSoundFromCoords','PlayLocalNativeSoundFromEntity','PlaySharedNativeSoundFromCoords','PlaySharedNativeSoundFromEntity'}
    for _,name in ipairs(names)do a[name]=guard(audio[name])end
    local c={}
    if side=='server'then
        c.getVehiclesByHash=guard(core.GetVehiclesByHash);c.setEntityBucket=guard(core.SetEntityBucket);c.enablePersistence=guard(core.EnablePersistence)
    else assert(type(ports.events)=='table','client PlayerData event ports required');c.GetPlayerData=guard(core.GetPlayerData)end
    local consumer={environment=env,isServer=side=='server',isCurrent=installed,package=package,requireFunction=requireFn,
        lib={native=native,library=library,cache=cache,audio=a,core=c,warn=guard(library.print.warn,true)},
        utils={native=native,library=library,cache=cache,searchInventory=guard(inventory.Search),random=guard(assert(ports.random),true),
            strsplit=guard(assert(ports.strsplit),true),discordLink=ports.discordLink},locale={warn=guard(library.print.warn,true)}}
    if side=='client'then consumer.getPlayerData=c.GetPlayerData;consumer.events=ports.events
    else assert(type(ports.discordLink)=='string','explicit Discord configuration required')end
    settings={consumer=consumer,isCurrent=installed,compile=guard(assert(ports.compile),true),moduleEnvironment=guard(assert(ports.moduleEnvironment),true)}
    function api.Install()
        if phase~='allocated'then return false,'PR consumer ports not repeatable'end
        assert(valid(),'PR consumer owner changed');assert(rawget(env,'ForgeQbxConsumerPorts')==nil,'foreign PR consumer ports')
        assert(rawget(env,'ForgeQbxConsumerPorts')==nil,'PR consumer slot changed during installation')
        rawset(env,'ForgeQbxConsumerPorts',settings);phase='installed';return true
    end
    function api.Close()
        phase='closed';if rawget(env,'ForgeQbxConsumerPorts')==settings then rawset(env,'ForgeQbxConsumerPorts',nil)end
        return pending==0
    end
    function api.Progress()return{phase=phase,pending=pending,publicationRemaining=rawget(env,'ForgeQbxConsumerPorts')==settings,
        consumerCleanupOwned=false,complete=phase=='closed'and pending==0 and rawget(env,'ForgeQbxConsumerPorts')~=settings}end
    return api
end
