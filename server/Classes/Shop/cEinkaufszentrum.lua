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
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Einkaufszentrum:Constructor(...)
	-- Klassenvariablen --
	self.outerMarker	= createMarker(392.12609863281, -1820.7961425781, 7.9182176589966, "corona", 1.0, 0, 255, 0);
	self.outerPos		= {392.17297363281, -1817.6300048828, 7.8409013748169};

	self.innerMarker	= createMarker(384.50814819336, -1825.1776123047, 7.8359375, "corona", 1.0, 0, 255, 0);
	self.innerPos		= {384.32287597656, -1828.3394775391, 7.8359375};

	aussichtsPunkt:CreateInOutMarker(self.outerMarker, self.innerPos[1], self.innerPos[2], self.innerPos[3], "onClientEnterExitEK", 168)
	aussichtsPunkt:CreateInOutMarker(self.innerMarker, self.outerPos[1], self.outerPos[2], self.outerPos[3], "onClientEnterExitEK", 0)


	self.BadezimmerShop = ItemShops[11].addMarker(ItemShops[11], 0, 0, 400.86291503906, -1852.0213623047, 7.5182176589966)
	self.WohnzimmerShop = ItemShops[12].addMarker(ItemShops[12], 0, 0, 383.5419921875, -1852.3303222656, 7.5182176589966)
	self.KuechenShop	= ItemShops[13].addMarker(ItemShops[13], 0, 0, 398.08285522461, -1842.1667480469, 7.5182176589966)
	self.EsszimmerShop	= ItemShops[14].addMarker(ItemShops[14], 0, 0, 384.48004150391, -1840.7575683594, 7.5182176589966)
	self.DekorationsShop= ItemShops[15].addMarker(ItemShops[15], 0, 0, 384.17166137695, -1845.9605712891, 7.5182176589966)
	self.HHGeraeteShop	= ItemShops[16].addMarker(ItemShops[16], 0, 0, 401.56903076172, -1830.0378417969, 7.5182176589966)
	self.SchlafzimerShop= ItemShops[17].addMarker(ItemShops[17], 0, 0, 384.28192138672, -1834.1448974609, 7.5182176589966)
	self.ArbeitsZShop	= ItemShops[18].addMarker(ItemShops[18], 0, 0, 396.60772705078, -1835.4291992188, 7.5182176589966)

	createBlip(2411.6201171875, -1426.2027587891, 23.984161376953, 65);

	self.ID = 0
	CShop.constructor(self, "Einkaufszentrum", self.ID)
	-- Methoden --


	-- Events --

	--logger:OutputInfo("[CALLING] Einkaufszentrum: Constructor");

end

-- EVENT HANDLER --
