local textui = {}
function textui.GetResourceName() return "codem-textui" end
function textui.Show(text) return exports['codem-textui']:OpenTextUI(text, 'thema-1') end
function textui.Hide() return exports['codem-textui']:CloseTextUI() end
textui.show=textui.Show; textui.hide=textui.Hide
return textui
