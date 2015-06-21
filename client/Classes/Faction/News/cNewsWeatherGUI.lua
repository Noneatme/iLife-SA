--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

-- #######################################
-- ## Project: MTA iLife				##
-- ## Name: NewsWeatherGUI.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

NewsWeatherGUI = {};
NewsWeatherGUI.__index = NewsWeatherGUI;

addEvent("onClientWeekweatherGetBack", true);
--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function NewsWeatherGUI:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// Render		 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function NewsWeatherGUI:Render()
	if(self.weatherData) and (self.show == true) then
		dxDrawRectangle(135/self.aesx*self.sx, 95/self.aesy*self.sy, 1187/self.aesx*self.sx, 712/self.aesy*self.sy, tocolor(0, 0, 0, self.alpha/2), true)
		dxDrawText("Wetterdaten vom: "..self:GetDate().." bis: "..self:GetDate(6).." (In Etwa)", 220/self.aesx*self.sx, 114/self.aesy*self.sy, 698/self.aesx*self.sx, 163/self.aesy*self.sy, tocolor(255, 255, 255, self.alpha), 2/(self.aesx+self.aesy)*(self.sx+self.sy), "sans", "center", "center", false, false, true, false, false)
		dxDrawLine(185/self.aesx*self.sx, 172/self.aesy*self.sy, 1269/self.aesx*self.sx, 172/self.aesy*self.sy, tocolor(255, 255, 255, self.alpha), 1/(self.aesx+self.aesy)*(self.sx+self.sy), true)

		local iHorizontalAdd1			= 0;
		local iHorizontalAddNumer1		= 142/self.aesx*self.sx;

		local iHorizontalAdd		= 0;
		local iHorizontalAddNumer	= 142/self.aesx*self.sx;
		for day = 0, 6, 1 do
			-- Render Ueberschrift

			local iVerticalAdd			= 0;
			local iVerticalAddNumber	= 21/self.aesy*self.sy;

			local sDay, _, iDay		= self:GetDate(day);

			if(iDay <= 31) then
				dxDrawText(sDay, ((176/self.aesx*self.sx)+iHorizontalAdd1), 193/self.aesy*self.sy, ((343/self.aesx*self.sx)+iHorizontalAdd1), 224/self.aesy*self.sy, tocolor(255, 255, 255, self.alpha), 2/(self.aesx+self.aesy)*(self.sx+self.sy), "default-bold", "center", "center", false, false, true, false, false)
				iHorizontalAdd1	= iHorizontalAdd1+iHorizontalAddNumer1;

				for hour = 0, 23, 1 do
					if(self.weatherData[sDay][hour]) then
						local weatherName = self.weatherIDs:GetWeatherFromID(self.weatherData[sDay][hour])

						dxDrawText(hour.." Uhr: "..self.wetterNamen[weatherName], (236/self.aesx*self.sx)+iHorizontalAdd, ((248+123)/self.aesy*self.sy)+iVerticalAdd, (176/self.aesx*self.sx)+iHorizontalAdd, (140/self.aesy*self.sy)+iVerticalAdd, tocolor(255, 255, 255, self.alpha), 1/(self.aesx+self.aesy)*(self.sx+self.sy), "default-bold", "left", "center", false, false, true, false, false)
						dxDrawImage((216/self.aesx*self.sx)+iHorizontalAdd, (248/self.aesy*self.sy)+iVerticalAdd, 16/self.aesx*self.sx, 16/self.aesy*self.sy, self.pfade.images.."hud/component_weather/icons/"..self.wetterIcons[weatherName]..".png", 0, 0, 0, tocolor(255, 255, 255, self.alpha), true)

						iVerticalAdd	= iVerticalAdd+iVerticalAddNumber;
					end
				end

				iHorizontalAdd = iHorizontalAdd+iHorizontalAddNumer;
			end
		end


		if(self.enabled) then
			if(self.alpha < 250) then
				self.alpha = self.alpha+10

			end
		else
			if(self.alpha > 0) then
				self.alpha = self.alpha-10
			else
				self.show = false;
			end
		end
	end
end

-- ///////////////////////////////
-- ///// Enable		 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function NewsWeatherGUI:Enable()
	if(self.enabled == false) then
		self.enabled = true;
		triggerServerEvent("onClientWeekweatherGet", localPlayer)
		toggleControl("enter_exit", false)
		self.show	 = true;
	end
end

-- ///////////////////////////////
-- ///// Disable	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function NewsWeatherGUI:Disable()
	if(self.enabled == true) then
		self.enabled = false;
		toggleControl("enter_exit", true)
		
	end
end

-- ///////////////////////////////
-- ///// GetDate	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function NewsWeatherGUI:GetDate(iDayPlus, iMonthPlus)
	local time = getRealTime();

	return (time.monthday+(iDayPlus or 0)).."."..((time.month+1)+(iMonthPlus or 0)).."."..(time.year+1900), time.hour, time.monthday;
end

-- ///////////////////////////////
-- ///// GetDatas	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function NewsWeatherGUI:GetDatas(tblDatas)
	self.weatherData	= tblDatas;
end


function NewsWeatherGUI:ToggleWeatherDingens(uKey, bState)
	if(isPedInVehicle(localPlayer)) and (getElementData(localPlayer, "Fraktion") == 6) and (getElementData(getPedOccupiedVehicle(localPlayer), "Fraktion")) and (tonumber(getElementData(getPedOccupiedVehicle(localPlayer), "Fraktion")) == 6) then
		if(bState == "down") then
			self:Enable()
		else
			self:Disable()
		end
	end
end
-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function NewsWeatherGUI:Constructor(...)
	-- Klassenvariablen --
	self.enabled		= false;
	self.show			= false;
	self.sx, self.sy	= guiGetScreenSize()
	self.aesx, self.aesy = 1440, 900;

	self.alpha			= 0;


	self.wetterNamen	=
	{
		["clear"] = "Klar",
		["sunny"] = "Sonne",
		["cloudy"] = "Wolken",
		["rainy"] = "Regen",
		["foggy"] = "Nebel",
	}

	self.pfade			= {};
	self.pfade.images	= "res/images/";


	self.wetterIcons	=
	{
		["clear"]		= "state_clear_day",
		["sunny"]		= "state_clear_day",
		["cloudy"]		= "state_cloudy_day",
		["foggy"]		= "state_foggy_day_night",
		["rainy"]		= "state_rainy_day_night",
	}

	-- Methoden --
	self.renderFunc				= function(...) self:Render(...) end;
	self.dataGetFunc			= function(...) self:GetDatas(...) end;
	self.toggleWeatherDingens 	= function(...) self:ToggleWeatherDingens(...) end;
	self.toggleWeatherVehicleFunc = function(uPlayer) if(uPlayer == localPlayer) then self:Disable() end end;

	self.weatherData	= false;
	self.weatherIDs		= WeatherIDs:New();



	bindKey("lshift", "both", self.toggleWeatherDingens)
	
	-- Events --
	addEventHandler("onClientRender", getRootElement(), self.renderFunc)
	addEventHandler("onClientWeekweatherGetBack", getRootElement(), self.dataGetFunc)
	addEventHandler("onClientVehicleExit", getRootElement(), self.toggleWeatherVehicleFunc)
	--logger:OutputInfo("[CALLING] NewsWeatherGUI: Constructor");
end

-- EVENT HANDLER --
