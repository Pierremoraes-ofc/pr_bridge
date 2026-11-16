-- Installed PR utilities plus Cfx standard functions. No framework,legacy callback or public bootstrap.
return function(ports)
 local f,loadPR,environment=assert(ports.foundation),assert(ports.loadPR),assert(ports.environment)
 local closed,pending=false,0;local api={OperationalReady=false,Library={}}
 local function live()return not closed and f.IsCurrent()end
 local function guard(fn)return function(...)
  assert(live(),'native graph utilities closed');pending=pending+1
  local out=table.pack(pcall(fn,...));pending=pending-1
  if not out[1]then error(out[2],0)end;return table.unpack(out,2,out.n)
 end end
 local function view(module,standard)
  local out={};for k,v in pairs(module)do out[k]=type(v)=='function'and guard(v)or v end
  return setmetatable(out,{__index=function(_,key)
   assert(live(),'native graph utilities closed')
   local value=standard and standard[key];return type(value)=='function'and guard(value)or value
  end})
 end
 for key,name in pairs({math='numbers',table='tables',string='strings'})do
  api.Library[key]=view(assert(loadPR('@pr_bridge/bridge/utils/'..name,environment)),assert(environment[key]))
 end
 local printView={};for name,fn in pairs(f.Seed.Library.Library.print)do printView[name]=guard(fn)end
 api.Library.print=printView
 api.Library.waitFor=guard(assert(loadPR('@pr_bridge/bridge/utils/waitFor',environment)))
 api.Library.checkDependency=assert(ports.checkDependency)
 local strings=assert(environment.string)
 api.Random=guard(assert(environment.math.random));api.Strsplit=guard(assert(strings.strsplit or environment.strsplit,'Cfx strsplit required'))
 api.Groupdigits=assert(api.Library.math.groupdigits)
 api.Clock={}
 if f.Side=='server'then
  local os=assert(environment.os,'server os library required')
  api.Clock={time=guard(assert(os.time)),date=guard(assert(os.date)),microtime=guard(assert(os.microtime,'Cfx microtime required'))}
 end
 for _,name in ipairs({'type','freeze','clone'})do assert(type(api.Library.table[name])=='function','PR/Cfx table function required:'..name)end
 function api.IsCurrent()return live()end
 function api.Close()closed=true;return pending==0 end
 function api.Progress()return{closed=closed,pending=pending,complete=closed and pending==0,operationalReady=false}end
 return api
end
