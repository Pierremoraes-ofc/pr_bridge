-- The manifest starts only this dispatcher, never an optional adapter directly.
if Config.compatOx_lib == true then PRCore.load('bridge.compat.ox_lib.ox_host') end
if Config.compatFramework and Config.compatFramework ~= 'off' then
    PRCore.load('bridge.compat.esx.host')
    if Config.compatQBCore ~= false then PRCore.load('bridge.compat.qb.host') end
    if ActiveBridges and ActiveBridges.frameworks=='forge'then PRCore.load('bridge.compat.qbx.host')end
end
