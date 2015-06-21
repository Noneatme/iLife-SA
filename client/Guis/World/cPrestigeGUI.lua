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
-- ## Name: PrestigeGUI.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

PrestigeGUI = {};
PrestigeGUI.__index = PrestigeGUI;

addEvent("onClientPrestigeOpen", true)
--[[

GUIEditor = {
label = {},
button = {},
staticimage = {},
window = {},
}
GUIEditor.window[1] = guiCreateWindow(501, 328, 466, 294, "Prestige", false)
guiWindowSetSizable(GUIEditor.window[1], false)

GUIEditor.staticimage[1] = guiCreateStaticImage(9, 22, 209, 106, ":guieditor/client/colorpicker/palette.png", false, GUIEditor.window[1])
GUIEditor.label[1] = guiCreateLabel(225, 24, 229, 102, "Prestige:\n\nBesitzer:\n\nKosten:", false, GUIEditor.window[1])
guiLabelSetVerticalAlign(GUIEditor.label[1], "center")
GUIEditor.label[2] = guiCreateLabel(11, 133, 443, 82, "Beschreibung:", false, GUIEditor.window[1])
GUIEditor.button[1] = guiCreateButton(13, 239, 187, 46, "Prestige Kaufen", false, GUIEditor.window[1])
guiSetProperty(GUIEditor.button[1], "NormalTextColour", "FFAAAAAA")
GUIEditor.button[2] = guiCreateButton(269, 238, 187, 46, "Pranger", false, GUIEditor.window[1])
guiSetProperty(GUIEditor.button[2], "NormalTextColour", "FFAAAAAA")
]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function PrestigeGUI:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// Show		 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function PrestigeGUI:Show(iID, iCost, iOwnerID, sTitle, sDescription)
	if not(self.guiEle["window"]) then

		self.guiEle["window"] 	= new(CDxWindow, "Prestigeobjekt", 466, 294, true, true, "Center|Middle")
		
		local canSell 	= false;
		local canBuy	= false;
		
		local buttonText = "Prestige Kaufen"
		
		local path = "res/images/prestige/"..iID..".jpg"
		if not(fileExists(path)) then
			path = "res/images/prestige/0.jpg"
		end
		
		if(iOwnerID == 0) then
			iOwnerID = "Niemand";
			canBuy = true;
		end
		
		if(iOwnerID == getPlayerName(localPlayer)) then
			canSell = true;
			buttonText = "Prestige Verkaufen"
		end
		
		self.guiEle["image"]	= new(CDxImage, 9, 22, 209, 106, path, tocolor(255,255,255,255), self.guiEle["window"])
		self.guiEle["label1"]	= new(CDxLabel, "Prestige: "..sTitle.."("..iID..")\n\nBesitzer: "..iOwnerID.."\n\nKosten: $"..iCost, 225, 24, 229, 102, tocolor(255,255,255,255), 1.0, "default-bold", "left", "center", self.guiEle["window"])
		self.guiEle["label2"]	= new(CDxLabel, "Beschreibung:\n\n"..sDescription, 11, 133, 443, 82, tocolor(255,255,255,255), 1.0, "default-bold", "left", "top", self.guiEle["window"])
		self.guiEle["button1"] 	= new(CDxButton, buttonText, 13, 210, 187, 46, tocolor(255,255,255,255), self.guiEle["window"])
		self.guiEle["button2"] 	= new(CDxButton, "Pranger", 269, 210, 187, 46, tocolor(255,255,255,255), self.guiEle["window"])
		
		self.guiEle["button2"]:setDisabled(true)
		
		
		self.guiEle["window"]:add(self.guiEle["image"]);
		self.guiEle["window"]:add(self.guiEle["label1"]);
		self.guiEle["window"]:add(self.guiEle["label2"]);
		self.guiEle["window"]:add(self.guiEle["button1"]);
		self.guiEle["window"]:add(self.guiEle["button2"]);
		
	
		self.guiEle["window"]:setHideFunction(function()
			self.guiEle["window"] = false;
		end)
		
		self.guiEle["button1"]:addClickFunction(function()
			if(canSell == false) and (canBuy == true) then
				self:Hide();
				confirmDialog:showConfirmDialog("Bist du dir sicher, das du dieses Prestige kaufen moechtest?", function()
					triggerServerEvent("onPrestigeBuy", localPlayer, iID)
				end, false, false)
			elseif(canBuy == false) and (canSell == true) then
				self:Hide();
				confirmDialog:showConfirmDialog("Bist du dir sicher, das du dieses Prestige verkaufen moechtest?", function()
					triggerServerEvent("onPrestigeSell", localPlayer, iID)
				end, false, false)
			end
		end)
		
		self.guiEle["window"]:show();
	end
end

-- ///////////////////////////////
-- ///// Hide		 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function PrestigeGUI:Hide()
	self.guiEle["window"]:hide();
	self.guiEle["window"] = false;
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function PrestigeGUI:Constructor(...)
	-- Klassenvariablen --
	self.guiEle		= {}

	-- Methoden --
	self.prestigeOpen	= function(...) self:Show(...) end;

	-- Events --
	addEventHandler("onClientPrestigeOpen", getLocalPlayer(), self.prestigeOpen)
	--logger:OutputInfo("[CALLING] PrestigeGUI: Constructor");
end

-- EVENT HANDLER --
