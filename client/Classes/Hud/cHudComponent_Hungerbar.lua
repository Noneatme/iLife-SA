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
-- ## Name: HudComponent_Hungerbar.lua	##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings

HudComponent_Hungerbar = {};
HudComponent_Hungerbar.__index = HudComponent_Hungerbar;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function HudComponent_Hungerbar:New(...)
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

function HudComponent_Hungerbar:Toggle(bBool)
	local component_name = "hungerbar"

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

function HudComponent_Hungerbar:Render()
	local component_name = "hungerbar"
	
	local x, y = hud.components[component_name].sx, hud.components[component_name].sy;
	local w, h = hud.components[component_name].width*hud.components[component_name].zoom, hud.components[component_name].height*hud.components[component_name].zoom;
	
	local alpha = hud.components[component_name].alpha
	
		
	local hunger = (tonumber(getElementData(localPlayer, "Hunger")) or 100);
	
	local r2, g2, b2 = 255, 255, 255
	if(hunger <= 0) then
		r2, g2, b2 = 255, 0, 0
	else
		hunger = math.abs(hunger - 0.01)
		r2, g2, b2 = (100 - hunger) * 2.55 / 2, hunger * 2.55, 0
	end
	
	
	local alpha2 =  (((hunger*(((255/hunger)*hunger)/hunger))*alpha/255))
	-- Background
	
	if(hunger < 1) then
		alpha2 = 255;
	end
	
	dxDrawImage(x-20*hud.components[component_name].zoom, y-20*hud.components[component_name].zoom, w+(40*hud.components[component_name].zoom), h+(40*hud.components[component_name].zoom), hud.pfade.images.."component_hungerbar/apple_sprite.png", 0, 0, 0, tocolor(r2, g2, b2, alpha2));

	
	dxDrawImage(x, y, w, h, hud.pfade.images.."component_hungerbar/apple_background.png", 0, 0, 0, tocolor(255, 255, 255, alpha));

	-- Section
	
	local height = 256/100*hunger;
	
	dxDrawImageSection ( x, y+64*hud.components[component_name].zoom, 64*hud.components[component_name].zoom, (-64/100*hunger)*hud.components[component_name].zoom, 0, 0, 256, -height, hud.pfade.images.."component_hungerbar/apple_background.png", 0, 0, 0, tocolor(r2, g2, b2, alpha) )
		
	dxDrawImage(x-30*hud.components[component_name].zoom, y-30*hud.components[component_name].zoom, w+(60*hud.components[component_name].zoom), h+(60*hud.components[component_name].zoom), hud.pfade.images.."component_hungerbar/apple_circle.png", getTickCount()/hud.comSettings["hungerbar"]["speed"], 0, 0, tocolor(255, 255, 255, alpha/2));				
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Hungerbar:Constructor(...)
	
-- 	outputDebugString("[CALLING] HudComponent_Hungerbar: Constructor");
end

-- EVENT HANDLER --
