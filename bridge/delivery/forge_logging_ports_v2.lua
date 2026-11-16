-- Installed PR logger with owned event/timer/HTTP boundaries. Hooks remain the internal Forge registry.
return function(ports)
 local f,n,events=assert(ports.foundation),assert(ports.native),assert(ports.events)
 assert(f.Side=='server','server logging ports required')
 local loadPR,clock=assert(ports.loadPR),assert(ports.clock)
 local phase,pending,httpPending,unknown='preparing',0,0,0;local records={}
 local api={OperationalReady=false};local tasks
 local function owner()return phase~='closed'and f.IsCurrent()end
 local function call(fn,...)
  assert(owner(),'native logging ports closed');pending=pending+1
  local out=table.pack(pcall(fn,...));pending=pending-1
  if not out[1]then error(out[2],0)end;return table.unpack(out,2,out.n)
 end
 local function http(url,callback,...)
  assert(phase=='open'and owner(),'native logging HTTP unavailable')
  local waiting=true;httpPending=httpPending+1
  local function reply(...)
   if waiting then waiting=false;httpPending=httpPending-1 end
   if phase~='open'or not owner()then return end;return call(callback,...)
  end
  local out=table.pack(pcall(assert(n.PerformHttpRequest),url,reply,...))
  if not out[1]then if waiting then waiting=false;httpPending=httpPending-1;unknown=unknown+1 end;error(out[2],0)end
  return table.unpack(out,2,out.n)
 end
 tasks=assert(ports.createTasks)({isCurrent=function()return phase=='open'and owner()end,running=assert(ports.running),onError=assert(ports.onError)})
 local scheduler=tasks.WrapNative({Wait=assert(n.Wait),CreateThread=assert(n.CreateThread),SetTimeout=assert(n.SetTimeout)})
 local env={};for k,v in pairs(assert(ports.environment))do env[k]=v end
 env.Wait,env.CreateThread,env.SetTimeout=scheduler.Wait,scheduler.CreateThread,scheduler.SetTimeout
 env.PerformHttpRequest=http
 for _,name in ipairs({'GetConvar','GetPlayerName','GetNumPlayerIdentifiers','GetPlayerIdentifier'})do env[name]=assert(n[name],'logging native required:'..name)end
 env.json=f.Seed.IO.Codec;env.warn=f.Seed.Library.Library.print.warn;env.cache=f.Seed.Library.Cache
 env.AddEventHandler=function(name,callback)
  assert(phase=='preparing'and name=='playerDropped','unexpected installed logger registration')
  records[#records+1]={name=name,callback=callback};return #records
 end
 env.PRCore={load=function(path,target)
  local prefix='@pr_bridge/bridge/logging/providers/'
  assert(path:sub(1,#prefix)==prefix,'logger provider path required')
  return loadPR(path,target or env)
 end}
 local logger=assert(loadPR('@pr_bridge/bridge/logging/server',env))({cache=f.Seed.Library.Cache})
 api.DeliveryPorts={isCurrent=owner,setTimeout=scheduler.SetTimeout,httpRequest=http,logger=function(...)
  assert(phase=='open'and owner(),'native library logger unavailable');return call(logger,...)
 end}
 local printError=assert(f.Seed.Library.Library.print.error)
 api.LoggerPorts={isServer=true,printError=function(...)return call(printError,...)end,
  getGameTimer=assert(n.GetGameTimer),wait=n.Wait,thread=n.CreateThread,
  encode=assert(f.Seed.IO.Codec.encode),time=assert(clock.time),date=assert(clock.date)}
 api.HookPorts={resource='forge-core',getInvokingResource=assert(n.GetInvokingResource),
  warn=f.Seed.Library.Library.print.warn,checkDependency=assert(ports.checkDependency),microtime=assert(clock.microtime)}
 function api.Open()
  if phase~='prepared'or not owner()then return false end;phase='open';assert(tasks.Open())
  for _,r in ipairs(records)do
   local ok,token=pcall(events.listen,r.name,function(...)
    if phase~='open'or not owner()then return end
    local previous=env.source;env.source=events.source()
    local out=table.pack(pcall(r.callback,...));env.source=previous
    if not out[1]then error(out[2],0)end;return table.unpack(out,2,out.n)
   end)
   if not ok or token==nil or token==false then r.uncertain=true;api.Close();return false,'logger_registration_uncertain'end
   r.token=token
  end;return true
 end
 function api.Close()
  if phase=='closed'then return true end;phase='closing';tasks.Close()
  local done=pending==0 and httpPending==0 and unknown==0 and tasks.Snapshot().quiescent
  for i=#records,1,-1 do local r=records[i]
   if r.uncertain then done=false end
   if r.token then local ok,v=pcall(events.remove,r.token);if ok and v~=false then r.token=nil else done=false end end
  end
  if done then phase='closed'end;return done
 end
 function api.Progress()
  local count,uncertain=0,0;for _,r in ipairs(records)do if r.token then count=count+1 end;if r.uncertain then uncertain=uncertain+1 end end
  return{phase=phase,pending=pending,pendingHTTP=httpPending,unknownHTTP=unknown,listeners=count,uncertain=uncertain,tasks=tasks.Snapshot(),complete=phase=='closed',operationalReady=false}
 end
 phase='prepared';return api
end
