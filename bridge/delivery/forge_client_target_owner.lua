-- Borrow installed native target service;track only this owner's registrations.
return function(p)
 assert(p.selected=='native','explicit native target selection required')
 local env={};for k,v in pairs(assert(p.environment))do env[k]=v end
 env.ActiveBridges={target=p.selected}
 local raw=assert(p.loadPR)('@pr_bridge/bridge/targets/native/client',env)
 local phase,pending,uncertain='prepared',0,false;local zones,entities={},{}
 local owner=assert(p.isCurrent);local api={Target={},OperationalReady=false}
 local function live()return phase=='open'and owner()==true end
 local function invoke(fn,cleanup,...)
  assert((live()or cleanup and phase=='closing')and owner()==true,'target owner unavailable')
  pending=pending+1;local r=table.pack(pcall(fn,...));pending=pending-1
  if not r[1]then error(r[2],0)end;return table.unpack(r,2,r.n)
 end
 local function callbacks(value,seen)
  if type(value)=='function'then return function(...)if live()then return invoke(value,false,...)end end end
  if type(value)~='table'then return value end
  seen=seen or{};if seen[value]then return seen[value]end
  local out={};seen[value]=out;for k,v in pairs(value)do out[k]=callbacks(v,seen)end;return out
 end
 local t=api.Target
 function t.addBoxZone(data)
  local id=invoke(raw.addBoxZone,false,callbacks(data))
  if id==nil or id==false then uncertain=true else zones[id]=true end
  return id
 end
 function t.removeZone(id,...)
  local r=table.pack(invoke(raw.removeZone,true,id,...));zones[id]=nil;return table.unpack(r,1,r.n)
 end
 local function list(v)return type(v)=='table'and v or{v}end
 function t.addLocalEntity(handles,options)
  local r=table.pack(invoke(raw.addLocalEntity,false,handles,callbacks(options)))
  local names={};for _,o in ipairs(options.name and{options}or options)do names[#names+1]=o.name or o.label end
  if #names==0 then uncertain=true end
  for _,handle in ipairs(list(handles))do entities[handle]=entities[handle]or{}
   for _,name in ipairs(names)do entities[handle][name]=true end
  end
  return table.unpack(r,1,r.n)
 end
 function t.removeLocalEntity(handles,names)
  local r=table.pack(invoke(raw.removeLocalEntity,true,handles,names))
  for _,handle in ipairs(list(handles))do
   if names==nil then entities[handle]=nil else for _,name in ipairs(list(names))do if entities[handle]then entities[handle][name]=nil end end end
  end
  return table.unpack(r,1,r.n)
 end
 function t.disableTargeting(value)return invoke(raw.disableTargeting,value==false,value)end
 function api.Open()if phase~='prepared'or not owner()then return false end;phase='open';return true end
 function api.BeginDrain()if phase~='closed'then phase='closing'end;return true end
 function api.Close()
  api.BeginDrain()
  for id in pairs(zones)do local ok,result=pcall(raw.removeZone,id,true);if ok and result~=false then zones[id]=nil else return false end end
  for handle,names in pairs(entities)do local keys={};for name in pairs(names)do keys[#keys+1]=name end
   if #keys>0 then local ok,result=pcall(raw.removeLocalEntity,handle,keys);if not ok or result==false then return false end end;entities[handle]=nil
  end
  if pending~=0 or uncertain then return false end;phase='closed';return true
 end
 function api.Progress()local z,e=0,0;for _ in pairs(zones)do z=z+1 end;for _ in pairs(entities)do e=e+1 end
  return{phase=phase,pending=pending,zones=z,entities=e,uncertain=uncertain,complete=phase=='closed',operationalReady=false}end
 return api
end
