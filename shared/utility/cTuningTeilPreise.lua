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
-- ## Name: TuningTeilPreise.lua					##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

TuningTeilPreise = {};
TuningTeilPreise.__index = TuningTeilPreise;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function TuningTeilPreise:New(...)
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

function TuningTeilPreise:Constructor(...)
	-- Klassenvariablen --

	self.ItemPrices =
	{
		["GPS"] = 1000,
		["Kofferaum"] = 3500,
		["Sportmotor"] = 25250,
		["Panzerung"] = 23500,
		["Bessere Hydraulik"] = 5250,
		["Grosser Tank"] = 6500,
		["Ersatzreifen"] = 2500,
	}

	self.customVinlys	=
	{
		["Vinly 1"] 		= {2100},
		["Vinly 2"]			= {2101},
		["Vinly 3"]			= {2102},
		["Vinly 4"]			= {2103},


	}

	self.lackierungen =
	{
		["Keine Lackierung"] = 3,
		["Lackierung 1"] = 0,
		["Lackierung 2"] = 1,
		["Lackierung 3"] = 2,

	}
	-- Methoden --


	-- Events --

	--logger:OutputInfo("[CALLING] TuningTeilPreise: Constructor");
end

-- EVENT HANDLER --
TuningTeilPreisClass = TuningTeilPreise:New();
