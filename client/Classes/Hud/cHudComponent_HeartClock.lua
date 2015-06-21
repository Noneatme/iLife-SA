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
-- ## Name: HudComponent_HeartClock.lua	##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings

HudComponent_HeartClock = {};
HudComponent_HeartClock.__index = HudComponent_HeartClock;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function HudComponent_HeartClock:New(...)
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

function HudComponent_HeartClock:Toggle(bBool)
	local component_name = "heartclock"

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

function HudComponent_HeartClock:Render()
	dxSetRenderTarget();
	
	local x, y = hud.components["heartclock"].sx, hud.components["heartclock"].sy;
	local w, h = hud.components["heartclock"].width*hud.components["heartclock"].zoom, hud.components["heartclock"].height*hud.components["heartclock"].zoom;
	
	local alpha = hud.components["heartclock"].alpha
	

	-- Image
	local s = dxDrawImage(x, y, w, h, hud.pfade.images.."component_heartbar/hearth_clock_bg.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
	

	local curTick = getTickCount()
	
	curTick = curTick

	local minus = (curTick-hud.startTick);
	
	minus = (minus/10)

	--if(curTick-hud.startTick > 4950) then
	--	hud.startTick = getTickCount()
	-- end

	local hp = getElementHealth(localPlayer)
	local r2, g2, b2 = 255, 255, 255
	if(hp <= 0) then
		r2, g2, b2 = 255, 0, 0
	else
		hp = math.abs(hp - 0.01)
		r2, g2, b2 = (100 - hp) * 2.55 / 2, hp * 2.55, 0
	end
	
	local add = 105;

	
	dxDrawImageSection(x+5, y+5, w-10, h-10, 366-minus, 0, 366-100, 105, hud.pfade.images.."component_heartbar/hearth_clock.png", 0, 0, 0, tocolor(r2, g2, b2, alpha))
	
	-- Render Blood
	
	local bl1, bl2, bl3 = self.bloodAlpha[1], self.bloodAlpha[2], self.bloodAlpha[3]
	local removeValue = 0.1;
	
	
	if(bl1 > 0) and (hp > bl1/3) then
		self.bloodAlpha[1] = self.bloodAlpha[1]-removeValue;
	end
	
	if(bl2 > 0) and (hp > bl2/3)  then
		self.bloodAlpha[2] = self.bloodAlpha[2]-removeValue;
	end
	
	if(bl3 > 0) and (hp > bl3/3) then
		self.bloodAlpha[3] = self.bloodAlpha[3]-removeValue;
	end

	dxDrawImage(x, y, w, h, hud.pfade.images.."component_heartbar/hearth_clock_blood1.png", 0, 0, 0, tocolor(255, 255, 255, bl1))
	dxDrawImage(x, y, w, h, hud.pfade.images.."component_heartbar/hearth_clock_blood2.png", 0, 0, 0, tocolor(255, 255, 255, bl2))
	dxDrawImage(x, y, w, h, hud.pfade.images.."component_heartbar/hearth_clock_blood3.png", 0, 0, 0, tocolor(255, 255, 255, bl3))

end


-- ///////////////////////////////
-- ///// PlayerDamage		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_HeartClock:PlayerDamage(attacker, weapon, bodypart, loss)
	local rand = math.random(1, 3);
	
	if(rand == 1) then
		rand = math.random(1, 3);
	end
	
	
	self.bloodAlpha[rand] = self.bloodAlpha[rand]+loss*5;
	
	
	if(self.bloodAlpha[rand] > 255) then
		self.bloodAlpha[rand] = 255;
	end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_HeartClock:Constructor(...)
	-- Instanzen
	self.bloodAlpha = {0, 0, 0};
	
	-- Funktionen
	self.damageFunc = function(...) self:PlayerDamage(...) end;
	
	-- Methoden
	addEventHandler("onClientPlayerDamage", localPlayer, self.damageFunc)
-- 	outputDebugString("[CALLING] HudComponent_HeartClock: Constructor");
end

-- EVENT HANDLER --
