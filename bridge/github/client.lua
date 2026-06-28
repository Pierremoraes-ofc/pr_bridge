local github = {}

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

return github
