local github = {}
local pr_lib = pr_lib or Bridge or _G.pr_lib or {}

local function compareVersions(v1, v2)
    local function parseVersion(v)
        local parts = {}
        for part in string.gmatch(v or "", "%d+") do
            parts[#parts + 1] = tonumber(part) or 0
        end
        return parts
    end

    local parts1 = parseVersion(v1)
    local parts2 = parseVersion(v2)

    for i = 1, math.max(#parts1, #parts2) do
        local p1 = parts1[i] or 0
        local p2 = parts2[i] or 0
        if p1 < p2 then
            return -1 -- v1 < v2
        elseif p1 > p2 then
            return 1  -- v1 > v2
        end
    end
    return 0 -- v1 == v2
end

---Verifica se uma dependência atende à versão mínima exigida
---@param resource string Nome do resource dependente
---@param minimumVersion string Versão mínima necessária (ex: '1.0.0')
---@param printMessage boolean Se deve exibir mensagem de erro no console
---@return boolean, string?
function github.checkDependency(resource, minimumVersion, printMessage)
    local currentVersion = GetResourceMetadata(resource, 'version', 0)
    currentVersion = currentVersion and currentVersion:match('%d+%.%d+%.%d+') or 'unknown'

    if currentVersion ~= minimumVersion then
        local cmp = compareVersions(currentVersion, minimumVersion)
        if cmp < 0 then
            local msg = ("^1%s requires version '%s' of '%s' (current version: %s)^0"):format(
                GetInvokingResource() or GetCurrentResourceName(),
                minimumVersion,
                resource,
                currentVersion
            )
            if printMessage then
                print(msg)
            end
            return false, msg
        end
    end

    return true
end

---Verifica a versão do script atual em relação ao GitHub Releases
---@param repository string? Nome do repositório no GitHub (ex: 'owner/repo'). Se nil, busca do fxmanifest.
function github.versionCheck(repository)
    local resource = GetInvokingResource() or GetCurrentResourceName()
    local currentVersion = GetResourceMetadata(resource, 'version', 0)

    if currentVersion then
        currentVersion = currentVersion:match('%d+%.%d+%.%d+')
    end

    if not currentVersion then
        return print(("^1Unable to determine current resource version for '%s'^0"):format(resource))
    end

    if not repository then
        local repoUrl = GetResourceMetadata(resource, 'repository', 0)
        if repoUrl then
            repository = repoUrl:gsub("https?://github%.com/", ""):gsub("github%.com/", ""):gsub("%.git$", "")
        end
    end

    if not repository then
        return print(("^1No repository specified for version check in '%s'^0"):format(resource))
    end

    SetTimeout(1000, function()
        local url = ("https://api.github.com/repos/%s/releases/latest"):format(repository)

        PerformHttpRequest(url, function(statusCode, response)
            if statusCode ~= 200 or not response then
                if pr_lib.config and pr_lib.config.Debug then
                    print(("^1Update check failed for '%s' (Status: %s)^0"):format(resource, statusCode))
                end
                return
            end

            local data = json.decode(response)
            if not data or not data.tag_name or data.prerelease then return end

            local latestVersion = data.tag_name:match('%d+%.%d+%.%d+')
            if not latestVersion then return end

            local cmp = compareVersions(currentVersion, latestVersion)
            local isUpToDate = cmp >= 0

            local status = isUpToDate and "^2UP TO DATE^0" or "^1OUTDATED^0"
            
            local function center(text, w)
                local cleanText = text:gsub("%^%d", "")
                local spaces = w - string.len(cleanText)
                local left = math.floor(spaces / 2)
                local right = spaces - left
                return string.rep(" ", left) .. text .. string.rep(" ", right)
            end

            local title = resource:gsub("^%[.-%]", ""):gsub("^pr_", ""):gsub("_", " "):gsub("-", " "):upper()
            
            local lines = {
                ("^5%s^0"):format(title),
                status,
                ("^7Version:^0 ^2%s^0"):format(currentVersion),
                ("^7GitHub:^0 github.com/%s"):format(repository),
            }

            local discord = GetResourceMetadata(resource, 'discord', 0)
            if discord then
                table.insert(lines, ("^7Discord:^0 %s"):format(discord))
            end

            if not isUpToDate then
                table.insert(lines, "^3A new version is available!^0")
                table.insert(lines, ("^3github.com/%s/releases/latest^0"):format(repository))
            end

            local maxWidth = 40
            for i = 1, #lines do
                local cleanText = lines[i]:gsub("%^%d", "")
                local len = string.len(cleanText)
                if len > maxWidth then
                    maxWidth = len
                end
            end

            maxWidth = maxWidth + 8
            local topBorder = "^8" .. string.rep("─", maxWidth + 2) .. "^0"
            local emptyLine = "^8|^0" .. center("", maxWidth) .. "^8|^0"

            local box = {
                topBorder,
                emptyLine,
                "^8|^0" .. center(lines[1], maxWidth) .. "^8|^0",
                emptyLine,
                "^8|^0" .. center(lines[2], maxWidth) .. "^8|^0",
                emptyLine,
                "^8|^0" .. center(lines[3], maxWidth) .. "^8|^0",
                "^8|^0" .. center(lines[4], maxWidth) .. "^8|^0",
            }

            local index = 5
            if discord then
                table.insert(box, "^8|^0" .. center(lines[index], maxWidth) .. "^8|^0")
                index = index + 1
            end

            if not isUpToDate then
                table.insert(box, emptyLine)
                table.insert(box, "^8|^0" .. center(lines[index], maxWidth) .. "^8|^0")
                table.insert(box, "^8|^0" .. center(lines[index + 1], maxWidth) .. "^8|^0")
            end

            table.insert(box, emptyLine)
            table.insert(box, topBorder)

            print("")
            for _, line in ipairs(box) do
                print(line)
            end
            print("")

        end, "GET", "", { ["User-Agent"] = "pr_bridge" })
    end)
end

return github
