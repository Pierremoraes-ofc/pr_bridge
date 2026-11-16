--246: explicit local export in the consumer resource. It is never a network event.
return function(p)
 local control=assert(p.control);local generation,instance=assert(p.generation),assert(p.instance)
 local invoker=assert(p.getInvokingResource);local available,publish=assert(p.available),assert(p.publishExport)
 local phase,pending,busy='allocated',0,false;local api={OperationalReady=false}
 local name='ForgePrActivationControl'
 local function authorized(epoch,id)
  return invoker()=='forge-core'and epoch==generation and id==instance
 end
 function api.Progress()
  local c=control.Progress()
  return{phase=phase,pending=pending+(c.pending or 0),busy=busy,
   complete=phase=='closed'and pending==0 and not busy and c.complete==true,physicalRemoval=false}
 end
 function api.Close()
  phase='closing';if busy then return false end;busy=true
  local ok,value=pcall(control.Close);busy=false
  if ok and value==true and pending==0 and control.Progress().complete then phase='closed'end
  return api.Progress().complete
 end
 local function dispatch(op,epoch,id)
  if not authorized(epoch,id)then return nil end
  -- Logical ingress is revoked on Close. Authenticated cleanup remains observable/retryable.
  if op=='Progress'then return api.Progress()end
  if op=='Close'or op=='Poll'then return api.Close()end
  if phase~='installed'then return nil end
  local fn=op=='Describe'and control.Describe or op=='Prepare'and control.Prepare or op=='Attach'and control.Attach
  if not fn then return nil end
  pending=pending+1;local out=table.pack(pcall(fn));pending=pending-1
  if not out[1]then error(out[2],0)end;return table.unpack(out,2,out.n)
 end
 function api.Install()
  if phase~='allocated'or available(name)~=true then return false end
  if phase~='allocated'then return false end
  phase='installing';pending=pending+1;local ok,why=pcall(publish,name,dispatch);pending=pending-1
  if not ok or why==false or phase~='installing'then api.Close();return false,why end
  phase='installed';return true
 end
 return api
end
