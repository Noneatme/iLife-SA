--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

UserVehicles = {}
local UserVehicleDatas = {}
local preise		= {}

local currentKeys	= {}

UserVehicleGui = {
	["Window"] 		= false,
	["Button"] 		= {},
	["Label"] 		= {},
	["Edit"] 		= {},
	["List"] 		= {},


	["VehicleBlip"] = false,
	["BlipTimer"] 	= false,
}


UserVehicleGui.destroyBlipFunc = function()
	if(isElement(UserVehicleGui["VehicleBlip"])) then
		destroyElement(UserVehicleGui["VehicleBlip"])
		killTimer(UserVehicleGui["BlipTimer"]);
	end
end

UserVehicleGui.locateFunc	= function(uVehicle)

	if(isElement(UserVehicleGui["VehicleBlip"])) then
		destroyElement(UserVehicleGui["VehicleBlip"])
		killTimer(UserVehicleGui["BlipTimer"]);
	end

	local x, y, z = getElementPosition(uVehicle);

	UserVehicleGui["VehicleBlip"] = createBlip(x, y, z, 0, 3, 0, 255, 255, 255, 0, 1337);

	UserVehicleGui["BlipTimer"] = setTimer(UserVehicleGui.destroyBlipFunc, 60000, 1);

	showInfoBox("info", "Dein "..getVehicleNameFromModel(getElementModel(uVehicle)).." wird dir nun auf deiner Karte angezeigt!");

	hud.hudObjects["radar"]:RefreshALShape();
end

