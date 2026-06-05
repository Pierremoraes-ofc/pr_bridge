-- bridge.fuel.cdn.server
if ActiveBridges["fuel"] ~= "legacyfuel" then return end
Debug('SUCCESS', Lang:t('Debug.FuelDetected', { fuel = 'Legacy Fuel' }))



return {}
