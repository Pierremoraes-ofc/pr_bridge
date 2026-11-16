-- Statebag cookies owned here;keybinds are the existing166 owner,never a second keyboard service.
return function(ports)
 local pr,f,n=assert(ports.prCore),assert(ports.foundation),assert(ports.native)
 assert(f.Side=='client','client input ports required')
 local add,remove=assert(n.AddStateBagChangeHandler),assert(n.RemoveStateBagChangeHandler)
 local closed,pending=false,0;local bags={};local keysOwner
 local api={OperationalReady=false}
 local function live()return not closed and f.IsCurrent()and(not keysOwner or pr.forgeKeybindScope==keysOwner)end
 local function keys()
  assert(live(),'native input ports closed')
  local owner=assert(pr.forgeKeybindScope,'canonical keybind scope not allocated')
  local phase=owner.Progress().phase;assert(phase=='open'or phase=='closing','canonical keybind scope unavailable')
  keysOwner=keysOwner or owner;assert(keysOwner==owner,'canonical keybind owner changed');return assert(owner.Keybind)
 end
 local function call(fn,...)
  pending=pending+1;local out=table.pack(pcall(fn,...));pending=pending-1
  if not out[1]then error(out[2],0)end;return table.unpack(out,2,out.n)
 end
 local keybind={get=function(...)local k=keys();return call(k.get,...)end,remove=function(...)local k=keys();return call(k.remove,...)end}
 setmetatable(keybind,{__call=function(_,...)local k=keys();return call(k,...)end})
 local function retire(record)
  if record.removing then return false end
  if not record.active then return not record.uncertain end
  record.removing=true;local ok,value=pcall(call,remove,record.cookie);record.removing=false
  if ok and value~=false then record.active=false;return true end;return false
 end
 api.Ports={keybind=keybind,availableKey=function(name)return keybind.get(name)==nil end,
  resolveEntity=function(...)
   assert(live(),'native input resolver closed')
   local assembly=assert(f.Base.ClientAssembly,'canonical client assembly not prepared')
   assert(assembly.IsCanonical(),'canonical client assembly changed')
   return call(assert(assembly.Parts.Helpers.Lib.getEntityAndNetIdFromBagName),...)
  end,
  addBag=function(key,filter,callback)
   assert(live(),'native statebag ports closed');local record={};bags[#bags+1]=record
   local ok,cookie=pcall(call,add,key,filter,function(...)if live()then return call(callback,...)end end)
   if not ok or cookie==nil or cookie==false then record.uncertain=true;error(ok and'statebag registration uncertain'or cookie,0)end
   record.cookie,record.active=cookie,true
   if not live()then retire(record);error('statebag owner closed during registration',0)end
   return record
  end,
  removeBag=function(record)
   local found=false;for _,r in ipairs(bags)do if r==record then found=true;break end end
   if not found then return false end;return retire(record)
  end}
 function api.IsCurrent()return live()end
 function api.Close()
  closed=true;local done=pending==0
  for i=#bags,1,-1 do done=retire(bags[i])and done end;return done
 end
 function api.Progress()
  local active,unknown=0,0;for _,r in ipairs(bags)do if r.active then active=active+1 end;if r.uncertain then unknown=unknown+1 end end
  return{closed=closed,pending=pending,statebags=active,uncertain=unknown,borrowedKeys=true,complete=closed and pending==0 and active==0 and unknown==0,operationalReady=false}
 end
 return api
end
