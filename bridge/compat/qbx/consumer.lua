--277: imported code executes in the consumer;PR supplies the reviewed integration ports.
return function(entry)
 local env=_ENV
 if not rawget(env,'ForgeQbxConsumerPorts')then
  if not rawget(env,'pr_lib')then
   local init=assert(LoadResourceFile('pr_bridge','init.lua'),'PR import required')
   assert(load(init,'@@pr_bridge/init.lua','t',env))()
  end
  assert(PRCore and pr_lib,'initialized PR consumer required')
  PRCore.load('@pr_bridge/bridge/compat/qbx/import_ports',env)({environment=env,prCore=PRCore,public=pr_lib})
 end
 local key='__forge_qbx_consumer_delivery107';local current=rawget(env,key)
 if current then assert(current.Protocol=='forge-qbx-consumer/1');return current.ExecuteEntry(entry)end
 local settings=assert(rawget(env,'ForgeQbxConsumerPorts'),'reviewed PR consumer ports required')
 assert(settings.consumer.environment==env and settings.consumer.isServer==(not not IsDuplicityVersion()))
 local function read(path)return assert(LoadResourceFile('pr_bridge','bridge/compat/qbx/'..path),'missing compatibility import:'..path)end
 local function factory(path)return assert(load(read(path),'@@qbx_core/'..path,'t',env))()end
 local delivery={};for k,v in pairs(settings)do delivery[k]=v end;delivery.readFile=read
 local scope=factory('compat/entry.lua')(factory('kernel/imports/consumer_delivery.lua'),{
  environment=env,namespace=key,resource=GetCurrentResourceName(),isCurrent=settings.isCurrent,delivery=delivery,
  listen=AddEventHandler,remove=RemoveEventHandler})
 local ok,problem=scope.Start();assert(ok,problem);return scope.ExecuteEntry(entry)
end
