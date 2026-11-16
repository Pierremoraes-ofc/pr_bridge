-- PR startup returns a preallocated facade; actual Forge attachment is a later explicit phase.
assert(PRCore.context=='client'and ActiveBridges.frameworks=='forge','explicit Forge profile required')
return PRCore.load('@pr_bridge/bridge/frameworks/forge/facade',_ENV)
