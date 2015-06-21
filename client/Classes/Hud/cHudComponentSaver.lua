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
-- ///// CheckForSavedComponents//
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponentSaver:CheckForSavedComponents(tblComponents)
	--outputChatBox(tostring(EasyIni))
	for component, settings in pairs(tblComponents) do
		if not(fileExists("savedfiles/hudsettings/"..component..".ini")) then
			local file = EasyIni:NewFile("savedfiles/hudsettings/"..component..".ini");

			for set, val in pairs(tblComponents[component]) do
				file:Set("settings", set, val);
			end
			if(self.defaultDisabled[component]) then
				file:Set("settings", "enabled", 0)
			end


			file:Save();
		end
	end
	-- Settingsfile
	local settingsFile = EasyIni:LoadFile("savedfiles/hudsettings/global.ini");
	if not(settingsFile) then
		settingsFile = EasyIni:NewFile("savedfiles/hudsettings/global.ini");
		local sx, sy = guiGetScreenSize();

		settingsFile:Set("global", "sx", sx);
		settingsFile:Set("global", "sy", sy);
		settingsFile:Set("global", "zoom", 1.0);

		settingsFile:Save();
	else
		local sx, sy = tonumber(settingsFile:Get("global", "sx")), tonumber(settingsFile:Get("global", "sy"))
		local aesx, aesy = guiGetScreenSize()

		if(sx ~= aesx or sy ~= aesy) then
			settingsFile:Set("global", "sx", aesx);
			settingsFile:Set("global", "sy", aesy);
		end
	end
	if not(fileExists("savedfiles/hudsettings/DO_NOT_EDIT_ANY_OF_THIS_FILES.important")) then
		local file = fileCreate("savedfiles/hudsettings/DO_NOT_EDIT_ANY_OF_THIS_FILES.important")
		fileWrite(file, "Seriously, don't. Unless you know what you are doing.\nIf you have problems, e.g. bad resolution or the widgets are out of your window, you can reset the 'sx' and 'sy' positions using your resoultion and divide it with 2.")
		fileFlush(file);
		fileClose(file);

		outputChatBox("Dies ist dein erster Besuch auf diesem Server.", 0, 255, 255)
		outputChatBox("Falls ein paar Sachen in deinem HUD nicht funktionieren, solltest du reconnecten.", 0, 255, 255)
		outputChatBox("Dein HUD kannst du mit F2 bearbeiten.", 0, 255, 255)

	end

	settingsFile:Save();
end

-- ///////////////////////////////
-- ///// UpdateComponent	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponentSaver:UpdateComponent(componentname, tblComponents)
	local file = EasyIni:LoadFile("savedfiles/hudsettings/"..componentname..".ini");

	if(file) then
		for index, key in pairs(tblComponents[componentname]) do
			file:Set("settings", index, key)
		end
		file:Save();
	else
		outputConsole("Component Error, updateComponent")
		-- Loop, aber egal
	end
end

-- ///////////////////////////////
-- ///// SaveRenderReihenfolge//// // Gutes Denglisch
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponentSaver:SaveRenderReihenfolge(renderReihenfolge)
	local file = EasyIni:LoadFile("savedfiles/hudsettings/renderreihenfolge.ini");

	if not(file) then
		file = EasyIni:NewFile("savedfiles/hudsettings/renderreihenfolge.ini");
	end

	for index, component in ipairs(renderReihenfolge) do
		file:Set("settings", "r"..index, component);
	end
	file:Set("settings", "ammount", #renderReihenfolge);
	file:Save()

	outputConsole("[HUD] Saved Render Reihenfolge");
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

	outputConsole("[HUD] Saved Component Setting [INI] for Component: "..sComponent.."("..sName..", "..sSetting..")");
	return file:Get(sName, sSetting);
end

-- ///////////////////////////////
-- ///// HardReset			//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponentSaver:HardReset()
	if(hud.hudModifier.state == true) then
		local andere_dateien =
		{
			["renderreihenfolge"] = true;
			["global"] = true;
		}

		for component, tbl in pairs(hud.components) do
			if(fileExists("savedfiles/hudsettings/"..component..".ini")) then
				fileDelete("savedfiles/hudsettings/"..component..".ini");
			end
		end
		for component, tbl in pairs(andere_dateien) do
			if(fileExists("savedfiles/hudsettings/"..component..".ini")) then
				fileDelete("savedfiles/hudsettings/"..component..".ini");
			end
		end
		playSound(hud.pfade.sounds.."bing.mp3", false)
		outputChatBox("HUD Einstellungen wurden gelöscht! Bitte reconnecte!", 255, 0, 0);
	else
		outputChatBox("Bitte öffne deinen Designer (F2) für diese Funktion.", 255, 0, 0);
	end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponentSaver:Constructor(...)
	-- Instanzen
	self.defaultDisabled = {
		["netstats"] 	= true,
		["wanteds"] 	= true,
		["money"] 		= true,
		["weather"] 	= true,
		["ping"]	 	= true,
		["weapons"]	 	= true,
		["development"] = true,
		["handy"]		= true,
		["heartclock"]	= true,
	}
	-- Funktionen

	-- Events
	-- 	outputDebugString("[CALLING] HudComponentSaver: Constructor");
end

-- EVENT HANDLER --
