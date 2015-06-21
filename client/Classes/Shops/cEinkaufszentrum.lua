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
-- ## Name: Einkaufszentrum.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings

Einkaufszentrum = {};
Einkaufszentrum.__index = Einkaufszentrum;

addEvent("onClientEnterExitEK", true)

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function Einkaufszentrum:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// EnterExitEK 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Einkaufszentrum:EnterExitEK(bBool)
	--[[
	if(bBool == "no") then
		bBool = false;
	else
		bBool = true;
	end
	setElementCollisionsEnabled(self.gebaeude, bBool);
	]]
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Einkaufszentrum:Constructor(...)
	-- Klassenvariablen --
	self.frame			= createObject(2257, 391.89999389648, -1854.9000244141, 9, 0, 0, 180);
	self.frame2			= createObject(2257, 390.79998779297, -1821.5, 15.800000190735, 0, 0, 180);
	self.gebaeude		= createObject(6874, 391.29998779297,-1841.3000488281, 6.5999999046326, 0, 0, 270);
	
	setObjectScale(self.frame2, 5);
	setObjectScale(self.frame, 1.5);
	
	FrameTextur:New(self.frame, "cj_painting15", "logos/einkaufszentrum.png");
	FrameTextur:New(self.frame2, "cj_painting15", "logos/einkaufszentrum.png");
	
	self.einkaufsInt	 = createObject(14671, 394.39999389648, -1829.6999511719, 8.8999996185303, 0, 0, 270);
	FrameTextur:New(self.einkaufsInt, "bwtilebroth", "floors/tile1.png");
	
	self.vk1			= createPed(17, 388.98031616211, -1826.6030273438, 7.8359375, 180);
	addEventHandler("onClientPedDamage", self.vk1, cancelEvent)
	setElementFrozen(self.vk1, true);
	
	self.vk2			= createPed(59, 392.18814086914, -1826.966796875, 7.8359375, 180);
	addEventHandler("onClientPedDamage", self.vk2, cancelEvent)
	setElementFrozen(self.vk2, true);
	
	
	setElementCollisionsEnabled(self.gebaeude, false);
	-- Methoden --
	self.EEEK	 = function(...) self:EnterExitEK(...) end;
	
	-- Events --
	addEventHandler("onClientEnterExitEK", getRootElement(), self.EEEK)
	--logger:OutputInfo("[CALLING] Einkaufszentrum: Constructor");
end

-- EVENT HANDLER --
