-- =========================================================================
-- SISTEMA DE TRADUÇÃO AUTOMÁTICA (SERVER-SIDE)
-- =========================================================================

local baseLang = GetConvar("pr_bridge:base_locale", "pt"):lower()
local saveInterval = GetConvarInt("pr_bridge:translator_save_interval", 60000)

local translationCache = {}
local isCacheDirty = false

-- Carregar o cache do arquivo local JSON
local function loadCache()
    local fileContent = LoadResourceFile("pr_bridge", "translations_cache.json")
    if fileContent then
        local ok, data = pcall(json.decode, fileContent)
        if ok and type(data) == "table" then
            translationCache = data
            if Debug then
                Debug("INFO", "[Translator] Cache de traduções carregado com sucesso.")
            end
            return
        end
    end
    translationCache = {}
end

-- Salvar o cache no arquivo local JSON
local function saveCache()
    local ok, encoded = pcall(json.encode, translationCache, { indent = true })
    if ok then
        SaveResourceFile("pr_bridge", "translations_cache.json", encoded, -1)
    end
end

-- Função para URL encode de strings
local function urlencode(str)
    if str then
        str = str:gsub("\n", "\r\n")
        str = str:gsub("([^%w %-%_%.%~])", function(c)
            return string.format("%%%02X", string.byte(c))
        end)
        str = str:gsub(" ", "%%20")
    end
    return str
end

-- Traduzir um texto individual usando a API pública gratuita do Google Translate
local function TranslateText(text, targetLang, cb)
    if not text or text == "" then
        return cb("")
    end

    if targetLang == baseLang then
        return cb(text)
    end

    -- Verificar cache em memória
    if translationCache[targetLang] and translationCache[targetLang][text] then
        return cb(translationCache[targetLang][text])
    end

    -- Chamada HTTP para API do Google Translate
    local url = string.format("https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=%s&dt=t&q=%s", targetLang, urlencode(text))

    PerformHttpRequest(url, function(statusCode, response, headers)
        if statusCode ~= 200 or not response then
            if Debug then
                Debug("WARNING", ("[Translator] Erro na API do Google Translate. Status: %s"):format(statusCode))
            end
            return cb(text)
        end

        local ok, data = pcall(json.decode, response)
        if not ok or not data or not data[1] then
            return cb(text)
        end

        local translated = ""
        for i = 1, #data[1] do
            if data[1][i][1] then
                translated = translated .. data[1][i][1]
            end
        end

        -- Atualizar Cache
        if not translationCache[targetLang] then
            translationCache[targetLang] = {}
        end
        translationCache[targetLang][text] = translated
        isCacheDirty = true

        cb(translated)
    end, "GET")
end

-- Registrar callback da pr_bridge para tradução em lote
PRCore.callback.register('pr_bridge:server:translateBatch', function(source, strings, targetLang)
    local p = promise.new()
    local results = {}
    local pending = #strings

    if pending == 0 then
        return {}
    end

    for i = 1, #strings do
        local text = strings[i]
        TranslateText(text, targetLang, function(translated)
            results[i] = translated
            pending = pending - 1
            if pending == 0 then
                p:resolve(results)
            end
        end)
    end

    return Citizen.Await(p)
end)

-- Thread de Inicialização e salvamento periódico do cache
CreateThread(function()
    loadCache()
    while true do
        Wait(saveInterval)
        if isCacheDirty then
            saveCache()
            isCacheDirty = false
        end
    end
end)

-- Garante que salva o cache se o script for reiniciado
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        if isCacheDirty then
            saveCache()
        end
    end
end)

local translator = {}

function translator.translateText(text, targetLang, cb)
    local p = promise.new()
    TranslateText(text, targetLang, function(translated)
        if cb then cb(translated) end
        p:resolve(translated)
    end)
    return Citizen.Await(p)
end

translator.translate = translator.translateText

function translator.translateBatch(strings, targetLang, cb)
    local p = promise.new()
    local results = {}
    local pending = #strings

    if pending == 0 then
        if cb then cb({}) end
        return {}
    end

    for i = 1, #strings do
        local text = strings[i]
        TranslateText(text, targetLang, function(translated)
            results[i] = translated
            pending = pending - 1
            if pending == 0 then
                if cb then cb(results) end
                p:resolve(results)
            end
        end)
    end

    return Citizen.Await(p)
end

return translator
