local textui = {}
function textui.GetResourceName() return "ox_lib" end
function textui.Show(text) return exports.ox_lib:showTextUI(text) end
function textui.Hide() return exports.ox_lib:hideTextUI() end
textui.show=textui.Show; textui.hide=textui.Hide
return textui
