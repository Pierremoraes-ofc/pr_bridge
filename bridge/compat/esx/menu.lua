-- ESX menu objects backed by the existing PR list/context/input interface.
return function(E,C)
    local Menu={RegisteredTypes={},Opened={}}
    E.UI=E.UI or {};E.UI.Menu=Menu
    local define=function(name,fn) C.define(E,'UI.Menu.'..name,fn) end
    define('RegisterType',function(kind,open,close)
        assert(C.callable(open) and C.callable(close));Menu.RegisteredTypes[kind]={open=open,close=close}
    end)
    define('GetOpened',function(kind,namespace,name)
        for _,menu in pairs(Menu.Opened) do if menu.type==kind and menu.namespace==namespace and menu.name==name then return menu end end
    end)
    define('GetOpenedMenus',function()
        local result={};for _,menu in pairs(Menu.Opened) do result[#result+1]=menu end;return result
    end)
    define('Close',function(kind,namespace,name,cancel)
        local menu=Menu.GetOpened(kind,namespace,name);if not menu then return end
        if cancel and menu.cancel then menu.cancel(menu.data,menu) end;menu.close()
    end)
    define('CloseAll',function(cancel) local copy={};for _,m in pairs(Menu.Opened) do copy[#copy+1]=m end
        for _,m in ipairs(copy) do Menu.Close(m.type,m.namespace,m.name,cancel) end
    end)
    define('Open',function(kind,namespace,name,data,submit,cancel,change,onClose)
        local id=C.owner..':esx:'..tostring(namespace)..':'..tostring(name)
        local menu={type=kind,namespace=namespace,name=name,resourceName=C.owner,data=C.copy(data),submit=submit,cancel=cancel,change=change}
        function menu.close()
            if not Menu.Opened[id] then return end;Menu.Opened[id]=nil
            if Menu.RegisteredTypes[kind] then Menu.RegisteredTypes[kind].close(namespace,name)
            elseif kind=='dialog' then C.ui.closeInputDialog() else C.ui.hideMenu(false) end
            if onClose then onClose() end
        end
        function menu.update(query,values)
            for _,element in ipairs(menu.data.elements or {}) do local matches=true
                for k,v in pairs(query) do if element[k]~=v then matches=false end end
                if matches then for k,v in pairs(values) do element[k]=v end end
            end
        end
        function menu.setElement(i,key,value) menu.data.elements[i][key]=value end
        function menu.setElements(elements) menu.data.elements=C.copy(elements) end
        function menu.setTitle(title) menu.data.title=title end
        function menu.removeElement(query)
            for i=#(menu.data.elements or {}),1,-1 do local matches=true
                for k,v in pairs(query) do if menu.data.elements[i][k]~=v then matches=false end end
                if matches then table.remove(menu.data.elements,i) end
            end
        end
        function menu.refresh()
            if Menu.RegisteredTypes[kind] then return Menu.RegisteredTypes[kind].open(namespace,name,menu.data) end
            if kind=='dialog' then
                CreateThread(function()
                    local input=C.ui.inputDialog(menu.data.title or name,{{type='input',label=menu.data.title or name,default=menu.data.value}})
                    if not Menu.Opened[id] then return end
                    if input and submit then submit({value=input[1]},menu) elseif cancel then cancel({},menu) end
                end);return
            end
            assert(kind=='default' or kind=='list','Unknown ESX menu type; register it first')
            local options={}
            for i,element in ipairs(menu.data.elements or {}) do
                local values=element.options or element.values
                if element.type=='slider' and not values then values={};for v=element.min or 0,element.max or 100 do values[#values+1]=tostring(v) end end
                options[i]={label=element.label or tostring(element.value or i),description=element.description,
                    disabled=element.disabled,values=values,defaultIndex=values and ((tonumber(element.value) or element.min or 0)-(element.min or 0)+1) or nil,
                    close=false,args={index=i}}
            end
            local function selected(index,scroll,confirm)
                if not Menu.Opened[id] then return end
                local element=menu.data.elements[index];if not element then return end
                if scroll and element.type=='slider' then element.value=(element.min or 0)+scroll-1 end
                local cb=confirm and submit or change
                if cb then cb({current=C.copy(element),elements=C.copy(menu.data.elements)},menu) end
            end
            C.ui.registerMenu({id=id,title=menu.data.title or name,position=menu.data.align=='right' and 'top-right' or 'top-left',
                options=options,onClose=function() if cancel then cancel({},menu) end;menu.close() end,
                onSideScroll=function(i,s) selected(i,s,false) end},function(i,s) selected(i,s,true) end)
            C.ui.showMenu(id)
        end
        Menu.Opened[id]=menu;menu.refresh();return menu
    end)
    C.define(E,'OpenContext',function(position,elements,select,close)
        local options={};for _,element in ipairs(elements) do
            options[#options+1]={label=element.title or element.label,value=element.value,description=element.description,disabled=element.unselectable,original=C.copy(element)}
        end
        return Menu.Open('default',C.owner,'context',{title='Context',elements=options},function(data,menu)
            if select then select(menu,data.current.original) end
        end,function(_,menu) if close then close(menu) end end)
    end)
    C.define(E,'CloseContext',function() return Menu.Close('default',C.owner,'context') end)
    C.define(E,'RefreshContext',function(elements)
        local menu=Menu.GetOpened('default',C.owner,'context');if menu then menu.setElements(elements);menu.refresh() end
    end)
end
