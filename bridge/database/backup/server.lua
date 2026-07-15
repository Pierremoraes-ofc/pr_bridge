return function(database, defaultResource)
    local backup = {}

    local function quoteIdentifier(value)
        value = tostring(value or "")
        if value == "" or value:find("%z") then return nil end
        return ("`%s`"):format(value:gsub("`", "``"))
    end

    local function quoteValue(value)
        if value == nil then return "NULL" end

        local valueType = type(value)
        if valueType == "number" then
            if value ~= value or value == math.huge or value == -math.huge then
                return "NULL"
            end
            return tostring(value)
        end

        if valueType == "boolean" then return value and "1" or "0" end

        value = tostring(value)
            :gsub("\\", "\\\\")
            :gsub("%z", "\\0")
            :gsub("\n", "\\n")
            :gsub("\r", "\\r")
            :gsub("\026", "\\Z")
            --:gsub("'", "\\'")
            :gsub("'", "''")

        return ("'%s'"):format(value)
    end

    local function normalizeMode(mode)
        mode = tostring(mode or "both"):lower():gsub("[%s_-]", "")

        if mode == "table" or mode == "tables" or mode == "schema" or mode == "structure" then
            return true, false, "schema"
        end

        if mode == "insert" or mode == "inserts" or mode == "data" or mode == "dados" then
            return false, true, "data"
        end

        return true, true, "both"
    end

    local function normalizeOutput(options)
        local resource = options.resource or options.targetResource or defaultResource
        local path = options.path or options.file or "backups/database.sql"

        if type(resource) ~= "string" or resource == "" then
            return nil, nil, "invalid_resource"
        end

        if type(path) ~= "string" or path == "" then
            return nil, nil, "invalid_path"
        end

        path = path:gsub("\\", "/"):gsub("^/+", "")
        if path == "" or path:find("..", 1, true) or path:find(":", 1, true) then
            return nil, nil, "invalid_path"
        end

        if path:sub(-4):lower() ~= ".sql" then path = path .. ".sql" end
        return resource, path
    end

    local function getFirstValue(row, ignoredValue)
        if type(row) ~= "table" then return nil end
        for _, value in pairs(row) do
            if value ~= ignoredValue then return value end
        end
    end

    local function getTables(requested)
        if type(requested) == "string" then requested = { requested } end

        if type(requested) == "table" and #requested > 0 then
            local tables = {}
            for i = 1, #requested do
                if type(requested[i]) ~= "string" or requested[i] == "" then
                    return nil, "invalid_table"
                end
                tables[#tables + 1] = requested[i]
            end
            return tables
        end

        local rows = database.query("SHOW FULL TABLES WHERE Table_type = 'BASE TABLE'") or {}
        local tables = {}

        for i = 1, #rows do
            local name = getFirstValue(rows[i], "BASE TABLE")
            if type(name) == "string" and name ~= "BASE TABLE" then
                tables[#tables + 1] = name
            end
        end

        table.sort(tables)
        return tables
    end

    local function getColumns(tableName)
        local identifier = quoteIdentifier(tableName)
        if not identifier then return nil, "invalid_table" end

        local rows = database.query(("SHOW COLUMNS FROM %s"):format(identifier)) or {}
        local columns = {}

        for i = 1, #rows do
            local name = rows[i].Field or rows[i].field
            if type(name) == "string" then columns[#columns + 1] = name end
        end

        return columns
    end

    local function appendSchema(output, tableName, options)
        local identifier = quoteIdentifier(tableName)
        if not identifier then return false, "invalid_table" end

        local row = database.single(("SHOW CREATE TABLE %s"):format(identifier))
        if not row then return false, "schema_unavailable" end

        local statement = row["Create Table"] or row["Create View"] or row.CreateTable
        if type(statement) ~= "string" then
            statement = getFirstValue(row, tableName)
        end
        if type(statement) ~= "string" then return false, "schema_unavailable" end

        output[#output + 1] = ("-- Structure for %s"):format(identifier)
        if options.dropTable ~= false then
            output[#output + 1] = ("DROP TABLE IF EXISTS %s;"):format(identifier)
        end
        output[#output + 1] = statement .. ";"
        output[#output + 1] = ""
        return true
    end

    local function appendData(output, tableName, options)
        local identifier = quoteIdentifier(tableName)
        if not identifier then return false, "invalid_table" end

        local columns, columnError = getColumns(tableName)
        if not columns then return false, columnError end
        if #columns == 0 then return true, 0 end

        local rows = database.query(("SELECT * FROM %s"):format(identifier)) or {}
        if #rows == 0 then return true, 0 end

        local quotedColumns = {}
        for i = 1, #columns do quotedColumns[i] = quoteIdentifier(columns[i]) end

        local batchSize = math.max(1, math.floor(tonumber(options.rowsPerInsert) or 100))
        output[#output + 1] = ("-- Data for %s"):format(identifier)

        for startIndex = 1, #rows, batchSize do
            local values = {}
            local lastIndex = math.min(#rows, startIndex + batchSize - 1)

            for rowIndex = startIndex, lastIndex do
                local rowValues = {}
                for columnIndex = 1, #columns do
                    rowValues[columnIndex] = quoteValue(rows[rowIndex][columns[columnIndex]])
                end
                values[#values + 1] = ("(%s)"):format(table.concat(rowValues, ", "))
            end

            output[#output + 1] = ("INSERT INTO %s (%s) VALUES\n%s;"):format(
                identifier,
                table.concat(quotedColumns, ", "),
                table.concat(values, ",\n")
            )
        end

        output[#output + 1] = ""
        return true, #rows
    end

    function backup.create(options)
        options = type(options) == "table" and options or { mode = options }

        if type(SaveResourceFile) ~= "function" then
            return false, "write_unavailable"
        end

        if type(database) ~= "table" or type(database.query) ~= "function" then
            return false, "database_unavailable"
        end

        if database.isReady and not database.isReady() then
            return false, "database_not_ready"
        end

        local includeSchema, includeData, mode = normalizeMode(options.mode or options.type)
        local resource, path, pathError = normalizeOutput(options)
        if not resource then return false, pathError end

        local tables, tableError = getTables(options.tables)
        if not tables then return false, tableError end

        local output = {
            "-- PR Bridge SQL Backup",
            ("-- Mode: %s"):format(mode),
            ("-- Tables: %d"):format(#tables),
            "SET FOREIGN_KEY_CHECKS=0;",
            "",
        }
        local totalRows = 0

        for i = 1, #tables do
            local tableName = tables[i]

            if includeSchema then
                local ok, err = appendSchema(output, tableName, options)
                if not ok then return false, ("%s:%s"):format(tableName, err) end
            end

            if includeData then
                local ok, rows = appendData(output, tableName, options)
                if not ok then return false, ("%s:%s"):format(tableName, rows) end
                totalRows = totalRows + rows
            end
        end

        output[#output + 1] = "SET FOREIGN_KEY_CHECKS=1;"
        output[#output + 1] = ""

        local content = table.concat(output, "\n")
        local saved = SaveResourceFile(resource, path, content, #content)
        if saved == false then return false, "save_failed" end

        return true, {
            resource = resource,
            path = path,
            mode = mode,
            tables = #tables,
            rows = totalRows,
            bytes = #content,
        }
    end

    backup.run = backup.create
    backup.export = backup.create
    return backup
end
