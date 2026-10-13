-- Canonical PR library module. Shared by native users and legacy adapters.
-- Algorithms promoted only where no equivalent PR implementation existed.
return function(api)
local cache = api.cache
--[[
    https://github.com/overextended/ox_lib

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright © 2025 Linden <https://github.com/thelindat>
]]

---@class SetPrivate
---@field map Map

---@class Set : OxClass
---@field private new SetConstructor
---@field private private SetPrivate
api.set = api.class('Set')

---@class SetConstructor
---@overload fun(self: Set, ...: any): Set
---@private
function api.set:constructor(...)
    self.private.map = api.map:new()

    local args = { ... }
    for i = 1, select('#', ...) do
        self:add(args[i])
    end
end

---@param value any
---@return Set self
function api.set:add(value)
    if value ~= nil and not self.private.map:has(value) then
        self.private.map:set(value, true)
    end
    return self
end

---@param value any
---@return boolean removed
function api.set:remove(value)
    return self.private.map:delete(value)
end

---@param value any
---@return boolean
function api.set:has(value)
    return self.private.map:has(value)
end

---@return integer
function api.set:size()
    return self.private.map:size()
end

---@return boolean
function api.set:isEmpty()
    return self.private.map:isEmpty()
end

---@return Set self
function api.set:clear()
    self.private.map:clear()
    return self
end

---@return fun(): any?
function api.set:each()
    return self.private.map:keys()
end

function api.set:__pack()
    return msgpack.pack(self:toArray()), true
end

function api.set:__tojson()
    return json.encode(self:toArray())
end

function api.set:__pairs()
    local it = self.private.map:keys()
    local i = 0
    return function()
        local v = it()
        if v == nil then return nil end
        i = i + 1
        return i, v
    end
end

api.set.__ipairs = api.set.__pairs
api.set.__len = api.set.size

---@return Array
function api.set:toArray()
    return api.array:from(self:each())
end

---@param other Set
---@return Set
function api.set:union(other)
    local result = api.set:new()
    for v in self:each() do result:add(v) end
    for v in other:each() do result:add(v) end
    return result
end

---@param other Set
---@return Set
function api.set:intersection(other)
    local result = api.set:new()
    for v in self:each() do
        if other:has(v) then result:add(v) end
    end
    return result
end

---@param other Set
---@return Set
function api.set:difference(other)
    local result = api.set:new()
    for v in self:each() do
        if not other:has(v) then result:add(v) end
    end
    return result
end

---@param other Set
---@return boolean
function api.set:equals(other)
    if self:size() ~= other:size() then return false end
    for v in self:each() do
        if not other:has(v) then return false end
    end
    return true
end

---@param other Set
---@return boolean
function api.set:isSubsetOf(other)
    if self:size() > other:size() then return false end
    for v in self:each() do
        if not other:has(v) then return false end
    end
    return true
end

return api.set
end

