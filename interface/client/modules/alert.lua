---Alert dialog module.
---@param Renderer table
return function(Renderer)
    local pending = nil

    local Alert = {}

    ---@class AlertDialogData
    ---@field header? string
    ---@field content? string
    ---@field centered? boolean
    ---@field cancel? boolean
    ---@field labels? { cancel?: string, confirm?: string }
    ---@field size? string

    ---@param data AlertDialogData
    ---@param timeout number|nil
    ---@return 'confirm'|'cancel'|nil
    function Alert.AlertDialog(data, timeout)
        if type(data) ~= "table" then
            return nil
        end

        if pending then
            pending.resolve("cancel")
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
        Renderer.send("alert:open", {
            header = data.header or "Alert",
            content = data.content or "",
            centered = data.centered ~= false,
            cancel = data.cancel ~= false,
            labels = {
                cancel = data.labels and data.labels.cancel or "Cancelar",
                confirm = data.labels and data.labels.confirm or "Confirmar",
            },
            size = data.size,
        })

        if timeout and timeout > 0 then
            SetTimeout(timeout, function()
                if pending and pending.promise == p then
                    pending.resolve("cancel")
                    Renderer.send("alert:close")
                    Renderer.clearFocus()
                end
            end)
        end

        return Citizen.Await(p)
    end

    ---@param result 'confirm'|'cancel'
    function Alert.HandleResult(result)
        if not pending then
            Renderer.send("alert:close")
            Renderer.clearFocus()
            return
        end

        local resolve = pending.resolve
        Renderer.send("alert:close")
        Renderer.clearFocus()
        resolve(result == "confirm" and "confirm" or "cancel")
    end

    function Alert.HandleClose()
        Alert.HandleResult("cancel")
    end

    return Alert
end
