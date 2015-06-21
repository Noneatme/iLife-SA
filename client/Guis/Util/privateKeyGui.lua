--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

local tPKGui = {}

tPKGui.showGui = function ()
	if (clientBusy) then return end
	
	triggerServerEvent("onPlayerRequestKey", getLocalPlayer())
	tPKGui.Window = new(CDxWindow, "Private Key Generation", 500, 250, true, true, "Center|Middle")
	tPKGui.Window:setHideFunction(tPKGui.hideGui)
	
	tPKGui.Edit = new(CDxEdit, "Es wurde noch kein Key für deinen Account generiert!", 20, 20, 460, 50, "normal", tocolor(0,0,0,160),tPKGui.Window)
	tPKGui.Edit:setEnabled(false)
	
	tPKGui.Button = {}
	tPKGui.Button[1] = new(CDxButton, "Generieren", 20, 75, 225, 37, tocolor(255,255,255,255), tPKGui.Window)
	tPKGui.Button[2] = new(CDxButton, "In Zwischenablage kopieren", 255, 75, 225, 37, tocolor(255,255,255,255), tPKGui.Window)
	
	local text = [[ACHTUNG: Der Private Key darf niemals in fremde Hände gegeben werden.
	Dieser erlaubt den Zugriff auf deinen Account innerhalb des Forums.
	Der Key kann auf der Benutzerprofil-Ändern Seite eingegeben werden.
	Sollte ein Verdacht bestehen, dass sich der Key in unrechtmässigen Besitz
	befindet, so kann ein neuer generiert werden.]]
	tPKGui.Label = new(CDxLabel, text, 20, 117, 460, 75, tocolor(255,255,255,255), 1, "default", "center", "center", tPKGui.Window)
	
	tPKGui.Button[1]:addClickFunction(
	function ()
		triggerServerEvent("onPlayerRequestNewKey", getLocalPlayer())
	end
	)
	
	tPKGui.Button[2]:addClickFunction(
	function ()
		setClipboard(tPKGui.Edit:getText())
	end
	)
	
	tPKGui.Window:add(tPKGui.Edit)
	tPKGui.Window:add(tPKGui.Button[1])
	tPKGui.Window:add(tPKGui.Button[2])
	tPKGui.Window:add(tPKGui.Label)
	tPKGui.Window:show()
end

tPKGui.hideGui = function ()
	if (tPKGui.Window) then
		tPKGui.Window:hide()
		tPKGui.Window = nil
	end
end

addCommandHandler("privatekey", function() if (tPKGui.Window) then tPKGui.hideGui() else tPKGui.showGui() end end)

--bindKey("F6", "down", function () if (tPKGui.Window) then tPKGui.hideGui() else tPKGui.showGui() end end)

tPKGui.onReceiveKey = function (key)
	if (key) then
		tPKGui.Edit:setText(tostring(key))
	end
end
addEvent("onReceiveKey", true)
addEventHandler("onReceiveKey", getRootElement(), tPKGui.onReceiveKey)