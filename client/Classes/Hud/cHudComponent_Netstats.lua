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
-- ## Name: HudComponent_Netstats.lua	##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings

HudComponent_Netstats = {};
HudComponent_Netstats.__index = HudComponent_Netstats;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function HudComponent_Netstats:New(...)
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

function HudComponent_Netstats:Toggle(bBool)
	local component_name = "netstats"

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

function HudComponent_Netstats:Render()
	local component_name = "netstats"
	
	local x, y = hud.components[component_name].sx, hud.components[component_name].sy;
	local w, h = hud.components[component_name].width*hud.components[component_name].zoom, hud.components[component_name].height*hud.components[component_name].zoom;
	
	local alpha = hud.components[component_name].alpha

--	dxDrawRectangle(17, 183, 271, 278, tocolor(5, 0, 0, 117), true)
	dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0, alpha/2), true);
	dxDrawRectangle(x+10*hud.components[component_name].zoom, y+5*hud.components[component_name].zoom, 245*hud.components[component_name].zoom, 30*hud.components[component_name].zoom, tocolor(0, 0, 0, alpha/2), true);
	
	dxDrawText("Network Statistics", x+21*hud.components[component_name].zoom, y+3*hud.components[component_name].zoom, w+8*hud.components[component_name].zoom, h+((278-222)*hud.components[component_name].zoom), tocolor(255, 255, 255, alpha), 1*hud.components[component_name].zoom, "pricedown", "left", "top", false, false, true, false, false)
	
	local stats = getNetworkStats();
	
	local statsstring = [[
		Bytes received: 	]]..stats["bytesReceived"]..[[ (]]..math.round(((stats["bytesReceived"]/1024)/1024), 2)..[[ MB)
		
		Bytes sent: 		]]..stats["bytesSent"]..[[ (]]..math.round(((stats["bytesSent"]/1024)/1024), 2)..[[ MB)
		
		Packets received: 	]]..stats["packetsReceived"]..[[
		
		
		Packets sent: 		]]..stats["packetsSent"]..[[
		
		
		Packet loss: 		]]..stats["packetlossTotal"]..[[%
		
		Ping: 				]]..getPlayerPing(localPlayer)..[[ MS
		
		
		Client Version:	 	]]..getVersion().sortable..[[
		]]
	
	dxDrawText(statsstring, x+6*hud.components[component_name].zoom, y-((183-227)*hud.components[component_name].zoom), w+8*hud.components[component_name].zoom, h+((278-454)*hud.components[component_name].zoom), tocolor(255, 255, 255, alpha), 1*hud.components[component_name].zoom, "default-bold", "left", "top", false, false, true, false, false)
		
end


-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Netstats:Constructor(...)
	
-- 	outputDebugString("[CALLING] HudComponent_Netstats: Constructor");
end

-- EVENT HANDLER --
