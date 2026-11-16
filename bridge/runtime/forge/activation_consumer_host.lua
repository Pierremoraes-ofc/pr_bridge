--256: one explicit consumer host assembled from installed factories;no automatic resource startup.
return function(p)
 local n,pr=assert(p.native),assert(p.prCore);local resource=n.GetCurrentResourceName()
 assert(resource~='forge-core'and resource~='qbx_core'and resource~='','external consumer required')
 assert(pr.forgeActivationHost==nil,'consumer activation host already owned')
 local side=n.IsDuplicityVersion()and'server'or'client';local load=assert(p.load)
 local closed=false;local api={OperationalReady=false};pr.forgeActivationHost=api
 local function current()return not closed and pr.forgeActivationHost==api and p.isCurrent()==true and n.GetCurrentResourceName()==resource end
 local proxy,bindings,control,publication
 local ok,why=pcall(function()
  local core=assert(p.external['forge-core'])
  control=load('bridge/runtime/forge/activation_consumer_control')({native=n,generation=p.generation,instance=p.instance,isCurrent=current,
   createProxy=function()
    proxy=load('bridge/frameworks/forge/native_api_factory')({side=side,isCurrent=current,proxy=core,expected=assert(p.expected)})
    return proxy
   end,
   createBindings=function(nativeAPI)
    local input={};for k,v in pairs(assert(p.bindingPorts))do input[k]=v end
    assert(input.prCore==pr and input.native==n,'consumer binding ownership mismatch')
    assert(input.api==nil,'proxy API owns consumer input')
    input.api=nativeAPI;input.isCurrent=current
    bindings=load('bridge/runtime/forge/native_bindings_factory')(input);return bindings
   end,
   claim=function(...)return core:ForgePrConsumerState(...)end})
  publication=load('bridge/runtime/forge/activation_control_publication')({control=control,generation=p.generation,instance=p.instance,
   getInvokingResource=assert(n.GetInvokingResource),available=assert(p.available),publishExport=assert(p.publishExport)})
 end)
 function api.Install()if closed then return false end;return publication.Install()end
 function api.Close()
  closed=true
  local done
  if publication then done=publication.Close()elseif control then done=control.Close()else done=true end
  if done and(not publication or publication.Progress().complete)and pr.forgeActivationHost==api then pr.forgeActivationHost=nil end
  return api.Progress().complete
 end
 function api.Progress()
  local s=publication and publication.Progress()
  return{phase=closed and'closed'or(s and s.phase or'allocated'),pending=s and s.pending or 0,
   complete=closed and(not s or s.complete)and pr.forgeActivationHost~=api,operationalReady=false}
 end
 if not ok then api.Close();error(why,0)end
 return api
end
