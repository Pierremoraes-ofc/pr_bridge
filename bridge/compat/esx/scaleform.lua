-- ESX signatures, with bounded native PR asset loading and consumer cleanup.
return function(E,C)
    local handles={}
    local define=function(name,fn) C.define(E,'Scaleform.'..name,fn) end
    local function release(handle)
        if handles[handle] then handles[handle]=nil;SetScaleformMovieAsNoLongerNeeded(handle) end
    end
    C.clearScaleforms=function() for handle in pairs(handles) do release(handle) end end
    define('Utils.RequestScaleformMovie',function(name)
        local ok,handle=C.bridge.fivem.streaming.requestScaleformMovie(name,5000)
        assert(ok and handle,'ESX scaleform load failed: '..tostring(name))
        if C.closed then SetScaleformMovieAsNoLongerNeeded(handle);error('ESX scaleform cancelled: consumer stopped') end
        handles[handle]=true;return handle
    end)
    define('Utils.RunMethod',function(handle,method,wantsReturn,...)
        if type(handle)~='number' then handle=E.Scaleform.Utils.RequestScaleformMovie(handle) end
        assert(type(method)=='string');BeginScaleformMovieMethod(handle,method)
        for _,value in ipairs({...}) do
            if type(value)=='string' then ScaleformMovieMethodAddParamTextureNameString(value)
            elseif type(value)=='boolean' then ScaleformMovieMethodAddParamBool(value)
            elseif type(value)=='number' then
                if math.type(value)=='integer' then ScaleformMovieMethodAddParamInt(value) else ScaleformMovieMethodAddParamFloat(value) end
            else error('Invalid ESX scaleform argument') end
        end
        if wantsReturn then return handle,EndScaleformMovieMethodReturnValue() end
        EndScaleformMovieMethod();return handle
    end)
    local function display(name,seconds,configure)
        assert(type(seconds)=='number' and seconds==seconds and seconds>=0 and seconds<math.huge,'Invalid scaleform duration')
        local handle=E.Scaleform.Utils.RequestScaleformMovie(name)
        local ok,reason=pcall(function()
            configure(handle);local deadline=GetGameTimer()+seconds*1000
            while not C.closed and handles[handle] and GetGameTimer()<deadline do
                DrawScaleformMovieFullscreen(handle,255,255,255,255,0);Wait(0)
            end
        end)
        release(handle);if not ok then error(reason,2) end
    end
    define('ShowFreemodeMessage',function(title,message,seconds)
        display('MP_BIG_MESSAGE_FREEMODE',seconds,function(h) E.Scaleform.Utils.RunMethod(h,'SHOW_SHARD_WASTED_MP_MESSAGE',false,title,message) end)
    end)
    define('ShowBreakingNews',function(title,message,bottom,seconds)
        display('BREAKING_NEWS',seconds,function(h)
            E.Scaleform.Utils.RunMethod(h,'SET_TEXT',false,message,bottom)
            E.Scaleform.Utils.RunMethod(h,'SET_SCROLL_TEXT',false,0,0,title)
            E.Scaleform.Utils.RunMethod(h,'DISPLAY_SCROLL_TEXT',false,0,0)
        end)
    end)
    define('ShowPopupWarning',function(title,message,bottom,seconds)
        display('POPUP_WARNING',seconds,function(h) E.Scaleform.Utils.RunMethod(h,'SHOW_POPUP_WARNING',false,500.0,title,message,bottom,true) end)
    end)
    define('ShowTrafficMovie',function(seconds)
        display('TRAFFIC_CAM',seconds,function(h) E.Scaleform.Utils.RunMethod(h,'PLAY_CAM_MOVIE',false) end)
    end)
end
