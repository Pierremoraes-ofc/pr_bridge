--[[
    https://github.com/overextended/ox_lib

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright © 2025 Linden <https://github.com/thelindat>
]]

-- PR Bridge integration: shared protocol implementation with request cleanup.
return assert(load(LoadResourceFile("pr_bridge", "bridge/compat/ox_callback.lua"),
    "@@pr_bridge/bridge/compat/ox_callback.lua", "t", _ENV))()
