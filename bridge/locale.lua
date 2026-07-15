local existingLocale = rawget(_ENV, "PRBridgeLocale")
if existingLocale then
    Locale = existingLocale
    return
end

Locale = {}
Locale.__index = Locale
PRBridgeLocale = Locale

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
    opts = opts or {}

    self.fallback = opts.fallbackLang and Locale.new(opts.fallbackLang, {
        warnOnMissing = false,
        phrases = opts.fallbackLang.phrases,
        currentLocale = opts.fallbackLang.currentLocale,
    }) or nil

    self.currentLocale = opts.currentLocale or opts.locale
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

local function normalizeLocaleName(localeName)
    if type(localeName) ~= "string" or localeName == "" then return "en-us" end

    localeName = localeName:gsub("_", "-"):lower()

    if localeName == "ptbr" then return "pt-br" end
    if localeName == "enus" then return "en-us" end

    return localeName
end

local function addLocaleCandidate(list, seen, localeName)
    if type(localeName) ~= "string" or localeName == "" then return end

    localeName = localeName:gsub("_", "-")

    local candidates = { localeName, localeName:lower() }
    local lang, region = localeName:match("^([%a]+)%-([%a]+)$")
    if lang and region then
        candidates[#candidates + 1] = ("%s-%s"):format(lang:lower(), region:upper())
    end

    local normalized = normalizeLocaleName(localeName)
    if normalized == "en" or normalized == "en-us" then
        candidates[#candidates + 1] = "en-US"
        candidates[#candidates + 1] = "en-us"
    elseif normalized == "pt" or normalized == "pt-br" then
        candidates[#candidates + 1] = "pt-BR"
        candidates[#candidates + 1] = "pt-br"
    end

    for i = 1, #candidates do
        local candidate = candidates[i]
        if candidate and not seen[candidate] then
            seen[candidate] = true
            list[#list + 1] = candidate
        end
    end
end

local function getGlobalStateLocale()
    if not GlobalState then return nil end

    local localeName = GlobalState.pr_bridge_locale
    if type(localeName) == "string" and localeName ~= "" then
        return localeName
    end
end

local function getConfiguredLocale()
    local localeName = GetConvar("pr_bridge:locale", "")
    local stateLocale = getGlobalStateLocale()

    if type(localeName) ~= "string" or localeName == "" then
        localeName = stateLocale
    elseif normalizeLocaleName(localeName) == "en-us" and stateLocale then
        localeName = stateLocale
    end

    return normalizeLocaleName(localeName or "en-us")
end

function Locale.init(invokingResource)
    local resource = invokingResource or GetInvokingResource() or GetCurrentResourceName()
    local localeName = getConfiguredLocale()
    
    local prefixes = { "", "bridge/" }
    local formats = { "locale/%s.lua", "locales/%s.lua", "locale/%s.json", "locales/%s.json" }
    local searchLocales = {}
    local seenLocales = {}
    addLocaleCandidate(searchLocales, seenLocales, localeName)
    addLocaleCandidate(searchLocales, seenLocales, "en-us")
    addLocaleCandidate(searchLocales, seenLocales, "pt-br")

    local chunk, foundPath, foundLocale
    for _, loc in ipairs(searchLocales) do
        for _, prefix in ipairs(prefixes) do
            for _, fmt in ipairs(formats) do
                local p = prefix .. fmt:format(loc)
                chunk = LoadResourceFile(resource, p)
                if chunk then
                    foundPath = p
                    foundLocale = loc
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

    local activeLocale = normalizeLocaleName(foundLocale or localeName)
    local localeObj = Locale:new({
        phrases = phrases,
        warnOnMissing = true,
        currentLocale = activeLocale,
    })

    local public
    public = {
        currentLocale = activeLocale,
        resource = resource,
        path = foundPath,
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
        locale = function(self, newLoc)
            if type(self) == "string" and newLoc == nil then
                newLoc = self
            end

            if type(newLoc) == "string" and newLoc ~= "" then
                newLoc = normalizeLocaleName(newLoc)
            else
                newLoc = nil
            end

            local currentLocale = localeObj:locale(newLoc)
            public.currentLocale = currentLocale
            return currentLocale
        end,
        delete = function(_, target, prefix)
            localeObj:delete(target, prefix)
        end
    }

    return setmetatable(public, {
        __call = function(_, key, subs)
            return localeObj:t(key, subs)
        end,
        __tostring = function()
            return public.currentLocale or ""
        end
    })
end
