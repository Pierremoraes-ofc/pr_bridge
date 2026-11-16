--277: bind reviewed imports inside the external consumer;all integrations use its installed PR.
return function(p)
 local e,pr,public=assert(p.environment),assert(p.prCore),assert(p.public)
 local resource=e.GetCurrentResourceName()
 if resource=='forge-core'or resource=='pr_bridge'or resource=='qbx_core'then return end
 if rawget(e,'ForgeQbxConsumerPorts')then return end
 local side=e.IsDuplicityVersion()and'server'or'client'
 if public.ox_lib and e.lib==public.ox_lib then
  local loader=assert(public.ox_lib.require,'installed PR compatibility loader required')
  assert(e.require==loader and type(rawget(e,'package'))=='table','PR loader/package identity mismatch')
 end
 local core=e.exports.qbx_core
 local library={table={freeze=assert(public.table.freeze)},string={random=assert(public.string.random)},
  waitFor=assert(public.waitFor),print={warn=assert(public.print.warn)}}
 local native=setmetatable({},{__index=e})
 local audio={};local sound=e.exports.pr_3dsound
 for _,name in ipairs(side=='server'and{'PlayNativeSound','PlayNativeSoundFromCoords','PlayNativeSoundFromEntity'}or{
  'PlayLocalNativeSound','PlayLocalNativeSoundFromCoords','PlayLocalNativeSoundFromEntity','PlaySharedNativeSoundFromCoords','PlaySharedNativeSoundFromEntity'})do
  audio[name]=function(...)return sound[name](sound,...)end
 end
 local consumer=assert(pr.forgeConsumerService,'PR integration service required')
 local function ready()
  return pr.forgeConsumerService==consumer and consumer.Progress().complete~=true
 end
 -- Helpers are local definitions. Native operations enforce their own readiness on request.
 local api=pr.load('@pr_bridge/bridge/compat/qbx/import_ports_factory',e)({
  environment=e,side=side,resource=resource,isCurrent=function()return pr.forgeConsumerService==consumer end,isReady=ready,
  library=library,native=native,cache=assert(public.cache),inventory=assert(public.inventory),audio=audio,
  core={GetVehiclesByHash=function(...)return core:GetVehiclesByHash(...)end,
   SetEntityBucket=function(...)return core:SetEntityBucket(...)end,EnablePersistence=function(...)return core:EnablePersistence(...)end,
   GetPlayerData=function(...)return core:GetPlayerData(...)end},
  events={listen=e.AddEventHandler,remove=e.RemoveEventHandler,markNetwork=e.RegisterNetEvent},random=e.math.random,strsplit=e.string.strsplit,
  discordLink=e.GetConvar('qbx:discordlink',''),compile=e.load,
  moduleEnvironment=function(requirePrivate)return setmetatable({require=requirePrivate},{__index=e})end})
 assert(api.Install());pr.forgeConsumerImportPorts=api
 return api
end
