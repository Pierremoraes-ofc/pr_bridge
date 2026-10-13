-- Canonical PR library module. Shared by native users and legacy adapters.
-- Algorithms promoted only where no equivalent PR implementation existed.
return function(api)
local cache = api.cache
--[[
    https://github.com/overextended/ox_lib

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright © 2025 Linden <https://github.com/thelindat>
]]

---@diagnostic disable: invisible

---@class MapPrivate
---@field keys any[]
---@field values any[]
---@field index table<any, integer>
---@field count integer
---@field deleted integer

---@class Map : OxClass
---@field private new MapConstructor
---@field private private MapPrivate
api.map = api.class('Map')

local TOMBSTONE = {}
local MIN_REBUILD = 8

---@param self Map
local function rebuild(self)
    local newKeys = {}
    local newValues = {}
    local newIndex = {}
    local n = 0
    local keys = self.private.keys
    local values = self.private.values

    for i = 1, #keys do
        local k = keys[i]
        if k ~= TOMBSTONE then
            n = n + 1
            newKeys[n] = k
            newValues[n] = values[i]
            newIndex[k] = n
        end
    end

    self.private.keys = newKeys
    self.private.values = newValues
    self.private.index = newIndex
    self.private.deleted = 0
end

---@class MapConstructor
---@overload fun(self: Map, initial?: table): Map
---@private
---@param initial? table Optional table of initial entries. Iteration order from a Lua table literal is not guaranteed.
function api.map:constructor(initial)
    self.private.keys = {}
    self.private.values = {}
    self.private.index = {}
    self.private.count = 0
    self.private.deleted = 0

    if initial ~= nil then
        if type(initial) ~= 'table' then
            error("initial must be a table or nil", 2)
        end
        for k, v in pairs(initial) do
            self:set(k, v)
        end
    end
end

---@param key any
---@param value any Must be non-nil. Use `:delete(key)` to remove entries.
---@return Map self
function api.map:set(key, value)
    if key == nil then
        error("map key cannot be nil", 2)
    end

    if value == nil then
        error("map value cannot be nil; use :delete(key) to remove entries", 2)
    end

    local pos = self.private.index[key]

    if pos then
        self.private.values[pos] = value
    else
        local keys = self.private.keys
        local newPos = #keys + 1
        keys[newPos] = key
        self.private.values[newPos] = value
        self.private.index[key] = newPos
        self.private.count = self.private.count + 1
    end

    return self
end

---@param key any
---@return any?
function api.map:get(key)
    local pos = self.private.index[key]
    if not pos then return nil end
    return self.private.values[pos]
end

---@param key any
---@return boolean
function api.map:has(key)
    return self.private.index[key] ~= nil
end

---@param key any
---@return boolean removed
function api.map:delete(key)
    local pos = self.private.index[key]
    if not pos then return false end

    self.private.keys[pos] = TOMBSTONE
    self.private.values[pos] = TOMBSTONE
    self.private.index[key] = nil
    self.private.count = self.private.count - 1
    self.private.deleted = self.private.deleted + 1

    if self.private.deleted >= self.private.count and self.private.deleted >= MIN_REBUILD then
        rebuild(self)
    end

    return true
end

---@return integer
function api.map:size()
    return self.private.count
end

---@return boolean
function api.map:isEmpty()
    return self.private.count == 0
end

---@return Map self
function api.map:clear()
    table.wipe(self.private.keys)
    table.wipe(self.private.values)
    table.wipe(self.private.index)
    self.private.count = 0
    self.private.deleted = 0
    return self
end

---@return fun(): any?, any?
function api.map:entries()
    local keys = self.private.keys
    local values = self.private.values
    local n = #keys
    local i = 0

    return function()
        i = i + 1
        while i <= n do
            local k = keys[i]
            if k ~= TOMBSTONE then return k, values[i] end
            i = i + 1
        end
    end
end

---@return fun(): any?
function api.map:keys()
    local keys = self.private.keys
    local n = #keys
    local i = 0

    return function()
        i = i + 1
        while i <= n do
            local k = keys[i]
            if k ~= TOMBSTONE then return k end
            i = i + 1
        end
    end
end

---@return fun(): any?
function api.map:values()
    local keys = self.private.keys
    local values = self.private.values
    local n = #keys
    local i = 0

    return function()
        i = i + 1
        while i <= n do
            if keys[i] ~= TOMBSTONE then return values[i] end
            i = i + 1
        end
    end
end

api.map.each = api.map.entries

function api.map:__pack()
    return msgpack.pack(self:toTable()), true
end

function api.map:__tojson()
    return json.encode(setmetatable(self:toTable(), {
        __jsonorder = self.private.keys
    }))
end

function api.map:__pairs()
    return self:entries()
end

api.map.__len = api.map.size

---@return table
function api.map:toTable()
    local out = {}
    local keys = self.private.keys
    local values = self.private.values
    for i = 1, #keys do
        local k = keys[i]
        if k ~= TOMBSTONE then out[k] = values[i] end
    end
    return out
end

---@return Array entries Array of `{ key, value }` tables in insertion order.
function api.map:toArray()
    local out = api.array:new()
    local keys = self.private.keys
    local values = self.private.values
    local n = 0
    for i = 1, #keys do
        local k = keys[i]
        if k ~= TOMBSTONE then
            n = n + 1
            out[n] = { key = k, value = values[i] }
        end
    end
    return out
end

return api.map
end

