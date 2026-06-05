if Locale then return end

Locale = {}
Locale.__index = Locale

local function translateKey(phrase, subs)
    if type(phrase) ~= "string" then
        error("TypeError: translateKey function expects arg #1 to be a string")
    end

    if not subs then return phrase end

    local result = phrase
    for key, value in pairs(subs) do
        result = result:gsub("%%{" .. key .. "}", tostring(value))
    end

    return result
end

function Locale.new(_, opts)
    local self = setmetatable({}, Locale)

    self.fallback = opts.fallbackLang and Locale.new(opts.fallbackLang, {
        warnOnMissing = false,
        phrases = opts.fallbackLang.phrases,
    }) or nil

    self.warnOnMissing = type(opts.warnOnMissing) ~= "boolean" or opts.warnOnMissing
    self.phrases = {}
    self:extend(opts.phrases or {})

    return self
end

function Locale:extend(phrases, prefix)
    for key, phrase in pairs(phrases) do
        local prefixKey = prefix and ("%s.%s"):format(prefix, key) or key

        if type(phrase) == "table" then
            self:extend(phrase, prefixKey)
        else
            self.phrases[prefixKey] = phrase
        end
    end
end

function Locale:clear()
    self.phrases = {}
end

function Locale:replace(phrases)
    self:clear()
    self:extend(phrases or {})
end

function Locale:locale(newLocale)
    if newLocale then
        self.currentLocale = newLocale
    end

    return self.currentLocale
end

function Locale:t(key, subs)
    local phrase = self.phrases[key]

    if type(phrase) ~= "string" then
        if self.warnOnMissing then
            local message = ('Missing phrase for key: "%s"'):format(key)
            if Debug then
                Debug("WARNING", message)
            end
        end

        if self.fallback then
            return self.fallback:t(key, subs)
        end

        return key
    end

    return translateKey(phrase, subs or {})
end

function Locale:has(key)
    return self.phrases[key] ~= nil
end

function Locale:delete(phraseTarget, prefix)
    if type(phraseTarget) == "string" then
        self.phrases[phraseTarget] = nil
        return
    end

    for key, phrase in pairs(phraseTarget) do
        local prefixKey = prefix and ("%s.%s"):format(prefix, key) or key

        if type(phrase) == "table" then
            self:delete(phrase, prefixKey)
        else
            self.phrases[prefixKey] = nil
        end
    end
end
