--267: explicit profile binds the local consumer to one host; no automatic publication.
return function(p)
 local n=assert(p.native);local profile=assert(p.profile);local side=n.IsDuplicityVersion()and'server'or'client'
 local resource=n.GetCurrentResourceName();local selected=assert(profile.Get(resource,side),'consumer absent from activation profile')
 local ports=assert(p.bindingPorts);assert(ports.native==n and ports.prCore==p.prCore,'consumer ownership mismatch')
 assert(ports.inventory==selected.inventory,'consumer inventory mismatch')
 assert(ports.config.compatFramework=='forge'and ports.contracts.qbx==true,'Forge consumer contracts required')
 assert(ports.contracts.qb==(side=='server'and profile.QBEnabled),'QB contract/profile mismatch')
 assert(ports.api==nil,'native proxy must supply API')
 local load=assert(p.load);local registration=assert(p.registration)
 local expected=load('bridge/runtime/forge/activation_api_expectations')(side,profile.QBEnabled)
 local host=load('bridge/runtime/forge/activation_consumer_host')({
  native=n,prCore=p.prCore,external=p.external,generation=profile.Generation,instance=selected.instance,
  expected=expected,bindingPorts=ports,isCurrent=p.isCurrent,load=load,
  available=function(name)return registration.available('export',name)end,publishExport=registration.publishExport})
 local api={OperationalReady=false,Host=host,Generation=profile.Generation,Instance=selected.instance,Resource=resource,Side=side}
 function api.Install()if p.installApproved~=true then return false,'consumer_install_not_approved'end;return host.Install()end
 function api.Close()return host.Close()end
 function api.Progress()return host.Progress()end
 return api
end
