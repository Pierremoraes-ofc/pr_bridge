-- Library connection primitive. No lookup occurs until the requested operation.
return function(p)
 local external=assert(p.external)
 return {Call=function(resource,operation,generation,instance)
  local target=assert(external[resource]);local invoke=target.ForgePrActivationControl
  assert(type(invoke)=='function','consumer control export required')
  return invoke(target,operation,generation,instance)
 end}
end
