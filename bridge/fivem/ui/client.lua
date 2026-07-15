local ui = {}
local function color(value) value=value or {}; return value.r or value[1] or 255, value.g or value[2] or 255, value.b or value[3] or 255, value.a or value[4] or 215 end
function ui.draw2DText(text, x, y, scale, textColor, font)
    local r,g,b,a=color(textColor); SetTextScale(scale or 0.35, scale or 0.35); SetTextColour(r,g,b,a); SetTextOutline(); SetTextFont(font or 4); SetTextProportional(true)
    BeginTextCommandDisplayText("STRING"); AddTextComponentSubstringPlayerName(tostring(text or "")); EndTextCommandDisplayText(x or 0.5, y or 0.5); return true
end
function ui.draw3DText(text, coords, scale, textColor, font)
    if not coords then return false end; SetDrawOrigin(coords.x,coords.y,coords.z,0); ui.draw2DText(text,0.0,0.0,scale,textColor,font); ClearDrawOrigin(); return true
end
function ui.drawRect(x,y,width,height,rectColor)
    local r,g,b,a=color(rectColor); DrawRect(x,y,width,height,r,g,b,a); return true
end
ui.Draw2DText=ui.draw2DText; ui.Draw3DText=ui.draw3DText; ui.DrawRect=ui.drawRect
return ui