local textui = {}
function textui.GetResourceName() return "jg-textui" end
function textui.Show(text) return exports['jg-textui']:DrawText(text) end
function textui.Hide() return exports['jg-textui']:HideText() end
textui.show=textui.Show; textui.hide=textui.Hide
return textui
