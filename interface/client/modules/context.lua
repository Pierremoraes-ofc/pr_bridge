---Context menu module. Receives Renderer via create(renderer).
---@param Renderer table
return function(Renderer)
    ---@class ContextOption
    ---@field title string
    ---@field description? string
    ---@field icon? string|table
    ---@field iconColor? string
    ---@field disabled? boolean
    ---@field readOnly? boolean
    ---@field metadata? string|table
    ---@field progress? number
    ---@field image? string
    ---@field arrow? boolean
    ---@field event? string
    ---@field serverEvent? string
    ---@field command? string
    ---@field args? any
    ---@field menu? string
    ---@field onSelect? fun(args: any)

    ---@class ContextMenu
    ---@field id string
    ---@field title string
    ---@field menu? string
    ---@field canClose? boolean
    ---@field onExit? fun()
    ---@field onBack? fun()
    ---@field options ContextOption[]|table<string, ContextOption>

    local registered = {}
    local stack = {}
    local openId = nil

    local SERIALIZE_KEYS = {
        "title",
        "description",
        "icon",
        "iconColor",
        "disabled",
        "readOnly",
        "metadata",
        "progress",
        "image",
        "arrow",
    }

    ---@param options ContextOption[]|table<string, ContextOption>
    ---@return table[], table[]
    local function normalizeOptions(options)
        local serializable = {}
        local callbacks = {}

        if type(options) ~= "table" then
            return serializable, callbacks
        end

        local isArray = options[1] ~= nil

        if isArray then
            for i = 1, #options do
                local opt = options[i]
                local item = {}
                for _, key in ipairs(SERIALIZE_KEYS) do
                    item[key] = opt[key]
                end
                item.index = i
                item.hasSubmenu = type(opt.menu) == "string"
                if item.arrow == nil and item.hasSubmenu then
                    item.arrow = true
                end
                serializable[#serializable + 1] = item
                callbacks[i] = {
                    onSelect = opt.onSelect,
                    event = opt.event,
                    serverEvent = opt.serverEvent,
                    command = opt.command,
                    args = opt.args,
                    menu = opt.menu,
                    disabled = opt.disabled == true,
                    readOnly = opt.readOnly == true,
                }
            end
        else
            local index = 0
            for key, opt in pairs(options) do
                if type(opt) == "table" then
                    index = index + 1
                    local item = {}
                    for _, field in ipairs(SERIALIZE_KEYS) do
                        item[field] = opt[field]
                    end
                    item.index = index
                    item.key = key
                    item.hasSubmenu = type(opt.menu) == "string"
                    if item.arrow == nil and item.hasSubmenu then
                        item.arrow = true
                    end
                    serializable[#serializable + 1] = item
                    callbacks[index] = {
                        onSelect = opt.onSelect,
                        event = opt.event,
                        serverEvent = opt.serverEvent,
                        command = opt.command,
                        args = opt.args,
                        menu = opt.menu,
                        disabled = opt.disabled == true,
                        readOnly = opt.readOnly == true,
                    }
                end
            end
        end

        return serializable, callbacks
    end

    ---@param data ContextMenu|ContextMenu[]
    local function storeContext(data)
        if type(data) ~= "table" then
            Bridge.debug.error("[pr_interface] RegisterContext: data must be a table")
            return false
        end

        if data.id then
            if type(data.id) ~= "string" or data.id == "" then
                Bridge.debug.error("[pr_interface] RegisterContext: id must be a non-empty string")
                return false
            end
            if type(data.title) ~= "string" then
                Bridge.debug.warn(("[pr_interface] RegisterContext '%s': missing title"):format(data.id))
            end

            local options, callbacks = normalizeOptions(data.options or {})
            registered[data.id] = {
                id = data.id,
                title = data.title or data.id,
                menu = data.menu,
                canClose = data.canClose ~= false,
                onExit = data.onExit,
                onBack = data.onBack,
                options = options,
                callbacks = callbacks,
            }
            return true
        end

        local ok = false
        for i = 1, #data do
            if storeContext(data[i]) then
                ok = true
            end
        end
        return ok
    end

    local Context = {}

    ---@param id string
    ---@param pushStack boolean|nil
    local function openContext(id, pushStack)
        local ctx = registered[id]
        if not ctx then
            Bridge.debug.error(("[pr_interface] ShowContext: context '%s' not found"):format(tostring(id)))
            return false
        end

        if openId and pushStack ~= false then
            stack[#stack + 1] = openId
        elseif not openId then
            Renderer.setFocus(false)
        end

        openId = id

        Renderer.send("context:open", {
            id = ctx.id,
            title = ctx.title,
            canClose = ctx.canClose,
            hasParent = #stack > 0 or ctx.menu ~= nil,
            options = ctx.options,
        })

        return true
    end

    ---@param data ContextMenu|ContextMenu[]
    function Context.RegisterContext(data)
        return storeContext(data)
    end

    ---@param id string
    function Context.ShowContext(id)
        if type(id) ~= "string" or id == "" then
            Bridge.debug.error("[pr_interface] ShowContext: id must be a non-empty string")
            return false
        end

        stack = {}
        return openContext(id, false)
    end

    ---@param onExit boolean|nil
    function Context.HideContext(onExit)
        local current = openId and registered[openId] or nil
        local shouldRunExit = onExit ~= false

        openId = nil
        stack = {}

        Renderer.send("context:close")
        Renderer.resetFocus()

        if shouldRunExit and current and type(current.onExit) == "function" then
            current.onExit()
        end

        return true
    end

    ---@return string|nil
    function Context.GetOpenContextMenu()
        return openId
    end

    ---@param id string
    ---@param index number
    function Context.HandleSelect(id, index)
        local ctx = registered[id]
        if not ctx or openId ~= id then
            return
        end

        local cb = ctx.callbacks[index]
        if not cb or cb.disabled or cb.readOnly then
            return
        end

        if type(cb.menu) == "string" then
            if type(cb.onSelect) == "function" then
                cb.onSelect(cb.args)
            end
            openContext(cb.menu, true)
            return
        end

        local onSelect = cb.onSelect
        local eventName = cb.event
        local serverEvent = cb.serverEvent
        local command = cb.command
        local args = cb.args

        Context.HideContext(true)

        if type(onSelect) == "function" then
            onSelect(args)
        elseif eventName then
            TriggerEvent(eventName, args)
        elseif serverEvent then
            TriggerServerEvent(serverEvent, args)
        elseif command then
            ExecuteCommand(command)
        end
    end

    function Context.HandleClose()
        local current = openId and registered[openId] or nil
        if current and current.canClose == false then
            return
        end
        Context.HideContext(true)
    end

    function Context.HandleBack()
        local current = openId and registered[openId] or nil
        if not current then
            return
        end

        if type(current.onBack) == "function" then
            current.onBack()
        end

        if #stack > 0 then
            local parentId = stack[#stack]
            stack[#stack] = nil
            openContext(parentId, false)
            return
        end

        if type(current.menu) == "string" and registered[current.menu] then
            openContext(current.menu, false)
            return
        end

        Context.HideContext(true)
    end

    return Context
end
