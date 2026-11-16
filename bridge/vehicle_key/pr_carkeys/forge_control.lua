-- Optional readiness connection, evaluated only when requested.
return function(e)
 return {Readiness=function()return e.exports['pr_carkeys']:ForgeKeysReadiness()end}
end
