local streaming = {}

function streaming.hash(model)
    if type(model) == "number" then return model end
    if type(model) == "string" then return joaat(model) end
    return nil
end

return streaming
