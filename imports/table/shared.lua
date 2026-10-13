-- Adapt ox's defaults; all algorithms are native PR Bridge utilities.
local native = lib.__native('bridge/utils/tables')
lib.table = table
function table.contains(source, value) return native.contains(source, value, true) end
function table.merge(target, source, addNumbers)
    return native.merge(target, source, {addNumbers=addNumbers ~= false, clone=false})
end
table.matches, table.deepclone = native.matches, native.clone
table.shuffle, table.map, table.isfrozen = native.shuffle, native.map, native.isfrozen
function table.freeze(source) return native.freeze(source, true) end
local originalRawset = rawset
function rawset(source, key, value)
    if native.isfrozen(source) then error('cannot set values on a frozen table', 2) end
    return originalRawset(source, key, value)
end
return lib.table
