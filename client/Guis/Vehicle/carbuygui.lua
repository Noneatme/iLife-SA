--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

--[[
addEventHandler("onClientRender", root,
    function()
        dxDrawRectangle(0, 0, 216, 329, tocolor(108, 108, 108, 125), true)
        dxDrawText("Modell:", 12, 16, 197, 52, tocolor(254, 254, 254, 255), 1.20, "default", "left", "center", false, false, true, false, false)
        dxDrawRectangle(13, 54, 183, 47, tocolor(255, 255, 255, 255), true)
        dxDrawText("Kosten:", 12, 103, 197, 139, tocolor(254, 254, 254, 255), 1.20, "default", "left", "center", false, false, true, false, false)
        dxDrawRectangle(13, 273, 183, 47, tocolor(255, 255, 255, 255), true)
        dxDrawText("Bestand:", 12, 189, 197, 225, tocolor(254, 254, 254, 255), 1.20, "default", "left", "center", false, false, true, false, false)
        dxDrawText("500.000$", 12, 139, 197, 188, tocolor(0, 200, 0, 125), 1.20, "default", "left", "center", false, false, true, false, false)
        dxDrawText("5", 12, 225, 197, 271, tocolor(0, 200, 0, 125), 1.20, "default", "left", "center", false, false, true, false, false)
    end
)
]]

local sX,sY = guiGetScreenSize()

carbuyguiShown = false

Carbuy = {
["Window"] = false,
["Label"] = {},
["Button"] = {},
["Edit"] = {}
}
	
addEvent("CarbuyGuiOpen",true)
addEventHandler("CarbuyGuiOpen", getLocalPlayer(), 
function(ID, Modelname, Cost, Bestand)
	if (not clientBusy) and (not carbuyguiShown) then
		hideCarbuyGui()
		
		Carbuy["Window"] = new(CDxWindow, "Neuwagen kaufen", 220, 327, true, true, "Center|Middle", 0, 0, {false, false, Modelname})

		Carbuy["Label"][1] = new(CDxLabel, "Modell:", 10, 5, 200, 50, tocolor(255,255,255,255), 1.2, "default", "left", "center", Carbuy["Window"])
		Carbuy["Edit"][1] = new(CDxEdit, Modelname, 10, 60, 200, 50, "normal", tocolor(0,0,0,255), Carbuy["Window"])
		Carbuy["Label"][2] = new(CDxLabel, "Kosten:", 10, 110, 200, 30, tocolor(255,255,255,255), 1.2, "default", "left", "center", Carbuy["Window"])
		Carbuy["Label"][3] = new(CDxLabel, formNumberToMoneyString(tostring(Cost)), 10, 140, 200, 30, tocolor(0,125,0,255), 1.2, "default", "left", "center", Carbuy["Window"])
		Carbuy["Label"][4] = new(CDxLabel, "Bestand:", 10, 170, 200, 30, tocolor(255,255,255,255), 1.2, "default", "left", "center", Carbuy["Window"])
		Carbuy["Label"][5] = new(CDxLabel, tostring(Bestand), 10, 200, 200, 30, tocolor(0,125,0,255), 1.2, "default", "left", "center", Carbuy["Window"])
		
		Carbuy["Button"][1] = new(CDxButton, "Kaufen", 10, 240, 200, 50, tocolor(255,255,255,255), Carbuy["Window"])
		
		Carbuy["Button"][1]:addClickFunction(
		function ()
			hideCarbuyGui()
			triggerServerEvent("onPlayerVehicleBuy", getLocalPlayer(), ID)
		end
		)

		Carbuy["Window"]:setHideFunction(function() hideCarbuyGui() end)
		
		Carbuy["Window"]:add(Carbuy["Label"][1])
		Carbuy["Window"]:add(Carbuy["Label"][2])
		Carbuy["Window"]:add(Carbuy["Label"][3])
		Carbuy["Window"]:add(Carbuy["Label"][4])
		Carbuy["Window"]:add(Carbuy["Label"][5])
		Carbuy["Window"]:add(Carbuy["Edit"][1])
		Carbuy["Window"]:add(Carbuy["Button"][1])
		Carbuy["Window"]:show()
		
		carbuyguiShown = true
	end
end
)

function hideCarbuyGui()
	if (Carbuy["Window"]) then
		Carbuy["Window"]:hide()
		delete(Carbuy["Window"])
		Carbuy["Window"] = nil
		setTimer(function() carbuyguiShown = false end, 1000, 1)
	end
end
addEvent("hideCarbuyGui", true)
addEventHandler("hideCarbuyGui", getRootElement(), hideCarbuyGui)