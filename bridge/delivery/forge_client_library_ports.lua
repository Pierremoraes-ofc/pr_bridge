-- Explicit client leaves; UI/progress/keybind are borrowed from existing graph owners.
return function(p)
 local f,s,pr=assert(p.foundation),assert(p.support),assert(p.prCore)
 assert(f.Side=='client'and f.IsCurrent(),'client library foundation required')
 local loadPR=assert(p.loadPR);local env={};for k,v in pairs(assert(p.environment))do env[k]=v end
 env.PRDebug=false;env.Config=assert(p.config)
 local closed,pending=false,0;local api={Library={},OperationalReady=false};local lib=api.Library
 local function live()return not closed and f.IsCurrent()and s.IsCurrent()end
 local function guard(fn)return function(...)assert(live(),'client library unavailable');pending=pending+1
  local out=table.pack(pcall(fn,...));pending=pending-1;if not out[1]then error(out[2],0)end;return table.unpack(out,2,out.n)end end
 local function scope(slot,field,name)return guard(function(...)
  local owner=assert(pr[slot],'client owner not prepared:'..slot)
  return assert(owner[field][name],'client owner method unavailable:'..name)(...)
 end)end
 for k,v in pairs(s.Utilities.Library)do lib[k]=v end
 lib.table=loadPR('@pr_bridge/bridge/delivery/forge_graph_table_compat',env)(lib.table)
 lib.utils=assert(loadPR('@pr_bridge/bridge/utils/shared',env))
 lib.debug=assert(loadPR('@pr_bridge/bridge/debug',env))
 lib.cache=f.NativeCache.Cache;lib.settings=f.Public.settings
 lib.callback=assert(p.rpc.Ox);lib.inventory=assert(p.services.Public.inventory)
 lib.command=guard(assert(f.RegistrationInput.prCommand))
 local aliases={registerContext='RegisterContext',showContext='ShowContext',hideContext='HideContext',
  inputDialog='InputDialog',alertDialog='AlertDialog',notify='Notify',showTextUI='ShowTextUI',hideTextUI='HideTextUI'}
 local ui,menus={},{}
 for lower,upper in pairs(aliases)do
  local fn=scope('forgeClientUI','Library',lower);ui[lower]=fn;lib[lower]=fn;lib[upper]=fn;menus[upper]=fn
 end
 api.UI=ui;lib.menus=menus;lib.textuiAdapter={Show=lib.ShowTextUI,Hide=lib.HideTextUI}
 lib.progress={};for _,name in ipairs({'progressBar','progressCircle','progressActive','cancelProgress','doProgressbar','doProgressCircle'})do
  lib.progress[name]=scope('forgeProgressScope','Library',name);lib[name]=lib.progress[name]
 end
 lib.addKeybind=guard(function(...)return assert(pr.forgeKeybindScope,'keybind owner unavailable').Library.addKeybind(...)end)
 local stream=assert(s.Streaming.Streaming);api.Streaming=stream
 lib.requestModel=guard(function(model,timeout)local ok,value=stream.requestModel(model,timeout);assert(ok,'model request failed');return value or model end)
 lib.requestAnimDict=guard(function(dict,timeout)local ok,value=stream.requestAnimDict(dict,timeout);assert(ok,'animation request failed');return value or dict end)
 local objects=assert(loadPR('@pr_bridge/bridge/fivem/objects/client',env))
 local queries=loadPR('@pr_bridge/bridge/delivery/forge_native_queries',env)({native=env,objects=objects})
 for name,fn in pairs(queries)do if type(fn)=='function'then lib[name]=guard(fn)end end
 -- Providers with their own runtime belong to the PR coordinator. No lazy global PR lookup.
 local caps=assert(p.capabilities,'explicit owned client capabilities required')
 for _,name in ipairs({'target','raycast','devtools','devlaser','getNearbyVehicles','setVehicleProperties','playAnim','openVisualAdminMenu'})do
  local value=assert(rawget(caps,name),'client capability required:'..name)
  lib[name]=type(value)=='function'and guard(value)or value
 end
 local fv=assert(rawget(caps,'fivem'));lib.fivem={streaming=stream,objects=objects}
 for _,name in ipairs({'blips','drawtext','gizmo','getVehicleProperties'})do lib.fivem[name]=assert(rawget(fv,name),'client fivem capability required:'..name)end
 lib.fivem.devTools,lib.fivem.devLaser=lib.devtools,lib.devlaser
 function api.IsCurrent()return live()end
 function api.Close()closed=true;return pending==0 end
 function api.Progress()return{closed=closed,pending=pending,complete=closed and pending==0,operationalReady=false}end
 return api
end
