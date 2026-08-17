if PRCore then return end

local resourceName = GetCurrentResourceName()

PRCore = {
    name = "pr_bridge",
    resource = resourceName,
    context = IsDuplicityVersion() and "server" or "client",
}

function PRCore.noop() end

local function normalizePath(path)
    path = path:gsub("%.lua$", "")

    if path:find("/", 1, true) or path:find("@", 1, true) then
        return path
    end

    return path:gsub("%.", "/")
end

local function getModuleInfo(path)
    local resource, modulePath = path:match("^@([^%./\\]+)[%./\\](.+)$")
    if resource then return resource, modulePath end

    return resourceName, path
end

local function getDataFileCandidates(path, extension)
    if type(path) ~= "string" or path == "" then
        error(("file path must be a non-empty string (received '%s')"):format(type(path)), 3)
    end

    local resource, fileName = getModuleInfo(path:gsub("\\", "/"))
    fileName = fileName:gsub("^/+", "")

    if fileName == "" or fileName:find("..", 1, true) or fileName:find(":", 1, true) then
        error(("invalid resource file path '%s'"):format(path), 3)
    end

    if not extension then return resource, { fileName } end

    local hasExtension = fileName:sub(-#extension):lower() == extension
    local withoutExtension = hasExtension and fileName:sub(1, -#extension - 1) or fileName
    local candidates = {}

    local function addCandidate(candidate)
        if candidate:sub(-#extension):lower() ~= extension then
            candidate = candidate .. extension
        end

        for index = 1, #candidates do
            if candidates[index] == candidate then return end
        end

        candidates[#candidates + 1] = candidate
    end

    if fileName:find("/", 1, true) then
        addCandidate(fileName)
    elseif hasExtension then
        -- Explicit JSON paths stay literal first for legacy filenames.
        addCandidate(fileName)
        addCandidate(withoutExtension:gsub("%.", "/"))
    else
        -- ox_lib dotted notation remains the primary resolution.
        addCandidate(withoutExtension:gsub("%.", "/"))
        addCandidate(withoutExtension)
    end

    return resource, candidates
end

local function getDataFileInfo(path, extension, preferExisting)
    local resource, candidates = getDataFileCandidates(path, extension)

    if preferExisting then
        for index = 1, #candidates do
            if LoadResourceFile(resource, candidates[index]) ~= nil then
                return resource, candidates[index]
            end
        end
    end

    return resource, candidates[1], candidates
end

function PRCore.loadFile(resource, fileName, env, optional)
    fileName = fileName:sub(-4) == ".lua" and fileName or ("%s.lua"):format(fileName)

    local chunk = LoadResourceFile(resource, fileName)
    if not chunk then
        if optional then return nil end
        error(("file '@%s/%s' not found"):format(resource, fileName), 2)
    end

    local fn, err = load(chunk, ("@@%s/%s"):format(resource, fileName), "t", env or _ENV)
    if not fn then error(err, 2) end

    return fn
end

function PRCore.load(path, env, optional)
    if type(path) ~= "string" then
        error(("file path must be a string (received '%s')"):format(type(path)), 2)
    end

    local resource, modulePath = getModuleInfo(normalizePath(path))
    local fn = PRCore.loadFile(resource, modulePath, env, optional)
    if not fn then return nil end

    return fn()
end

function PRCore.loadModule(path, env, optional)
    return PRCore.load(path, env, optional)
end

function PRCore.loadJson(path, optional)
    if type(path) ~= "string" then
        error(("json path must be a string (received '%s')"):format(type(path)), 2)
    end

    local resource, fileName, candidates = getDataFileInfo(path, ".json")
    local content

    for index = 1, #candidates do
        content = LoadResourceFile(resource, candidates[index])
        if content ~= nil then
            fileName = candidates[index]
            break
        end
    end

    if not content then
        if optional then return nil end
        error(("json file '@%s/%s' not found"):format(resource, fileName), 2)
    end

    return json.decode(content)
end

PRCore.readJson = PRCore.loadJson

function PRCore.jsonExists(path)
    local resource, _, candidates = getDataFileInfo(path, ".json")

    for index = 1, #candidates do
        if LoadResourceFile(resource, candidates[index]) ~= nil then return true end
    end

    return false
end

function PRCore.saveJson(path, value, options)
    options = options or {}
    if type(SaveResourceFile) ~= "function" then return false, "write_unavailable" end

    local resource, fileName = getDataFileInfo(path, ".json", true)
    local encoded = json.encode(value)

    if not encoded then return false, "encode_failed" end

    local saved = SaveResourceFile(resource, fileName, encoded, #encoded)
    if saved == false then return false, "save_failed" end

    return true, {
        resource = resource,
        path = fileName,
        bytes = #encoded,
    }
end

PRCore.writeJson = PRCore.saveJson

function PRCore.updateJson(path, changes, options)
    options = options or {}

    local current = PRCore.loadJson(path, true)
    if current == nil then current = {} end

    if type(changes) == "function" then
        local updated = changes(current)
        if updated ~= nil then current = updated end
    elseif type(changes) == "table" then
        if type(current) ~= "table" then current = {} end

        for key, value in pairs(changes) do
            current[key] = value
        end
    else
        return false, "invalid_changes"
    end

    local saved, result = PRCore.saveJson(path, current, options)
    if not saved then return false, result end
    return true, current, result
end

PRCore.mergeJson = PRCore.updateJson

function PRCore.deleteJson(path)
    if type(SaveResourceFile) ~= "function" then return false, "write_unavailable" end

    local resource, fileName = getDataFileInfo(path, ".json", true)
    local content = "null"
    local saved = SaveResourceFile(resource, fileName, content, #content)

    if saved == false then return false, "save_failed" end
    return true, { resource = resource, path = fileName }
end

PRCore.callback = PRCore.callback or {}

function PRCore.callback.register(name, cb)
    RegisterNetEvent(name, function(requestId, ...)
        local src = source
        local args = table.pack(...)
        CreateThread(function()
            local result
            if PRCore.context == "server" then
                result = table.pack(cb(src, table.unpack(args, 1, args.n)))
            else
                result = table.pack(cb(table.unpack(args, 1, args.n)))
            end

            if type(requestId) == "string" then
                if PRCore.context == "server" then
                    TriggerClientEvent("pr_bridge:callback:response", src, requestId, table.unpack(result, 1, result.n))
                else
                    TriggerServerEvent("pr_bridge:callback:response", requestId, table.unpack(result, 1, result.n))
                end
            end
        end)
    end)
end
