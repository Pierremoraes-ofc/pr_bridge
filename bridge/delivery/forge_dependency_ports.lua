-- Installed PR version contract,including its explicit OX alias;never discover a framework.
return function(ports)
 local n,loadModule,current=assert(ports.native),assert(ports.loadPR),assert(ports.isCurrent)
 local side=assert(ports.side);assert(side=='client'or side=='server','dependency side required')
 local env={};for k,v in pairs(assert(ports.environment))do env[k]=v end
 for _,name in ipairs({'GetResourceMetadata','GetCurrentResourceName','GetInvokingResource','GetResourceState'})do env[name]=assert(n[name],'dependency native required:'..name)end
 env.pr_lib={};env.Bridge=env.pr_lib;env.PRCore={};env._G=env
 local github=assert(loadModule('@pr_bridge/bridge/github/'..side,env))
 local configEnv={};loadModule('@pr_bridge/bridge/config',configEnv)
 local compat=assert(configEnv.Config,'installed PR config required').compatOx_lib==true
 local catalog=assert(loadModule('@pr_bridge/bridge/compat/ox_lib/ox_catalog',env))
 local closed,pending=false,0;local api={OperationalReady=false}
 local function live()local ok,v=pcall(current);return not closed and ok and v==true end
 function api.CheckDependency(resource,minimum,printMessage)
  assert(live(),'native dependency ports closed');pending=pending+1
  local out=table.pack(pcall(function()
   local version
   if resource=='ox_lib'and compat and n.GetResourceState('pr_bridge')=='started'then
    -- Cfx resolves a provided name to PR metadata/state too; started is not proof of an original OX instance.
    if n.GetResourceState('ox_lib')~='started'or n.GetResourceMetadata('ox_lib','name',0)=='pr_bridge'then
     version=assert(catalog.version)
    end
   end
   return github.checkDependency(resource,minimum,printMessage,version)
  end));pending=pending-1
  if not out[1]then error(out[2],0)end;assert(live(),'native dependency ports closed during call');return table.unpack(out,2,out.n)
 end
 function api.IsCurrent()return live()end
 function api.Close()closed=true;return pending==0 end
 function api.Progress()return{closed=closed,pending=pending,complete=closed and pending==0,operationalReady=false}end
 return api
end
