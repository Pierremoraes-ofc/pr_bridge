-- Installed individual PR modules;one existing UI/streaming/keybind owner,not fivem/client bootstrap.
return function(p)
 local f,pr=assert(p.foundation),assert(p.prCore);local loadPR=assert(p.loadPR)
 local scope=loadPR('@pr_bridge/bridge/delivery/forge_client_engine_scope',p.environment)({
  foundation=f,prCore=pr,environment=p.environment,createTasks=assert(p.createTasks),running=p.running,onError=p.onError})
 local targetEnv={};for k,v in pairs(p.environment)do targetEnv[k]=v end
 for _,name in ipairs({'DoesPickupExist','GetPickupObject','DoesEntityExist','GetEntityType','GetEntityCoords','GetPickupCoords',
  'NetworkGetEntityIsNetworked','NetworkGetNetworkIdFromEntity','GetEntityModel','GetPickupHash'})do targetEnv[name]=p.environment[name]end
 local target=loadPR('@pr_bridge/bridge/delivery/forge_client_target_owner',p.environment)({
  selected=assert(p.targetSelection),environment=targetEnv,loadPR=loadPR,isCurrent=f.IsCurrent})
 local impl={};local api={Capabilities={fivem={}},Scope=scope,Target=target,OperationalReady=false}
 local caps=api.Capabilities
 local function method(group,name,cleanup)return function(...)
  local object=assert(impl[group],'client tool not open:'..group)
  return scope.Invoke(assert(object[name],'installed tool method missing:'..group..'.'..name),cleanup,...)
 end end
 caps.target=target.Target
 for group,names in pairs({raycast={'FromCamera','FromCoords'},devtools={'placePed','placeVehicle','drawPedBox','stop','isActive'},
  devlaser={'start','stop','toggle','isActive','getTarget','inspectEntity','moveWithGizmo'},
  gizmo={'start','stop','cancel','isActive'},drawtext={'drawText3d','drawText2d','hide'},
  blips={'getPedImageUrl','getPropImageUrl','getVehicleImageUrl','getPropHashId'}})do
  local out={};for _,name in ipairs(names)do out[name]=method(group,name,name=='stop'or name=='cancel'or name=='hide')end
  if group=='gizmo'or group=='drawtext'or group=='blips'then caps.fivem[group]=out else caps[group]=out end
 end
 caps.getNearbyVehicles=method('proximity','getNearbyVehicles')
 caps.setVehicleProperties=method('properties','set');caps.fivem.getVehicleProperties=method('properties','get')
 caps.playAnim=function(...)return scope.Invoke(assert(pr.forgeClientUI).Streaming.playAnim,false,...)end
 caps.openVisualAdminMenu=function(...)return scope.Invoke(assert(pr.forgeClientUI).Library.openVisualAdminMenu,false,...)end
 function api.Open()
  local ui=pr.forgeClientUI;local key=pr.forgeKeybindScope
  if not ui or ui.Progress().phase~='open'or not key or key.Progress().phase~='open'then return false,'UI/keybind owners not open'end
  local ok,why=scope.Open(function(env)
   local bridge={settings=f.Public.settings,cache=f.NativeCache.Cache,debug=assert(p.debug),fivem={},addKeybind=env.PRAddKeybind}
   env.Bridge,env.pr_lib=bridge,bridge
   env.EditorCamera,env.PRBridgeEditorCamera,env.Gizmo,env.PRBridgeGizmo=false,false,false,false
   local function mod(path)return assert(loadPR('@pr_bridge/bridge/fivem/'..path,env),'installed PR module required:'..path)end
   env.PRFivemNet=mod('net/client');env.PRVehicleCache=mod('vehicleCache/shared')
   impl.blips=mod('blips/shared');impl.objects=mod('objects/client');impl.raycast=mod('raycast/client')
   impl.properties=mod('vehicleProperties/client')
   impl.proximity=mod('proximity/shared')(impl.objects,'client',f.NativeCache.Cache)
   env.PRStreaming={};for _,name in ipairs({'requestModel','requestAnimDict','createObject','createPed','createVehicle','deleteEntity','releaseModel','releaseAnimDict','playAnim'})do
    env.PRStreaming[name]=function(...)return assert(ui.Streaming[name],'borrowed streaming method missing:'..name)(...)end
   end
   bridge.fivem.streaming=env.PRStreaming
   env.PRInstructionalButtons=mod('instructionalButtons/client')
   impl.drawtext=mod('drawtext/client');env.PRDrawText=impl.drawtext;bridge.fivem.drawtext=impl.drawtext
   impl.editor=mod('editorCamera/client');env.PREditorCamera=impl.editor;bridge.fivem.editorCamera=impl.editor
   scope.AddCleanup('editor',assert(impl.editor.stop))
   impl.gizmo=mod('gizmo/client');env.PRGizmo=impl.gizmo;bridge.fivem.gizmo=impl.gizmo
   scope.AddCleanup('gizmo',assert(impl.gizmo.stop))
   impl.devlaser=mod('devlaser/client');scope.AddCleanup('devlaser',assert(impl.devlaser.stop))
   impl.devtools=mod('devtools/client');scope.AddCleanup('devtools',assert(impl.devtools.stop))
   scope.AddCleanup('drawtext',assert(impl.drawtext.hide))
   assert(target.Open(),'native target owner refused')
  end)
  if not ok then target.Close();return false,why end;return true
 end
 function api.BeginDrain()target.BeginDrain();return scope.BeginDrain()end
 function api.Close()
  local done=api.BeginDrain();if not target.Close()then done=false end
  if not scope.Close()then done=false end;return done
 end
 function api.IsReady()return scope.IsOpen()and target.Progress().phase=='open'end
 function api.Progress()local s,t=scope.Progress(),target.Progress();return{scope=s,target=t,complete=s.complete and t.complete,operationalReady=false}end
 return api
end
