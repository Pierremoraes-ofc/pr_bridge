-- Explicit installed server library leaves. No framework/hook/callback bootstrap.
return function(ports)
 local f,s,v=assert(ports.foundation),assert(ports.support),assert(ports.values)
 assert(f.Side=='server','server library required')
 local loadPR=assert(ports.loadPR);local env={};for k,x in pairs(assert(ports.environment))do env[k]=x end
 local closed,pending=false,0;local api={OperationalReady=false,Library={}};local lib=api.Library
 local function live()return not closed and f.IsCurrent()and s.IsCurrent()and v.IsCurrent()end
 local function guard(fn)return function(...)assert(live(),'server library unavailable');pending=pending+1
  local r=table.pack(pcall(fn,...));pending=pending-1;if not r[1]then error(r[2],0)end;return table.unpack(r,2,r.n)end end
 local function project(raw)
  local out={};for k,x in pairs(raw)do out[k]=type(x)=='function'and guard(x)or x end
  local mt=getmetatable(raw);if type(mt)=='table'and mt.__index then setmetatable(out,{__index=function(_,k)
   assert(live(),'server library unavailable');local x=raw[k];return type(x)=='function'and guard(x)or x end})end
  return out
 end
 local n=assert(ports.native);env.TriggerClientEvent=guard(assert(n.TriggerClientEvent))
 env.GetPlayerIdentifierByType=guard(assert(n.GetPlayerIdentifierByType))
 env.Config=assert(ports.config);env.PRDebug=nil
 lib.debug=project(assert(loadPR('@pr_bridge/bridge/debug',env)))
 lib.notify=project(assert(loadPR('@pr_bridge/bridge/notifications/default/server',env)));lib.notifications=lib.notify
 lib.identifiers=project(assert(loadPR('@pr_bridge/bridge/fivem/identifiers/server',env)))
 lib.utils=project(assert(loadPR('@pr_bridge/bridge/utils/shared',env)))
 for k,x in pairs(s.Utilities.Library)do lib[k]=x end
 lib.cache=f.Seed.Library.Cache;lib.settings=f.Public.settings
 local rpc=assert(ports.rpc)
 lib.callback={await=guard(assert(rpc.Ox.await)),awaitClient=guard(assert(rpc.Ox.await)),
  register=guard(assert(rpc.Owners.native.CaptureRegister))}
 lib.command=guard(assert(f.RegistrationInput.prCommand))
 for _,name in ipairs({'loadJsonRecovery','saveJsonRecovery','saveJsonBatch','withJsonLock','jsonDraft','wrapJsonMutations','recordJsonIncident'})do
  lib[name]=guard(assert(f.Seed.IO.JSON[name],'installed JSON delegate required:'..name))
 end
 lib.database={isReady=v.Database.IsReady};for _,name in ipairs({'query','execute','insert','update','scalar','single','transaction','prepare','rawExecute'})do
  lib.database[name]=guard(assert(v.Database.Database[name].await))
 end;lib.db=lib.database
 for _,name in ipairs({'inventory','banking','vehicle_key'})do lib[name]=assert(ports.services.Public[name])end
 local githubEnv={pr_lib={}};for k,x in pairs(env)do githubEnv[k]=x end
 for _,name in ipairs({'GetCurrentResourceName','GetInvokingResource','GetResourceMetadata','GetResourceState'})do githubEnv[name]=guard(assert(n[name]))end
 githubEnv.PerformHttpRequest=assert(s.Logging.DeliveryPorts.httpRequest)
 lib.versionCheck=guard(assert(loadPR('@pr_bridge/bridge/github/server',githubEnv)).versionCheck)
 lib.checkDependency=s.Dependencies.CheckDependency
 lib.load=guard(function(path)
  assert(path=='@pr_bridge/bridge/compat/framework/helpers','unlisted graph library import')
  return loadPR(path,env)
 end)
 function api.IsCurrent()return live()end
 function api.Close()closed=true;return pending==0 end
 function api.Progress()return{closed=closed,pending=pending,complete=closed and pending==0,operationalReady=false}end
 return api
end
