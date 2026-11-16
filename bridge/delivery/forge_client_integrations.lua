-- PR boundary for the installed client integration contracts, including the minimum loading timer.
return function(p)
 local f,n,external=assert(p.foundation),assert(p.native),assert(p.external)
 assert(f.Side=='client','client integrations required')
 local closed,pending=false,0;local api={OperationalReady=false}
 local function live()return not closed and f.IsCurrent()end
 local function guard(fn)return function(...)assert(live(),'client integrations unavailable');pending=pending+1
  local out=table.pack(pcall(fn,...));pending=pending-1;if not out[1]then error(out[2],0)end;return table.unpack(out,2,out.n)end end
 local state=guard(assert(n.GetResourceState))
 local event=guard(assert(n.TriggerEvent));local server=guard(assert(n.TriggerServerEvent))
 local function call(resource,method,...)
  assert(state(resource)=='started','integration resource unavailable:'..resource)
  local proxy=assert(external[resource]);return assert(proxy[method],'integration export required:'..method)(proxy,...)
 end
 local function exported(resource,method)return guard(function(...)return call(resource,method,...)end)end
 api.SetPedAppearance=exported('forge-appearance','setPedAppearance')
 api.Character={
  openFirstCharacterAppearance=guard(function()return event('qb-clothes:client:CreateFirstCharacter')end),
  deferForAppearance=guard(function()return event('space_spawn:client:deferForAppearance')end),
  spawnPlayer=exported('spawnmanager','spawnPlayer'),setAutoSpawn=exported('spawnmanager','setAutoSpawn'),
  setHouseInside=guard(function(...)return server('qb-houses:server:SetInsideMeta',...)end),
  setApartmentInside=guard(function(...)return server('qb-apartments:server:SetInsideMeta',...)end),
  enterProperty=guard(function(...)return server('forge-housing:server:enterProperty',...)end),
  setupApartmentSpawn=guard(function(...)return event('apartments:client:setupSpawnUI',...)end),
  setupSpawns=guard(function(...)return event('qb-spawn:client:setupSpawns',...)end),
  openSpawnUI=guard(function(...)return event('qb-spawn:client:openUI',...)end),
  enableWeatherSync=guard(function()return event('qb-weathersync:client:EnableSync')end),
  finishLoadingScreen=exported('forge-loadscreen','FinishLoadingScreen')}
 api.Consumption={setEvidenceStatus=guard(function(...)return event('evidence:client:SetStatus',...)end)}
 api.Zones={lockpickState=function()return state('glitch-minigames')end,startLockpick=exported('glitch-minigames','StartLockpickGame')}
 api.Work={resourceState=state,emitClientMenu=event,emitServerMenu=server,
  openDocuments=guard(function(resource)return call(resource,'OpenAdminPanel')end),
  openSeatMenu=guard(function(resource,...)return call(resource,'OpenAdminMenu',...)end)}
 api.Panel={resourceState=state,openAdminMenu=guard(function(resource,...)return call(resource,'OpenAdminMenu',...)end)}
 api.Weather={resourceState=state,openWeatherAdmin=guard(function(resource,...)return call(resource,'OpenWeatherAdmin',...)end)}
 api.Access={resourceState=state,isInCharacterCreation=guard(function(resource)return call(resource,'isInCharacterCreation')end)}
 api.Npcs={resourceState=state,event=event,command=guard(assert(n.ExecuteCommand)),
  resolveExports=guard(function(resource)
   assert(state(resource)=='started','NPC resource unavailable')
   return setmetatable({},{__index=function(_,name)return exported(resource,name)end})
  end)}
 local env={};for k,v in pairs(assert(p.environment))do env[k]=v end;env.PRProgression=false
 assert(p.loadPR)('@pr_bridge/shared/progression',env);api.Progression=assert(env.PRProgression)
 function api.IsCurrent()return live()end
 function api.Close()closed=true;return pending==0 end
 function api.Progress()return{closed=closed,pending=pending,complete=closed and pending==0,operationalReady=false}end
 return api
end
