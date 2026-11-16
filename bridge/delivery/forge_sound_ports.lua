-- pr_3dsound endpoints stay behind PR,with the exact Cfx receiver and return values.
return function(ports)
 local f,n=assert(ports.foundation),assert(ports.native);local side=f.Side
 assert(side=='server'or side=='client','native sound side required')
 local external=assert(assert(ports.external).pr_3dsound,'installed pr_3dsound provider required')
 local closed,pending=false,0;local raw={};local api={OperationalReady=false,Raw=raw}
 local function live()return not closed and f.IsCurrent()end
 local function invoke(fn,...)
  assert(live(),'native sound ports closed');pending=pending+1
  local out=table.pack(pcall(fn,...));pending=pending-1;if not out[1]then error(out[2],0)end;return table.unpack(out,2,out.n)
 end
 local names=side=='server'and{'PlayNativeSound','PlayNativeSoundFromEntity','PlayNativeSoundFromCoords'}or{
  'PlayLocalNativeSound','PlayLocalNativeSoundFromEntity','PlayLocalNativeSoundFromCoords','PlaySharedNativeSoundFromEntity','PlaySharedNativeSoundFromCoords'}
 for _,name in ipairs(names)do local method=assert(external[name],'sound export required:'..name)
  raw[name]=function(self,...)assert(self==raw,'native sound receiver required');return invoke(method,external,...)end
 end
 api.Ports={nativeSound=raw,isCurrent=live}
 if side=='server'then
  api.Ports.resourceState=function(...)return invoke(assert(n.GetResourceState),...)end
  api.Ports.sendClient=function(...)return invoke(assert(n.TriggerClientEvent),...)end
 else
  local audio={}
  for _,name in ipairs({'GetResourceState','RequestScriptAudioBank','GetSoundId','PlaySoundFromCoord','PlaySoundFromEntity','PlaySoundFrontend','ReleaseSoundId'})do
   local method=assert(n[name],'client sound native required:'..name);audio[name]=function(...)return invoke(method,...)end
  end
  api.Ports.nativeAudio=audio
 end
 function api.IsCurrent()return live()end
 function api.Close()closed=true;return pending==0 end
 function api.Progress()return{closed=closed,pending=pending,complete=closed and pending==0,operationalReady=false}end
 return api
end
