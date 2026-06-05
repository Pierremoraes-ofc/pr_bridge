-- bridge.weather.renewed.server

if ActiveBridges["weather"] ~= "renewed" then return end
Debug('SUCCESS', Lang:t('Debug.WeatherDetected', { weather = 'Renewed Weather' }))

return {}
