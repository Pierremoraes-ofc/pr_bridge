-- Public alias entry for @qbx_core/modules/utils.lua when PR provides QBX.
local source=assert(LoadResourceFile('pr_bridge','bridge/compat/qbx/entries/utils.lua'),'PR QBX public entry unavailable')
return assert(load(source,'@@pr_bridge/bridge/compat/qbx/entries/utils.lua','t',_ENV))()
