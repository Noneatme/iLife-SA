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
-- ## Name: HudComponent_Crosshair.lua	##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings

HudComponent_Crosshair = {};
HudComponent_Crosshair.__index = HudComponent_Crosshair;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function HudComponent_Crosshair:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// triggerFunc 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Crosshair:triggerFunc()

	local enabled = 0;
	if(hud) and (hud.components["crosshair"]) then
		if(hud.components["crosshair"].enabled) then
			enabled = hud.components["crosshair"].enabled
		end
	else
		enabled = self.startupEnabled;
	end

	if(enabled == 1) then
		engineApplyShaderToWorldTexture(self.shader, "sitem16");
	else
		engineRemoveShaderFromWorldTexture(self.shader, "sitem16");
	end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Crosshair:Constructor(...)
	showPlayerHudComponent("crosshair", true);
	
	local name, hudklasse = debug.getlocal(3, 1)
	
	self.shader = dxCreateShader(hudklasse.pfade.shaders.."texture.fx");
	
	dxSetShaderValue(self.shader, "Tex", dxCreateTexture(hudklasse.pfade.images.."component_crosshair/crosshair.png"));
	
	self.startupEnabled = tonumber(hudklasse.hudLoader:GetComponentSetting("crosshair", "settings", "enabled"))
	
	self:triggerFunc();
-- 	outputDebugString("[CALLING] HudComponent_Crosshair: Constructor");
end

-- EVENT HANDLER --
