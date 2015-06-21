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
-- ## Name: HudComponent_Money.lua		##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings

HudComponent_Money = {};
HudComponent_Money.__index = HudComponent_Money;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function HudComponent_Money:New(...)
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

function HudComponent_Money:Toggle(bBool)
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

function HudComponent_Money:Render()
	local component_name = "money"
	
	local x, y = hud.components[component_name].sx, hud.components[component_name].sy;
	local w, h = hud.components[component_name].width*hud.components[component_name].zoom, hud.components[component_name].height*hud.components[component_name].zoom;
	
	local alpha = hud.components[component_name].alpha

	
	local minus = (getTickCount()-hud.startTick);
	
	minus = (minus/10)
		
	dxDrawImage(x, y, w, h, hud.pfade.images.."component_money/money_background.png", 0, 0, 0, tocolor(255, 255, 255, alpha));
	
	
	dxDrawImageSection(x, y, w, h, 666, -minus, 666, 573/2, hud.pfade.images.."component_money/money_flying.png", 0, 0, 0, tocolor(255, 255, 255, alpha/2))
	
	x = x+130*hud.components[component_name].zoom
	
	dxDrawText("$"..setDotsInNumber(tostring(getPlayerMoney())), x, y, x+w, y+h, tocolor(200, 200, 200, alpha), 0.4*hud.components[component_name].zoom, hud.fonts.money, "left", "center")
	
end


-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Money:Constructor(...)
	
-- 	outputDebugString("[CALLING] HudComponent_Money: Constructor");
end

-- EVENT HANDLER --
