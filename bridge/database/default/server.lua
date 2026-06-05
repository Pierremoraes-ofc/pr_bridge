local database = {
    driver = "none",
    resource = nil,
    context = "server",
}

local function unavailable(method, cb)
    if Debug then
        Debug("WARNING", ("database.%s called but no supported database resource was detected."):format(method))
    end

    if type(cb) == "function" then
        cb(nil)
    end

    return nil
end

function database.isReady()
    return false
end

function database.GetResourceName()
    return nil
end

function database.query(_, _, cb)
    return unavailable("query", cb)
end

function database.execute(_, _, cb)
    return unavailable("execute", cb)
end

function database.insert(_, _, cb)
    return unavailable("insert", cb)
end

function database.scalar(_, _, cb)
    return unavailable("scalar", cb)
end

function database.single(_, _, cb)
    return unavailable("single", cb)
end

function database.transaction(_, _, cb)
    return unavailable("transaction", cb)
end

database.read = database.query
database.fetch = database.query
database.fetchAll = database.query
database.run = database.execute
database.update = database.execute
database.write = database.execute

return database
