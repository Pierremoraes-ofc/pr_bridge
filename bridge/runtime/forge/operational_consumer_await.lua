--279: publish preparation before waiting;bootstrap backends must still finish loading their exports.
return function(p)
 local e,owner=assert(p.environment),assert(p.owner)
 local bootstrap={pr_bridge=true,ox_inventory=true,['Renewed-Banking']=true,pr_carkeys=true,pr_3dsound=true,['forge-loadscreen']=true}
 if bootstrap[e.GetCurrentResourceName()]then return true end
 local started=e.GetGameTimer();local timeout=e.GetConvarInt('forge:activationTimeout',120000)
 assert(timeout>=1000 and timeout<=600000,'bounded consumer activation timeout required')
 while true do
  local ok,s=pcall(function()return e.exports['forge-core']:ForgeRuntimeStatus()end)
  if ok and s and s.generation==owner.Generation and s.ingressOpen==true then return true end
  assert(not ok or not s or s.phase~='failed','Forge activation failed before consumer startup')
  assert(e.GetGameTimer()-started<timeout,'timeout awaiting Forge before consumer startup')
  assert(owner.Progress().complete~=true,'Forge consumer closed before startup')
  e.Wait(25)
 end
end
