--237: execute inside the consumer's own Lua/resource context. No public export is installed here.
return function(p)
 local resource=assert(p.native.GetCurrentResourceName)()
 local side=p.native.IsDuplicityVersion()and'server'or'client'
 assert(resource~='forge-core'and resource~='qbx_core'and resource~='','external consumer context required')
 local generation,instance=assert(p.generation),assert(p.instance)
 assert(type(instance)=='string'and instance~=''and type(generation)=='string'and generation~='')
 local phase,pending='allocated',0;local proxy,bindings;local api={OperationalReady=false}
 local function current()return phase~='closing'and phase~='closed'and p.isCurrent()==true and p.native.GetCurrentResourceName()==resource end
 local function tracked(fn,...)
  pending=pending+1;local out=table.pack(pcall(fn,...));pending=pending-1
  if not out[1]then error(out[2],0)end;return table.unpack(out,2,out.n)
 end
 function api.Describe()
  return{protocol='forge-pr-consumer/1',generation=generation,resource=resource,side=side,instance=instance,
   current=current(),phase=not current()and'closed'or(bindings and bindings.Progress().phase or phase),
   proxyReady=proxy~=nil and proxy.Progress().phase=='prepared'}
 end
 function api.Prepare()
  if phase~='allocated'or not current()then return false end;phase='preparing'
  local ok,why=pcall(tracked,function()
   proxy=assert(p.createProxy)();assert(current()and phase=='preparing')
   bindings=assert(p.createBindings)(assert(proxy.API));assert(current()and phase=='preparing')
   assert(bindings.Prepare());assert(current()and phase=='preparing')
  end)
  if not ok then api.Close();return false,why end;phase='prepared';return true
 end
 function api.Attach()
  if phase~='prepared'or not current()then return false end;phase='attaching'
  local ok,why=pcall(tracked,function()
   assert(proxy.Prepare());assert(current()and phase=='attaching')
   assert(p.claim(generation,instance,'attaching'));assert(current()and phase=='attaching')
   assert(bindings.Attach());assert(current()and phase=='attaching')
   assert(p.claim(generation,instance,'committed'));assert(current()and phase=='attaching')
  end)
  if not ok then api.Close();return false,why end;phase='attached';return true
 end
 function api.Close()
  phase='closing';local clean=true
  for _,c in ipairs({bindings or false,proxy or false})do if c then local ok,v=pcall(c.Close);if not ok or v~=true then clean=false end end end
  if clean and pending==0 then phase='closed'end;return api.Progress().complete
 end
 function api.Progress()
  local total,clean=pending,true
  for _,c in ipairs({bindings or false,proxy or false})do if c then local s=c.Progress();total=total+(s.pending or 0);clean=clean and s.complete==true end end
  return{phase=phase,pending=total,complete=phase=='closed'and total==0 and clean,operationalReady=false}
 end
 return api
end
