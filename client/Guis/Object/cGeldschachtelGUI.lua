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
-- ## Name: GeldschachtelGUI.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

GeldschachtelGUI = {};
GeldschachtelGUI.__index = GeldschachtelGUI;

addEvent("onClientGeldschachtelInfosRefresh", true)

--[[

self.guiEle = {
edit = {},
button = {},
window = {},
label = {},
gridlist = {}
}
addEventHandler("onClientResourceStart", resourceRoot,
function()
self.guiEle.window[1] = guiCreateWindow(559, 260, 348, 319, "Geldschachtel", false)
guiWindowSetSizable(self.guiEle.window[1], false)

self.guiEle.gridlist[1] = guiCreateGridList(10, 23, 176, 180, false, self.guiEle.window[1])
self.guiEle.edit[1] = guiCreateEdit(197, 48, 141, 30, "", false, self.guiEle.window[1])
self.guiEle.label[1] = guiCreateLabel(197, 25, 136, 17, "Spielername:", false, self.guiEle.window[1])
self.guiEle.button[1] = guiCreateButton(196, 89, 138, 34, "Rechte geben", false, self.guiEle.window[1])
guiSetProperty(self.guiEle.button[1], "NormalTextColour", "FFAAAAAA")
self.guiEle.button[2] = guiCreateButton(196, 128, 138, 34, "Rechte entfernen", false, self.guiEle.window[1])
guiSetProperty(self.guiEle.button[2], "NormalTextColour", "FFAAAAAA")
self.guiEle.label[2] = guiCreateLabel(196, 172, 136, 17, "Geld:", false, self.guiEle.window[1])
self.guiEle.edit[2] = guiCreateEdit(196, 193, 141, 30, "", false, self.guiEle.window[1])
self.guiEle.button[3] = guiCreateButton(196, 227, 138, 34, "Einzahlen", false, self.guiEle.window[1])
guiSetProperty(self.guiEle.button[3], "NormalTextColour", "FFAAAAAA")
self.guiEle.button[4] = guiCreateButton(196, 265, 138, 34, "Auszahlen", false, self.guiEle.window[1])
guiSetProperty(self.guiEle.button[4], "NormalTextColour", "FFAAAAAA")
self.guiEle.label[3] = guiCreateLabel(14, 209, 167, 14, "Saldo:", false, self.guiEle.window[1])
self.guiEle.label[4] = guiCreateLabel(13, 231, 168, 68, "$0", false, self.guiEle.window[1])
guiLabelSetHorizontalAlign(self.guiEle.label[4], "center", false)
guiLabelSetVerticalAlign(self.guiEle.label[4], "center")
end
)

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function GeldschachtelGUI:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// SetMoney	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function GeldschachtelGUI:RefreshDatas()
	self.guiEle.gridlist[1]:clearRows();

	self.guiEle.label[4]:setText("$"..getElementData(self.uObject, "wa:geld") or 0);

	for name, bool in pairs(self.tblList) do
		self.guiEle.gridlist[1]:addRow(name);
	end
end

-- ///////////////////////////////
-- ///// CreateGUI	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function GeldschachtelGUI:CreateGUI()

	self.guiEle.window[1] 		= new(CDxWindow, "Geldschachtel", 348, 369, true, true, "Center|Middle")
	self.guiEle.gridlist[1] 	= new(CDxList, 10, 23, 176, 180, tocolor(125, 125, 125, 200), self.guiEle.window[1])
	self.guiEle.edit[1] 		= new(CDxEdit, "", 197, 48, 141, 30, "normal", tocolor(0, 0, 0, 255), self.guiEle.window[1])
	self.guiEle.label[1] 		= new(CDxLabel, "Spielername:", 197, 25, 136, 17, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "top", self.guiEle.window[1])
	self.guiEle.button[1] 		= new(CDxButton, "Rechte geben", 196, 89, 138, 34, tocolor(255, 255, 255, 255), self.guiEle.window[1])
	self.guiEle.button[2] 		= new(CDxButton, "Rechte entfernen", 196, 128, 138, 34, tocolor(255, 255, 255, 255), self.guiEle.window[1])
	self.guiEle.label[2] 		= new(CDxLabel, "Geld:", 196, 172, 136, 17, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "top", self.guiEle.window[1])
	self.guiEle.edit[2] 		= new(CDxEdit, "", 196, 193, 141, 30, "normal", tocolor(0, 0, 0, 255), self.guiEle.window[1])
	self.guiEle.button[3] 		= new(CDxButton, "Einzahlen", 196, 227, 138, 34, tocolor(255, 255, 255, 255), self.guiEle.window[1])
	self.guiEle.button[4] 		= new(CDxButton, "Auszahlen", 196, 265, 138, 34, tocolor(255, 255, 255, 255), self.guiEle.window[1])
	self.guiEle.label[3] 		= new(CDxLabel, "Saldo:", 14, 209, 167, 14, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "top", self.guiEle.window[1])
	self.guiEle.label[4] 		= new(CDxLabel, "$0", 13, 231, 168, 68, tocolor(25, 255, 25, 255), 3, "default-bold", "center", "center", self.guiEle.window[1])

	self.guiEle.gridlist[1]:addColumn("Spieler");

	self.guiEle.window[1]:add(self.guiEle.gridlist[1]);
	self.guiEle.window[1]:add(self.guiEle.edit[1]);
	self.guiEle.window[1]:add(self.guiEle.label[1]);
	self.guiEle.window[1]:add(self.guiEle.button[1]);
	self.guiEle.window[1]:add(self.guiEle.button[2]);
	self.guiEle.window[1]:add(self.guiEle.label[2]);
	self.guiEle.window[1]:add(self.guiEle.edit[2]);
	self.guiEle.window[1]:add(self.guiEle.button[3]);
	self.guiEle.window[1]:add(self.guiEle.button[4]);
	self.guiEle.window[1]:add(self.guiEle.label[3]);
	self.guiEle.window[1]:add(self.guiEle.label[4]);

	self.guiEle.window[1]:hide();

	-- Rechte Geben --
	self.guiEle.button[1]:addClickFunction(function()
		local sName = self.guiEle.edit[1]:getText()

		if(#sName > 1) then
			triggerServerEvent("onGeldschachtelPermissionGebe", localPlayer, sName, self.uObject)
		else
			showInfoBox("error", "Bitte gebe einen Namen ein!");
		end
	end)
	-- Rechte Entfernen --
	self.guiEle.button[2]:addClickFunction(function()
		local sName = self.guiEle.gridlist[1]:getRowData(1);

		if(sName) and (#sName > 1) then
			triggerServerEvent("onGeldschachtelPermissionLoesche", localPlayer, sName, self.uObject)
		else
			showInfoBox("error", "Bitte waehle einen Namen aus der Liste!")
		end

	end)

	-- Geld einzahlen --

	self.guiEle.button[3]:addClickFunction(function()
		local iValue = tonumber(self.guiEle.edit[2]:getText())

		if(iValue) and (iValue > 0) then
			triggerServerEvent("onGeldschachtelEinzahl", localPlayer, self.uObject, iValue)
		else
			showInfoBox("error", "Bitte gebe eine korrekte Zahl ein!")
		end

	end)

	-- Geld auszahlen --

	self.guiEle.button[4]:addClickFunction(function()
		local iValue = tonumber(self.guiEle.edit[2]:getText())

		if(iValue) and (iValue > 0) then
			triggerServerEvent("onGeldschachtelAuszahl", localPlayer, self.uObject, iValue)
		else
			showInfoBox("error", "Bitte gebe eine korrekte Zahl ein!")
		end

	end)
end

-- ///////////////////////////////
-- ///// Show		 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function GeldschachtelGUI:Show(uObject, tblList)

	self.guiEle.window[1]:show();

	self.uObject = uObject;
	self.tblList = tblList;

	self:RefreshDatas()

end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function GeldschachtelGUI:Constructor()
	-- Klassenvariablen --
	self.guiEle = {
		edit = {},
		button = {},
		window = {},
		label = {},
		gridlist = {}
	}

	-- Methoden --
	self:CreateGUI()

	self.uObject	= false;
	self.tblList	= {}

	self.refreshInfosFunc = function(...) self:Show(...) end;
	-- Events --

	addEventHandler("onClientGeldschachtelInfosRefresh", getLocalPlayer(), self.refreshInfosFunc)
	--logger:OutputInfo("[CALLING] GeldschachtelGUI: Constructor");
end

-- EVENT HANDLER --
