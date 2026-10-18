-- Legacy Locale:new contract for @qb-core/shared/locale.lua consumers.
-- This runs in the importing resource, never in the host's locale namespace.
local Class={};Class.__index=Class
function Class:new(options)
    options=options or {}
    local value=setmetatable({phrases={},currentLocale=options.locale or 'en',warnOnMissing=options.warnOnMissing~=false,
        fallback=options.fallbackLang},self)
    value:extend(options.phrases or {});return value
end
function Class:extend(phrases,prefix)
    for key,value in pairs(phrases) do
        local name=prefix and (prefix..'.'..key) or tostring(key)
        if type(value)=='table' then self:extend(value,name) else self.phrases[name]=value end
    end
end
function Class:clear() self.phrases={} end
function Class:replace(phrases) self:clear();self:extend(phrases or {}) end
function Class:locale(value) if value then self.currentLocale=value end;return self.currentLocale end
function Class:has(key) return self.phrases[key]~=nil end
function Class:delete(key)
    self.phrases[key]=nil
    for name in pairs(self.phrases) do if name:sub(1,#key+1)==key..'.' then self.phrases[name]=nil end end
end
function Class:t(key,substitutions)
    local text=self.phrases[key]
    if type(text)~='string' then
        if self.fallback and self.fallback~=self then return self.fallback:t(key,substitutions) end
        if self.warnOnMissing then print('[PR Bridge QB locale] Missing phrase: '..tostring(key)) end
        return key
    end
    return (text:gsub('%%{(.-)}',function(name)
        local value=(substitutions or {})[name];return value~=nil and tostring(value) or ('%{'..name..'}')
    end))
end
Locale=Class
return Class