function showUserVehicleGui(uPlayer)
	if (not clientBusy) then

		loadingSprite:setEnabled(false);

		hideUserVehicleGui()
		UserVehicleGui["Window"] = new(CDxWindow, "Deine Fahrzeuge", 680, 400, true, true, "Center|Middle", 0, 0, {false, false, "Deine Fahrzeuge"}, "Hier kannst du deine Fahrzeuge betrachten. Benutze die rechte Liste um jemanden einen Schluessel zu geben.")
		UserVehicleGui["Window"]:setHideFunction(function() UserVehicleGui["Window"] = nil end)
		UserVehicleGui["List"][1] = new(CDxList, 10, 10, 300, 350, tocolor(125,125,125,200), UserVehicleGui["Window"])
		UserVehicleGui["List"][1]:addColumn("ID")
		UserVehicleGui["List"][1]:addColumn("Modell")
		UserVehicleGui["List"][1]:addColumn("Schild")
		UserVehicleGui["List"][1]:addColumn("Standort")


		UserVehicleGui["Button"][1] = new(CDxButton, "Abschleppen", 320, 10, 170, 42, tocolor(255,255,255,255), UserVehicleGui["Window"])
		UserVehicleGui["Button"][2] = new(CDxButton, "Lokalisieren", 320, 60, 170, 42, tocolor(255,255,255,255), UserVehicleGui["Window"])
		UserVehicleGui["Button"][3] = new(CDxButton, "Freikaufen", 320, 110, 170, 42, tocolor(255,255,255,255), UserVehicleGui["Window"])

		if not(uPlayer) then
			UserVehicleGui["Button"][4] = new(CDxButton, "Verkaufen", 320, 160, 170, 42, tocolor(255,255,255,255), UserVehicleGui["Window"])
		else
			UserVehicleGui["Button"][4] = new(CDxButton, "An Spieler verkaufen", 320, 160, 170, 42, tocolor(255,255,255,255), UserVehicleGui["Window"])
			showInfoBox("info", "Klicke auf 'an Spieler geben' um das Auto einem Spieler zu verkaufen.");
		end

		-- SCHLUESSEL --
		UserVehicleGui["List"][2] = new(CDxList, 500, 10, 170, 150, tocolor(125,125,125,200), UserVehicleGui["Window"])
		UserVehicleGui["List"][2]:addColumn("Spielername")

		UserVehicleGui["Button"][5] = new(CDxButton, "Schluessel Geben", 500, 170, 170, 42, tocolor(255,255,255,255), UserVehicleGui["Window"])
		UserVehicleGui["Button"][6] = new(CDxButton, "Schluessel entfernen", 500, 170+50, 170, 42, tocolor(255,255,255,255), UserVehicleGui["Window"])

		UserVehicleGui["List"][2]:addClickFunction( function()
			if(UserVehicleGui["List"][2]:getSelectedRow() ~= 0) then
				UserVehicleGui["Button"][6]:setDisabled(false);
			else
				UserVehicleGui["Button"][6]:setDisabled(true);
			end
		end)

		UserVehicleGui["Button"][5]:addClickFunction(function()
			local function absenden()
				local value = confirmDialog.guiEle["edit"]:getText()
				if(value) then
					triggerServerEvent("onPlayerVehicleKeyGive", localPlayer, UserVehicleGui["List"][1]:getRowData(1), value)
					UserVehicleGui["List"][1]:setDisabled(false)
				end
			end
			local function reset()
				UserVehicleGui["List"][1]:setDisabled(false)
			end
			confirmDialog:showConfirmDialog("Bitte gebe den Spielernamen an, dem du einen Schluessel geben moechtest!", absenden, reset, true, true)

			UserVehicleGui["List"][1]:setDisabled(true)
		end)
		UserVehicleGui["Button"][6]:addClickFunction(function()
			if(UserVehicleGui["List"][2]:getSelectedRow() ~= 0) then
				local function absenden()
					triggerServerEvent("onPlayerVehicleKeyRemove", localPlayer, UserVehicleGui["List"][1]:getRowData(1), UserVehicleGui["List"][2]:getRowData(1))
					UserVehicleGui["List"][1]:setDisabled(false)
				end
				local function reset()
					UserVehicleGui["List"][1]:setDisabled(false)
				end
				confirmDialog:showConfirmDialog("Bist du sicher dass du dem Spieler den Schluessel entziehen moechtest?", absenden, reset, true, false)

				UserVehicleGui["List"][1]:setDisabled(true)
			end
		end)
			-- SONSTIGES --

		UserVehicleGui["Button"][1]:setDisabled(true);
		UserVehicleGui["Button"][2]:setDisabled(true);
		UserVehicleGui["Button"][3]:setDisabled(true);
		UserVehicleGui["Button"][4]:setDisabled(true);
		UserVehicleGui["Button"][5]:setDisabled(true);
		UserVehicleGui["Button"][6]:setDisabled(true);

		UserVehicleGui["Button"][1]:addClickFunction(
		function()
			if (UserVehicleGui["List"][1]:getSelectedRow() ~= 0) then
				triggerServerEvent("onUserVehicleRespawnRequest", getLocalPlayer(), UserVehicleGui["List"][1]:getRowData(1))
				loadingSprite:setEnabled(true);
			else
				showInfoBox("error", "Du musst ein Fahrzeug auswählen!")
			end
		end)

		if(UserVehicles) then
			local sortedTable = UserVehicles
			table.sort(sortedTable, function(a, b) return getVehicleNameFromModel(tonumber(a["VID"])) < getVehicleNameFromModel(tonumber(b["VID"])) end)

			for k,v in ipairs(sortedTable) do
				local vehicle = UserVehicleDatas[tonumber(v["ID"])];
				if(vehicle) then
					local x, y, z = getElementPosition(vehicle);
					local zone = getZoneName(x, y, z, false)
					local zone2 = getZoneName(x, y, z, true);

					if(zone2 == "Los Santos") then
						zone2 = "LS"
					elseif(zone2 == "San Fierro") then
						zone2 = "SF"
					elseif(zone2 == "Las Venturas") then
						zone2 = "LV"
					end
					zone = zone..", "..zone2

					local name = tostring(getVehicleNameFromModel(tonumber(v["VID"])))

					if(string.len(name) < 2) then
						name = "Unbekannt"
					end

					UserVehicleGui["List"][1]:addRow((tonumber(v["ID"]) or 0).."|"..name.."|"..tostring(v["Plate"] or "Unbekannt").."|"..tostring(zone or "Unbekannt"))
				end
			end
		end
		UserVehicleGui["List"][1]:addClickFunction( function()
			local enabled = {}
			UserVehicleGui["List"][2]:clearRows();

			if(UserVehicleGui["List"][1]:getSelectedRow() ~= 0) then
				enabled[1] = true;
				enabled[4] = true;

				enabled[5] = true;
				enabled[6] = false;

				local iID = tonumber(UserVehicleGui["List"][1]:getRowData(1));
				if(iID) then
					local vehicle = UserVehicleDatas[iID];
					if(getElementData(vehicle, "tuningteil:GPS") == true) then
						enabled[2] = true;
					end

					if(getElementData(vehicle, "Abgeschleppt") == true) then
						enabled[3] = true;
					end

					if(getElementData(vehicle, "vehiclerequest") == true) then
						UserVehicleGui["Button"][4]:setText("Angebot zurueckziehen");
					else

						if not(uPlayer) then
							UserVehicleGui["Button"][4]:setText("Verkaufen")
						else
							UserVehicleGui["Button"][4]:setText("An Spieler verkaufen");
						end
					end
					local keys		= getElementData(vehicle, "takeys");

					if(keys) and (fromJSON(keys)) then
						keys		= fromJSON(keys);

						currentKeys	= keys;

						for id, playername in pairs(keys) do
							if(playername) then
								UserVehicleGui["List"][2]:addRow(playername.."|");
							end
						end
					end
				end

				for i = 1, 6, 1 do
					if(enabled[i] == true) then
						UserVehicleGui["Button"][i]:setDisabled(false);
					else
						UserVehicleGui["Button"][i]:setDisabled(true);
					end
				end


			end
		end)

		UserVehicleGui["Button"][2]:addClickFunction(function()
			local iID = tonumber(UserVehicleGui["List"][1]:getRowData(1));
			if(iID) then
				local vehicle = UserVehicleDatas[iID];
				UserVehicleGui.locateFunc(vehicle);
			end
		end)

		UserVehicleGui["Button"][3]:addClickFunction(function()
			local iID = tonumber(UserVehicleGui["List"][1]:getRowData(1));
			if(iID) then
				local vehicle = UserVehicleDatas[iID];
				triggerServerEvent("onPlayerVehicleCallback", localPlayer, vehicle);
				loadingSprite:setEnabled(true);
			end
		end)

		UserVehicleGui["Button"][4]:addClickFunction(function()
			local iID = tonumber(UserVehicleGui["List"][1]:getRowData(1));
			if(iID) then
				local iID2 = iID;
				iID = UserVehicleDatas[iID];
				local vName = getVehicleNameFromModel(getElementModel(iID));
				local preis	= (preise[getElementModel(iID)] or 0)

				if(isElement(uPlayer)) then
					confirmDialog:showConfirmDialog("Fuer wieviel $ willst du dein(en) "..vName.." an "..getPlayerName(uPlayer).." verkaufen?\nNormaler Preis: $"..preis, function()
						local dollar = tonumber(confirmDialog.guiEle["edit"]:getText());
						if(dollar) and (dollar >= 0) then
							triggerServerEvent("onPlayerUserVehicleMakeSellRequest", localPlayer, uPlayer, iID2, dollar)
							loadingSprite:setEnabled(true);
							hideUserVehicleGui();
						end
					end, false, false, true)


				elseif(getElementData(iID, "vehiclerequest") == true) then
					triggerServerEvent("onPlayerUserVehicleMakeSellRequest", localPlayer, uPlayer, iID2, 9999999)
					loadingSprite:setEnabled(true);
					hideUserVehicleGui();

				else
					confirmDialog:showConfirmDialog("Moechtest du dein(en) "..vName.." verkaufen?\nDu wirst $"..math.floor(preis/100*50).." erhalten.", function()
						triggerServerEvent("onPlayerUserVehicleSell", localPlayer, iID2)
						loadingSprite:setEnabled(true);
					end, false, true)
				end
			end
		end)


		UserVehicleGui["Window"]:add(UserVehicleGui["List"][1])
		UserVehicleGui["Window"]:add(UserVehicleGui["List"][2])
		UserVehicleGui["Window"]:add(UserVehicleGui["Button"][1])
		UserVehicleGui["Window"]:add(UserVehicleGui["Button"][2])
		UserVehicleGui["Window"]:add(UserVehicleGui["Button"][3])
		UserVehicleGui["Window"]:add(UserVehicleGui["Button"][4])
		UserVehicleGui["Window"]:add(UserVehicleGui["Button"][5])
		UserVehicleGui["Window"]:add(UserVehicleGui["Button"][6])
		UserVehicleGui["Window"]:show()
	end
