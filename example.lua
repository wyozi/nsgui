local fr = vgui.Create("NSFrame")
fr:SetSize(800, 600)
fr:Center()
fr:SetTitle("Hello world")

local btn = vgui.Create("NSButton", fr)
btn:SetPos(25, 200)
btn:SetSize(200, 35)
btn:SetText("Click me")

fr:MakePopup()