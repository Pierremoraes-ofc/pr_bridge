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

function Locale.init(invokingResource)
    local resource = invokingResource or GetInvokingResource() or GetCurrentResourceName()
    local localeName = GetConvar("pr_bridge:locale", "en-us"):lower()
    
    local prefixes = { "", "bridge/" }
    local formats = { "locale/%s.lua", "locales/%s.lua", "locale/%s.json", "locales/%s.json" }
    local searchLocales = { localeName }
    if localeName ~= "en-us" then table.insert(searchLocales, "en-us") table.insert(searchLocales, "en-US") end
    if localeName ~= "pt-br" then table.insert(searchLocales, "pt-br") end

    local chunk, foundPath
    for _, loc in ipairs(searchLocales) do
        for _, prefix in ipairs(prefixes) do
            for _, fmt in ipairs(formats) do
                local p = prefix .. fmt:format(loc)
                chunk = LoadResourceFile(resource, p)
                if chunk then
                    foundPath = p
                    break
                end
            end
            if chunk then break end
        end
        if chunk then break end
    end

    if not chunk then
        error(("^1[pr_bridge] Could not find any translation file for resource '%s' with locale '%s'^0"):format(resource, localeName), 2)
    end

    local phrases
    if foundPath:match("%.json$") then
        phrases = PRCore.loadJson(("@%s/%s"):format(resource, foundPath), true)
    else
        local env = setmetatable({ Locale = Locale }, { __index = _G })
        local fn, err = load(chunk, ("@@%s/%s"):format(resource, foundPath), "t", env)
        if not fn then
            error(err, 2)
        end
        local result = fn()
        phrases = type(result) == "table" and result or env.Translations or env.Phrases or env.Locales
        if not phrases then
            for k, v in pairs(env) do
                if k ~= "Locale" and type(v) == "table" then
                    phrases = v
                    break
                end
            end
        end

        if type(phrases) == "table" and getmetatable(phrases) == Locale then
            phrases = phrases.phrases
        end
    end

    if not phrases then
        error(("^1[pr_bridge] Translation file '%s' did not define a valid table^0"):format(foundPath), 2)
    end

    local localeObj = Locale:new({
        phrases = phrases,
        warnOnMissing = true
    })

    return setmetatable({
        t = function(self, key, subs)
            if type(self) == "string" then
                return localeObj:t(self, key)
            end
            return localeObj:t(key, subs)
        end,
        has = function(self, key)
            if type(self) == "string" then
                return localeObj:has(self)
            end
            return localeObj:has(key)
        end,
        extend = function(_, newPhrases, prefix)
            localeObj:extend(newPhrases, prefix)
        end,
        replace = function(_, newPhrases)
            localeObj:replace(newPhrases)
        end,
        locale = function(_, newLoc)
            return localeObj:locale(newLoc)
        end,
        delete = function(_, target, prefix)
            localeObj:delete(target, prefix)
        end
    }, {
        __call = function(_, key, subs)
            return localeObj:t(key, subs)
        end
    })
end

