-- Public alias entry for @qbx_core/modules/lib.lua when PR provides QBX.
local source=assert(LoadResourceFile('pr_bridge','bridge/compat/qbx/entries/lib.lua'),'PR QBX public entry unavailable')
return assert(load(source,'@@pr_bridge/bridge/compat/qbx/entries/lib.lua','t',_ENV))()
