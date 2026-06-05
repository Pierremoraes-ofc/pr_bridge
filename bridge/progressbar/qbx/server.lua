-- bridge.progressbar.qbx.server

if ActiveBridges["progressbar"] ~= "qbx" then return end

Debug('SUCCESS', Lang:t('Debug.ProgressbarDetected', { progressbar = 'Ox Lib progressbar' }))

return {}
