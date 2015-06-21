--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

-- #######################################
-- ## Project: MTA iLife				##
-- ## Name: TuningGarage.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

TuningGarage = {};
TuningGarage.__index = TuningGarage;


local vehicleUpgradeNames =
{
	[1000]="Pro",
	[1001]="Win",
	[1002]="Drag",
	[1003]="Alpha",
	[1004]="Champ Scoop",
	[1005]="Fury Scoop",
	[1006]="Roof Scoop",
	[1007]="Sideskirt",
	[1008]="5x Aufladungen",
	[1009]="2x Aufladungen",
	[1010]="10x Aufladungen",
	[1011]="Race Scoop",
	[1012]="Worx Scoop",
	[1013]="Round Fog",
	[1014]="Champ",
	[1015]="Race",
	[1016]="Worx",
	[1017]="Sideskirt",
	[1018]="Upswept",
	[1019]="Twin",
	[1020]="Large",
	[1021]="Medium",
	[1022]="Small",
	[1023]="Fury",
	[1024]="Square Fog",
	[1025]="Offroad",
	[1026]="Alien",
	[1027]="Alien",
	[1028]="Alien",
	[1029]="X-Flow",
	[1030]="X-Flow",
	[1031]="X-Flow",
	[1032]="Alien",
	[1033]="Alien",
	[1034]="Alien",
	[1035]="Alien",
	[1036]="Alien",
	[1037]="X-Flow",
	[1038]="Alien",
	[1039]="X-Flow",
	[1040]="Alien",
	[1041]="X-Flow",
	[1042]="Chrome",
	[1043]="Slamin",
	[1044]="Chrome",
	[1045]="X-Flow",
	[1046]="Alien",
	[1047]="Alien",
	[1048]="X-Flow",
	[1049]="Alien",
	[1050]="X-Flow",
	[1051]="Alien",
	[1052]="X-Flow",
	[1053]="X-Flow",
	[1054]="Alien",
	[1055]="Alien",
	[1056]="Alien",
	[1057]="X-Flow",
	[1058]="Alien",
	[1059]="X-Flow",
	[1060]="X-Flow",
	[1061]="X-Flow",
	[1062]="Alien",
	[1063]="X-Flow",
	[1064]="Alien",
	[1065]="Alien",
	[1066]="X-Flow",
	[1067]="Alien",
	[1068]="X-Flow",
	[1069]="Alien",
	[1070]="X-Flow",
	[1071]="Alien",
	[1072]="X-Flow",
	[1073]="Shadow",
	[1074]="Mega",
	[1075]="Rimshine",
	[1076]="Wires",
	[1077]="Classic",
	[1078]="Twist",
	[1079]="Cutter",
	[1080]="Switch",
	[1081]="Grove",
	[1082]="Import",
	[1083]="Dollar",
	[1084]="Trance",
	[1085]="Atomic",
	[1086]="Stereo",
	[1087]="Hydraulics",
	[1088]="Alien",
	[1089]="X-Flow",
	[1090]="Alien",
	[1091]="X-Flow",
	[1092]="Alien",
	[1093]="X-Flow",
	[1094]="Alien",
	[1095]="X-Flow",
	[1096]="Ahab",
	[1097]="Virtual",
	[1098]="Access",
	[1099]="Sideskirt",
	[1100]="Chrome Grill",
	[1101]="Chrome Flames",
	[1102]="Chrome Strip",
	[1103]="Covertible",
	[1104]="Chrome",
	[1105]="Slamin",
	[1106]="Chrome Arches",
	[1107]="Chrome Strip",
	[1108]="Chrome Strip",
	[1109]="Chrome",
	[1110]="Slamin",
	[1111]="Little Sign?",
	[1112]="Little Sign?",
	[1113]="Chrome",
	[1114]="Slamin",
	[1115]="Chrome",
	[1116]="Slamin",
	[1117]="Chrome",
	[1118]="Chrome Trim",
	[1119]="Wheelcovers",
	[1120]="Chrome Trim",
	[1121]="Wheelcovers",
	[1122]="Chrome Flames",
	[1123]="Bullbar Chrome Bars",
	[1124]="Chrome Arches",
	[1125]="Bullbar Chrome Lights",
	[1126]="Chrome Exhaust",
	[1127]="Slamin Exhaust",
	[1128]="Vinyl Hardtop",
	[1129]="Chrome",
	[1130]="Hardtop",
	[1131]="Softtop",
	[1132]="Slamin",
	[1133]="Chrome Strip",
	[1134]="Chrome Strip",
	[1135]="Slamin",
	[1136]="Chrome",
	[1137]="Chrome Strip",
	[1138]="Alien",
	[1139]="X-Flow",
	[1140]="X-Flow",
	[1141]="Alien",
	[1142]="Oval Vents",
	[1143]="Oval Vents",
	[1144]="Square Vents",
	[1145]="Square Vents",
	[1146]="X-Flow",
	[1147]="Alien",
	[1148]="X-Flow",
	[1149]="Alien",
	[1150]="Alien",
	[1151]="X-Flow",
	[1152]="X-Flow",
	[1153]="Alien",
	[1154]="Alien",
	[1155]="Alien",
	[1156]="X-Flow",
	[1157]="X-Flow",
	[1158]="X-Flow",
	[1159]="Alien",
	[1160]="Alien",
	[1161]="X-Flow",
	[1162]="Alien",
	[1163]="X-Flow",
	[1164]="Alien",
	[1165]="X-Flow",
	[1166]="Alien",
	[1167]="X-Flow",
	[1168]="Alien",
	[1169]="Alien",
	[1170]="X-Flow",
	[1171]="Alien",
	[1172]="X-Flow",
	[1173]="X-Flow",
	[1174]="Chrome",
	[1175]="Slamin",
	[1176]="Chrome",
	[1177]="Slamin",
	[1178]="Slamin",
	[1179]="Chrome",
	[1180]="Chrome",
	[1181]="Slamin",
	[1182]="Chrome",
	[1183]="Slamin",
	[1184]="Chrome",
	[1185]="Slamin",
	[1186]="Slamin",
	[1187]="Chrome",
	[1188]="Slamin",
	[1189]="Chrome",
	[1190]="Slamin",
	[1191]="Chrome",
	[1192]="Chrome",
	[1193]="Slamin"
}

