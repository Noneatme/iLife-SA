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
-- ## Name: HudComponent_Wanteds.lua					##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings

HudComponent_Wanteds = {};
HudComponent_Wanteds.__index = HudComponent_Wanteds;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function HudComponent_Wanteds:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// Toggle		 		//////
-- ///// Returns:	void	//////
-- ///////////////////////////////

function HudComponent_Wanteds:Toggle(bBool)
	local component_name = "wanteds"

	if (bBool == nil) then
		hud.components[component_name].enabled = not (hud.components[component_name].enabled);
	else
		hud.components[component_name].enabled = bBool;
	end
end


-- ///////////////////////////////
-- ///// Render				//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Wanteds:Render()
	local component_name = "wanteds"
	
	local x, y = hud.components[component_name].sx, hud.components[component_name].sy;
	local w, h = hud.components[component_name].width*hud.components[component_name].zoom, hud.components[component_name].height*hud.components[component_name].zoom;
	
	local alpha = hud.components[component_name].alpha
	
	dxDrawImage(x, y, w, h, hud.pfade.images.."component_wanted/wanted_background.png", 0, 0, 0, tocolor(255, 255, 255, alpha));
	
	
	if(getPlayerWantedLevel() > 0) then
		local skinid = getElementModel(localPlayer);
		
		if(fileExists(hud.pfade.images.."skins/"..skinid..".jpg")) then
			dxDrawImage(x+15*hud.components[component_name].zoom, y+30*hud.components[component_name].zoom, w-30*hud.components[component_name].zoom, h-40*hud.components[component_name].zoom, hud.pfade.images.."skins/"..skinid..".jpg", 0, 0, 0, tocolor(255, 255, 255, alpha));
	
		end
		
		dxDrawText(getPlayerWantedLevel(), x, y, x+w, y+h/1.2, tocolor(255, 255, 255, alpha/3), 0.2*hud.components[component_name].zoom, hud.fonts.clock, "center", "bottom")
	end
	
	local jailtime = getElementData(localPlayer, "Jailtime")
	if(tonumber(jailtime)) and (tonumber(jailtime) > 0) then
		dxDrawText("Minuten \nverbleibend:", x, y, x+w, y+h/2, tocolor(0, 0, 0, alpha/1), 1*hud.components[component_name].zoom, "default-bold", "center", "bottom")
		dxDrawText(jailtime, x, y, x+w, y+h/1.2, tocolor(0, 0, 0, alpha/1), 0.2*hud.components[component_name].zoom, hud.fonts.clock, "center", "bottom")
	
	end
	
end


-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Wanteds:Constructor(...)
	
-- 	outputDebugString("[CALLING] HudComponent_Wanteds: Constructor");
end

-- EVENT HANDLER --
