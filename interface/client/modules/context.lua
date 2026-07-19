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
        "iconAnimation",
        "disabled",
        "readOnly",
        "metadata",
        "progress",
        "colorScheme",
        "image",
        "arrow",
        "badge",
        "keybind",
        "checked",
    }

    local function cloneSerializable(value, seen)
        local valueType = type(value)
        if valueType == "function" or valueType == "thread" or valueType == "userdata" then
            return nil
        end

        if valueType ~= "table" then
            return value
        end

        seen = seen or {}
        if seen[value] then return nil end
        seen[value] = true

        local copy = {}
        for key, item in pairs(value) do
            local safeKey = cloneSerializable(key, seen)
            if safeKey ~= nil then
                local safeValue = cloneSerializable(item, seen)
                if safeValue ~= nil then
                    copy[safeKey] = safeValue
                end
            end
        end

        seen[value] = nil
        return copy
    end

    local function isOptionArray(options)
        if type(options) ~= "table" then return false end
        if options[1] ~= nil then return true end

        local count = 0
        local numeric = 0
        for key in pairs(options) do
            count = count + 1
            if type(key) == "number" then numeric = numeric + 1 end
        end

        return count > 0 and count == numeric
    end

    local function normalizeTitle(option, key)
        if type(option) == "string" then return option end
        if type(option) ~= "table" then return tostring(key or "") end
        return option.title or option.label or tostring(key or "")
    end

    local function normalizeOption(option, index, key)
        if type(option) == "string" then
            return {
                index = index,
                title = option,
            }, {
                disabled = false,
                readOnly = false,
            }
        end

        if type(option) ~= "table" then
            return nil, nil
        end

        local item = {}
        for _, field in ipairs(SERIALIZE_KEYS) do
            item[field] = cloneSerializable(option[field])
        end

        item.index = index
        item.key = key
        item.title = normalizeTitle(option, key)
        item.hasSubmenu = type(option.menu) == "string"

        if item.arrow == nil and (item.hasSubmenu or option.event or option.serverEvent) then
            item.arrow = true
        end

        return item, {
            onSelect = option.onSelect,
            event = option.event,
            serverEvent = option.serverEvent,
            command = option.command,
            args = option.args,
            menu = option.menu,
            disabled = option.disabled == true,
            readOnly = option.readOnly == true,
        }
    end

    ---@param options ContextOption[]|table<string, ContextOption>
    ---@return table[], table[]
    local function normalizeOptions(options)
        local serializable = {}
        local callbacks = {}

        if type(options) ~= "table" then
            return serializable, callbacks
        end

        local isArray = isOptionArray(options)

        if isArray then
            for i = 1, #options do
                local item, callback = normalizeOption(options[i], i)
                if item then
                    serializable[#serializable + 1] = item
                    callbacks[i] = callback
                end
            end
        else
            local index = 0
            for key, opt in pairs(options) do
                local item, callback = normalizeOption(opt, index + 1, key)
                if item then
                    index = index + 1
                    serializable[#serializable + 1] = item
                    callbacks[index] = callback
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
                position = data.position,
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
            position = ctx.position,
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

    Context.registerContext = Context.RegisterContext

    ---@param id string
    function Context.ShowContext(id)
        if type(id) ~= "string" or id == "" then
            Bridge.debug.error("[pr_interface] ShowContext: id must be a non-empty string")
            return false
        end

        stack = {}
        return openContext(id, false)
    end

    Context.showContext = Context.ShowContext

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

    Context.hideContext = Context.HideContext

    ---@return string|nil
    function Context.GetOpenContextMenu()
        return openId
    end

    Context.getOpenContextMenu = Context.GetOpenContextMenu

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
