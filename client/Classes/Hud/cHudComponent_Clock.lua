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
-- ## Name: HudComponent_Clock.lua					##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings

HudComponent_Clock = {};
HudComponent_Clock.__index = HudComponent_Clock;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function HudComponent_Clock:New(...)
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

function HudComponent_Clock:Render()

	local x, y = hud.components["clock"].sx, hud.components["clock"].sy;
	local w, h = hud.components["clock"].width*hud.components["clock"].zoom, hud.components["clock"].height*hud.components["clock"].zoom;
	
	local alpha = hud.components["clock"].alpha
	-- Image
	dxDrawImage(x, y, w, h, hud.pfade.images.."component_clock/img_clock.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
	
	-- Text
	dxDrawText(self:GetTime(), x, y, x+w, y+h, tocolor(255, 255, 255, alpha), 0.3*hud.components["clock"].zoom, hud.fonts.clock, "center", "center")
end

-- ///////////////////////////////
-- ///// Toggle		 		//////
-- ///// Returns:	void	//////
-- ///////////////////////////////

function HudComponent_Clock:Toggle(bBool)
	local component_name = "clock"

	if (bBool == nil) then
		hud.components[component_name].enabled = not (hud.components[component_name].enabled);
	else
		hud.components[component_name].enabled = bBool;
	end
end


-- ///////////////////////////////
-- ///// GetTime			//////
-- ///// Returns: String	//////
-- ///////////////////////////////

function HudComponent_Clock:GetTime()
	local time = getRealTime()
	local day = time.monthday
	local month = time.month+1
	local year = time.year+1900
	local hour = time.hour
	local minute = time.minute
	local second = time.second;
	
	if(hour < 10) then
		hour = "0"..hour;
	end
	
	if(minute < 10) then
		minute = "0"..minute;
	end
	
	if(second < 10) then
		second = "0"..second;
	end
	return hour..":"..minute..":"..second;
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Clock:Constructor(...)
	
-- 	outputDebugString("[CALLING] HudComponent_Clock: Constructor");
end

-- EVENT HANDLER --
