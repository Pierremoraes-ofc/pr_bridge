-- ESX DiscordLog is not a generic console/Fivemerr log. Keep that contract.
return function(N)
    local colors={red=16711680,green=65280,blue=255,orange=16753920,white=16777215}
    local function factory(fields)
        if not next(Config.compatDiscordWebhookConvars or {}) then return nil,'Discord webhook convar not configured' end
        return function(name,title,color,body)
            local convar=(Config.compatDiscordWebhookConvars or {})[name]
            local url=type(convar)=='string' and GetConvar(convar,'') or nil
            assert(type(url)=='string' and url:match('^https://[%w%.%-]+/api/webhooks/'),'Discord log channel not configured')
            local embed={title=tostring(title),color=tonumber(color) or colors[color] or colors.white}
            if fields then assert(type(body)=='table','Invalid Discord fields');embed.fields=body
            else embed.description=tostring(body) end
            PerformHttpRequest(url,function(status)
                if status<200 or status>=300 then print(('[PR Bridge compat] Discord channel %s HTTP %s'):format(name,status)) end
            end,'POST',json.encode({embeds={embed}}),{['Content-Type']='application/json'})
        end
    end
    N.DiscordLog=N.DiscordLog or function() return factory(false) end
    N.DiscordLogFields=N.DiscordLogFields or function() return factory(true) end
    return N
end
