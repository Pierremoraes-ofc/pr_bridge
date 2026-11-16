--275: own only adapter registrations in the already installed PR callback mode.
-- Protocol is the native registration interface;the selected secure/plain wire is unchanged.
return function(p)
 local env=assert(p.environment);local current=assert(p.isCurrent)
 local registerNet,add,remove=assert(env.RegisterNetEvent),assert(env.AddEventHandler),assert(env.RemoveEventHandler)
 local running=assert(p.running);local records,names={},{};local capture;local closed=false;local api={Protocol='native',Side=p.side}
 local function live()return not closed and current()==true end
 local listen=function(name,fn)
  if capture and capture.thread==running()then
   assert(name==capture.name and type(fn)=='function'and capture.token==nil,'callback listener mismatch')
   capture.token=assert(add(name,fn),'callback listener token required');return capture.token
  end
  return add(name,fn)
 end
 local wrapper=function(name,fn)
  if capture and capture.thread==running()then
   assert(name==capture.name,'callback network name mismatch');registerNet(name)
   if fn then return listen(name,fn)end;return
  end
  return registerNet(name,fn)
 end
 env.RegisterNetEvent=wrapper
 env.AddEventHandler=listen
 function api.IsReady()return live()and type(p.getCallback().register)=='function'end
 function api.Reserve(name)
  assert(api.IsReady()and type(name)=='string'and names[name]==nil,'callback already owned/unavailable')
  local lease={};local r={name=name,thread=running()};records[lease],names[name]=r,r;return lease
 end
 function api.Bind(lease,fn)
  local r=assert(records[lease]);assert(api.IsReady()and not r.attempted and not capture)
  r.attempted=true;r.thread=running();capture=r
  local out=table.pack(pcall(p.getCallback().register,r.name,fn));capture=nil
  if not out[1]then error(out[2],0)end
  assert(r.token,'installed callback mode did not expose its listener');return true
 end
 function api.Release(lease)
  local r=assert(records[lease]);if r.token then local v=remove(r.token);if v==false then return false end;r.token=nil end
  records[lease]=nil;return true
 end
 function api.Close()
  closed=true;local clean=true
  for lease in pairs(records)do if not api.Release(lease)then clean=false end end
  if clean and env.RegisterNetEvent==wrapper then env.RegisterNetEvent=registerNet end
  if clean and env.AddEventHandler==listen then env.AddEventHandler=add end
  return clean
 end
 function api.Progress()local count=0;for _ in pairs(records)do count=count+1 end;return{pending=0,complete=closed and count==0,leases=count}end
 return api
end
