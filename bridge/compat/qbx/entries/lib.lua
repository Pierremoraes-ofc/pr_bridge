-- PR-owned legacy import; executes in the consumer context.
local source=assert(LoadResourceFile('pr_bridge','bridge/compat/qbx/consumer.lua'),'PR QBX import unavailable')
return assert(load(source,'@@pr_bridge/bridge/compat/qbx/consumer.lua','t',_ENV))()('modules.lib')
