-- Optional readiness connection, evaluated only when requested.
return function(e)
 return {Readiness=function()return e.exports['Renewed-Banking']:ForgeBankingReadiness()end}
end
