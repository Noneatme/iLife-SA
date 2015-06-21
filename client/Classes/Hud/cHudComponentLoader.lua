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
	if(fileExists("savedfiles/hudsettings/"..componentname..".ini")) then
		local tbl = {};
		local file = EasyIni:LoadFile("savedfiles/hudsettings/"..componentname..".ini");
		
		if(file.data["settings"]) then
			for index, key in pairs(file.data["settings"]) do
				if(isNumber(key)) then
					key = tonumber(key)
				end
				tbl[index] = key;
			end
		else
			tbl = false;

	--		hud.hudSaver:UpdateComponent(componentname, components)
		end
		
		file:Save();
		if(fileExists("savedfiles/hudsettings/global.ini")) then
			local gFile = EasyIni:LoadFile("savedfiles/hudsettings/global.ini");
			local sx, sy = tonumber(gFile:Get("global", "sx")), tonumber(gFile:Get("global", "sy"))
			--[[
			local global_zoom = tonumber(gFile:Get("global", "zoom"));
			if not(global_zoom) then
				global_zoom = 1;
			end]]
			local aesx, aesy = guiGetScreenSize()
			
			if(sx ~= aesx or sy ~= aesy) and (tbl) then
				tbl.sx = tbl.sx/sx*aesx;
				tbl.sy = tbl.sy/sy*aesy;
				outputConsole("Resolution changed, updating components")
			end
			
			gFile:Save();
		end
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
-- ///// LoadRenderReihenfolge////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponentLoader:LoadRenderReihenfolge()
	local file = EasyIni:LoadFile("savedfiles/hudsettings/renderreihenfolge.ini");
	
	if not(file) then
		return false;
	end
	
	local render_reihenfolge = {}
	
	local ammount = tonumber(file:Get("settings", "ammount"));

	if not(ammount) or (type(tonumber(ammount)) ~= "number") then
		hud.hudSaver:SaveRenderReihenfolge(hud.renderReihenfolge)
		outputConsole("[ERROR] Renderreihenfolge not found!")
		return
	end

	for i = 1, ammount, 1 do
		render_reihenfolge[i] = file:Get("settings", "r"..i)

	end	
	
	file:Save();
	return render_reihenfolge
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponentLoader:Constructor(...)
	-- Instanzen
	
	-- Funktionen
	
	-- Events
-- 	outputDebugString("[CALLING] HudComponentLoader: Constructor");
end

-- EVENT HANDLER --

function isNumber(sString)
	if(tonumber(sString) == nil) then return true else return false end;
end
