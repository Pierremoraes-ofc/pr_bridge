-- Public @es_extended/imports.lua entrypoint; implementation stays in compat/esx.
local chunk = assert(LoadResourceFile('pr_bridge', 'bridge/compat/esx/consumer.lua'), 'PR Bridge ESX bootstrap missing')
return assert(load(chunk, '@@pr_bridge/bridge/compat/esx/consumer.lua', 't', _ENV))()
