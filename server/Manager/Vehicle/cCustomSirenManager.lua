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
-- ## Name: CustomSirenManager.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

CustomSirenManager = {};
CustomSirenManager.__index = CustomSirenManager;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function CustomSirenManager:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// AddSirens	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CustomSirenManager:AddTowtruckSirens(uVehicle)
	addVehicleSirens(uVehicle, 3, 2, false, true, true, true)
	setVehicleSirens(uVehicle, 1, 0.55, -0.5, 1.5, 255, 0, 0, 200, 200)
	setVehicleSirens(uVehicle, 2, -0.55, -0.5, 1.5, 255, 0, 0, 255, 200)
	setVehicleSirens(uVehicle, 3, 0, -0.5, 1.5, 255, 255, 0, 255, 200)
end

-- ///////////////////////////////
-- ///// AddNewsvanSirens	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CustomSirenManager:AddNewsvanSirens(uVehicle)
	addVehicleSirens(uVehicle, 4, 2, false, true, true, true)
	setVehicleSirens(uVehicle, 1, 0.9, -2.65, 1.4, 255, 255, 255, 200, 200)
	setVehicleSirens(uVehicle, 2, -0.9, -2.65, 1.4, 255, 255, 255, 200, 200)
	setVehicleSirens(uVehicle, 3, -0.9, -1.25, 1.4, 0, 255, 255, 200, 200)
	setVehicleSirens(uVehicle, 4, 0.9, -1.25, 1.4, 0, 255, 255, 200, 200)
end

-- ///////////////////////////////
-- ///// ParseVehicles		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CustomSirenManager:ParseVehicles()
	for index, uVehicle in pairs(getElementsByType("vehicle")) do
		if(getElementModel(uVehicle) == 525) then
			self:AddTowtruckSirens(uVehicle);
		elseif(getElementModel(uVehicle) == 582) then
			self:AddNewsvanSirens(uVehicle);
		end
	end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CustomSirenManager:Constructor(...)
	-- Klassenvariablen --


	-- Methoden --
	self:ParseVehicles()

	-- Events --

	--logger:OutputInfo("[CALLING] CustomSirenManager: Constructor");
end

-- EVENT HANDLER --
