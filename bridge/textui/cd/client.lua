local textui = {}
function textui.GetResourceName() return "cd_drawtextui" end
function textui.Show(text) TriggerEvent('cd_drawtextui:ShowUI', 'show', text); return true end
function textui.Hide() TriggerEvent('cd_drawtextui:HideUI'); return true end
textui.show=textui.Show; textui.hide=textui.Hide
return textui