--[[
-- Nur 1 Objekt erstellen!
-- Managerklasse
]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function TuningGarage:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// UpdateComponentTableForSlot
-- ///// Returns: void		//////
-- ///////////////////////////////

function TuningGarage:UpdateComponentTableForSlot(iSlotID)
	if(self.items["default-page"][iSlotID]) then
		local vehicle = getPedOccupiedVehicle(localPlayer)
		local iSlot = self.items["default-page"][iSlotID][3] or -1;
		local sPage = self.items["default-page"][iSlotID][2];
		self.currentSlotID = (iSlot or -1);
		local upgrades = getVehicleCompatibleUpgrades(vehicle, iSlot);

		self.upgradeSlots = {}
		local index = 1;
		if(upgrades) and (iSlot) then
			for upgradeKey, upgradeValue in ipairs (upgrades) do
				if(upgradeValue) then
					self.items[sPage][index] = {vehicleUpgradeNames[upgradeValue].." - "..upgradeValue, "default-page"};
					self.upgradeSlots[index] = upgradeValue;
					index = index+1;
				end
			end
		end


		if(sPage == "page_sonstiges") then
			local index = 1;
			for tune, tbl in pairs(self.tuningTeilPreise.ItemPrices) do
				self.items[sPage][index] = {" - "..tune};
				self.upgradeSlots[index] = tune;

				index = index+1;
			end
		end

		if(#self.items[sPage] < 1) and not(self.noItemsPages[sPage]) then

			self.items[sPage][#self.items[sPage]+1] = {"Kein Upgrade Vorhanden", "default-page"};
		end
	end
end


-- ///////////////////////////////
-- ///// SelectPage			//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function TuningGarage:SelectPage(sPage, iID)
	if(self.items[sPage]) then

		if(self.selectedPage == "default-page") and (iID) then
			self:UpdateComponentTableForSlot(iID)
			self.oldCurrentIndex = self.currentIndex;

		end

		self.selectedPage = sPage;

		self.currentIndex = 1;

		if(self.selectedPage == "default-page") then
			self.currentIndex = self.oldCurrentIndex;
		end

		self:RefreshGuiComponents()
	end
end

-- ///////////////////////////////
-- ///// DestroyGuiComponents/////
-- ///// Returns: void		//////
-- ///////////////////////////////

function TuningGarage:DestroyGui()
	for index, guiEle in pairs(self.guiEle) do
		if(isElement(guiEle)) then
			destroyElement(guiEle);
		end
	end
end

-- ///////////////////////////////
-- ///// PreviewUpgrade		 /////
-- ///// Returns: void		//////
-- ///////////////////////////////

function TuningGarage:PreviewUpgrade(iUpgradeID)

	if(iUpgradeID) then
		addVehicleUpgrade(self.vehicle, iUpgradeID)
	end

	if(iUpgradeID == 2100) then
		setVehiclePaintjob(self.vehicle, 0)
	elseif(iUpgradeID == 2101) then
		setVehiclePaintjob(self.vehicle, 1)
	elseif(iUpgradeID == 2102) then
		setVehiclePaintjob(self.vehicle, 2)
	elseif(iUpgradeID == 2103) then
		setVehiclePaintjob(self.vehicle, 3)
	end
end

-- ///////////////////////////////
-- ///// LoadBoughtUpgrades	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function TuningGarage:LoadBoughtUpgrades()
	local upgrades = getVehicleUpgrades(self.vehicle);

	for i = 0, 50, 1 do
		self.upgradeInstalled[i] = nil;
		local iUpgrade = getVehicleUpgradeOnSlot(self.vehicle, i);
		if(iUpgrade) then
			self.upgradeInstalled[i] = iUpgrade;
		end

		for index, tbl in pairs(self.tuningTeilPreise.ItemPrices) do
			self.upgradeInstalled[index] = getElementData(self.vehicle, "tuningteil:"..index);
		end
	end

	-- Color

	local r1, g1, b1, r2, g2, b2, r3, g3, b3, r4, g4, b4 = getVehicleColor(self.vehicle, true);
	local lr, lg, lb = getVehicleHeadLightColor(self.vehicle);



	self.colorTable[1] = {r1, g1, b1};
	self.colorTable[2] = {r2, g2, b2};
	self.colorTable[3] = {r3, g3, b3};
	self.colorTable[4] = {r4, g4, b4};
	self.colorTable[5] = {lr, lg, lb};

end

-- ///////////////////////////////
-- ///// SellUpgrades		 /////
-- ///// Returns: void		//////
-- ///////////////////////////////

function TuningGarage:SellUpgrade(slotID, upgrade)
	playSound("res/sounds/shop/sell.wav", false);
	local slot = slotID;

	if not(self.tuningTeilPreise.ItemPrices[upgrade]) then
		removeVehicleUpgrade(self.vehicle, upgrade)

	else
		slot = upgrade;
	end

	local nitro = {[1008] = 75, [1009] = 125, [1010] = 150}

	local preis = self.preis;
	if (nitro[upgrade]) then
		preis = nitro[upgrade];
	end

	if(self.tuningTeilPreise.ItemPrices[upgrade]) then
		preis = self.tuningTeilPreise.ItemPrices[upgrade];
	end

	self.upgradeInstalled[slot] = nil;


	triggerServerEvent("onPlayerTuningteilVerkauf", localPlayer, slot, upgrade, preis);

end


-- ///////////////////////////////
-- ///// BuyUpgrade			 /////
-- ///// Returns: void		//////
-- ///////////////////////////////

function TuningGarage:BuyUpgrade(iUpgradeID)
	if(iUpgradeID) then
		local slotID = self.currentSlotID;

		if(self.tuningTeilPreise.ItemPrices[iUpgradeID]) then
			-- Custom Tuningteil

			if(self.upgradeInstalled[iUpgradeID]) then
				self:SellUpgrade(iUpgradeID, iUpgradeID);
			else
				local preis = self.tuningTeilPreise.ItemPrices[iUpgradeID];
				if(preis <= getPlayerMoney()) then
					self.upgradeInstalled[iUpgradeID] = true;
					playSound("res/sounds/shop/buy.wav", false);
					triggerServerEvent("onPlayerTuningteilKauf", localPlayer, iUpgradeID, iUpgradeID, preis, self.tuningGarageID);
				else
					showInfoBox("error", "Du hast nicht soviel Geld auf der Hand!")
				end
				return false;
			end
		else
			if(self.upgradeInstalled[slotID] and self.upgradeInstalled[slotID] == iUpgradeID) then
				self:SellUpgrade(slotID, self.upgradeInstalled[slotID]);
			else
				local nitro = {[1008] = 75, [1009] = 125, [1010] = 150}

				local preis = self.preis;
				if (nitro[iUpgrade]) then
					preis = nitro[iUpgrade];
				end

				if(preis <= getPlayerMoney()) then
					self.upgradeInstalled[slotID] = iUpgradeID;
					self:DontPreviewUpgrade(iUpgradeID)
					playSound("res/sounds/shop/buy.wav", false);
					triggerServerEvent("onPlayerTuningteilKauf", localPlayer, slotID, iUpgradeID, preis, self.tuningGarageID);
					return true;
				else
					showInfoBox("error", "Du hast nicht soviel Geld auf der Hand!")
				end
				return false;
			end
		end

	end
	return false;
end

-- ///////////////////////////////
-- ///// DontPreviewUpgrade	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function TuningGarage:DontPreviewUpgrade(iUpgradeID)
	if(iUpgradeID) then
		local slotID = self.currentSlotID;
		--		outputChatBox(slotID..", "..tostring(self.upgradeInstalled[slotID]))
		if(self.upgradeInstalled[slotID] ~= iUpgradeID) then
			removeVehicleUpgrade(self.vehicle, iUpgradeID)
			if(self.upgradeInstalled[slotID]) then
				addVehicleUpgrade(self.vehicle, self.upgradeInstalled[slotID])
			end
		else
			addVehicleUpgrade(self.vehicle, self.upgradeInstalled[slotID])
		end

	end

end

-- ///////////////////////////////
-- ///// updateVariant		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function TuningGarage:updateVariant()
	triggerServerEvent("onPlayerTuninggarageVariantPreview", localPlayer, self.m_iCurVariant1, self.m_iCurVariant2);
end


-- ///////////////////////////////
-- ///// RefreshGuiComponents/////
-- ///// Returns: void		//////
-- ///////////////////////////////

function TuningGarage:RefreshGuiComponents()
	-- Delete Old Gui --
	local aesx, aesy = 1440, 900;
	local sx, sy = guiGetScreenSize();
	local max_items		= self.maxItems;

	for index, guiEle in pairs(self.guiEle) do
		if(isElement(guiEle)) then
			destroyElement(guiEle);
		end
	end

	-- Items --

	local items = self.items[self.selectedPage];
	local current_add 	= 0;
	local add			= 30/aesy*sy
	local current_index = 0;
	if(items) then
		if(items["back"] == true) then
			max_items = max_items-1;

			self.guiEle["btn_back"] = guiCreateButton((60/aesx*sx), (636/aesy*sy), 243/aesx*sx, 26/aesy*sy, "back", false)
			guiSetAlpha(self.guiEle["btn_back"], 0);


			addEventHandler("onClientMouseEnter", self.guiEle["btn_back"], function()
				self.selectedItem = "back";
			end, false)

			addEventHandler("onClientMouseLeave", self.guiEle["btn_back"], function()
				self.selectedItem = "-";
			end, false)
			addEventHandler("onClientGUIClick", self.guiEle["btn_back"], function()
				if(items["leave"] ~= true) then
					self:SelectPage("default-page");
					self:MoveCamera("default", 1000);
				else
					self:DoExit();
				end
			end, false)
		end

		if(self.selectedPage == "page_farbe") then

			--[[

			GUIEditor.radiobutton[1] = guiCreateRadioButton(72, 311, 201, 22, "Farbe 1", false)
			guiSetFont(GUIEditor.radiobutton[1], "default-bold-small")


			GUIEditor.radiobutton[2] = guiCreateRadioButton(72, 333, 201, 22, "Farbe 2", false)
			guiSetFont(GUIEditor.radiobutton[2], "default-bold-small")


			GUIEditor.radiobutton[3] = guiCreateRadioButton(72, 355, 201, 22, "Farbe 3", false)
			guiSetFont(GUIEditor.radiobutton[3], "default-bold-small")


			GUIEditor.radiobutton[4] = guiCreateRadioButton(72, 377, 201, 22, "Farbe 4", false)
			guiSetFont(GUIEditor.radiobutton[4], "default-bold-small")


			GUIEditor.radiobutton[5] = guiCreateRadioButton(72, 409, 201, 22, "Lichtfarbe", false)
			guiSetFont(GUIEditor.radiobutton[5], "default-bold-small")
			guiRadioButtonSetSelected(GUIEditor.radiobutton[5], true)


			GUIEditor.scrollbar[1] = guiCreateScrollBar(69, 458, 213, 24, true, false)


			GUIEditor.scrollbar[2] = guiCreateScrollBar(69, 488, 213, 24, true, false)


			GUIEditor.scrollbar[3] = guiCreateScrollBar(69, 520, 213, 24, true, false)


			GUIEditor.scrollbar[4] = guiCreateScrollBar(69, 554, 213, 24, true, false)
			--]]

			self.guiEle["radiobtn_01"] = guiCreateRadioButton(72/aesx*sx, 311/aesy*sy, 201/aesx*sx, 22/aesy*sy, "Farbe 1", false)
			guiSetFont(self.guiEle["radiobtn_01"], "default-bold-small")


			self.guiEle["radiobtn_02"] = guiCreateRadioButton(72/aesx*sx, 333/aesy*sy, 201/aesx*sx, 22/aesy*sy, "Farbe 2", false)
			guiSetFont(self.guiEle["radiobtn_02"], "default-bold-small")


			self.guiEle["radiobtn_03"] = guiCreateRadioButton(72/aesx*sx, 355/aesy*sy, 201/aesx*sx, 22/aesy*sy, "Farbe 3", false)
			guiSetFont(self.guiEle["radiobtn_03"], "default-bold-small")


			self.guiEle["radiobtn_04"] = guiCreateRadioButton(72/aesx*sx, 377/aesy*sy, 201/aesx*sx, 22/aesy*sy, "Farbe 4", false)
			guiSetFont(self.guiEle["radiobtn_04"], "default-bold-small")


			self.guiEle["radiobtn_05"] = guiCreateRadioButton(72/aesx*sx, 409/aesy*sy, 201/aesx*sx, 22/aesy*sy, "Lichtfarbe", false)
			guiSetFont(self.guiEle["radiobtn_05"], "default-bold-small")
			guiRadioButtonSetSelected(self.guiEle["radiobtn_01"], true)

			--[[
			self.guiEle["scrollbar_01"] = guiCreateScrollBar(69/aesx*sx, 458/aesy*sy, 213/aesx*sx, 24/aesy*sy, true, false)


			self.guiEle["scrollbar_02"] = guiCreateScrollBar(69/aesx*sx, 488/aesy*sy, 213/aesx*sx, 24/aesy*sy, true, false)


			self.guiEle["scrollbar_03"] = guiCreateScrollBar(69/aesx*sx, 520/aesy*sy, 213/aesx*sx, 24/aesy*sy, true, false)


			self.guiEle["scrollbar_04"] = guiCreateScrollBar(69/aesx*sx, 554/aesy*sy, 213/aesx*sx, 24/aesy*sy, true, false)
			guiSetEnabled(self.guiEle["scrollbar_04"], false);

			for i = 1, 4, 1 do
				addEventHandler("onClientGUIScroll", self.guiEle["scrollbar_0"..i], self.scrollFarbeFunc);
			end

			local r, g, b = self.colorTable[1][1], self.colorTable[1][2], self.colorTable[1][3]
			guiScrollBarSetScrollPosition(self.guiEle["scrollbar_01"], r/2.55);
			guiScrollBarSetScrollPosition(self.guiEle["scrollbar_02"], g/2.55);
			guiScrollBarSetScrollPosition(self.guiEle["scrollbar_03"], b/2.55);

			for i = 1, 5, 1 do

			end
		]]

		for i = 1, 5, 1 do
			addEventHandler("onClientGUIClick", self.guiEle["radiobtn_0"..i], function()
				local r, g, b = self.colorTable[i][1], self.colorTable[i][2], self.colorTable[i][3]
				colorPicker.closeSelect();
				colorPicker.openSelect(r, g, b, 255)
			end, false)
		end
		elseif(self.selectedPage == "page_nummernschild") then
			self.guiEle["nummernschild"] = guiCreateEdit(66/aesx*sx, 446/aesy*sy, 224/aesx*sx, 31/aesy*sy, getVehiclePlateText(self.vehicle), false)
			guiEditSetMaxLength(self.guiEle["nummernschild"], 8)
			guiSetFont(self.guiEle["nummernschild"], "default-bold-small")

			addEventHandler("onClientGUIChanged", self.guiEle["nummernschild"], function()
				local sText = guiGetText(source)
				if(#sText < 1) then
					sText = "-"
				end
				setVehiclePlateText(self.vehicle, sText)
			end)

		elseif(self.selectedPage == "page_vinlys") then

			self.guiEle["lackierungen"] = guiCreateGridList(65/aesx*sx, 433/aesy*sy, 232/aesx*sx, 175/aesy*sy, false)
			guiGridListAddColumn(self.guiEle["lackierungen"], "Lackierung", 0.9)
			guiSetFont(self.guiEle["lackierungen"], "default-bold-small")

			for index, id in orderedPairs(self.tuningTeilPreise.lackierungen) do
				local iID = guiGridListAddRow(self.guiEle["lackierungen"])
				guiGridListSetItemText(self.guiEle["lackierungen"], iID, 1, index, false, false);

			end

			addEventHandler("onClientGUIClick", self.guiEle["lackierungen"], function()
				local row = guiGridListGetItemText(self.guiEle["lackierungen"], guiGridListGetSelectedItem(self.guiEle["lackierungen"]), 1);

				if(#row > 1) and (row ~= "") then
					local iID = self.tuningTeilPreise.lackierungen[row]

					if(iID) then
						setVehiclePaintjob(self.vehicle, iID)
					end
				else
					setVehiclePaintjob(self.vehicle, -1);
				end
			end)
		elseif(self.selectedPage == "page_varianten") then
			--[[
			--GUIEditor.button[1] = guiCreateButton(75, 447, 88, 27, "<<", false)
        guiSetFont(GUIEditor.button[1], "default-bold-small")
        guiSetProperty(GUIEditor.button[1], "NormalTextColour", "FFAAAAAA")


        GUIEditor.button[2] = guiCreateButton(237, 447, 88, 27, ">>", false)
        guiSetFont(GUIEditor.button[2], "default-bold-small")
        guiSetProperty(GUIEditor.button[2], "NormalTextColour", "FFAAAAAA")


        GUIEditor.button[3] = guiCreateButton(75, 484, 88, 27, "<<", false)
        guiSetFont(GUIEditor.button[3], "default-bold-small")
        guiSetProperty(GUIEditor.button[3], "NormalTextColour", "FFAAAAAA")


        GUIEditor.button[4] = guiCreateButton(237, 484, 88, 27, ">>", false)
        guiSetFont(GUIEditor.button[4], "default-bold-small")
        guiSetProperty(GUIEditor.button[4], "NormalTextColour", "FFAAAAAA")


        GUIEditor.label[1] = guiCreateLabel(171, 449, 56, 25, "1", false)


        GUIEditor.label[2] = guiCreateLabel(171, 484, 56, 25, "1", false)

         --]]
			self.guiEle["var_btn1"] = guiCreateButton(75/aesx*sx, 447/aesy*sy, 88/aesx*sx, 27/aesy*sy, "<<", false)
			guiSetFont(self.guiEle["var_btn1"], "default-bold-small")
			guiSetProperty(self.guiEle["var_btn1"], "NormalTextColour", "FFAAAAAA")

			addEventHandler("onClientGUIClick", self.guiEle["var_btn1"], function()
				if(self.m_iCurVariant1 < 1) then
					self.m_iCurVariant1 = 255;
				else
					self.m_iCurVariant1 = self.m_iCurVariant1-1;
				end
				self:updateVariant()
			end, false)

			self.guiEle["var_btn2"] = guiCreateButton(200/aesx*sx, 447/aesy*sy, 88/aesx*sx, 27/aesy*sy, ">>", false)
			guiSetFont(self.guiEle["var_btn2"], "default-bold-small")
			guiSetProperty(self.guiEle["var_btn2"], "NormalTextColour", "FFAAAAAA")

			addEventHandler("onClientGUIClick", self.guiEle["var_btn2"], function()
				if(self.m_iCurVariant1 > 254) then
					self.m_iCurVariant1 = 0;
				else
					self.m_iCurVariant1 = self.m_iCurVariant1+1;
				end
				self:updateVariant()
			end, false)

			self.guiEle["var_btn3"] = guiCreateButton(75/aesx*sx, 484/aesy*sy, 88/aesx*sx, 27/aesy*sy, "<<", false)
			guiSetFont(self.guiEle["var_btn3"], "default-bold-small")
			guiSetProperty(self.guiEle["var_btn3"], "NormalTextColour", "FFAAAAAA")

			addEventHandler("onClientGUIClick", self.guiEle["var_btn3"], function()
				if(self.m_iCurVariant2 < 1) then
					self.m_iCurVariant2 = 255;
				else
					self.m_iCurVariant2 = self.m_iCurVariant2-1;
				end
				self:updateVariant()
			end, false)

			self.guiEle["var_btn4"] = guiCreateButton(200/aesx*sx, 484/aesy*sy, 88/aesx*sx, 27/aesy*sy, ">>", false)
			guiSetFont(self.guiEle["var_btn4"], "default-bold-small")
			guiSetProperty(self.guiEle["var_btn4"], "NormalTextColour", "FFAAAAAA")

			addEventHandler("onClientGUIClick", self.guiEle["var_btn4"], function()
				if(self.m_iCurVariant2 > 254) then
					self.m_iCurVariant2 = 0;
				else
					self.m_iCurVariant2 = self.m_iCurVariant2+1;
				end
				self:updateVariant()
			end, false)
		else
			for i = 0+self.currentIndex, max_items+self.currentIndex, 1 do
				if(items[i]) then
					self.guiEle["btn_"..i] = guiCreateButton((60/aesx*sx), ((272+add)/aesy*sy)+current_add, 243/aesx*sx, 26/aesy*sy, i, false)
					guiSetAlpha(self.guiEle["btn_"..i], 0);

					current_add = current_add+add;

					addEventHandler("onClientMouseEnter", self.guiEle["btn_"..i], function()
						self.selectedItem = i;
						if(items["previewupgrades"]) and (items["previewupgrades"] == true) then
							self:PreviewUpgrade(self.upgradeSlots[i])
						end
					end, false)
					addEventHandler("onClientMouseLeave", self.guiEle["btn_"..i], function()
						self.selectedItem = "-";
						if(items["previewupgrades"]) and (items["previewupgrades"] == true) then
							self:DontPreviewUpgrade(self.upgradeSlots[i])
						end
					end, false)

					addEventHandler("onClientGUIClick", self.guiEle["btn_"..i], function()
						if(items["previewupgrades"]) and (items["previewupgrades"] == true) then
							local s = self:BuyUpgrade(self.upgradeSlots[i])
							if(s) then
								self:SelectPage(items[i][2], i);
								self:MoveCamera("default", 1000);
							else

							end
						else
							self:SelectPage(items[i][2], i);

							self:MoveCamera("slot_cam_"..self.items["default-page"][i][3], 1000);

						end
					end, false)
				end
			end
		end

	end
end

-- ///////////////////////////////
-- ///// Render				//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function TuningGarage:Render()
	if(self.doRender == true) then

		local aesx, aesy = 1440, 900;
		local sx, sy = guiGetScreenSize();
		-- Titel --
		dxDrawImage(60/aesx*sx, 254/aesy*sy, 241/aesx*sx, 45/aesy*sy, "res/textures/logos/"..self.sLogo, 0, 0, 0, tocolor(255, 255, 255, 255), true)

		-- Hintergrund --
		dxDrawRectangle(60/aesx*sx, 300/aesy*sy, 243/aesx*sx, 368/aesy*sy, tocolor(0, 0, 0, 158), false)

		-- Items --

		local items = self.items[self.selectedPage];

		local current_add 	= 0;
		local add			= 30/aesy*sy
		local current_index = 0;


		local max_items		= self.maxItems;

		if(items) then
			--[[
			for item, nextpage in pairs(items) do

			dxDrawRectangle(60/aesx*sx, 300/aesy*sx, 243, 36, tocolor(255, 255, 255, 204), true)
			dxDrawText(item, 78/aesx*sx, 300/aesy*sy, 303/aesx*sx, 334/aesy*sy, tocolor(0, 0, 0, 204), 1, "default-bold", "left", "center", false, false, true, false, false)

			current_index = current_index+1;



			addEventHandler("onClientRender", root,
			function()
			dxDrawRectangle(60, 300, 243, 368, tocolor(0, 0, 0, 158), true)
			dxDrawRectangle(60, 300, 243, 36, tocolor(255, 255, 255, 204), true)
			dxDrawImage(60, 254, 241, 45, ":guieditor/images/dx_elements/slider_end.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
			dxDrawText("Item 1", 78, 300, 303, 334, tocolor(0, 0, 0, 204), 1, "default-bold", "left", "center", false, false, true, false, false)
			end
			)
			end]]

			if(items["back"] == true) then
				max_items = max_items-1;



				local fontColor = tocolor(0, 0, 0, 255)
				if(self.selectedItem == "back") then
					dxDrawRectangle((60/aesx*sx), (636/aesy*sy), 243/aesx*sx, 26/aesy*sy, tocolor(255, 255, 255, 154), false)
				else
					fontColor = tocolor(255, 255, 255, 255)
				end
				local text = "Seite Zurueck";
				if(items["leave"] ~= true) then else
					text = "Garage Verlassen";
				end

				dxDrawText(text, 78/aesx*sx, (636/aesy*sy), 303/aesx*sx, (662/aesy*sy), fontColor, 1/(aesx+aesy)*(sx+sy), "default-bold", "left", "center", false, false, true, false, true)

			end
			for i = 0+self.currentIndex, max_items+self.currentIndex, 1 do
				if(items[i]) then


					local fontColor = tocolor(0, 0, 0, 255)
					if(self.selectedItem == i) then
						dxDrawRectangle((60/aesx*sx), ((272+add)/aesy*sy)+current_add, 243/aesx*sx, 26/aesy*sy, tocolor(255, 255, 255, 204), false)
					else
						fontColor = tocolor(255, 255, 255, 255)
					end
					local iUpgrade;
					local text = items[i][1];
					if(gettok(text, 2, "-")) then
						if(tonumber((gettok(items[i][1], 2, "-"))) ~= nil) then
							iUpgrade = tonumber((gettok(items[i][1], 2, "-")));
						else
							iUpgrade = string.gsub((gettok(items[i][1], 2, "-")), " ", "", 1);

						end
					end


					if(iUpgrade) then
						local slotID = self.currentSlotID;
						if(self.tuningTeilPreise.ItemPrices[iUpgrade]) then
							slotID = iUpgrade;
						end
						if(self.upgradeInstalled[slotID] == iUpgrade) or (self.upgradeInstalled[slotID] == true) then
							if not(self.selectedItem == i) then
								fontColor = tocolor(0, 255, 0, 255);
							end
						end

						local nitro = {[1008] = 75, [1009] = 125, [1010] = 150}

						local preis = self.preis;

						if (nitro[iUpgrade]) then
							preis = nitro[iUpgrade];
						end

						if(self.tuningTeilPreise.ItemPrices[iUpgrade]) then
							preis = self.tuningTeilPreise.ItemPrices[iUpgrade];
						end

						dxDrawText("$"..preis, 60/aesx*sx, ((305)/aesy*sy)+current_add, 280/aesx*sx, (329/aesy*sy)+current_add, fontColor, 1/(aesx+aesy)*(sx+sy), "default-bold", "right", "center", false, false, true, false, true)

					end
					dxDrawText(text, 78/aesx*sx, ((305)/aesy*sy)+current_add, 303/aesx*sx, (329/aesy*sy)+current_add, fontColor, 1/(aesx+aesy)*(sx+sy), "default-bold", "left", "center", false, false, true, false, true)

					-- Preis



					current_add = current_add+add;
				end
			end

			if(self.selectedPage == "page_farbe") then
				dxDrawText("Benutze die Knopfe\nUm die Farbe deines Autos\n zu Modifizieren.", 74/aesx*sx, 555/aesy*sy, 281/aesx*sx, 604/aesy*sy, tocolor(255, 255, 255, 255), 1/(aesx+aesy)*(sx+sy), "default-bold", "center", "top", false, false, true, false, false)
				dxDrawText("R", 283/aesx*sx, 461/aesy*sy, 300/aesx*sx, 478/aesy*sy, tocolor(255, 0, 0, 255), 1/(aesx+aesy)*(sx+sy), "default-bold", "center", "center", false, false, true, false, false)
				dxDrawText("G", 283/aesx*sx, 492/aesy*sy, 298/aesx*sx, 509/aesy*sy, tocolor(0, 255, 0, 255), 1/(aesx+aesy)*(sx+sy), "default-bold", "center", "center", false, false, true, false, false)
				dxDrawText("B", 283/aesx*sx, 523/aesy*sy, 298/aesx*sx, 540/aesy*sy, tocolor(0, 0, 255, 255), 1/(aesx+aesy)*(sx+sy), "default-bold", "center", "center", false, false, true, false, false)
				dxDrawText("__________________", 71/aesx*sx, 432/aesy*sy, 291/aesx*sx, 451/aesy*sy, tocolor(255, 255, 255, 255), 1/(aesx+aesy)*(sx+sy), "default", "center", "top", false, false, true, false, false)
				dxDrawText("__________________", 71/aesx*sx, 614/aesy*sy, 291/aesx*sx, 633/aesy*sy, tocolor(255, 255, 255, 255), 1/(aesx+aesy)*(sx+sy), "default", "center", "top", false, false, true, false, false)
				self:ScrollFarbe()
			elseif(self.selectedPage == "page_nummernschild") then
				dxDrawText("Hier kannst du dein Nummernschild bearbeiten! Bitte beachte: Du kannst maximal 8 Zeichen benutzen.", 66/aesx*sx, 304/aesy*sy, 295/aesx*sx, 405/aesy*sy, tocolor(255, 255, 255, 255), 1/(aesx+aesy)*(sx+sy), "default-bold", "center", "center", false, true, true, false, false)
				dxDrawLine(66/aesx*sx, 409/aesy*sy, 295/aesx*sx, 409/aesy*sy, tocolor(255, 255, 255, 255), 1, true)
				dxDrawText("Nummernschild:", 66/aesx*sx, 416/aesy*sy, 291/aesx*sx, 442/aesy*sy, tocolor(255, 255, 255, 255), 1/(aesx+aesy)*(sx+sy), "default-bold", "left", "center", false, false, true, false, false)

			elseif(self.selectedPage == "page_vinlys") then
				dxDrawText("Hier kannst du deine Lackierung auswaehlen. Bitte beachte, das nicht alle Lackierungen mit deinem Fahrzeug kompatibel sein koennen! Es unterstuetzen nur sehr wenige Fahrzeuge lackierungen.", 64/aesx*sx, 302/aesy*sy, 294/aesx*sx, 421/aesy*sy, tocolor(255, 255, 255, 255), 1/(aesx+aesy)*(sx+sy), "default-bold", "center", "center", false, true, true, false, false)
				dxDrawLine(63/aesx*sx, 427/aesy*sy, 296/aesx*sx, 427/aesy*sy, tocolor(255, 255, 255, 255), 1, true)

			elseif(self.selectedPage == "page_varianten") then
				dxDrawText("Hier kannst du deine Fahrzeugvariante ausawehlen, falls dein Fahrzeug welche besitzt. Fahrzeugvarianten sind andere Varianten deines Fahrzeuges, wie z.B. Beladung, Motor, Texturen oder Auspuffe.", 64/aesx*sx, 302/aesy*sy, 294/aesx*sx, 421/aesy*sy, tocolor(255, 255, 255, 255), 1/(aesx+aesy)*(sx+sy), "default-bold", "center", "center", false, true, true, false, false)

				dxDrawText(self.m_iCurVariant1, 171/aesx*sx, 449/aesy*sy, (171+56)/aesx*sx, (449+25)/aesy*sy, tocolor(255, 255, 255, 255), 1/(aesx+aesy)*(sx+sy), "default-bold", "left", "center", false, false, true, false, false)
				dxDrawText(self.m_iCurVariant2, 171/aesx*sx, 484/aesy*sy, (171+56)/aesx*sx, (484+25)/aesy*sy, tocolor(255, 255, 255, 255), 1/(aesx+aesy)*(sx+sy), "default-bold", "left", "center", false, false, true, false, false)

				--[[
				--        GUIEditor.label[1] = guiCreateLabel(171, 449, 56, 25, "1", false)


        GUIEditor.label[2] = guiCreateLabel(171, 484, 56, 25, "1", false)
				 ]]
			end

		end
	end
end

-- ///////////////////////////////
-- ///// MoveUp				//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function TuningGarage:MoveUp()
	if(self.doRender) then
		if not(self.currentIndex > #self.items[self.selectedPage]-self.maxItems) then
			self.currentIndex = self.currentIndex+1;

			self:RefreshGuiComponents();
		end
	end
end

-- ///////////////////////////////
-- ///// MoveDown			//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function TuningGarage:MoveDown()
	if(self.doRender) then
		if not(self.currentIndex < 2) then
			self.currentIndex = self.currentIndex-1;

			self:RefreshGuiComponents();
		end
	end
end

-- ///////////////////////////////
-- ///// ScrollFarbe		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function TuningGarage:ScrollFarbe(...)

	local selectedColor = 1;

	for i = 1, 5, 1 do
		if(guiRadioButtonGetSelected(self.guiEle["radiobtn_0"..i])) then
			selectedColor = i;
		end
	end
	if (not colorPicker.isSelectOpen) then return end
	local r, g, b, a = colorPicker.updateTempColors();

	local r1, g1, b1, r2, g2, b2, r3, g3, b3, r4, g4, b4 = self.colorTable[1][1], self.colorTable[1][2], self.colorTable[1][3], self.colorTable[2][1], self.colorTable[2][2], self.colorTable[2][3], self.colorTable[3][1], self.colorTable[3][2], self.colorTable[3][3], self.colorTable[4][1], self.colorTable[4][2], self.colorTable[4][3]
	local lr, lg, lb = self.colorTable[5][1], self.colorTable[5][2], self.colorTable[5][3];

	local w1, w2, w3, w4 = colorPicker.updateTempColors();

	if(selectedColor == 1) then
		r1, g1, b1 = w1, w2, w3
	elseif(selectedColor == 2) then
		r2, g2, b2 = w1, w2, w3
	elseif(selectedColor == 3) then
		r3, g3, b3 = w1, w2, w3
	elseif(selectedColor == 4) then
		r4, g4, b4 = w1, w2, w3
	elseif(selectedColor == 5) then
		lr, lg, lb = w1, w2, w3
	end

	setVehicleHeadLightColor(self.vehicle, lr, lg, lb);
	setVehicleColor(self.vehicle, r1, g1, b1, r2, g2, b2, r3, g3, b3, r4, g4, b4);

	self.colorTable[1] = {r1, g1, b1};
	self.colorTable[2] = {r2, g2, b2};
	self.colorTable[3] = {r3, g3, b3};
	self.colorTable[4] = {r4, g4, b4};
	self.colorTable[5] = {lr, lg, lb};

	--[[
	local selectedColor = 1;

	for i = 1, 5, 1 do
		if(guiRadioButtonGetSelected(self.guiEle["radiobtn_0"..i])) then
			selectedColor = i;
		end
	end

	local r1, g1, b1, r2, g2, b2, r3, g3, b3, r4, g4, b4 = self.colorTable[1][1], self.colorTable[1][2], self.colorTable[1][3], self.colorTable[2][1], self.colorTable[2][2], self.colorTable[2][3], self.colorTable[3][1], self.colorTable[3][2], self.colorTable[3][3], self.colorTable[4][1], self.colorTable[4][2], self.colorTable[4][3]
	local lr, lg, lb = self.colorTable[5][1], self.colorTable[5][2], self.colorTable[5][3];

	local w1, w2, w3, w4 = guiScrollBarGetScrollPosition(self.guiEle["scrollbar_01"])*2.55, guiScrollBarGetScrollPosition(self.guiEle["scrollbar_02"])*2.55, guiScrollBarGetScrollPosition(self.guiEle["scrollbar_03"])*2.55, guiScrollBarGetScrollPosition(self.guiEle["scrollbar_04"])*2.55
	--outputChatBox(w1..", "..w2..", "..w3)
	if(selectedColor == 1) then
		r1, g1, b1 = w1, w2, w3
	elseif(selectedColor == 2) then
		r2, g2, b2 = w1, w2, w3
	elseif(selectedColor == 3) then
		r3, g3, b3 = w1, w2, w3
	elseif(selectedColor == 4) then
		r4, g4, b4 = w1, w2, w3
	elseif(selectedColor == 5) then
		lr, lg, lb = w1, w2, w3
	end

	setVehicleHeadLightColor(self.vehicle, lr, lg, lb);
	setVehicleColor(self.vehicle, r1, g1, b1, r2, g2, b2, r3, g3, b3, r4, g4, b4);

	self.colorTable[1] = {r1, g1, b1};
	self.colorTable[2] = {r2, g2, b2};
	self.colorTable[3] = {r3, g3, b3};
	self.colorTable[4] = {r4, g4, b4};
	self.colorTable[5] = {lr, lg, lb};]]
end

-- ///////////////////////////////
-- ///// MoveCamera			//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function TuningGarage:MoveCamera(sIndex, iTime)
	if(self.cameraPositions[sIndex]) then
		local x1, y1, z1, x2, y2, z2 = unpack(self.cameraMover:GetCurrentMatrix());
		local x3, y3, z3, x4, y4, z4 = unpack(self.cameraPositions[sIndex]);
		self.cameraMover:SmoothMoveCamera(x1, y1, z1, x2, y2, z2, x3, y3, z3, x4, y4, z4, iTime, "InOutQuad");

		self.currentCamPos = sIndex;
	end
end


-- ///////////////////////////////
-- ///// DoEnter			//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function TuningGarage:DoEnter(sID, iInt, iDim, sLogo)
	addEventHandler("onClientRender", getRootElement(), self.renderFunc)

	-- Damit der Server weiss, welche Tuninggarage man betreten hat
	self.tuningGarageID = sID;
	self.sLogo = sLogo or "transfender";

	setElementInterior(self.garageObject, iInt);
	setElementDimension(self.garageObject, iDim);

	local vehicle = getPedOccupiedVehicle(localPlayer);
	local x, y, z = getElementPosition(vehicle)
	setElementPosition(vehicle, x, y, z+0.5);

	if(getVehicleType(vehicle) == "Bike") or (getVehicleType(vehicle) == "BMX") or (getVehicleType(vehicle) == "Quad") then
		setElementFrozen(vehicle, true);
	else
		setElementFrozen(vehicle, false);

	end
	--self:MoveCamera("default", 2000)

	self.vehicle = vehicle;

	setCameraMatrix(unpack(self.cameraPositions["default"]))
	setSkyGradient(50, 50, 50);
	setVehicleOverrideLights(self.vehicle, 2)

	self.doRender = true;
	self:RefreshGuiComponents();
	self:LoadBoughtUpgrades()

	self.m_iCurVariant1, self.m_iCurVariant2 = vehicle:getVariant()

	fadeCamera(true);
	showCursor(true);

	hud:Toggle(false);

	bindKey("mouse2", "both", self.toggleVehicleLook);

	clientBusy = true;
end
-- ///////////////////////////////
-- ///// DoExit				//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function TuningGarage:DoExit(...)
	removeEventHandler("onClientRender", getRootElement(), self.renderFunc)

	self.cameraMover:StopCam();

	local colorString = "";

	for i = 1, 4, 1 do
		colorString = colorString..self.colorTable[i][1].."|"..self.colorTable[i][2].."|"..self.colorTable[i][3].."|";

	end

	local headlightColor = self.colorTable[5][1].."|"..self.colorTable[5][2].."|"..self.colorTable[5][3].."|"


	self.doRender = false;
	self:DestroyGui();
	resetSkyGradient();
	showCursor(false);
	fadeCamera(false);

	clientBusy = false;

	setTimer(function()
		triggerServerEvent("onPlayerExitTuningGarage", localPlayer, self.tuningGarageID, colorString, headlightColor, getVehiclePlateText(self.vehicle), getVehiclePaintjob(self.vehicle))

		hud:Toggle(true)
	end, 1000, 1)

	unbindKey("mouse2", "both", self.toggleVehicleLook);

end

-- ///////////////////////////////
-- ///// ToggleVehicleLook	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function TuningGarage:ToggleVehicleLook(key, state)
	if(state == "down") then
		self.doRender = false;
		setCameraTarget(localPlayer);
		showCursor(false);
	else
		self.doRender = true;
		self:MoveCamera(self.currentCamPos, 1000);
		showCursor(true);
	end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function TuningGarage:Constructor(...)
	-- Klassenvariablen --
	self.garageObject = createObject(14776, 4652.8999023438, 617.29998779297, 802.09997558594, 0, 0, 0)

	addEvent("onTuninggarageCameraReset", true)
	addEvent("onClientPlayerTuninggarageCantBuyUpgrade", true)
	-- Methoden --

	self.cameraPositions =
	{
		["default"] = {4647.7705078125, 602.03125, 796.40936279297, 4596.5629882813, 687.61260986328, 803.73181152344};
		-- Vorne
		["slot_cam_0"] = {4645.3959960938, 605.52862548828, 798.67248535156, 4644.0302734375, 699.5625, 764.67584228516}; -- Motorhaube
		["slot_cam_1"] = {4645.3959960938, 605.52862548828, 798.67248535156, 4644.0302734375, 699.5625, 764.67584228516}; -- Lueftung
		["slot_cam_7"] = {4645.3959960938, 605.52862548828, 798.67248535156, 4644.0302734375, 699.5625, 764.67584228516}; -- Dach

		["slot_cam_4"] = {4645.41015625, 603.78570556641, 797.39367675781, 4642.9350585938, 702.81121826172, 783.68884277344};
		["slot_cam_14"] = {4645.41015625, 603.78570556641, 797.39367675781, 4642.9350585938, 702.81121826172, 783.68884277344};
		["slot_cam_8"] = {4645.4145507813, 602.45648193359, 796.34466552734, 4645.009765625, 702.4365234375, 798.30145263672};
		["slot_cam_6"] = {4645.4145507813, 602.45648193359, 796.34466552734, 4645.009765625, 702.4365234375, 798.30145263672};

		-- Hinten
		["slot_cam_5"] = {4645.2705078125, 620.99981689453, 797.828125, 4644.5810546875, 522.701171875, 779.47320556641},
		["slot_cam_15"] = {4645.2705078125, 620.99981689453, 797.828125, 4644.5810546875, 522.701171875, 779.47320556641},
		["slot_cam_2"] = {4645.2705078125, 620.99981689453, 797.828125, 4644.5810546875, 522.701171875, 779.47320556641},

		-- Seite
		["slot_cam_3"] = {4651.3657226563, 612.79895019531, 796.07501220703, 4551.4892578125, 610.85522460938, 800.64782714844},

		-- Reifen
		["slot_cam_12"] = {4651.0810546875, 611.31018066406, 795.89306640625, 4551.2109375, 611.45819091797, 800.98876953125},

		-- Hydraulik
		["slot_cam_9"] = {4641.1303710938, 605.25341796875, 797.79473876953, 4689.6157226563, 691.08245849609, 780.98577880859},

		-- Nitro
		["slot_cam_8"] = {4645.2705078125, 620.99981689453, 797.828125, 4644.5810546875, 522.701171875, 779.47320556641},

		-- Auspuff
		["slot_cam_13"] = {4649.9204101563, 618.63482666016, 795.78594970703, 4587.5458984375, 540.85290527344, 803.49365234375},

		-- Lichtfarbe und Farbe

		["slot_cam_17"] = {4641.1303710938, 605.25341796875, 797.79473876953, 4689.6157226563, 691.08245849609, 780.98577880859},
		["slot_cam_16"] = {4641.1303710938, 605.25341796875, 797.79473876953, 4689.6157226563, 691.08245849609, 780.98577880859},

		-- Nummernschild --
		["slot_cam_18"] = {4645.3208007813, 619.66741943359, 796.24401855469, 4645.9033203125, 519.67938232422, 794.81066894531},
		-- Vinlys 		--
		["slot_cam_19"] = {4641.1303710938, 605.25341796875, 797.79473876953, 4689.6157226563, 691.08245849609, 780.98577880859},

		-- Varianten --
		["slot_cam_20"] = {4637.3115234375, 612.80590820313, 803.42718505859, 4711.6342773438, 613.21704101563, 736.5244140625},
		--
		["slot_cam_"] = {},
		["slot_cam_"] = {},
		["slot_cam_"] = {},
		["slot_cam_"] = {},
		["slot_cam_"] = {},

	}

	self.currentCamPos = "default";

	-- Upgrade s--

	self.upgradeSlotNames =
	{
		["Hood"] = 0,
		["Vent"] = 1,
		["Spoiler"] = 2,
		["Sideskirt"] = 3,
		["Front Bullbars"] = 4,
		["Rear Bullbars"] = 5,
		["Headlights"] = 6,
		["Roof"] = 7,
		["Nitro"] = 8,
		["Hydraulics"] = 9,
		["Stereo"] = 10,
		["Wheels"] = 12,
		["Exhaust"] = 13,
		["Front Bumper"] = 14,
		["Rear Bumper"] = 15,
		["Misc"] = 16,
	}

	self.tuningTeilPreise = TuningTeilPreise:New();

	self.items =
	{
		["default-page"] =
		{
			["back"] = true,
			["leave"] = true,
			{"Motorhaube", "page_motorhaube", 0},
			{"Lueftung", "page_lueftung", 1},
			{"Spoiler", "page_spoiler", 2},
			{"Seitenteile", "page_seitenteile", 3},
			{"Vorderteile", "page_vorderteile", 4},
			{"Hinterteile", "page_hinterteile", 5},
			{"Lichter", "page_lichter", 6},
			{"Dach", "page_dach", 7},
			{"Nitro", "page_nitro", 8},
			{"Hydraulik", "page_hydraulik", 9},
			{"Reifen", "page_reifen", 12},
			{"Auspuff", "page_auspuff", 13},
			{"Vordere Stosstange", "page_stosstange", 14},
			{"Hintere Stosstange", "page_heckstange", 15},
			{"Farbe", "page_farbe", 17},
			{"Nummernschild", "page_nummernschild", 18},
			{"Vinlys", "page_vinlys", 19},
			{"Varianten", "page_varianten", 20},
			{"Sonstiges", "page_sonstiges", 16},

		},
		["page_motorhaube"] =
		{
			["back"] = true,
			["previewupgrades"] = true,

		},
		["page_lueftung"] =
		{
			["back"] = true,
			["previewupgrades"] = true,

		},
		["page_spoiler"] =
		{
			["back"] = true,
			["previewupgrades"] = true,

		},
		["page_seitenteile"] =
		{
			["back"] = true,
			["previewupgrades"] = true,

		},
		["page_vorderteile"] =
		{
			["back"] = true,
			["previewupgrades"] = true,

		},
		["page_hinterteile"] =
		{
			["back"] = true,
			["previewupgrades"] = true,

		},
		["page_lichter"] =
		{
			["back"] = true,
			["previewupgrades"] = true,

		},
		["page_dach"] =
		{
			["back"] = true,
			["previewupgrades"] = true,

		},
		["page_nitro"] =
		{
			["back"] = true,
			["previewupgrades"] = true,

		},
		["page_hydraulik"] =
		{
			["back"] = true,
			["previewupgrades"] = true,

		},
		["page_reifen"] =
		{
			["back"] = true,
			["previewupgrades"] = true,

		},
		["page_auspuff"] =
		{
			["back"] = true,
			["previewupgrades"] = true,

		},
		["page_stosstange"] =
		{
			["back"] = true,
			["previewupgrades"] = true,

		},
		["page_heckstange"] =
		{
			["back"] = true,
			["previewupgrades"] = true,

		},
		["page_farbe"] =
		{
			["back"] = true,
			["previewupgrades"] = true,

		},
		["page_nummernschild"] =
		{
			["back"] = true,
			["previewupgrades"] = true,

		},
		["page_vinlys"] =
		{
			["back"] = true,
			["previewupgrades"] = true,
		},

		["page_sonstiges"] =
		{
			["back"] = true,
			["previewupgrades"] = true,
		},
		["page_varianten"] =
		{
			["back"] = true,
			["previewupgrades"] = true,
		},
	}
	self.noItemsPages =
	{
		["page_farbe"] 			= true,
		["page_nummernschild"] 	= true,
		["page_vinlys"] 		= true,
		["page_varianten"]		= true,
	}


	self.tuningGarageID = 0;
	self.cameraMover 	= CameraMover:New();
	self.doRender		= false; -- Auf False

	self.selectedPage 	= "default-page";
	self.currentIndex	= 1;
	self.oldCurrentIndex = 1;
	self.maxItems		= 11;

	self.guiEle			= {}

	self.selectedItem	= "back";
	self.upgradeInstalled = {}

	self.preis			= 75;

	self.colorTable		= {}

	self.m_iCurVariant1 = 0;
	self.m_iCurVariant2 = 0;


	self.vehicle 		= getPedOccupiedVehicle(localPlayer)

	self.enterFunc		= function(...) self:DoEnter(...) end;
	self.exitFunc		= function(...) self:DoExit(...) end;
	self.renderFunc		= function(...) self:Render(...) end;
	self.moveUpFunc		= function(...) self:MoveUp(...) end;
	self.moveDownFunc	= function(...) self:MoveDown(...) end;
	self.scrollFarbeFunc= function(...) self:ScrollFarbe(...) end;
	self.toggleVehicleLook = function(...) self:ToggleVehicleLook(...) end;
	self.m_funcResetCam	= function(...) self:MoveCamera(self.currentCamPos, 50); end
	self.m_funcResetTuningTeil = function(iSlotID, iUpgradeID)
		self.upgradeInstalled[iSlotID] = nil;
		localPlayer:getOccupiedVehicle():removeUpgrade(iSlotID, iUpgradeID)
	end

	-- Events --

	bindKey("mouse_wheel_down", "down", self.moveUpFunc)
	bindKey("mouse_wheel_up", "down", self.moveDownFunc)


	setOcclusionsEnabled(false);
	--	self:RefreshGuiComponents();
	addEvent("onClientPlayerEnterTuningGarage", true);
	addEventHandler("onClientPlayerEnterTuningGarage", getLocalPlayer(), self.enterFunc)
	addEventHandler("onTuninggarageCameraReset", getLocalPlayer(), self.m_funcResetCam)
	addEventHandler("onClientPlayerTuninggarageCantBuyUpgrade", getLocalPlayer(), self.m_funcResetTuningTeil)

	--logger:OutputInfo("[CALLING] TuningGarage: Constructor");
end

-- EVENT HANDLER --

-- Functions --
function __genOrderedIndex( t )
	local orderedIndex = {}
	for key in pairs(t) do
		table.insert( orderedIndex, key )
	end
	table.sort( orderedIndex )
	return orderedIndex
end

function orderedNext(t, state)
	-- Equivalent of the next function, but returns the keys in the alphabetic
	-- order. We use a temporary ordered key table that is stored in the
	-- table being iterated.

	--print("orderedNext: state = "..tostring(state) )
	if state == nil then
		-- the first time, generate the index
		t.__orderedIndex = __genOrderedIndex( t )
		key = t.__orderedIndex[1]
		return key, t[key]
	end
	-- fetch the next value
	key = nil
	for i = 1,table.getn(t.__orderedIndex) do
		if t.__orderedIndex[i] == state then
			key = t.__orderedIndex[i+1]
		end
	end

	if key then
		return key, t[key]
	end

	-- no more value to return, cleanup
	t.__orderedIndex = nil
	return
end

function orderedPairs(t)
	-- Equivalent of the pairs() function on tables. Allows to iterate
	-- in order
	return orderedNext, t, nil
end
