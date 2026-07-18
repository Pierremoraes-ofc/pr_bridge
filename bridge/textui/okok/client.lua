local textui = {}
function textui.GetResourceName() return "okokTextUI" end
function textui.Show(text) return exports['okokTextUI']:Open(text, 'lightgrey', 'right', false) end
function textui.Hide() return exports['okokTextUI']:Close() end
textui.show=textui.Show; textui.hide=textui.Hide
return textui
