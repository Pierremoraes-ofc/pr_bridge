--275: one early local host,then actual installed public PR providers at attachment.
return function(p)
 local e,pr,public=assert(p.environment),assert(p.prCore),assert(p.public)
 local load=assert(p.load);local side=e.IsDuplicityVersion()and'server'or'client';local resource=e.GetCurrentResourceName()
 local profile=assert(p.profile);assert(profile.Get(resource,side),'consumer absent from operational profile')
 local closed,complete=false,false;local selectedPublic=public;local host,callbacks;local token;local api
 local function current()return not closed and pr.forgeRuntimeConsumer==api and p.isCurrent()==true end
 assert(pr.forgeRuntimeConsumer==nil,'runtime consumer already owned')
 api={OperationalReady=false,Generation=profile.Generation};pr.forgeRuntimeConsumer=api
 local native={}
 for _,name in ipairs(load('bridge/runtime/forge/native_names'))do native[name]=e[name]end
 native.GetInvokingResource=e.GetInvokingResource
 if side=='server'then native.Entity=e.Entity;native.GetVehicleNumberPlateText=e.GetVehicleNumberPlateText end
 local events={listen=e.AddEventHandler,remove=e.RemoveEventHandler,markNetwork=e.RegisterNetEvent,source=function()return e.source end}
 callbacks=load('bridge/runtime/forge/consumer_callback_leases')({environment=p.callbackEnvironment or e,side=side,isCurrent=current,running=e.coroutine.running,
 getCallback=function()return assert(selectedPublic.callback)end})
 local function ready()
  return current()and complete and type(selectedPublic.cache)=='table'and type(selectedPublic.inventory)=='table'
 end
 local function services()
  assert(ready(),'consumer public providers not initialized')
  local s={inventory=selectedPublic.inventory,banking=selectedPublic.banking,notify=selectedPublic.notify,
   textui=selectedPublic.textuiAdapter,db=selectedPublic.database,decode=e.json.decode,cache=selectedPublic.cache,events=events,
   callbacks=side=='server'and callbacks or nil}
  if resource=='ox_inventory'and side=='server'then
   local inventory=e.require('modules.inventory.server');local state=e.require('modules.state.server')
   s.inventoryBridge={server=assert(e.server),Inventory=inventory,clearState=assert(state.clear),source=function()return e.source end,
    traceback=e.debug.traceback,events=events,schedule=e.SetTimeout,native=native,
    database={scalar=function(sql,args)return selectedPublic.database.scalar(sql,args)end}}
  end
  return s
 end
 local ok,why=pcall(function()
  host=load('bridge/runtime/forge/activation_host_configuration_v2')({native=native,profile=profile,prCore=pr,external=e.exports,
   isCurrent=current,load=load,registration=assert(p.registration),installApproved=true,
    bindingPorts={native=native,prCore=pr,config=p.config,contracts={qbx=true,qb=profile.QBEnabled},
    inventory=resource=='ox_inventory'and side=='server',load=load,isReady=ready,api=nil,
    readDeclarations=p.readDeclarations,createEvents=load('bridge/runtime/forge/event_registration'),
    view=side=='client'and{PlayerData={}}or nil,cacheNamespace='qbx_core',
    readSessionReady=function()local r=selectedPublic.cache.GetResourceState('qbx_core','session');return type(r)=='table'and r.authenticated==true end,
    getServices=services}})
  assert(host.Prepare());assert(host.Install())
  if p.readCoreStatus then
   load('bridge/runtime/forge/consumer_boot_wait')({facade=assert(pr.forgeNormalizedFacade),isCurrent=current,isAttached=host.IsAttached,
    generation=profile.Generation,readStatus=p.readCoreStatus,clock=e.GetGameTimer,wait=e.Wait,timeout=e.GetConvarInt('forge:activationTimeout',120000)})
   load('bridge/runtime/forge/consumer_boot_wait')({facade=assert(pr.forgeLateBinding.NativeHost),isCurrent=current,isAttached=host.IsAttached,
    generation=profile.Generation,readStatus=p.readCoreStatus,clock=e.GetGameTimer,wait=e.Wait,timeout=e.GetConvarInt('forge:activationTimeout',120000)})
  end
  token=e.AddEventHandler(side=='server'and'onResourceStop'or'onClientResourceStop',function(name)if name==resource then api.Close()end end)
  assert(token~=nil and token~=false,'consumer stop token required')
 end)
 function api.Complete(value)
  assert(current()and not complete);selectedPublic=assert(value)
  selectedPublic.forgeLateBinding=pr.forgeLateBinding;complete=true;return ready()
 end
 function api.IsReady()return ready()end
 function api.Close()
  local lateBinding=pr.forgeLateBinding
  local imports=pr.forgeConsumerImportPorts
  if imports and not imports.Close()then return false end
  if imports then pr.forgeConsumerImportPorts=nil end
  closed=true;local clean=not host or host.Close()
  if clean and lateBinding and selectedPublic.forgeLateBinding==lateBinding then selectedPublic.forgeLateBinding=nil end
  if callbacks then clean=callbacks.Close()and clean end
  if token then local result=e.RemoveEventHandler(token);if result~=false then token=nil else clean=false end end
  if clean and token==nil and pr.forgeRuntimeConsumer==api then pr.forgeRuntimeConsumer=nil end
  return api.Progress().complete
 end
 function api.Progress()
  local h=host and host.Progress();local c=callbacks and callbacks.Progress()
  return{complete=closed and token==nil and pr.forgeRuntimeConsumer~=api and(not h or h.complete)and(not c or c.complete),
   host=h,callbacks=c,publicReady=complete,operationalReady=false}
 end
 if not ok then api.Close();error(why,0)end
 return api
end
