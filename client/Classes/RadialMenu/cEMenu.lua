--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

-- #######################################
-- ## Project: 	HUD iLife				##
-- ## For MTA: San Andreas				##
-- ## Name: EMenu.lua					##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings

EMenu = {};
EMenu.__index = EMenu;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function EMenu:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// LoadSettings 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function EMenu:LoadSettings()
	if(fileExists("settings/RadialMenu/settings.ini")) then
		local tbl = {};
		
		local file = EasyIni:LoadFile("settings/RadialMenu/settings.ini");
		for i = 1, #self.options, 1 do
			tbl[i] = file:Get("settings", "O"..i);
		end
		
		if(#tbl > 9) then
			self.options = tbl;
		else
			outputDebugString("Could not parse RadialMenu Settings file: "..#tbl);
		end
		
		file:Save();
	end
end

-- ///////////////////////////////
-- ///// SaveSettings 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function EMenu:SaveSettings()
	if(fileExists("settings/RadialMenu/settings.ini")) then
		fileDelete("settings/RadialMenu/settings.ini");
	end
	local file = EasyIni:NewFile("settings/RadialMenu/settings.ini");
	
	for i = 1, #self.options, 1 do
		file:Set("settings", "O"..i, self.options[i]);
	end
	file:Save();
end

-- ///////////////////////////////
-- ///// ConfigRadialCMD	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function EMenu:ConfigRadialCMD(cmd, sParam1, ...)
	local sParams = table.concat({...}, " ");
	sParam1 = tonumber(sParam1)
		
	if not(sParam1) then
		outputChatBox(self.defaultOutput, 0, 255, 0);
		outputChatBox("Ein GUI wird folgen.", 0, 255, 0);
	else
		if(sParam1 > 0 and sParam1 < 11) then
			self.options[sParam1] = sParams;
			self:SaveSettings()
			outputChatBox("Option "..sParam1.." ist nun "..sParams.."!", 0, 255, 0);
		else
			outputChatBox(self.defaultOutput, 0, 255, 0);
		end 
	end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function EMenu:Constructor(...)
	self.options = {
		"/handsup",
		"/lay",
		"/ground",
		"/chairsit",
		"/anims",
		"/radialconfig",
		"/radialconfig",
		"/radialconfig",
		"/radialconfig",
		"/radialconfig",	
	}
	
	self.defaultOutput	= "Verwende: /radialconfig <Radialslot (1-10)> <Command mit Parametern>";
	
	self:LoadSettings();
	self.radialMenu = RadialMenu:New(true, self.options);
	self.configRadial = function(...) self:ConfigRadialCMD(...) end;
	
	-- Events --
	addCommandHandler("radialconfig", self.configRadial);
	
	--outputDebugString("[CALLING] EMenu: Constructor");
end

-- EVENT HANDLER --
