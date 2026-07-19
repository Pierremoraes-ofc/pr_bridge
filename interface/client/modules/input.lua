---Input dialog module.
---@param Renderer table
return function(Renderer)
    local pending = nil

    local SERIALIZE_ROW_KEYS = {
        "type",
        "label",
        "description",
        "placeholder",
        "default",
        "required",
        "disabled",
        "min",
        "max",
        "step",
        "options",
        "password",
        "icon",
    }

    local function serializeRows(rows)
        local out = {}
        if type(rows) ~= "table" then
            return out
        end

        for i = 1, #rows do
            local row = rows[i]
            if type(row) == "string" then
                out[#out + 1] = {
                    index = i,
                    type = "input",
                    label = row,
                }
            elseif type(row) == "table" then
                local item = { index = i }
                for _, key in ipairs(SERIALIZE_ROW_KEYS) do
                    item[key] = row[key]
                end
                item.type = item.type or "input"
                out[#out + 1] = item
            end
        end

        return out
    end

    local Input = {}

    ---@param heading string
    ---@param rows table
    ---@param options table|nil
    ---@return table|nil
    function Input.InputDialog(heading, rows, options)
        if pending then
            pending.resolve(nil)
            pending = nil
        end

        local p = promise.new()
        pending = {
            resolve = function(result)
                if pending and pending.promise == p then
                    pending = nil
                end
                p:resolve(result)
            end,
            promise = p,
        }

        Renderer.setFocus(false)
        Renderer.send("input:open", {
            heading = heading or "Input",
            rows = serializeRows(rows),
            options = options or {},
        })

        return Citizen.Await(p)
    end

    ---@param values table|nil
    function Input.HandleSubmit(values)
        if not pending then
            Renderer.send("input:close")
            Renderer.clearFocus()
            return
        end

        local resolve = pending.resolve
        Renderer.send("input:close")
        Renderer.clearFocus()
        resolve(values)
    end

    function Input.HandleClose()
        Input.HandleSubmit(nil)
    end

    return Input
end
