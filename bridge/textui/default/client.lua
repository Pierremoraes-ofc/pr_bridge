local textui = {}
function textui.GetResourceName() return "default" end
function textui.Show(text) return Bridge.drawtext.show(text) end
function textui.Hide() return Bridge.drawtext.hide() end
textui.show=textui.Show; textui.hide=textui.Hide
return textui
