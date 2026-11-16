-- External integrations stay in PR. Identity for ACE is supplied by the local Forge lookup.
return function(ports)
 local f,n,external=assert(ports.foundation),assert(ports.native),assert(ports.external)
 assert(f.Side=='server','server integrations required')
 local loadPR=assert(ports.loadPR);local closed,pending=false,0;local tokens={};local callbacks={};local rpcOwner
 local api={OperationalReady=false,Callbacks=callbacks}
 local function live()return not closed and f.IsCurrent()end
 local function guard(fn)return function(...)assert(live(),'server integrations unavailable');pending=pending+1
  local r=table.pack(pcall(fn,...));pending=pending-1;if not r[1]then error(r[2],0)end;return table.unpack(r,2,r.n)end end
 local function methods(raw)local view={};for k,v in pairs(raw)do view[k]=type(v)=='function'and guard(v)or v end;return view end
 local env={};for k,v in pairs(assert(ports.environment))do env[k]=v end
 env.exports=external;env.ActiveBridges={};env.GetResourceState=guard(assert(n.GetResourceState))
 for _,name in ipairs({'GetConvar','GetPlayerIdentifiers','IsPlayerAceAllowed','IsPrincipalAceAllowed','ExecuteCommand','GetCurrentResourceName','LoadResourceFile'})do env[name]=guard(assert(n[name]))end
 local identity=assert(ports.identity)
 env.Bridge={framework={GetIdentifier=guard(assert(identity.GetIdentifier)),GetPlayer=guard(assert(identity.GetPlayer))}}
 env.pr_lib=env.Bridge;env.PRCore={load=function(path,target)return loadPR(path,target or env)end,
  callback={register=function(name,fn)callbacks[#callbacks+1]={name=name,handler=fn}end}}
 env.AddEventHandler=guard(function(name,fn)local token=f.Events.listen(name,guard(fn))
  assert(token~=nil and token~=false,'integration event registration uncertain');tokens[#tokens+1]=token;return token end)
 env.Debug=assert(ports.debug,'installed PR debug delegate required');env.Lang=assert(ports.lang,'PR domain locale required')
 local ace=assert(loadPR('@pr_bridge/bridge/ace/server',env));api.Ace={}
 for _,name in ipairs({'isPlayerAceAllowed','getPermissionCatalog','addAce','removeAce','addPrincipal','removePrincipal',
  'isAdminWhitelisted','isWhitelisted','hasFrameworkAccess','ensureAce','isPrincipalAceAllowed'})do api.Ace[name]=guard(assert(ace[name]))end
 api.Prison=methods(assert(loadPR('@pr_bridge/bridge/prison/server',env)))
 local progressionEnv={};for k,v in pairs(env)do progressionEnv[k]=v end;progressionEnv.PRProgression=nil
 loadPR('@pr_bridge/shared/progression',progressionEnv);api.Progression=assert(progressionEnv.PRProgression)
 api.Skill={invoke=guard(function(resource,name,...)
  local proxy=assert(external[resource],'configured progression provider unavailable');return assert(proxy[name])(proxy,...)
 end)}
 api.Documents={documentState=guard(function()return n.GetResourceState('forge-dk')end),
  getDocumentItems=guard(function()local p=assert(external['forge-dk']);return assert(p.GetDocumentItems)(p)end),
  readDocumentConfig=guard(function(path)return n.LoadResourceFile('forge-dk',path)end),json=f.Seed.IO.Codec}
 api.Management={resourceState=guard(function()return n.GetResourceState('forge-management')end)}
 for key,name in pairs({registerPlugin='RegisterPlugin',unregisterPlugin='UnregisterPlugin'})do api.Management[key]=guard(function(...)
  local p=assert(external['forge-management']);return assert(p[name])(p,...)
 end)end
 api.Webhook={request=guard(assert(ports.httpRequest))}
 api.Consumption={useLockpick=guard(function(src,advanced)
  n.TriggerClientEvent('lockpicks:UseLockpick',src,advanced);return n.TriggerEvent('lockpicks:UseLockpick',src,advanced)
 end)}
 api.Purchases={onPurchaseResult=guard(function(name,callback)
  local token=f.Events.listen(name,function(...)if live()then return guard(callback)(...)end end)
  assert(token~=nil and token~=false,'purchase event registration uncertain');tokens[#tokens+1]=token;return token
 end),removePurchaseResult=function(token)
  for i,t in ipairs(tokens)do if t==token then local v=f.Events.remove(t);if v~=false then tokens[i]=false end;return v end end;return false
 end}
 -- Use the same installed non-framework selection order for phone/weather.
 local config={};loadPR('@pr_bridge/bridge/config',config)
 local function selected(category)
  local folder='default'
  for _,row in ipairs(assert(config.ConfigBridge)[category]or{})do
   local state=n.GetResourceState(row.resource);if state=='started'or state=='starting'then folder=row.folder;break end
  end
  env.ActiveBridges[category]=folder
  return loadPR('@pr_bridge/bridge/'..category..'/'..folder..'/server',env)
 end
 api.Phone=methods(assert(selected('phones')));api.Weather=methods(assert(selected('weather')))
 api.CatalogFile={read=guard(assert(f.Seed.IO.Files.LoadResourceFile)),write=guard(assert(f.Seed.IO.Files.SaveResourceFile))}
 function api.Open(owner,wrap)
  assert(live()and rpcOwner==nil,'integration callbacks already owned or closed');rpcOwner=assert(owner)
  for _,record in ipairs(callbacks)do
   record.lease=rpcOwner.Reserve(record.name)
   assert(rpcOwner.Bind(record.lease,assert(wrap)(guard(record.handler))),'integration callback bind refused')
  end;return true
 end
 function api.IsCurrent()return live()end
 function api.Close()
  closed=true;local done=pending==0
  for i=#callbacks,1,-1 do local r=callbacks[i];if r.lease then local ok,v=pcall(rpcOwner.Release,r.lease)
   if ok and v==true then r.lease=nil else done=false end
  end end
  for i=#tokens,1,-1 do if tokens[i]then local ok,v=pcall(f.Events.remove,tokens[i]);if ok and v~=false then tokens[i]=false else done=false end end end
  return done
 end
 function api.Progress()local count=0;for _,t in ipairs(tokens)do if t then count=count+1 end end
  local leases=0;for _,r in ipairs(callbacks)do if r.lease then leases=leases+1 end end
  return{closed=closed,pending=pending,listeners=count,leases=leases,complete=closed and pending==0 and count==0 and leases==0,operationalReady=false}
 end
 return api
end
