--276: defer framework calls until their single authority is ready;identity is safe before attachment.
return function(p)
 local facade=assert(p.facade);local current=assert(p.isCurrent);local attached=assert(p.isAttached)
 local status,clock,wait=assert(p.readStatus),assert(p.clock),assert(p.wait)
 local generation,timeout=assert(p.generation),assert(p.timeout)
 local catalog={GetFrameworkJobs=true,GetFrameworkGangs=true,GetVehiclesByHash=true,GetVehicleData=true,GetCoreObject=true}
 local wrapped={}
 local catalogFunction={}
 for name,fn in pairs(facade)do if catalog[name]and type(fn)=='function'then catalogFunction[fn]=true end end
 for name,fn in pairs(facade)do if type(fn)=='function'then
  if name=='GetResourceName'then facade[name]=function()assert(current(),'consumer closed');return'forge-core'end
  else
   local key=fn
   if not wrapped[key]then
    local canReadCatalog=catalogFunction[fn]==true
    wrapped[key]=function(...)
     local started=clock()
     while true do
      assert(current(),'consumer closed before Forge activation')
      local s=status()
      if s and s.generation==generation and attached()and(s.ingressOpen==true or canReadCatalog and(s.stage or 0)>=4)then break end
      assert(not s or s.phase~='failed','Forge activation failed')
      assert(clock()-started<timeout,'timeout waiting for Forge activation')
      wait(25)
     end
     return fn(...)
    end
   end
   facade[name]=wrapped[key]
  end
 end end
 return facade
end
