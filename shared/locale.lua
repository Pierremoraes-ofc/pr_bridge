-- Public legacy path. Real QB/QBX still own their own shared/locale.lua.
assert(load(assert(LoadResourceFile('pr_bridge','bridge/compat/qb/locale.lua')),
    '@@pr_bridge/bridge/compat/qb/locale.lua','t',_ENV))()
