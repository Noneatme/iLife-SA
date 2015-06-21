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
-- ## Name: BusinessGUI.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

BusinessGUI = {};
BusinessGUI.__index = BusinessGUI;

addEvent("onClientBusinessOpen", true)
addEvent("onClientBizUpdate", true)
--[[

GUIEditor = {
label = {},
button = {},
staticimage = {},
window = {},
}
GUIEditor.window[1] = guiCreateWindow(501, 328, 466, 294, "Business", false)
guiWindowSetSizable(GUIEditor.window[1], false)

GUIEditor.staticimage[1] = guiCreateStaticImage(9, 22, 209, 106, ":guieditor/client/colorpicker/palette.png", false, GUIEditor.window[1])
GUIEditor.label[1] = guiCreateLabel(225, 24, 229, 102, "Business:\n\nBesitzer:\n\nKosten:", false, GUIEditor.window[1])
guiLabelSetVerticalAlign(GUIEditor.label[1], "center")
GUIEditor.label[2] = guiCreateLabel(11, 133, 443, 82, "Beschreibung:", false, GUIEditor.window[1])
GUIEditor.button[1] = guiCreateButton(13, 239, 187, 46, "Business Kaufen", false, GUIEditor.window[1])
guiSetProperty(GUIEditor.button[1], "NormalTextColour", "FFAAAAAA")
GUIEditor.button[2] = guiCreateButton(269, 238, 187, 46, "Pranger", false, GUIEditor.window[1])
guiSetProperty(GUIEditor.button[2], "NormalTextColour", "FFAAAAAA")


	GUIEditor = {
	button = {},
	edit = {},
	window = {},
	gridlist = {},
	label = {},
	}
	GUIEditor.window[1] = guiCreateWindow(404, 340, 609, 390, "Business Management", false)


	GUIEditor.label[1] = guiCreateLabel(14, 24, 203, 20, "Business Name: ", false, GUIEditor.window[1])

	GUIEditor.gridlist[1] = guiCreateGridList(10, 45, 212, 218, false, GUIEditor.window[1])

	GUIEditor.label[2] = guiCreateLabel(228, 44, 147, 19, "Spielername:", false, GUIEditor.window[1])


	GUIEditor.edit[1] = guiCreateEdit(227, 65, 151, 26, "", false, GUIEditor.window[1])

	GUIEditor.button[2] = guiCreateButton(227, 145, 151, 36, "Rechte entfernen", false, GUIEditor.window[1])+


	GUIEditor.button[3] = guiCreateButton(227, 99, 151, 36, "Rechte geben", false, GUIEditor.window[1])

	GUIEditor.label[3] = guiCreateLabel(10, 273, 180, 21, "Businesssaldo:", false, GUIEditor.window[1])

	GUIEditor.label[4] = guiCreateLabel(9, 293, 215, 83, "$0", false, GUIEditor.window[1])

	GUIEditor.edit[2] = guiCreateEdit(231, 257, 151, 26, "", false, GUIEditor.window[1])

	GUIEditor.label[5] = guiCreateLabel(231, 232, 149, 19, "Wert:", false, GUIEditor.window[1])

	GUIEditor.button[4] = guiCreateButton(232, 293, 151, 36, "Einzahlen", false, GUIEditor.window[1])


	GUIEditor.button[5] = guiCreateButton(231, 339, 151, 36, "Einzahlen", false, GUIEditor.window[1])

	GUIEditor.label[6] = guiCreateLabel(395, 25, 147, 19, "Einstellungen aendern:", false, GUIEditor.window[1])

	GUIEditor.gridlist[2] = guiCreateGridList(390, 47, 210, 215, false, GUIEditor.window[1])

	GUIEditor.label[8] = guiCreateLabel(423, 283, 149, 19, "Wert:", false, GUIEditor.window[1])

	GUIEditor.edit[3] = guiCreateEdit(423, 303, 151, 26, "", false, GUIEditor.window[1])

	GUIEditor.button[6] = guiCreateButton(423, 339, 151, 36, "Setzen", false, GUIEditor.window[1])

	--]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function BusinessGUI:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// WhichPermissionHaveI ////
-- ///// Returns: void		//////
-- ///////////////////////////////
--[[
function BusinessGUI:WhichPermissionHaveI(tblSettings, iOwnerID)

	if(string.lower(iOwnerID) == string.lower(getPlayerName(localPlayer))) then
		return 1;
	end
	if(tblSettings["permissions"]) then
		for index, b in pairs(tblSettings["permissions"]) do
			if(string.lower(index) == string.lower(getPlayerName(localPlayer))) then
				return 2;
			end
		end
	end
	return false;
end
]]
-- ///////////////////////////////
-- ///// Update		 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////
--[[
function BusinessGUI:Update(iID, iCost, iOwnerID, sTitle, sDescription, tblSettings)
	if(self.guiEle["window"]) then
		self.guiEle["gridlist1"]:clearRows();
		self.guiEle["gridlist1"]:addRow(iOwnerID.."|Leiter")

		if(tblSettings["permissions"]) then
			for index, b in pairs(tblSettings["permissions"]) do
				self.guiEle["gridlist1"]:addRow(index.."|Mitglied")
			end
		end

		self.guiEle["label4"]:setText("$"..tblSettings["saldo"])
	end
end]]
-- ///////////////////////////////
-- ///// ShowVariante2 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////
--[[
function BusinessGUI:ShowVariante2(iID, iCost, iOwnerID, sTitle, sDescription, tblSettings)

	if not(self.guiEle["window"]) then
		local iGeld = tblSettings["saldo"];
		if not(iGeld) then
			iGeld = 0;
		end

		local rechte = self:WhichPermissionHaveI(tblSettings, iOwnerID);
		if(rechte) then
			self.guiEle["window"] 	= new(CDxWindow, "Fillialen Management", 609, 420, true, true, "Center|Middle")
			self.guiEle["label1"]	= new(CDxLabel, "Filliale: "..sTitle, 14, 24, 203, 20, tocolor(255,255,255,255), 1.0, "default-bold", "left", "center", self.guiEle["window"])

			self.guiEle["gridlist1"] = new(CDxList, 10, 45, 212, 218, tocolor(125, 125, 125, 200), self.guiEle["window"])
			self.guiEle["label2"]	= new(CDxLabel, "Spielername: ", 228, 44, 147, 19, tocolor(255,255,255,255), 1.0, "default-bold", "left", "center", self.guiEle["window"])
			self.guiEle["edit1"]	= new(CDxEdit, "", 227, 65, 151, 26, "normal", tocolor(0, 0, 0, 255), self.guiEle["window"])
			self.guiEle["button1"]	= new(CDxButton, "Rechte entfernen", 227, 145, 151, 36, tocolor(255,255,255,255), self.guiEle["window"])
			self.guiEle["button2"]	= new(CDxButton, "Rechte geben", 227, 99, 151, 36, tocolor(255,255,255,255), self.guiEle["window"])

			self.guiEle["label3"]	= new(CDxLabel, "Saldo:", 10, 273, 180, 21, tocolor(255,255,255,255), 1.0, "default-bold", "left", "center", self.guiEle["window"])
			self.guiEle["label4"]	= new(CDxLabel, "$"..iGeld, 9, 293, 215, 83, tocolor(10,155,10,255), 2.0, "default-bold", "center", "center", self.guiEle["window"])
			self.guiEle["edit2"]	= new(CDxEdit, "", 231, 257, 151, 26, "normal", tocolor(0, 0, 0, 255), self.guiEle["window"])
			self.guiEle["label5"]	= new(CDxLabel, "Wert:", 231, 232, 149, 19, tocolor(255,255,255,255), 1.0, "default-bold", "left", "center", self.guiEle["window"])
			self.guiEle["button3"]	= new(CDxButton, "Einzahlen", 232, 293, 151, 36, tocolor(255,255,255,255), self.guiEle["window"])
			self.guiEle["button4"]	= new(CDxButton, "Auszahlen", 231, 339, 151, 36, tocolor(255,255,255,255), self.guiEle["window"])

			self.guiEle["label6"]	= new(CDxLabel, "Einstellungen aendern:", 395, 25, 147, 19, tocolor(255,255,255,255), 1.0, "default-bold", "left", "center", self.guiEle["window"])
			self.guiEle["gridlist2"] = new(CDxList, 390, 47, 210, 215, tocolor(125, 125, 125, 200), self.guiEle["window"])
			self.guiEle["label7"]	= new(CDxLabel, "Wert:", 423, 283, 149, 19, tocolor(255,255,255,255), 1.0, "default-bold", "left", "center", self.guiEle["window"])
			self.guiEle["edit3"]	= new(CDxEdit, "", 423, 303, 151, 26, "normal", tocolor(0, 0, 0, 255), self.guiEle["window"])

			self.guiEle["button5"]	= new(CDxButton, "Speichern", 423, 339, 151, 36, tocolor(255,255,255,255), self.guiEle["window"])

			-- SACHEN --
			-- LISTE --
			self.guiEle["gridlist1"]:addColumn("Spielername");
			self.guiEle["gridlist1"]:addColumn("Rank");

			self:Update(iID, iCost, iOwnerID, sTitle, sDescription, tblSettings)

			-- RECHTE GEBEN --
			self.guiEle["button2"]:addClickFunction(function()
				local text = self.guiEle["edit1"]:getText();
				if(#text > 2) then
					triggerServerEvent("onBusinessPermissionGive", localPlayer, iID, text)
				else
					showInfoBox("error", "Bitte gebe einen Namen an!");
				end
			end)
			-- RECHTE ENTFERNEN
			self.guiEle["button1"]:addClickFunction(function()
				local text = self.guiEle["gridlist1"]:getRowData(1);
				if(#text > 2) then
					triggerServerEvent("onBusinessPermissionRemove", localPlayer, iID, text)
				else
					showInfoBox("error", "Bitte waehle einen Spieler aus!");
				end
			end)
			-- EINZAHLEN --
			self.guiEle["button3"]:addClickFunction(function()
				local text = tonumber(self.guiEle["edit2"]:getText());
				if(text) and (text > 0) then
					triggerServerEvent("onBusinessGeldEinzahl", localPlayer, iID, math.floor(text))
				else
					showInfoBox("error", "Bitte gebe eine Korrekte Zahl ein!");
				end
			end)

			-- AUSZAHLEN --
			self.guiEle["button4"]:addClickFunction(function()
				local text = tonumber(self.guiEle["edit2"]:getText());
				if(text) and (text > 0) then
					triggerServerEvent("onBusinessGeldAuszahl", localPlayer, iID, math.floor(text))
				else
					showInfoBox("error", "Bitte gebe eine Korrekte Zahl ein!");
				end
			end)


			self.guiEle["window"]:add(self.guiEle["label1"])
			self.guiEle["window"]:add(self.guiEle["label2"])
			self.guiEle["window"]:add(self.guiEle["label3"])
			self.guiEle["window"]:add(self.guiEle["label4"])
			self.guiEle["window"]:add(self.guiEle["label5"])
			self.guiEle["window"]:add(self.guiEle["label6"])
			self.guiEle["window"]:add(self.guiEle["label7"])

			self.guiEle["window"]:add(self.guiEle["edit1"])
			self.guiEle["window"]:add(self.guiEle["edit2"])
			self.guiEle["window"]:add(self.guiEle["edit3"])

			self.guiEle["window"]:add(self.guiEle["button1"])
			self.guiEle["window"]:add(self.guiEle["button2"])
			self.guiEle["window"]:add(self.guiEle["button3"])
			self.guiEle["window"]:add(self.guiEle["button4"])
			self.guiEle["window"]:add(self.guiEle["button5"])

			self.guiEle["window"]:add(self.guiEle["gridlist1"])
			self.guiEle["window"]:add(self.guiEle["gridlist2"])

			self.guiEle["window"]:setHideFunction(function()
				self.guiEle["window"] = false;
			end)


			if(rechte == 2) then
				self.guiEle["button5"]:setDisabled(true);
				self.guiEle["button4"]:setDisabled(true);
				self.guiEle["button1"]:setDisabled(true);
				self.guiEle["button2"]:setDisabled(true);
			end

			self.guiEle["window"]:show();
		end
	end
end
]]
-- ///////////////////////////////
-- ///// Show		 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function BusinessGUI:Show(iID, iCost, iOwnerID, sTitle, sDescription, sEinkommen)
if getPedOccupiedVehicle(getLocalPlayer()) then return false end
	if not(self.guiEle["window"]) then

		self.guiEle["window"] 	= new(CDxWindow, "Business", 466, 274, true, true, "Center|Middle")


		local path = "res/images/business/"..sTitle..".png"
		if not(fileExists(path)) then
			path = "res/images/business/0.jpg"
		end


		self.guiEle["image"]	= new(CDxImage, 9, 22, 209, 106, path, tocolor(255,255,255,255), self.guiEle["window"])
		self.guiEle["label1"]	= new(CDxLabel, "Filliale: "..sTitle.."("..iID..")\n\nBesitzer: "..iOwnerID.."\n\nEinkommen: $"..sEinkommen.."\n\nKosten: $"..iCost, 225, 24, 229, 102, tocolor(255,255,255,255), 1.0, "default-bold", "left", "top", self.guiEle["window"])
		self.guiEle["label2"]	= new(CDxLabel, "Beschreibung:\n\n"..string.removeInvalidSonderzeichen(sDescription), 11, 133, 443, 82, tocolor(255,255,255,255), 1.0, "default-bold", "left", "top", self.guiEle["window"])


		if(buttonText2 == "Pranger") then
			self.guiEle["button2"]:setDisabled(true);
		end

		self.guiEle["window"]:add(self.guiEle["image"]);
		self.guiEle["window"]:add(self.guiEle["label1"]);
		self.guiEle["window"]:add(self.guiEle["label2"]);


		self.guiEle["window"]:setHideFunction(function()
			self.guiEle["window"] = false;
		end)

		self.guiEle["window"]:show();
	end
end

-- ///////////////////////////////
-- ///// Hide		 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function BusinessGUI:Hide()
	self.guiEle["window"]:hide();
	self.guiEle["window"] = false;
end


-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function BusinessGUI:Constructor(...)
	-- Klassenvariablen --
	self.guiEle		= {}

	-- Methoden --
	self.BusinessOpen	= function(...) self:Show(...) end;

	-- Events --
	addEventHandler("onClientBusinessOpen", getLocalPlayer(), self.BusinessOpen)
	--logger:OutputInfo("[CALLING] BusinessGUI: Constructor");
end

-- EVENT HANDLER --
