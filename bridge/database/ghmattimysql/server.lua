if ActiveBridges["database"] ~= "ghmattimysql" then return end

local database = {
    driver = "ghmattimysql",
    resource = "ghmattimysql",
    context = "server",
}

local readCommands = {
    SELECT = true,
    SHOW = true,
    DESCRIBE = true,
    EXPLAIN = true,
}

local function isReadQuery(query)
    local command = type(query) == "string" and query:match("^%s*(%a+)")
    return command and readCommands[command:upper()] == true
end

local function firstValue(row)
    if type(row) ~= "table" then return nil end

    for _, value in pairs(row) do
        return value
    end

    return nil
end

local function awaitCall(start)
    local p = promise.new()

    local ok, err = pcall(function()
        start(function(result)
            p:resolve(result)
        end)
    end)

    if not ok then
        if Debug then
            Debug("ERROR", ("ghmattimysql call failed: %s"):format(err))
        end

        p:resolve(nil)
    end

    return Citizen.Await(p)
end

local function call(start, cb)
    if type(cb) == "function" then
        local ok, err = pcall(function()
            start(cb)
        end)

        if not ok then
            if Debug then
                Debug("ERROR", ("ghmattimysql async call failed: %s"):format(err))
            end

            cb(nil)
        end

        return nil
    end

    return awaitCall(start)
end

function database.isReady()
    return GetResourceState(database.resource):find("start") ~= nil
end

function database.GetResourceName()
    return database.resource
end

function database.query(query, parameters, cb)
    parameters = parameters or {}

    return call(function(resolve)
        exports.ghmattimysql:fetchAll(query, parameters, resolve)
    end, cb)
end

function database.execute(query, parameters, cb)
    parameters = parameters or {}

    return call(function(resolve)
        exports.ghmattimysql:execute(query, parameters, resolve)
    end, cb)
end

function database.insert(query, parameters, cb)
    parameters = parameters or {}

    return call(function(resolve)
        exports.ghmattimysql:execute(query, parameters, function(result)
            if type(result) == "table" then
                resolve(result.insertId or result.insert_id or result[1])
                return
            end

            resolve(result)
        end)
    end, cb)
end

function database.scalar(query, parameters, cb)
    if type(cb) == "function" then
        return database.query(query, parameters, function(rows)
            cb(rows and firstValue(rows[1]) or nil)
        end)
    end

    local rows = database.query(query, parameters)
    return rows and firstValue(rows[1]) or nil
end

function database.single(query, parameters, cb)
    if type(cb) == "function" then
        return database.query(query, parameters, function(rows)
            cb(rows and rows[1] or nil)
        end)
    end

    local rows = database.query(query, parameters)
    return rows and rows[1] or nil
end

function database.transaction(_, _, cb)
    if Debug then
        Debug("WARNING", "ghmattimysql transaction is not implemented in pr_bridge.")
    end

    if type(cb) == "function" then cb(false) end
    return false
end

function database.run(query, parameters, cb)
    if isReadQuery(query) then
        return database.query(query, parameters, cb)
    end

    return database.execute(query, parameters, cb)
end

database.read = database.query
database.fetch = database.query
database.fetchAll = database.query
database.update = database.execute
database.write = database.execute
database.auto = database.run

return database
