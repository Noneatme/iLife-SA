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
-- ## Name: HudComponent_Breath.lua					##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings

HudComponent_Breath = {};
HudComponent_Breath.__index = HudComponent_Breath;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function HudComponent_Breath:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// Render				//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Breath:Render()

	local component_name = "breath"

	local x, y = 0, 0
	local w, h = hud.sx, hud.sy;
	
	local fProgress = getPedOxygenLevel(localPlayer)/1000
	
	local alpha = interpolateBetween(200, 0, 0, 0, 0, 0, fProgress, "InOutQuad");

	dxDrawImage(x, y, w, h, hud.pfade.images.."component_breath/breath_background.png", 0, 0, 0, tocolor(100, 100, 255, alpha));
	
end

-- ///////////////////////////////
-- ///// Toggle		 		//////
-- ///// Returns:	void	//////
-- ///////////////////////////////

function HudComponent_Breath:Toggle(bBool)
	local component_name = "breath"

	if (bBool == nil) then
		hud.components[component_name].enabled = not (hud.components[component_name].enabled);
	else
		hud.components[component_name].enabled = bBool;
	end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Breath:Constructor(...)
	-- Instanzen
	self.alpha = 0;
	-- Funktionen
	
	-- Methoden
	-- outputDebugString("[CALLING] HudComponent_Breath: Constructor");
end

-- EVENT HANDLER --
