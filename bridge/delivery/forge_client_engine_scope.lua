-- Private module environment using the existing99/166 and cooperative tasks57.
return function(p)
 local f,pr=assert(p.foundation),assert(p.prCore)
 local phase,pending,uncertain='prepared',0,false;local tokens,bindings,cleanups={},{},{}
 local api={OperationalReady=false}
 local function current()return phase~='closed'and f.IsCurrent()end
 local function active()return current()and(phase=='open'or phase=='opening')end
 local tasks=assert(p.createTasks)({isCurrent=active,running=assert(p.running),onError=assert(p.onError)})
 local env={};for k,v in pairs(assert(p.environment))do env[k]=v end;setmetatable(env,{__index=p.environment})
 env._G=env -- editor modules must not write the shared Cfx globals.
 local schedule=tasks.WrapNative({CreateThread=assert(env.CreateThread),SetTimeout=assert(env.SetTimeout),Wait=assert(env.Wait)})
 env.CreateThread,env.SetTimeout,env.Wait=schedule.CreateThread,schedule.SetTimeout,schedule.Wait
 local citizen={};for k,v in pairs(env.Citizen or{})do citizen[k]=v end
 citizen.CreateThread,citizen.Wait,citizen.SetTimeout=env.CreateThread,env.Wait,env.SetTimeout;env.Citizen=citizen
 local function finish(ok,...)
  pending=pending-1;if not ok then error((...),0)end;return ...
 end
 function api.Invoke(fn,cleanup,...)
  assert(current()and(active()or cleanup and phase=='closing'),'client engine scope unavailable');pending=pending+1
  return finish(pcall(fn,...))
 end
 local events=assert(f.Events)
 local function add(name,fn,network)
  assert(active(),'client engine registration outside Open')
  if network then assert(events.markNetwork(name)~=false,'network mark refused')end
  local token=events.listen(name,function(...)if phase=='open'and current()then return api.Invoke(fn,false,...)end end)
  if token==nil or token==false then uncertain=true;error('client engine listener handle missing',0)end
  tokens[#tokens+1]=token;return token
 end
 env.AddEventHandler=function(name,fn)return add(name,fn,false)end
 env.RegisterNetEvent=function(name,fn)assert(type(fn)=='function','owned network handler required');return add(name,fn,true)end
 env.RemoveEventHandler=function(token)return events.remove(token)end
 env.RegisterCommand=function()error('tool command must use owned keybind166',0)end
 -- The private tools execute in Forge, but the existing PR host owns the NUI frame.
 -- Sending here must not claim menu ownership or change keyboard/mouse focus.
 env.SendNUIMessage=function(message)
  assert(current()and(active()or phase=='closing'),'client tool UI unavailable')
  assert(type(message)=='table'and type(message.action)=='string','client tool UI message required')
  return p.environment.TriggerEvent('pr_bridge:ui:send',message.action,message.data)
 end
 env.PRAddKeybind=function(data)
  assert(active(),'tool keybind outside Open')
  local key=assert(pr.forgeKeybindScope,'owned keybind166 unavailable')
  assert(type(data)=='table'and type(data.name)=='string'and data.name~='','tool keybind name required')
  -- These tools run in a private Forge instance alongside the public PR tools.
  -- Keep their command/mapping names distinct without changing the public PR API or caller data.
  local owned={};for name,value in pairs(data)do owned[name]=value end
  owned.name='forge-core_'..data.name
  local bind=key.Library.addKeybind(owned);assert(type(bind)=='table','owned tool binding required')
  bindings[bind]=true;return bind
 end
 api.Environment=env
 function api.AddCleanup(name,fn)assert(active()and type(fn)=='function','tool cleanup required');cleanups[#cleanups+1]={name=name,fn=fn}end
 function api.Open(build)
  if phase~='prepared'or not f.IsCurrent()then return false end;phase='opening';assert(tasks.Open())
  local ok,reason=pcall(build,env)
  if not ok then api.BeginDrain();return false,reason end;phase='open';return true
 end
 function api.BeginDrain()
  if phase=='closed'then return true end;phase='closing';local done=true
  for i=#cleanups,1,-1 do local c=cleanups[i];if not c.done then
   local ok,err=pcall(c.fn);if ok then c.done=true else api.LastError=tostring(err);done=false end
  end end
  for bind in pairs(bindings)do local ok,err=pcall(bind.disable,bind,true);if not ok then api.LastError=tostring(err);done=false end end
  tasks.Close()
  for i=#tokens,1,-1 do if tokens[i]then local ok,value=pcall(events.remove,tokens[i]);if ok and value~=false then tokens[i]=false else done=false end end end
  return done and not uncertain
 end
 function api.Close()
  if phase=='closed'then return true end
  if not api.BeginDrain()or pending~=0 or not tasks.Snapshot().quiescent then return false end
  for bind in pairs(bindings)do local ok,err=pcall(bind.destroy,bind);if not ok then api.LastError=tostring(err);return false end;bindings[bind]=nil end
  phase='closed';return true
 end
 function api.IsCurrent()return current()end
 function api.IsOpen()return phase=='open'and current()end
 function api.Progress()local remaining=0;for _,v in pairs(tokens)do if v then remaining=remaining+1 end end
  return{phase=phase,pending=pending,listeners=remaining,uncertain=uncertain,tasks=tasks.Snapshot(),lastError=api.LastError,complete=phase=='closed',operationalReady=false}end
 return api
end
