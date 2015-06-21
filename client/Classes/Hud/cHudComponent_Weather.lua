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
-- ## Name: HudComponent_Weather.lua	##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings

HudComponent_Weather = {};
HudComponent_Weather.__index = HudComponent_Weather;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function HudComponent_Weather:New(...)
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

function HudComponent_Weather:Toggle(bBool)
	local component_name = "wanteds"

	if (bBool == nil) then
		hud.components[component_name].enabled = not (hud.components[component_name].enabled);
	else
		hud.components[component_name].enabled = bBool;
	end
end


-- ///////////////////////////////
-- ///// CheckBolt	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Weather:CheckBolt()
	-- Urgent:
	-- Diese Methode wird in einem 'onClientRender' Event aufgerufen.
	
	if not(isTimer(self.blitzWaitTimer)) then

		self.blitzWaitTimer = setTimer(self.blitzAddFunc, math.random(500, 10000), 1)
	end
end

-- ///////////////////////////////
-- ///// AddRandomBlitz		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Weather:AddRandomBlitz()
	local id = math.random(1, 3)
	
	self.blitzAlpha[id] = 255;
	
end


-- ///////////////////////////////
-- ///// Render					//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Weather:Render()
	local component_name = "weather"
	
	local x, y = hud.components[component_name].sx, hud.components[component_name].sy;
	local w, h = hud.components[component_name].width*hud.components[component_name].zoom, hud.components[component_name].height*hud.components[component_name].zoom;
	
	local alpha = hud.components[component_name].alpha
	
	dxDrawImage(x, y, w, h, hud.pfade.images.."component_weather/background.png", 0, 0, 0, tocolor(200, 255, 200, alpha));
	
	-- Weather
	
	local id = getWeather()
	

	
	local name = self.weather_list[id]
	
	local rightText1 = "False"
	local rightText2 = 0;
	if(name) then else
		name = self.weather_list[1]
		rightText1 = "Sunny(Default)"
	end

	local time = getTime()
	
	local heatHaze = getHeatHaze()
	local tempMin, tempMax = 0, 20
	local temp = math.round((heatHaze/(tempMax/2.55)), 1, "round")

	if(fileExists(hud.pfade.images.."component_weather/icons/"..name.."_day_night.png")) then
		name = name.."_day_night"
		rightText1 = self.weather_namelist[id];
	else
		if(time < 7) or (time > 20) then
			name = name.."_night";
			rightText1 = self.weather_namelist_night[id];
		else
			name = name.."_day";
			rightText1 = self.weather_namelist[id];
		end
	end

--	outputChatBox(name)
	
	-- Weather Icons
	if not(fileExists(hud.pfade.images.."component_weather/icons/"..name..".png")) then
		name = "state_clear_day";
		rightText1 = "Blue sky"
	end
	
	
	dxDrawImage(x+40*hud.components[component_name].zoom, y-5*hud.components[component_name].zoom, 109*hud.components[component_name].zoom, 109*hud.components[component_name].zoom, hud.pfade.images.."component_weather/icons/"..name..".png", 0, 0, 0, tocolor(255, 255, 255, alpha));

		
	-- Regen Blitze
	if(self.is_rain[id]) then
		for i = 1, 3, 1 do
			local alpha2 = self.blitzAlpha[i]
			
			if(alpha2 > 2) then
				alpha2 = alpha2-2
				
				self.blitzAlpha[i] = alpha2;
				
				dxDrawImage(x, y, w, h, hud.pfade.images.."component_weather/bolt_"..i..".png", 0, 0, 0, tocolor(200, 200, 255, alpha2/255*alpha));
	
			end
		end
	end
	
	-- Text
	if not(rightText1) then
		rightText1 = "Unknow"
	end
	
	dxDrawText(rightText1, x+w/(1.6), y+10*hud.components[component_name].zoom, x+w, y+h, tocolor(255, 255, 255, alpha), 1.7*hud.components[component_name].zoom, "default-bold", "center", "top", false, false, true, false, false)
	
	
	dxDrawText(temp.."' C", x+w/(1.6), y+60*hud.components[component_name].zoom, x+w, y+h, tocolor(255, 255, 255, alpha), 1.4*hud.components[component_name].zoom, "default-bold", "center", "top", false, false, true, false, false)
	
	-- Spezielles
	
	-- Regen
	
	if(self.is_rain[id]) then
		dxDrawImageSection(x, y, w, h, 697-getTickCount()/20, -getTickCount()/10, 697, 384/2, hud.pfade.images.."component_weather/rain_texture.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
		self:CheckBolt();
	
		-- Blitz Alphas
		
		
	end
end


-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Weather:Constructor(...)
	-- Instanzen
	
	self.weather_list = {
		[0] = "state_clear",
		[1] = "state_clear",
		[2] = "state_clear",
		[3] = "state_cloudy2",
		[4] = "state_cloudy2",
		[5] = "state_cloudy2",
		[6] = "state_cloudy2",
		[7] = "state_cloudy",
		[8] = "state_rainy",
		[9] = "state_foggy",
		[10] = "state_clear",
		[11] = "state_clear",
		[12] = "state_cloudy2",
		[13] = "state_clear",
		[14] = "state_clear",
		[15] = "state_clear",
		[16] = "state_rainy",
		[17] = "state_clear",
		[18] = "state_clear",
		[19] = "state_foggy",
		[20] = "state_clear",
	}
	
	self.weather_namelist = {
		[0] = "Blue sky",
		[1] = "Blue sky",
		[2] = "Blue sky",
		[3] = "Cloudy",
		[4] = "Cloudy",
		[5] = "Cloudy",
		[6] = "Cloudy",
		[7] = "Cloudy",
		[8] = "Rainy",
		[9] = "Foggy",
		[10] = "Blue sky",
		[11] = "Blue sky",
		[12] = "Cloudy",
		[13] = "Blue sky",
		[14] = "Blue sky",
		[15] = "Blue sky",
		[16] = "Stormy",
		[17] = "Blue sky",
		[18] = "Blue sky",
		[19] = "Sandstorm",
		[20] = "Blue sky",
	}
	self.weather_namelist_night = {
		[1] = "Clear sky",
		[2] = "Clear sky",
		[3] = "Cloudy",
		[4] = "Cloudy",
		[5] = "Cloudy",
		[6] = "Cloudy",
		[7] = "Cloudy",
		[8] = "Rainy",
		[9] = "Foggy",
		[10] = "Clear sky",
		[11] = "Clear sky",
		[12] = "Cloudy",
		[13] = "Clear sky",
		[14] = "Clear sky",
		[15] = "Clear sky",
		[16] = "Stormy",
		[17] = "Clear sky",
		[18] = "Clear sky",
		[19] = "Sandstorm",
		[20] = "Clear sky",
	}
	
	self.is_rain = {
		[8] = true,
		[16] = true,
	}
	
	self.blitzAlpha = {
		[1] = 0,
		[2] = 0,
		[3] = 0,
	}
	-- Funktionen
	self.blitzAddFunc = function() self:AddRandomBlitz() end;
	
	-- Events
-- 	outputDebugString("[CALLING] HudComponent_Weather: Constructor");
end

-- EVENT HANDLER --
