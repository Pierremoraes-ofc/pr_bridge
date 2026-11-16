-- One public QB compatibility owner. Object/state/services remain in Forge.
return function()
 assert(GetCurrentResourceName()=='pr_bridge','PR QB host context required')
 if GetConvar('qbx:enablebridge','true')=='false'then return end
 local alive=true
 local function call(name,...)
  assert(alive,'PR QB compatibility closed')
  return assert(PRCore.forgeLegacyCompatibility,'PR QB transport unavailable').CallQB(name,...)
 end
 local function get(...)return call('GetCoreObject',...)end
 local function publish(name,fn)
  AddEventHandler('__cfx_export_qb-core_'..name,function(setCallback)if alive then setCallback(fn)end end)
 end
 exports('getQBCoreObject',get)
 publish('GetCoreObject',get)
 publish('GetShared',function(namespace,item)
  local shared=assert(get().Shared);local value=shared[namespace]
  if item~=nil then if type(value)=='table'then return value[item]end;return end
  return value
 end)
 local names=PRCore.load('@pr_bridge/bridge/compat/qb/forge_exports',_ENV)[PRCore.context]
 for _,name in ipairs(names)do if name~='GetCoreObject'then
  publish(name,function(...)
   return call(name,...)
  end)
 end end
 AddEventHandler(IsDuplicityVersion()and'onResourceStop'or'onClientResourceStop',function(name)
  if name=='pr_bridge'or name=='forge-core'then alive=false end
 end)
end
