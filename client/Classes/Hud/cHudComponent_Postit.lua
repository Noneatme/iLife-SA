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
-- ## Name: HudComponent_Postit.lua		##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings

HudComponent_Postit = {};
HudComponent_Postit.__index = HudComponent_Postit;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function HudComponent_Postit:New(...)
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

function HudComponent_Postit:Toggle(bBool)
	local component_name = "postit"

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

function HudComponent_Postit:Render()
	local component_name = "postit"
	
	local x, y = hud.components[component_name].sx, hud.components[component_name].sy;
	local w, h = hud.components[component_name].width*hud.components[component_name].zoom, hud.components[component_name].height*hud.components[component_name].zoom;
	
	local alpha = hud.components[component_name].alpha

	dxDrawImage(x, y, w, h, hud.pfade.images.."component_postit/background.png", 0, 0, 0, tocolor(255, 255, 255, alpha));
	
	dxDrawText(self.changelog, x+30*hud.components[component_name].zoom, y+25*hud.components[component_name].zoom, x+w-30*hud.components[component_name].zoom, y+h-25*hud.components[component_name].zoom, tocolor(0, 0, 0, alpha), 1*hud.components[component_name].zoom, "default-bold", "left", "top", false, true)
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Postit:Constructor(...)
	self.changelog =
	[[	Changelog 1.3:
		-------------
		
		- Changelog hinzugefuegt
		- Komponente koennen nun einzelnd verkleinert werden
		- HUD Anti-Lag hinzugefuegt
			+ Irgendwann spaeter kommen Gangzonen mit ins Radar
		- Diverse Performance-Sachen
	]]
	
-- 	outputDebugString("[CALLING] HudComponent_Postit: Constructor");
end

-- EVENT HANDLER --
