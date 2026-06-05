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
    local resource = path:match("^@(.-)/.+")

    if resource then
        return resource, path:sub(#resource + 3)
    end

    return resourceName, path
end

function PRCore.loadFile(resource, fileName, env, optional)
    fileName = fileName:find("%.lua$", 1, true) and fileName or ("%s.lua"):format(fileName)

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

    local resource, modulePath = getModuleInfo(normalizePath(path))
    local fileName = modulePath:find("%.json$", 1, true) and modulePath or ("%s.json"):format(modulePath)
    local content = LoadResourceFile(resource, fileName)

    if not content then
        if optional then return nil end
        error(("json file '@%s/%s' not found"):format(resource, fileName), 2)
    end

    return json.decode(content)
end

PRCore.callback = PRCore.callback or {}

function PRCore.callback.register(name, cb)
    RegisterNetEvent(name, function(requestId, ...)
        local src = source
        local result = table.pack(cb(src, ...))

        if type(requestId) == "string" then
            if PRCore.context == "server" then
                TriggerClientEvent("pr_bridge:callback:response", src, requestId, table.unpack(result, 1, result.n))
            else
                TriggerServerEvent("pr_bridge:callback:response", requestId, table.unpack(result, 1, result.n))
            end
        end
    end)
end