end
addEvent("showUserVehicleGui", true)
addEventHandler("showUserVehicleGui", getRootElement(), showUserVehicleGui)

function hideUserVehicleGui()
	if (UserVehicleGui["Window"]) then
		UserVehicleGui["Window"]:hide()
		delete(UserVehicleGui["Window"])
		UserVehicleGui["Window"] = false
	end
end
addEvent("closeUserVehicleGui", true)
addEventHandler("closeUserVehicleGui", getRootElement(), hideUserVehicleGui)


function receiveUserVehicles(data, tblPreise, thePlayer)
	UserVehicles = data
	preise		 = tblPreise;
	if(UserVehicles) then
		for index, data in pairs(UserVehicles) do
			UserVehicleDatas[tonumber(data["ID"])] = data["Vehicle"];
		end
	end
	--if (UserVehicleGui["Window"]) then
	hideUserVehicleGui()
	showUserVehicleGui(thePlayer)
	--end
end
addEvent("onClientReceivUserVehicles", true)
addEventHandler("onClientReceivUserVehicles", getRootElement(), receiveUserVehicles)

function requestUserVehicles(thePlayer)
	triggerServerEvent("onPlayerRequestUserVehicles", getLocalPlayer(), thePlayer)
end

bindKey(_Gsettings.keys.Vehicles, "down",
function()
	if (UserVehicleGui["Window"]) then
		hideUserVehicleGui()
	else
		requestUserVehicles()
	end
end
)
