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
					if (getElementData(clickedWorld, "UserVehicle") or getElementData(clickedWorld, "FactionVehicle") or getElementData(clickedWorld, "CorporationVehicle")) then
						showUserVehicleClickGui(clickedWorld)
					end
				end
			end
		end
		if (button == "left" and state == "down") then
			if (clickedWorld) then
				if (not clientBusy) then
					if (getElementType(clickedWorld) == "vehicle") then
						if (getElementData(clickedWorld, "UserVehicle") or getElementData(clickedWorld, "FactionVehicle") or getElementData(clickedWorld, "CorporationVehicle")) then
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

local TTP
local VC

function showUserVehicleClickGui(theVehicle)
	if (not clientBusy) then
		if not(TTP) then
			TTP = TuningTeilPreise:New()
		end
		if not(VC) then
			VC = vehicleCategoryManager
		end
		hideUserVehicleClickGui()

		local type		= "User"

		local unknown = getLocalizationString("default_string_unknown")

		if(getElementData(theVehicle, "Type")) then
			type = getElementData(theVehicle, "Type")
		end

		UserVehicleClick["Window"] = new(CDxWindow, getLocalizationString("GUI_clicksystem_uservehicle_title"), 350, 320, true, true, "Center|Middle")

		UserVehicleClick["List"][1] = new(CDxList, 5, 10, 190, 280, tocolor(125,125,125,200), UserVehicleClick["Window"])
		UserVehicleClick["List"][1]:addColumn(getLocalizationString("GUI_clicksystem_uservehicle_list1_columntitle_1"))
		UserVehicleClick["List"][1]:addColumn(getLocalizationString("GUI_clicksystem_uservehicle_list1_columntitle_2"))

		UserVehicleClick["List"][1]:addRow(getLocalizationString("GUI_clicksystem_uservehicle_list_attribut_modell").."|"..getVehicleName(theVehicle) or unknown)
		UserVehicleClick["List"][1]:addRow(getLocalizationString("GUI_clicksystem_uservehicle_list_attribut_typ").."|"..(type or unknown))
			local category = VC:getCategoryName(VC:getVehicleCategory(theVehicle)) or "vehicle_category_special"
		UserVehicleClick["List"][1]:addRow(getLocalizationString("GUI_clicksystem_uservehicle_list_attribut_category").."|"..( getLocalizationString("GUI_clicksystem_uservehicle_list_value_"..category) or unknown))
		UserVehicleClick["List"][1]:addRow(getLocalizationString("GUI_clicksystem_uservehicle_list_attribut_owner").."|"..tostring(getElementData(theVehicle, "OwnerName") or unknown))
		UserVehicleClick["List"][1]:addRow(getLocalizationString("GUI_clicksystem_uservehicle_list_attribut_plate").."|"..(getElementData(theVehicle, "Plate") or getVehiclePlateText(theVehicle)))

		local lock = getElementData(theVehicle, "Locked") == true and getLocalizationString("default_string_yes") or getLocalizationString("default_string_no")
		local engine = getElementData(theVehicle, "Engine") == true and getLocalizationString("default_string_on") or getLocalizationString("default_string_off")

		local kaufdatum	= getElementData(theVehicle, "Kaufdatum")
		if not(kaufdatum) then
			kaufdatum = getLocalizationString("default_string_unknown")
		end

		UserVehicleClick["List"][1]:addRow(getLocalizationString("GUI_clicksystem_uservehicle_list_attribut_locked").."|"..lock)
		UserVehicleClick["List"][1]:addRow(getLocalizationString("GUI_clicksystem_uservehicle_list_attribut_enginestate").."|"..engine)
		UserVehicleClick["List"][1]:addRow(getLocalizationString("GUI_clicksystem_uservehicle_list_attribut_purchasedate").."|"..kaufdatum)


		-- Tunings --
		UserVehicleClick["List"][1]:addRow("   "..getLocalizationString("GUI_clicksystem_uservehicle_list_attribut_tunings")..":|".." ");

		local kofferaum			= false;
		local ersatzreifen 		= false;

		for tuning, cost in pairs(TTP.ItemPrices) do
			local upgrade 	= getElementData(theVehicle, "tuningteil:"..tuning)
			local text 		= getLocalizationString("default_string_no")
			if(upgrade) then
				text 		= getLocalizationString("default_string_yes")
			end

			if(tuning == "Bessere Hydraulik") then
				tuning = getLocalizationString("GUI_clicksystem_uservehicle_tuning_hydraulics");
			end
			if(tuning == "Kofferaum") and ((text == "Ja") or (type == "Corporationsfahrzeug")) and not(isVehicleLocked(theVehicle)) then
				kofferaum = true
			end
			if(tuning == "Ersatzreifen") and (text == "Ja") then
				ersatzreifen = true;
			end
			UserVehicleClick["List"][1]:addRow(tuning.."|"..text)

		end

		UserVehicleClick["Button"][1] = new(CDxButton, getLocalizationString("GUI_clicksystem_uservehicle_button_park"), 200, 10, 140, 35, tocolor(255,255,255,255), UserVehicleClick["Window"])
		local lock = getElementData(theVehicle, "Locked") == true and getLocalizationString("GUI_clicksystem_uservehicle_button_unlock") or getLocalizationString("GUI_clicksystem_uservehicle_button_lock")
		UserVehicleClick["Button"][2] = new(CDxButton, lock, 200, 50, 140, 35, tocolor(255,255,255,255), UserVehicleClick["Window"])
		UserVehicleClick["Button"][3] = new(CDxButton, getLocalizationString("GUI_clicksystem_uservehicle_button_respawn"), 200, 90, 140, 35, tocolor(255,255,255,255), UserVehicleClick["Window"])


		if(type ~= "User") then
			UserVehicleClick["Button"][1]:setDisabled(true)
			UserVehicleClick["Button"][3]:setDisabled(true)
		end
		local abgeschleppt = false;
		-- Abschleppen --
		if(getElementData(theVehicle, "v:AbgeschlepptVon") == localPlayer) and (getElementData(localPlayer, "OnDuty") == true) then
			UserVehicleClick["Button"][4] = new(CDxButton, getLocalizationString("GUI_clicksystem_uservehicle_button_tow"), 200, 130, 140, 35, tocolor(255,255,255,255), UserVehicleClick["Window"])

			UserVehicleClick["Button"][4]:addClickFunction(
			function()
				triggerServerEvent("onPlayerVehicleAbschlepp", getLocalPlayer(), theVehicle)
				hideUserVehicleClickGui()
			end
			)

			UserVehicleClick["Window"]:add(UserVehicleClick["Button"][4])
			abgeschleppt = true;
		end

		if(getElementData(theVehicle, "Abgeschleppt") == true) and (getElementData(localPlayer, "OnDuty") == true) then
			UserVehicleClick["Button"][5] = new(CDxButton, getLocalizationString("GUI_clicksystem_uservehicle_button_untow"), 200, 170, 140, 35, tocolor(255,255,255,255), UserVehicleClick["Window"])

			UserVehicleClick["Button"][5]:addClickFunction(
			function()
				triggerServerEvent("onPlayerVehicleFreistell", getLocalPlayer(), theVehicle)
				hideUserVehicleClickGui()
			end
			)
			UserVehicleClick["Window"]:add(UserVehicleClick["Button"][5])
			abgeschleppt = true
		end

		if not(abgeschleppt) then
			UserVehicleClick["Button"][4] = new(CDxButton, getLocalizationString("GUI_clicksystem_uservehicle_button_trunk"), 200, 130, 140, 35, tocolor(255,255,255,255), UserVehicleClick["Window"])
			UserVehicleClick["Button"][5] = new(CDxButton, getLocalizationString("GUI_clicksystem_uservehicle_button_tires"), 200, 170, 140, 35, tocolor(255,255,255,255), UserVehicleClick["Window"])

			if not(kofferaum) then
				UserVehicleClick["Button"][4]:setDisabled(true)
			end
			if not(ersatzreifen) then
				UserVehicleClick["Button"][5]:setDisabled(true)
			end
		end


		if(getElementData(localPlayer, "Adminlevel") > 0) and (type == "User") then
			UserVehicleClick["Window"].Width = UserVehicleClick["Window"].Width+155;

			UserVehicleClick["Button"]["warn"] = new(CDxButton, getLocalizationString("GUI_clicksystem_uservehicle_button_warnuser"), 355, 10, 140, 35, tocolor(255,255,255,255), UserVehicleClick["Window"])
			UserVehicleClick["Window"]:add(UserVehicleClick["Button"]["warn"])

			UserVehicleClick["Button"]["warn"]:addClickFunction(function()
				confirmDialog:showConfirmDialog("Hiermit wird eine Nachricht an dem User gesendet.(Kein Warn!)", function()
					local msg = confirmDialog.guiEle["edit"]:getText();
					triggerServerEvent("onOfflineMSGWrite", localPlayer, tostring(getElementData(theVehicle, "OwnerName")), "Dein Auto "..getVehicleName(theVehicle).." wurde von Admin "..getPlayerName(localPlayer).." verwarnt!("..msg..")");
				end, false, true, true)
			end)

			UserVehicleClick["Button"]["delete"] = new(CDxButton, getLocalizationString("GUI_clicksystem_uservehicle_button_deletevehicle"), 355, 50, 140, 35, tocolor(255,255,255,255), UserVehicleClick["Window"])
			UserVehicleClick["Window"]:add(UserVehicleClick["Button"]["delete"])


			UserVehicleClick["Button"]["delete"]:addClickFunction(function()
				confirmDialog:showConfirmDialog("Moechtest du das Fahrzeug wirklich loeschen?\nGrund:(Optional)", function()
					local msg = confirmDialog.guiEle["edit"]:getText();
					triggerServerEvent("onUserVehicleAdminDelete", localPlayer, tonumber(getElementData(theVehicle, "ID")), msg);
				end, false, true, true)
			end)

			if(getElementData(localPlayer, "Adminlevel") >= 3) then

				UserVehicleClick["Button"]["chgmdl"] = new(CDxButton, getLocalizationString("GUI_clicksystem_uservehicle_button_changemodel"), 355, 90, 140, 35, tocolor(255,255,255,255), UserVehicleClick["Window"])
				UserVehicleClick["Window"]:add(UserVehicleClick["Button"]["chgmdl"])


				UserVehicleClick["Button"]["chgmdl"]:addClickFunction(function()
					confirmDialog:showConfirmDialog("Neue ModellID eingeben:\n1337 hinter schreiben, um das Auto zu tunen.", function()
						local id = tonumber(confirmDialog.guiEle["edit"]:getText());
						if(id) and (id >= 400) and (id <= 611) or (string.find(tostring(id), "1337")) then
							triggerServerEvent("onUserVehicleAdminChangeModel", localPlayer, tonumber(getElementData(theVehicle, "ID")), id);
						end
					end, false, true, true)
				end)
			end
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
		UserVehicleClick["Button"][4]:addClickFunction(
			function()
				if not(isPedInVehicle(localPlayer)) then
					local x, y, z = getElementPosition(localPlayer)
					local x2, y2, z2 = getElementPosition(theVehicle);
					if(getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) < 10) then
						if(type == "User") or (type == "Corporationsfahrzeug") then
							clientBusy = false
							hideUserVehicleClickGui()
							cKofferaumGUI:getInstance():show(tonumber(getElementData(theVehicle, "ID")), type);
						end
					else
						showInfoBox("error", "Du musst naeher drann!");
					end
				else
					showInfoBox("error", "Du musst aus deinem Fahrzeug aussteigen!");
				end
			end
		)
		UserVehicleClick["Button"][5]:addClickFunction(
			function()
				if not(isPedInVehicle(localPlayer)) then
					if(type == "User") then
						local x, y, z = getElementPosition(localPlayer)
						local x2, y2, z2 = getElementPosition(theVehicle);
						if(getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) < 10) then
							triggerServerEvent("onPlayerErsatzreifenUse", localPlayer, getElementData(theVehicle, "ID"))
						else
							showInfoBox("error", "Du musst naeher drann!");
						end
					end
				else
					showInfoBox("error", "Du musst aus deinem Fahrzeug aussteigen!");
				end
			end
		)
		UserVehicleClick["Window"]:add(UserVehicleClick["List"][1])
		UserVehicleClick["Window"]:add(UserVehicleClick["Button"][1])
		UserVehicleClick["Window"]:add(UserVehicleClick["Button"][2])
		UserVehicleClick["Window"]:add(UserVehicleClick["Button"][3])
		UserVehicleClick["Window"]:add(UserVehicleClick["Button"][4])
		UserVehicleClick["Window"]:add(UserVehicleClick["Button"][5])

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
