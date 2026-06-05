local framework = {}
if ActiveBridges["frameworks"] ~= "nd" then return end

local NDCore = exports["ND_Core"]

Debug('SUCCESS', Lang:t('Debug.FrameworkDetected', { framework = 'ND Core' }))



return framework