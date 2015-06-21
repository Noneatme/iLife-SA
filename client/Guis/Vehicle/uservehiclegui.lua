--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

addEventHandler("onClientClick", getRootElement(),
	function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedWorld)
		if (button == "right" and state == "down") then
			if (clickedWorld) then
				if (getElementType(clickedWorld) == "vehicle") then
					if (getElementData(clickedWorld, "UserVehicle")) then
						showUserVehicleClickGui(clickedWorld)
					end
				end
			end
		end
		if (button == "left" and state == "down") then
			if (clickedWorld) then
				if (not clientBusy) then
					if (getElementType(clickedWorld) == "vehicle") then
						if (getElementData(clickedWorld, "UserVehicle")) then
							triggerServerEvent("onVehicleSwitchLock", clickedWorld, getLocalPlayer())
						end
					end
				end
			end
		end		
	end
)

UserVehicleClick = {
	["Window"] = false,
	["Image"] = {},
	["List"] = {},
	["Button"] = {}
}

local TTP;

function showUserVehicleClickGui(theVehicle)
	if (not clientBusy) then
		if not(TTP) then
			TTP = TuningTeilPreise:New();
		end
		hideUserVehicleClickGui()
		
		UserVehicleClick["Window"] = new(CDxWindow, "Fahrzeug", 350, 320, true, true, "Center|Middle")
		
		UserVehicleClick["List"][1] = new(CDxList, 5, 10, 190, 280, tocolor(125,125,125,200), UserVehicleClick["Window"])
		UserVehicleClick["List"][1]:addColumn("Attribut")
		UserVehicleClick["List"][1]:addColumn("Eigenschaft")
		
		UserVehicleClick["List"][1]:addRow("Modell|"..getVehicleName(theVehicle))
		UserVehicleClick["List"][1]:addRow("Typ|".."Privatfahrzeug")
		UserVehicleClick["List"][1]:addRow("Besitzer|"..getElementData(theVehicle, "OwnerName"))
		UserVehicleClick["List"][1]:addRow("Nummernschild|"..getElementData(theVehicle, "Plate"))
		
		local lock = getElementData(theVehicle, "Locked") == true and "Ja" or "Nein"
		local engine = getElementData(theVehicle, "Engine") == true and "An" or "Aus"
		
		UserVehicleClick["List"][1]:addRow("Abgeschlossen|"..lock)
		UserVehicleClick["List"][1]:addRow("Motorstatus|"..engine)
		
		
		-- Tunings --
		UserVehicleClick["List"][1]:addRow("   Tunings:|".." ");
		
		for i = 0, 50, 1 do
			
			if(TTP:GetTuningNameFromSlot(i)) then
				local iID = TTP.customTunings[TTP:GetTuningNameFromSlot(i)][1];
				
				local name = TTP:GetTuningNameFromSlot(i);
				
				local bBool = "Nein";
				if(getElementData(theVehicle, "upgrade_"..i) == 1) then
					bBool = "Ja";
				end
				
				if(name == "Bessere Hydraulik") then
					name = "Hydraulik";
				end
				UserVehicleClick["List"][1]:addRow(name.."|"..bBool);
			end
		end
		
		UserVehicleClick["Button"][1] = new(CDxButton, "Parken", 200, 10, 140, 35, tocolor(255,255,255,255), UserVehicleClick["Window"])
		local lock = getElementData(theVehicle, "Locked") == true and "Aufschließen" or "Abschließen"
		UserVehicleClick["Button"][2] = new(CDxButton, lock, 200, 50, 140, 35, tocolor(255,255,255,255), UserVehicleClick["Window"])
		UserVehicleClick["Button"][3] = new(CDxButton, "Respawnen", 200, 90, 140, 35, tocolor(255,255,255,255), UserVehicleClick["Window"])
		
		-- Abschleppen --
		if(getElementData(theVehicle, "v:AbgeschlepptVon") == localPlayer) then
			UserVehicleClick["Button"][4] = new(CDxButton, "Abschleppen", 200, 130, 140, 35, tocolor(255,255,255,255), UserVehicleClick["Window"])
			
			UserVehicleClick["Button"][4]:addClickFunction(
			function()
				triggerServerEvent("onPlayerVehicleAbschlepp", getLocalPlayer(), theVehicle)
				hideUserVehicleClickGui()
			end
			)
			
			UserVehicleClick["Window"]:add(UserVehicleClick["Button"][4])
		
		end
		
		if(getElementData(theVehicle, "Abgeschleppt") == true) and (getElementData(localPlayer, "OnDuty") == true) then
			UserVehicleClick["Button"][5] = new(CDxButton, "Freistellen", 200, 170, 140, 35, tocolor(255,255,255,255), UserVehicleClick["Window"])
			
			UserVehicleClick["Button"][5]:addClickFunction(
			function()
				triggerServerEvent("onPlayerVehicleFreistell", getLocalPlayer(), theVehicle)
				hideUserVehicleClickGui()
			end
			)
			UserVehicleClick["Window"]:add(UserVehicleClick["Button"][5])
		
		end
		
		UserVehicleClick["Button"][1]:addClickFunction(
			function()
				triggerServerEvent("onPlayerExecuteServerCommand", getLocalPlayer(), "park")
			end
		)
		
		UserVehicleClick["Button"][2]:addClickFunction(
			function()
				triggerServerEvent("onVehicleSwitchLock", theVehicle, getLocalPlayer())
				hideUserVehicleClickGui()
			end
		)
		
		UserVehicleClick["Button"][3]:addClickFunction(
			function()
				triggerServerEvent("onPlayerExecuteServerCommand", getLocalPlayer(), "respawn", getElementData(theVehicle, "ID"))
			end
		)
		
		UserVehicleClick["Window"]:add(UserVehicleClick["List"][1])
		UserVehicleClick["Window"]:add(UserVehicleClick["Button"][1])
		UserVehicleClick["Window"]:add(UserVehicleClick["Button"][2])
		UserVehicleClick["Window"]:add(UserVehicleClick["Button"][3])
		
		UserVehicleClick["Window"]:show()
	end
end

function hideUserVehicleClickGui()
	if (UserVehicleClick["Window"]) then
		UserVehicleClick["Window"]:hide()
		delete(UserVehicleClick["Window"])
		UserVehicleClick["Window"] = false
	end
end

