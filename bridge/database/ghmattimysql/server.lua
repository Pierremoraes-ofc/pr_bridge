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
        exports.ghmattimysql:execute(query, parameters, resolve)
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

local function preparedReadResult(rows)
    if type(rows) ~= "table" or #rows ~= 1 or type(rows[1]) ~= "table" then
        return rows
    end

    local count, value = 0, nil
    for _, current in pairs(rows[1]) do
        count = count + 1
        value = current
        if count > 1 then return rows end
    end

    return value
end

local function runParameterSets(parameters, executeOne)
    parameters = parameters or {}

    if type(parameters[1]) ~= "table" then
        return executeOne(parameters)
    end

    local results = {}
    for i = 1, #parameters do
        results[i] = executeOne(parameters[i])
    end
    return results
end

-- Emulates oxmysql prepare semantics for drivers without a native prepare API.
function database.prepare(query, parameters, cb)
    local function execute()
        return runParameterSets(parameters, function(values)
            if isReadQuery(query) then
                return preparedReadResult(database.query(query, values))
            end
            return database.execute(query, values)
        end)
    end

    if type(cb) == "function" then
        CreateThread(function() cb(execute()) end)
        return
    end

    return execute()
end

-- Preserves detailed affectedRows payloads for single and batch writes.
function database.rawExecute(query, parameters, cb)
    local function execute()
        return runParameterSets(parameters, function(values)
            local result = database.execute(query, values)
            if type(result) == "number" then return { affectedRows = result } end
            return result
        end)
    end

    if type(cb) == "function" then
        CreateThread(function() cb(execute()) end)
        return
    end

    return execute()
end

function database.ready(cb)
    if type(cb) ~= "function" then return database.isReady() end

    CreateThread(function()
        while not database.isReady() do Wait(50) end
        cb()
    end)
end
function database.transaction(queries, parameters, cb)
    if type(parameters) == "function" then cb, parameters = parameters, nil end
    return call(function(resolve)
        local statements = {}
        for i, statement in ipairs(queries) do
            local query = type(statement) == "table" and statement.query or statement
            local values = type(statement) == "table" and (statement.values or statement.parameters) or nil
            values = values or parameters or {}
            -- Both names support legacy and current driver versions.
            statements[i] = { query = query, values = values, parameters = values }
        end
        exports.ghmattimysql:transaction(statements, {}, function(success)
            resolve(success == true)
        end)
    end, cb)
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
-- update returns affected rows, while execute retains the provider's raw result.
function database.update(query, parameters, cb)
    local function affectedRows(result)
        if type(result) == "table" then return tonumber(result.affectedRows or result.affected_rows) end
        return tonumber(result)
    end
    if type(cb) == "function" then
        return database.execute(query, parameters, function(result) cb(affectedRows(result)) end)
    end
    return affectedRows(database.execute(query, parameters))
end
database.write = database.execute
database.auto = database.run

return database
