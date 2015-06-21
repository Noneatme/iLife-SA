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
-- ## Name: HudComponentSaver.lua		##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings

HudComponentSaver = {};
HudComponentSaver.__index = HudComponentSaver;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function HudComponentSaver:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// DoCreateNewSettingsFile//
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponentSaver:DoCreateNewSettingsFile(componentname, tblComponents)
	local file = fileCreate("savedfiles/hudsettings/"..componentname..".cfg");
	
	local settings = tblComponents[componentname]
	
	local defaultenabled = self.defaultDisabled[componentname]
	if(defaultenabled == true) then
		settings.enabled = 0
	else
		settings.enabled = 1
	end
	
	fileWrite(file, settings.sx..","..settings.sy..","..settings.width..","..settings.height..","..settings.alpha..","..(settings.enabled))
	
	fileFlush(file);
	fileClose(file);
	
	if not(fileExists("savedfiles/hudsettings/DO_NOT_EDIT_ANY_OF_THIS_FILES.important")) then
		fileClose(fileCreate("savedfiles/hudsettings/DO_NOT_EDIT_ANY_OF_THIS_FILES.important"))
	end
end

-- ///////////////////////////////
-- ///// CheckForSavedComponents//
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponentSaver:CheckForSavedComponents(tblComponents)
	-- Checking and creating the settings files
	for componentname, setting in pairs(tblComponents) do
		if not(fileExists("savedfiles/hudsettings/"..componentname..".cfg")) then
			self:DoCreateNewSettingsFile(componentname, tblComponents)
		end
	end
	
	local settingsfile;
	if(fileExists("savedfiles/hudsettings/global.cfg")) then
		local settingsfile = fileOpen("savedfiles/hudsettings/global.cfg")
		local text = fileRead(settingsfile, fileGetSize(settingsfile));
		
		local sx, sy = tonumber(gettok(text, 1, ",")), tonumber(gettok(text, 2, ","));
		
		if(sx and sy) then
			local sx2, sy2 = guiGetScreenSize()
			
			if(sx ~= sx2) or(sy2 ~= sy) then
				fileClose(settingsfile);
				fileDelete("savedfiles/hudsettings/global.cfg");
				self:CheckForSavedComponents(tblComponents);
			end
		end
	else
		settingsfile = fileCreate("savedfiles/hudsettings/global.cfg");
		local sx, sy = guiGetScreenSize();
		
		fileWrite(settingsfile, sx..","..sy);
		fileFlush(settingsfile);
		fileClose(settingsfile);
	end
end

-- ///////////////////////////////
-- ///// UpdateComponent	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponentSaver:UpdateComponent(componentname, tblComponents)
	if(fileExists("savedfiles/hudsettings/"..componentname..".cfg")) then
		fileDelete("savedfiles/hudsettings/"..componentname..".cfg")
		local file = fileCreate("savedfiles/hudsettings/"..componentname..".cfg");
		
		local settings = tblComponents[componentname];
		
		fileWrite(file, settings.sx..","..settings.sy..","..settings.width..","..settings.height..","..settings.alpha..","..(settings.enabled or 1))
		
		fileFlush(file);
		fileClose(file);
	else
		self:CheckForSavedComponents(tblComponents);
	end
end

-- ///////////////////////////////
-- ///// SetComponentSetting /////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponentSaver:SetComponentSetting(sComponent, sName, sSetting, sValue)
	local file = EasyIni:LoadFile("savedfiles/hudsettings/"..sComponent..".ini");
	
	if not(file) then
		file = EasyIni:NewFile("savedfiles/hudsettings/"..sComponent..".ini");
	end
	
	file:Set(sName, sSetting, sValue)
	file:Save();
	
	outputDebugString("[HUD] Saved Component Setting [INI] for Component: "..sComponent.."("..sName..", "..sSetting..")");
	return file:Get(sName, sSetting);
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponentSaver:Constructor(...)
	-- Instanzen
	self.defaultDisabled = {
		["netstats"] = true;
	}
	-- Funktionen
	
	-- Events
	outputDebugString("[CALLING] HudComponentSaver: Constructor");
end

-- EVENT HANDLER --
