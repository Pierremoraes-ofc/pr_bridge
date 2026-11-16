-- Borrow133 streaming after it opens. No second streaming module,task owner or NUI host.
return function(ports)
 local pr,f=assert(ports.prCore),assert(ports.foundation);assert(f.Side=='client','client streaming ports required')
 local closed,pending=false,0;local bound
 local api={OperationalReady=false,Streaming={}}
 local function live()return not closed and f.IsCurrent()and(not bound or pr.forgeClientUI==bound)end
 for _,name in ipairs({'requestModel','requestAnimDict','createObject','createPed','createVehicle','deleteEntity','releaseModel','releaseAnimDict'})do
  api.Streaming[name]=function(...)
   assert(live(),'native streaming ports closed')
   local ui=assert(pr.forgeClientUI,'canonical UI streaming not allocated')
   assert(ui.Progress().phase=='open','canonical UI streaming not open')
   bound=bound or ui;assert(bound==ui,'canonical streaming owner changed')
   local fn=assert(ui.Streaming[name],'canonical streaming method missing:'..name)
   pending=pending+1;local out=table.pack(pcall(fn,...));pending=pending-1
   if not out[1]then error(out[2],0)end
   assert(live()and pr.forgeClientUI==ui,'native streaming return expired')
   return table.unpack(out,2,out.n)
  end
 end
 function api.IsCurrent()return live()end
 function api.Close()closed=true;return pending==0 end
 function api.Progress()return{closed=closed,pending=pending,complete=closed and pending==0,borrowedUI=true,retainedAssetsRevoked=false,operationalReady=false}end
 return api
end
