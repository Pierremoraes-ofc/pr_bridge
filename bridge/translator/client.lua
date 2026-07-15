-- =========================================================================
-- CLIENT-SIDE TRADUÇÃO DO MENU (PR_BRIDGE)
-- =========================================================================

local translator = {}

-- Solicita a tradução em lote/batch ao servidor
function translator.translateBatch(strings, targetLang)
    if not strings or #strings == 0 then return {} end

    local success, translated = pcall(function()
        return PRCore.callback.await('pr_bridge:server:translateBatch', 10000, strings, targetLang)
    end)

    if success and type(translated) == "table" then
        return translated
    end

    return strings
end

-- Traduz um texto individual de forma síncrona
function translator.translateText(text, targetLang)
    if not text or text == "" then return "" end
    local res = translator.translateBatch({ text }, targetLang)
    return res[1] or text
end

translator.translate = translator.translateText

-- Função auxiliar que traduz a estrutura de um menu ox_lib automaticamente
function translator.translateMenu(menuData, targetLang)
    if not menuData then return nil end

    local stringsToTranslate = {}
    local stringMap = {}

    -- 1. Mapear o Título do Menu
    if menuData.title then
        table.insert(stringsToTranslate, menuData.title)
        stringMap["title"] = #stringsToTranslate
    end

    -- 2. Mapear os títulos e descrições das opções
    if menuData.options then
        for i, option in ipairs(menuData.options) do
            if option.title then
                table.insert(stringsToTranslate, option.title)
                stringMap["opt_" .. i .. "_title"] = #stringsToTranslate
            end
            if option.description and (option.translateDescription or option.translateDesc) then
                table.insert(stringsToTranslate, option.description)
                stringMap["opt_" .. i .. "_desc"] = #stringsToTranslate
            end
        end
    end

    if #stringsToTranslate == 0 then
        return menuData
    end

    -- 3. Solicita a tradução em lote ao servidor
    local translatedStrings = translator.translateBatch(stringsToTranslate, targetLang)

    -- 4. Aplica as traduções de volta nos campos correspondentes
    if type(translatedStrings) == "table" and #translatedStrings > 0 then
        if stringMap["title"] then
            menuData.title = translatedStrings[stringMap["title"]] or menuData.title
        end
        if menuData.options then
            for i, option in ipairs(menuData.options) do
                if stringMap["opt_" .. i .. "_title"] then
                    option.title = translatedStrings[stringMap["opt_" .. i .. "_title"]] or option.title
                end
                if stringMap["opt_" .. i .. "_desc"] then
                    option.description = translatedStrings[stringMap["opt_" .. i .. "_desc"]] or option.description
                end
            end
        end
    end

    return menuData
end

-- Função auxiliar para exibir notificações traduzidas (com suporte a textos longos)
function translator.showTranslatedNotify(title, description, notifyType, targetLang)
    local stringsToTranslate = { title, description }
    local translated = translator.translateBatch(stringsToTranslate, targetLang)

    local finalTitle = translated[1] or title
    local finalDesc = translated[2] or description

    local BridgeRef = Bridge or pr_lib
    if BridgeRef then
        if BridgeRef.notify and type(BridgeRef.notify) == "function" then
            BridgeRef.notify({
                title = finalTitle,
                description = finalDesc,
                type = notifyType or "info",
                duration = 8000
            })
        elseif BridgeRef.notifications and BridgeRef.notifications.Notify then
            BridgeRef.notifications.Notify({
                title = finalTitle,
                description = finalDesc,
                type = notifyType or "info",
                duration = 8000
            })
        end
    end
end

return translator
