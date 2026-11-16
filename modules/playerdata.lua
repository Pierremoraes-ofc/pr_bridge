-- Public alias entry for @qbx_core/modules/playerdata.lua when PR provides QBX.
local source=assert(LoadResourceFile('pr_bridge','bridge/compat/qbx/entries/playerdata.lua'),'PR QBX public entry unavailable')
return assert(load(source,'@@pr_bridge/bridge/compat/qbx/entries/playerdata.lua','t',_ENV))()
