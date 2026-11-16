-- Deliver through the installed PR host;the consumer cache remains passive.
return function(ports)
 local foundation,n,external=assert(ports.foundation),assert(ports.native),assert(ports.external)
 local cache=assert(foundation.Seed.Library.Cache);assert(cache~=foundation.NativeCache.Cache,'native/passive cache must differ')
 local host=assert(external.pr_bridge,'PR cache host required');local access=assert(host.accessCacheState)
 local closed,pending=false,0;local api={OperationalReady=false}
 local function live()return not closed and foundation.IsCurrent()end
 local function guard(fn)return function(...)
  assert(live(),'native cache ports closed');pending=pending+1
  local out=table.pack(pcall(fn,...));pending=pending-1
  if not out[1]then error(out[2],0)end;return table.unpack(out,2,out.n)
 end end
 api.Ports={cache=cache,running=assert(ports.running),isCurrent=live,
  accessCacheState=guard(function(...)return access(host,...)end),emit=guard(assert(n.TriggerEvent)),
  getResourceState=guard(assert(n.GetResourceState))}
 function api.IsCurrent()return live()end
 function api.Close()closed=true;return pending==0 end
 function api.Progress()return{closed=closed,pending=pending,complete=closed and pending==0,collector=false,operationalReady=false}end
 return api
end
