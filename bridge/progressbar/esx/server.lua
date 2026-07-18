local progress = {}

if ActiveBridges["progressbar"] ~= "esx" then return end

Debug('SUCCESS', Lang:t('Debug.ProgressbarDetected', { progressbar = 'ESX Progressbar' }))

return progress