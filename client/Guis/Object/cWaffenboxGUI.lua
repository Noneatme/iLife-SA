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
-- ## Name: WaffenschrankGUI.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

WaffenschrankGUI = {};
WaffenschrankGUI.__index = WaffenschrankGUI;

addEvent("onClientWaffenschrankInfosRefresh", true)

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

function WaffenschrankGUI:New(...)
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

function WaffenschrankGUI:RefreshDatas()
	self.guiEle.gridlist[1]:clearRows();

--[[
self.guiEle.label[4]:setText("$"..getElementData(self.uObject, "wa:geld"));

for name, bool in pairs(self.tblList) do
self.guiEle.gridlist[1]:addRow(name);
end]]
	for id, ammo in pairs(self.tblList) do
		self.guiEle.gridlist[1]:addRow(getWeaponNameFromID(id).."|"..ammo.." Schuss");
	end
end

-- ///////////////////////////////
-- ///// CreateGUI	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function WaffenschrankGUI:CreateGUI()

	self.guiEle.window[1] 		= new(CDxWindow, "Waffenschrank", 348, 259, true, true, "Center|Middle")
	self.guiEle.gridlist[1] 	= new(CDxList, 10, 23, 176, 180, tocolor(125, 125, 125, 200), self.guiEle.window[1])
	--	self.guiEle.edit[1] 		= new(CDxEdit, "", 197, 48, 141, 30, "normal", tocolor(0, 0, 0, 255), self.guiEle.window[1])
	self.guiEle.label[1] 		= new(CDxLabel, "Aktionen:", 197, 25, 136, 17, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "top", self.guiEle.window[1])
	self.guiEle.button[1] 		= new(CDxButton, "Waffe einlagern", 196, 48, 138, 34, tocolor(255, 255, 255, 255), self.guiEle.window[1])
	self.guiEle.button[2] 		= new(CDxButton, "Waffe herausnehmen", 196, 89, 138, 34, tocolor(255, 255, 255, 255), self.guiEle.window[1])

	--[[
	self.guiEle.label[2] 		= new(CDxLabel, "Geld:", 196, 172, 136, 17, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "top", self.guiEle.window[1])
	self.guiEle.edit[2] 		= new(CDxEdit, "", 196, 193, 141, 30, "normal", tocolor(0, 0, 0, 255), self.guiEle.window[1])
	self.guiEle.button[3] 		= new(CDxButton, "Einzahlen", 196, 227, 138, 34, tocolor(255, 255, 255, 255), self.guiEle.window[1])
	self.guiEle.button[4] 		= new(CDxButton, "Auszahlen", 196, 265, 138, 34, tocolor(255, 255, 255, 255), self.guiEle.window[1])
	self.guiEle.label[3] 		= new(CDxLabel, "Saldo:", 14, 209, 167, 14, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "top", self.guiEle.window[1])
	self.guiEle.label[4] 		= new(CDxLabel, "$0", 13, 231, 168, 68, tocolor(25, 255, 25, 255), 3, "default-bold", "center", "center", self.guiEle.window[1])
	]]
	self.guiEle.gridlist[1]:addColumn("Waffe");
	self.guiEle.gridlist[1]:addColumn("Munition");

	self.guiEle.window[1]:add(self.guiEle.gridlist[1]);
	--	self.guiEle.window[1]:add(self.guiEle.edit[1]);
	self.guiEle.window[1]:add(self.guiEle.label[1]);
	self.guiEle.window[1]:add(self.guiEle.button[1]);
	self.guiEle.window[1]:add(self.guiEle.button[2]);
	--[[
	self.guiEle.window[1]:add(self.guiEle.label[2]);
	self.guiEle.window[1]:add(self.guiEle.edit[2]);
	self.guiEle.window[1]:add(self.guiEle.button[3]);
	self.guiEle.window[1]:add(self.guiEle.button[4]);
	self.guiEle.window[1]:add(self.guiEle.label[3]);
	self.guiEle.window[1]:add(self.guiEle.label[4]);]]

	self.guiEle.window[1]:hide();

	-- Waffe einlagern --
	self.guiEle.button[1]:addClickFunction(function()
		triggerServerEvent("onWaffenschrankWaffeEinlager", localPlayer, self.uObject)
	end)

	-- Waffe herausnehmen

	self.guiEle.button[2]:addClickFunction(function()
		local sName = self.guiEle.gridlist[1]:getRowData(1);

		if(sName) and (#sName >= 2) and (sName ~= nil) and (sName ~= "nil") then
			triggerServerEvent("onWaffenschrankWaffeHerausnehm", localPlayer, sName, self.uObject)
		else

			showInfoBox("error", "Bitte w\aehle einen Waffe aus der Liste!")
		end

	end)
end

-- ///////////////////////////////
-- ///// Show		 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function WaffenschrankGUI:Show(uObject, tblList)

	self.guiEle.window[1]:show();

	self.uObject = uObject;
	self.tblList = tblList;

	self:RefreshDatas()

end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function WaffenschrankGUI:Constructor()
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

	addEventHandler("onClientWaffenschrankInfosRefresh", getLocalPlayer(), self.refreshInfosFunc)
	--logger:OutputInfo("[CALLING] WaffenschrankGUI: Constructor");
end

-- EVENT HANDLER --
