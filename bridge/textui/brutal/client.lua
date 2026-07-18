local textui = {}
function textui.GetResourceName() return "brutal_textui" end
function textui.Show(text) return exports['brutal_textui']:Open(text, 'gray', 1, 'right') end
function textui.Hide() return exports['brutal_textui']:Close() end
textui.show=textui.Show; textui.hide=textui.Hide
return textui
