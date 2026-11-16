-- Optional installed Forge/OX contract. Does not assume compatibility with stock OX.
return function(e)
 local control=assert(e.PRCore).load('@pr_bridge/bridge/runtime/forge/control_client',e)({external=e.exports})
 local api={}
 function api.Control(operation,generation,instance)
  return control.Call('ox_inventory',operation,generation,instance)
 end
 function api.Describe(generation,instance)return api.Control('Describe',generation,instance)end
 function api.GetOwnedHookSnapshot()return e.exports.ox_inventory:ForgeOwnedHookSnapshot()end
 function api.State()return e.GetResourceState('ox_inventory')end
 -- Existing PR providers perform the operations; Forge receives no new authority.
 function api.Native()return e.exports.ox_inventory end
 return api
end
