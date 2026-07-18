-- bridge.targets.ox.server

if ActiveBridges["target"] ~= "ox" then return end

Debug('SUCCESS', Lang:t('Debug.TargetDetected', { target = 'Ox Target' }))

return {}
