-- Private compatibility for installed tables.clone/freeze on protected readonly children.
-- Preserve PR's interfaces;never patch the installed table module or the Cfx global table.
return function(source)
 local out={};for k,v in pairs(source)do out[k]=v end
 local readonly='pr_bridge:readonly'
 local function clone(value,seen,keepFrozen)
  if type(value)~='table'then return value end
  if keepFrozen and source.isfrozen(value)then return value end
  seen=seen or{};if seen[value]then return seen[value]end
  local copy={};seen[value]=copy
  for k,v in pairs(value)do copy[clone(k,seen,keepFrozen)]=clone(v,seen,keepFrozen)end
  local meta=getmetatable(value)
  if type(meta)=='table'then setmetatable(copy,clone(meta,seen,keepFrozen))end
  return copy
 end
 out.clone=function(value,seen)return clone(value,seen,false)end
 out.deepclone,out.DeepClone=out.clone,out.clone
 out.freeze=function(value,shallow)
  assert(type(value)=='table','freeze expects a table')
  if source.isfrozen(value)then return value end
  local values={}
  if shallow then for k,v in pairs(value)do values[k]=v end
  else for k,v in pairs(value)do values[k]=clone(v,nil,true)end end
  local meta=getmetatable(value)
  for k in pairs(value)do value[k]=nil end
  setmetatable(value,{__index=type(meta)=='table'and setmetatable(values,meta)or values,
   __newindex=function()error('cannot set values on a frozen table',2)end,
   __len=function()return #values end,__pairs=function()return next,values end,__metatable=readonly})
  return value
 end
 out.Freeze=out.freeze
 return setmetatable(out,{__index=source})
end
