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
-- ## Name: HudComponentLoader.lua		##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings

HudComponentLoader = {};
HudComponentLoader.__index = HudComponentLoader;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function HudComponentLoader:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// LoadComponentFile	//////
-- ///// Returns:bool/table //////
-- ///////////////////////////////

function HudComponentLoader:LoadComponentFile(componentname, components)
	if(fileExists("savedfiles/hudsettings/"..componentname..".cfg")) then
		local tbl = {}
		
		local file = fileOpen("savedfiles/hudsettings/"..componentname..".cfg")
		local input = fileRead(file, fileGetSize(file));
		-- Warum hab ich das eigentlich nicht mit der Ini gemacht?
		tbl.sx = tonumber(gettok(input, 1, ","));
		tbl.sy = tonumber(gettok(input, 2, ","));
		tbl.width = tonumber(gettok(input, 3, ","));
		tbl.height = tonumber(gettok(input, 4, ","));
		tbl.alpha = tonumber(gettok(input, 5, ","));
		tbl.enabled = (tonumber(gettok(input, 6, ",")) or 1);
		
		
		if(fileExists("savedfiles/hudsettings/global.cfg")) then
			local settingsfile = fileOpen("savedfiles/hudsettings/global.cfg");
			
			local text = fileRead(settingsfile, fileGetSize(settingsfile));
		
			local sx, sy = tonumber(gettok(text, 1, ",")), tonumber(gettok(text, 2, ","));
			
			local aesx, aesy = guiGetScreenSize()
			
			if(sx ~= aesx or sy ~= aesy) then
				tbl.sx = tbl.sx/sx*aesx;
				tbl.sy = tbl.sy/sy*aesy;
			end
			
			fileClose(settingsfile)
		end
		fileClose(file);
		
		return tbl;
	else
		return false;
	end
end

-- ///////////////////////////////
-- ///// GetComponentSetting /////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponentLoader:GetComponentSetting(sComponent, sName, sSetting)
	local file = EasyIni:LoadFile("savedfiles/hudsettings/"..sComponent..".ini");
	
	if not(file) then
		file = EasyIni:NewFile("savedfiles/hudsettings/"..sComponent..".ini");
		file:Save();
		return false;
	end
	
	local data = file:Get(sName, sSetting);
	
	if(data) then
		return data;
	else
		return false;
	end
	
end


-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponentLoader:Constructor(...)
	-- Instanzen
	
	-- Funktionen
	
	-- Events
	outputDebugString("[CALLING] HudComponentLoader: Constructor");
end

-- EVENT HANDLER --
