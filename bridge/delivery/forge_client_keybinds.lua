-- Own the installed PR keybind module;99 publishes one native command per owned name.
return function(ports)
 local pr=assert(ports.prCore);assert(pr.resource=='forge-core'and pr.context=='client','Forge client required')
 assert(pr.forgeKeybindScope==nil,'keybind scope already owned')
 local owner,public=assert(ports.isCurrent),assert(ports.public)
 local phase,pending,uncertain='allocated',0,false;local engine;local cells,bindings,errors={},{},{}
 local api={OperationalReady=false};pr.forgeKeybindScope=api
 local function current()local ok,v=pcall(owner);return phase~='closed'and pr.forgeKeybindScope==api and ok and v==true end
 local function invoke(fn,...)assert(phase=='open'and current(),'keybind scope unavailable');pending=pending+1
 local out=table.pack(pcall(fn,...));pending=pending-1;if not out[1]then error(out[2],0)end;return table.unpack(out,2,out.n)end
 local function fail(err)uncertain=true;errors[#errors+1]=tostring(err);error(err,0)end
 local env={};for k,v in pairs(assert(ports.environment))do env[k]=v end
 local tasks=assert(ports.createTasks)({isCurrent=current,running=assert(ports.running),onError=assert(ports.onError)})
 local scheduler=tasks.WrapNative({Wait=assert(env.Wait),SetTimeout=assert(env.SetTimeout)});env.Wait,env.SetTimeout=scheduler.Wait,scheduler.SetTimeout
 env.RegisterCommand=function(name,fn,restricted)
  assert(phase=='open'and current(),'owned keybind command unavailable')
  local key=name:lower();if cells[key]then cells[key].fn=fn;return end
  local cell={fn=fn};cells[key]=cell
  local ok,value=pcall(public.nativeCommand,name,function(...)if phase=='open'and current()then return invoke(cell.fn,...)end end,restricted)
  if not ok or value==false then fail(ok and'keybind command namespace refused:'..name or value)end
 end
 local mapping=assert(env.RegisterKeyMapping)
 env.RegisterKeyMapping=function(...)assert(phase=='open'and current(),'keybind mapping unavailable')
 local out=table.pack(pcall(mapping,...));if not out[1]then fail(out[2])end;return table.unpack(out,2,out.n)end
 local callable={get=function(name)return invoke(assert(engine).get,name)end,remove=function(name)return invoke(assert(engine).remove,name)end}
 setmetatable(callable,{__call=function(_,data)local out=table.pack(invoke(assert(engine),data))
 if type(out[1])=='table'then bindings[out[1]]=true end;return table.unpack(out,1,out.n)end})
 api.Keybind=callable;api.Library={addKeybind=callable,keybind=callable,keybinds=callable}
 function api.Open()
  if phase~='allocated'or not current()then return false end;phase='opening'
  if not tasks.Open()then phase='closing';return false end
  local ok,err=pcall(function()
   engine=assert(ports.load)('@pr_bridge/bridge/addKeybind/client',env)
   assert(type(engine)=='table'and getmetatable(engine).__call and type(engine.get)=='function'and type(engine.remove)=='function','installed keybind required')
   callable.list=assert(engine.list)
  end)
  if not ok then errors[#errors+1]=tostring(err);api.Close();return false,err end;phase='open';return true
 end
 function api.CloseIngress()
  if phase=='closed'then return not uncertain end;phase='closing';tasks.Close()
  if engine then for _,bind in pairs(engine.list)do bindings[bind]=true end end
  for bind in pairs(bindings)do local ok,err=pcall(bind.disable,bind,true);if not ok then uncertain=true;errors[#errors+1]=tostring(err)end end
  return not uncertain
 end
 function api.Close()
  local done=api.CloseIngress();if not done or pending~=0 or not tasks.Snapshot().quiescent then return false end
  for bind in pairs(bindings)do local ok,err=pcall(bind.destroy,bind);if not ok then uncertain=true;errors[#errors+1]=tostring(err);return false end end
  phase='closed';if pr.forgeKeybindScope==api then pr.forgeKeybindScope=nil end;return true
 end
 function api.IsCurrent()return current()end
 function api.Progress()
  local n,b=0,0;for _ in pairs(cells)do n=n+1 end;for _ in pairs(bindings)do b=b+1 end
  return{phase=phase,pending=pending,bindings=b,commands=n,tasks=tasks.Snapshot(),uncertain=uncertain,errors=errors,
  complete=phase=='closed'and pending==0 and not uncertain,physicalCommandRemoval=false,physicalMappingRemoval=false,retainedObjectsRevoked=false,operationalReady=false}
 end
 return api
end
