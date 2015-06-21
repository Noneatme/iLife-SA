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
				if (getElementType(clickedWorld) == "object") then
					local x1, y1, z1 = getElementPosition(clickedWorld)
					local x2, y2, z2 = getCameraMatrix(localPlayer);
					
					if(getDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2) < 15) then
						showObjectClickGui(clickedWorld)
					else
						showInfoBox("error", "Du bist zu weit entfernt!")
					end
				end
			end
		end
	end
)

ObjectClick = {
	["Window"] = false,
	["Image"] = {},
	["List"] = {},
	["Button"] = {}
}

function showObjectClickGui(uObject)
	if (not clientBusy) then
		hideObjectClickGui()
		
		ObjectClick["Window"] = new(CDxWindow, "Objekt", 400, 320, true, true, "Center|Middle")
		
		ObjectClick["List"][1] = new(CDxList, 5, 10, 235, 280, tocolor(125,125,125,200), ObjectClick["Window"])
		ObjectClick["List"][1]:addColumn("Attribut")
		ObjectClick["List"][1]:addColumn("Wert")
		
		ObjectClick["List"][1]:addRow("ID|"..getElementModel(uObject))
	
		local sOwner = getElementData(uObject, "wa:OwnerName");
		if not(sOwner) then
			sOwner = "Niemand";
		end
		
		local sUrl = getElementData(uObject, "wa:radio_url");
		if not(sUrl) or (tonumber(sUrl) == 0) then
			sUrl = "-";
		end
		
		ObjectClick["List"][1]:addRow("Besitzer|"..sOwner)
		ObjectClick["List"][1]:addRow("Groesse|"..getObjectScale(uObject))
		ObjectClick["List"][1]:addRow("Masse|"..getObjectMass(uObject))
	
		ObjectClick["List"][1]:addRow("Aufnehmbar|Kann sein");
		ObjectClick["List"][1]:addRow("Radio-URL|"..sUrl);
	
	
		ObjectClick["Button"][1] = new(CDxButton, "Bewegen", 250, 10, 140, 35, tocolor(255,255,255,255), ObjectClick["Window"])
		ObjectClick["Button"][2] = new(CDxButton, "Interagieren", 250, 60, 140, 35, tocolor(255,255,255,255), ObjectClick["Window"])
		ObjectClick["Button"][3] = new(CDxButton, "Aufheben", 250, 110, 140, 35, tocolor(255,255,255,255), ObjectClick["Window"])
		
		ObjectClick["Button"][1]:addClickFunction(function()
			hideObjectClickGui();
			objectMover:ToggleGuiAction("move", uObject);
		end)
		
		ObjectClick["Button"][2]:addClickFunction(function()
			hideObjectClickGui();
			objectMover:ToggleGuiAction("interact", uObject);
		end)
		
		ObjectClick["Button"][3]:addClickFunction(function()
			hideObjectClickGui();
			objectMover:ToggleGuiAction("pickup", uObject);
		end)
		
		if(sOwner == "Niemand") then
			for i = 1, 3, 1 do
				ObjectClick["Button"][i]:setDisabled(true);
			end
		end
		ObjectClick["Window"]:add(ObjectClick["Button"][1])
		ObjectClick["Window"]:add(ObjectClick["Button"][2])
		ObjectClick["Window"]:add(ObjectClick["Button"][3])
		
	
		
		ObjectClick["Window"]:add(ObjectClick["List"][1])
		ObjectClick["Window"]:show()
	end
end

function hideObjectClickGui()
	if (ObjectClick["Window"]) then
		ObjectClick["Window"]:hide()
		delete(ObjectClick["Window"])
		ObjectClick["Window"] = false
	end
end

