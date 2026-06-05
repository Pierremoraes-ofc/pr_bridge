-- bridge/version.lua  (carregado no shared_scripts)
local CURRENT_VERSION = "1.0.2"
local REPO_OWNER      = "Pierremoraes-ofc"
local REPO_NAME       = "pr_bridge"

-- Só roda no server para não abrir requisição no client
if IsDuplicityVersion() and Config.VersionCheck then
    CreateThread(function()
        -- Aguarda o server subir completamente
        Wait(5000)

        local url = ("https://api.github.com/repos/%s/%s/releases/latest"):format(REPO_OWNER, REPO_NAME)

        PerformHttpRequest(url, function(statusCode, response, headers)
            if statusCode ~= 200 or not response then
                if Config.Debug then
                    Debug('ERROR', Lang:t('message.UpdateCheckFailed'))
                end
                return
            end

            local data = json.decode(response)
            if not data or not data.tag_name then return end

            local latestVersion = data.tag_name:gsub("^v", "")

            local isUpToDate = latestVersion == CURRENT_VERSION

            -- Se estiver atualizado mas o debug for false, não exibimos nada para manter o console limpo
            if isUpToDate and not Config.Debug then return end

            local status = isUpToDate and "^2UP TO DATE^0" or "^1OUTDATED^0"
            local versionText = isUpToDate and ("VERSION %s"):format(CURRENT_VERSION) or ("VERSION %s -> %s"):format(CURRENT_VERSION, latestVersion)
            
            local function center(text, width)
                local cleanText = text:gsub("%^%d", "")
                local spaces = width - string.len(cleanText)
                local left = math.floor(spaces / 2)
                local right = spaces - left
                return string.rep(" ", left) .. text .. string.rep(" ", right)
            end

            local box = {
                "^8--------------------------------------------------^0",
                "^8|^0                                                ^8|^0",
                "^8|^0" .. center("^5ffffff iii vv       vv eeeeeee mm    mm^0", 48) .. "^8|^0",
                "^8|^0" .. center("^5ff     iii  vv     vv  ee      mmm  mmm^0", 48) .. "^8|^0",
                "^8|^0" .. center("^5ffff   iii   vv   vv   eeeee   mmmmmmmm^0", 48) .. "^8|^0",
                "^8|^0" .. center("^5ff     iii    vv vv    ee      mm mm mm^0", 48) .. "^8|^0",
                "^8|^0" .. center("^5ff     iii     vvv     eeeeeee mm    mm^0", 48) .. "^8|^0",
                "^8|^0                                                ^8|^0",
                "^8|^0" .. center("^5bbbbbb  rrrrrr  iii ddddd     ggggg  eeeee^0", 48) .. "^8|^0",
                "^8|^0" .. center("^5bb   bb rr   rr iii dd  dd   gg      ee   ^0", 48) .. "^8|^0",
                "^8|^0" .. center("^5bbbbbb  rrrrrr  iii dd   dd gg  ggg  eeeee^0", 48) .. "^8|^0",
                "^8|^0" .. center("^5bb   bb rr  rr  iii dd   dd  gg   gg ee   ^0", 48) .. "^8|^0",
                "^8|^0" .. center("^5bbbbbb  rr   rr iii dddddd    ggggg  eeeee^0", 48) .. "^8|^0",
                "^8|^0                                                ^8|^0",
                "^8|^0" .. center(status, 48) .. "^8|^0",
                "^8|^0" .. center(versionText, 48) .. "^8|^0",
            }
            
            if not isUpToDate then
                table.insert(box, "^8|^0                                                ^8|^0")
                table.insert(box, "^8|^0" .. center("^3Please update your script!^0", 48) .. "^8|^0")
                table.insert(box, "^8|^0                                                ^8|^0")
                table.insert(box, "^8--------------------------------------------------^0")
                table.insert(box, "" .. center(("^3https://github.com/%s/%s/releases/latest^0"):format(REPO_OWNER, REPO_NAME), 48) .. "")
            else
                table.insert(box, "^8|^0                                                ^8|^0")
                table.insert(box, "^8--------------------------------------------------^0")
            end

            Debug("INFO", "")
            for _, line in ipairs(box) do
                Debug("INFO", line)
            end
            Debug("INFO", "")
            
        end, "GET", "", { ["User-Agent"] = "pr_bridge" })
    end)
end
