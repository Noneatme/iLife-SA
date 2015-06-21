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
-- ## Name: WeatherIDs.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

WeatherIDs = {};
WeatherIDs.__index = WeatherIDs;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function WeatherIDs:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// GetWeatherFromID	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function WeatherIDs:GetWeatherFromID(iID)
	for weather, ids in pairs(self.ids) do
		for index, weatherID in pairs(ids) do
			if(weatherID == (tonumber(iID) or 0)) then
				return weather;
			end
		end
	end
	return false;
end

-- ///////////////////////////////
-- GetRandomWeatherIDFromCategory
-- ///// Returns: void		//////
-- ///////////////////////////////

function WeatherIDs:GetRandomWeatherIDFromCategory(sCategory)
	return self.ids[sCategory][math.random(1, #self.ids[sCategory])];
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function WeatherIDs:Constructor(...)
	-- Klassenvariablen --

	self.ids		=
	{
		["clear"] 	= {0, 2, 3, 6, 11, 13}, -- ohne Wolken
		["sunny"] 	= {1, 5, 10, 14}, -- Sonne mit Wolken
		["cloudy"] 	= {4, 7, 15}, -- grauer Himmel
		["rainy"] 	= {8, 16}, -- Regen
		["foggy"] 	= {9}, -- Nebel

    }

    self.rainyIDS   =
    {
        [8] = true,
        [16] = true,
				[9] = true,
    }

	-- Methoden --


	-- Events --

	--logger:OutputInfo("[CALLING] WeatherIDs: Constructor");
end

-- EVENT HANDLER --
