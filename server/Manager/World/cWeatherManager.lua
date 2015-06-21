--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

 -- #######################################
-- ## Project: 		 iLife				##
-- ## For MTA: San Andreas				##
-- ## Name: WeatherManager.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

WeatherManager = inherit(cSingleton);

addEvent("onClientWeekweatherGet", true)

--[[

]]


-- ///////////////////////////////
-- ///// GetRandInt			//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function WeatherManager:GetRandInt(iVon, iBis)
	return math.random(iVon, iBis);
end

-- ///////////////////////////////
-- ///// GenerateNewWeather	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function WeatherManager:GenerateNewWeather()
	for day = 0, 6, 1 do	-- 7 Tage
		self.generatedData.weatherData[day]	= {};
		for hour = 0, 23, 1 do -- 24 Stunden
			local sCurrentWeatherName 	= (self.WeatherIDs:GetWeatherFromID(self.generatedData.currentWeather) or "sunny");
			local iNewWeather			= 0;

			-- WeatherNames
			if(sCurrentWeatherName == "clear") then
				local iRand = self:GetRandInt(0, 5);
				if(iRand == 0 or iRand == 1) then
					iNewWeather	= self.WeatherIDs:GetRandomWeatherIDFromCategory("clear")
				elseif(iRand == 2 or iRand == 3 or iRand == 4) then
					iNewWeather	= self.WeatherIDs:GetRandomWeatherIDFromCategory("sunny")
				elseif(iRand == 5) then
					iNewWeather	= self.WeatherIDs:GetRandomWeatherIDFromCategory("cloudy")
				else
					iNewWeather	= self.WeatherIDs:GetRandomWeatherIDFromCategory(sCurrentWeatherName)
				end
			elseif(sCurrentWeatherName == "sunny") then
				local iRand = self:GetRandInt(0, 10);
				if(iRand == 0 or iRand == 1) then
					iNewWeather	= self.WeatherIDs:GetRandomWeatherIDFromCategory("clear")
				elseif(iRand == 2 or iRand == 3 or iRand == 4) then
					iNewWeather	= self.WeatherIDs:GetRandomWeatherIDFromCategory("sunny")
				elseif(iRand == 5) then
					iNewWeather	= self.WeatherIDs:GetRandomWeatherIDFromCategory("cloudy")
				else
					iNewWeather	= self.WeatherIDs:GetRandomWeatherIDFromCategory(sCurrentWeatherName)
				end
			elseif(sCurrentWeatherName == "cloudy") then
				local iRand = self:GetRandInt(0, 10);
				if(iRand == 0 or iRand == 1) then
					iNewWeather	= self.WeatherIDs:GetRandomWeatherIDFromCategory("clear")
				elseif(iRand == 2 or iRand == 3) then
					iNewWeather	= self.WeatherIDs:GetRandomWeatherIDFromCategory("foggy")
				elseif(iRand == 10) then
					iNewWeather	= self.WeatherIDs:GetRandomWeatherIDFromCategory("rainy")
				else
					iNewWeather	= self.WeatherIDs:GetRandomWeatherIDFromCategory(sCurrentWeatherName)
				end
			elseif(sCurrentWeatherName == "rainy") then
				local iRand = self:GetRandInt(0, 8);
				if(iRand == 0 or iRand == 1) then
					iNewWeather	= self.WeatherIDs:GetRandomWeatherIDFromCategory("foggy")
				elseif(iRand == 2 or iRand == 3 or iRand == 4) then
					iNewWeather	= self.WeatherIDs:GetRandomWeatherIDFromCategory("cloudy")
				else
					iNewWeather	= self.WeatherIDs:GetRandomWeatherIDFromCategory(sCurrentWeatherName)
				end
			elseif(sCurrentWeatherName == "foggy") then
				local iRand = self:GetRandInt(0, 5);
				if(iRand == 0 or iRand == 1) then
					iNewWeather	= self.WeatherIDs:GetRandomWeatherIDFromCategory("rainy")
				elseif(iRand == 2 or iRand == 3 or iRand == 4) then
					iNewWeather	= self.WeatherIDs:GetRandomWeatherIDFromCategory("cloudy")
				else
					iNewWeather	= self.WeatherIDs:GetRandomWeatherIDFromCategory(sCurrentWeatherName)
				end
			end
			if(iNewWeather > 20) and ((hour >= 21) or (hour <= 6)) then
				iNewWeather = math.random(1, 10);
			end

			self.generatedData.currentWeather 			= iNewWeather;
			self.generatedData.weatherData[day][hour] 	= self.generatedData.currentWeather;
		end
	end

	self:SaveWeatherToDatabase()
	self:LoadWeekWeather()
end

-- ///////////////////////////////
-- ///// GetDate	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function WeatherManager:GetDate(iDayPlus, iMonthPlus)
	local time = getRealTime();

	return (time.monthday+(iDayPlus or 0)).."."..((time.month+1)+(iMonthPlus or 0)).."."..(time.year+1900), time.hour;
end

-- ///////////////////////////////
-- ///// SaveWeatherToDatabase////
-- ///// Returns: void		//////
-- ///////////////////////////////

function WeatherManager:SaveWeatherToDatabase()
	for i = 0, 6, 1 do
		local day = self:GetDate(i);

		for i2 = 0, 23, 1 do
			local wetterIndex	= day..":"..i2;
			if(self.generatedData.weatherData) and (self.generatedData.weatherData[i]) and (self.generatedData.weatherData[i][i2]) and (self.WeatherIDs:GetWeatherFromID(self.generatedData.weatherData[i][i2])) then
				CDatabase:getInstance():exec("INSERT INTO weatherdatas (Day, Hour, WeatherID, WetterIndex, Description) VALUES ('"..day.."', '"..i2.."', '"..self.generatedData.weatherData[i][i2].."', '"..wetterIndex.."', '"..self.WeatherIDs:GetWeatherFromID(self.generatedData.weatherData[i][i2]).."');");
			end
		end
	end

	outputDebugString("Wetterdaten in der Datenbank aktualisiert!");
end

-- ///////////////////////////////
-- ///// LoadWeekWeather	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function WeatherManager:LoadWeekWeather()
	local datas = CDatabase:getInstance():query("SELECT * FROM weatherdatas");
	local weatherDatas = {}
	for i, v in ipairs(datas) do
		if (not weatherDatas[tostring(v['Day'])]) then weatherDatas[tostring(v['Day'])] = {} end
		weatherDatas[tostring(v['Day'])][tonumber(v['Hour'])] = v
	end

	local weatherDates	= 0;
	for i = 0, 6, 1 do
		local sTag	= self:GetDate(i);
		self.weatherData[sTag]		= {}

		for hour = 0, 23, 1 do
			if(weatherDatas[sTag] and weatherDatas[sTag][hour]) then
				self.weatherData[sTag][hour] = tonumber(weatherDatas[sTag][hour]["WeatherID"]);
			else
				self.WeatherSelectCount = self.WeatherSelectCount+1;
				if(self.WeatherSelectCount < 2) then
					outputDebugString("Wetterdaten nicht gefunden, erstelle neue...");
					self:GenerateNewWeather()
					return
				else
				--	outputDebugString("Schwerwiegender Wetterdatenfehler! Wetter nicht gefunden: "..sTag..", "..hour)
			--		outputDebugString("SELECT * FROM weatherdatas WHERE Day = '"..sTag.."' AND Hour = '"..hour.."';")
				end
				weatherDates = 0;
				break;
			end
		end

		weatherDates = weatherDates+1
	end
	if(weatherDates ~= 0) then
		outputDebugString(weatherDates.." Wettertage geladen!");
		self:RefreshWeather()
	end
end

-- ///////////////////////////////
-- ///// RefreshWeather		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function WeatherManager:RefreshWeather(i)
	local sTag, hour	= self:GetDate(i);
	if(self.weatherData) and (self.weatherData[sTag]) and (self.weatherData[sTag][hour]) then
			local weatherID		= self.weatherData[sTag][hour]

			    local rainy     = self.WeatherIDs.rainyIDS[weatherID]
			    local lvl       = math.random(1, 50)/100;
	    local wind      = math.random(0, 50)/100;
	    local wind2     = wind

	    local waterLevel    = math.random(0, 100)/100;
	    if(rainy) then
	        setRainLevel(lvl);
	        wind        = math.random(50, 100)/100;
	        waterLevel    = math.random(100, 400)/100;
	    else
	        setRainLevel(0)
	    end

	    if(math.random(0, 2) == 1) then
	        wind = wind*-1
	    elseif(math.random(0, 1) == 0) then
	        wind2 = wind2*-1;
	    end
      for i,v in pairs(self.tblChannelWater) do
	      setWaterLevel(v, waterLevel, true, true)
      end
	    setWindVelocity(wind, wind2, 0);
		  setWeather(weatherID);
	    outputDebugString("Weather Change: "..weatherID..", Rainy: "..tostring(rainy)..", Windy: "..wind);

	    if(weatherID == 8) then
	        if(cBasicFunctions:calculateProbability(5)) then
	            self.m_uUeberschwemmTimer       = setTimer(self.m_funcCreateUeberschwemmung, 10*1000, 1);
	            outputChatBox("Info: Eine Sturmflut wird in wenigen Minuten auf Los Santos treffen!", root, 200, 0, 0);
	        end
	    end
	else
		self:GenerateNewWeather();
	end
end

-- ///////////////////////////////
-- ///generateSturmflut	//
-- ///// Returns: void		//////
-- ///////////////////////////////

function WeatherManager:generateSturmflut()
    if(isElement(self.m_uWater)) then
        destroyElement(self.m_uWater)
    end
    if not(self.m_bUeberschwommen) then
        self.m_uWater = createWater(self.m_isouthWest_X, self.m_isouthWest_Y, self.m_iheight, self.m_isouthEast_X, self.m_isouthEast_Y, self.m_iheight, self.m_inorthWest_X, self.m_inorthWest_Y, self.m_iheight, self.m_inorthEast_X, self.m_inorthEast_Y, self.m_iheight, true)
        setWaterLevel(self.m_uWater, self.m_iCurWaterLevel)
        self.m_bUeberschwommen = true;

        setTimer(self.m_funcIncreaseWaterLevel, 15000, 12);
        setTimer(self.m_funcIncreaseWaterLevel, 15000*13, 1, true);

        setTimer(self.m_funcStopSturmflut, 2*60*60*1000, 1);
    end
end
 -- ///////////////////////////////
 -- ///stopSturmflut	//
 -- ///// Returns: void		//////
 -- ///////////////////////////////

function WeatherManager:stopSturmflut()
    if(self.m_bUeberschwommen) then
        setTimer(self.m_funcDecreaseWaterLevel, 15000, 12);
        setTimer(self.m_funcDecreaseWaterLevel, 15000*13, 1, true);
    end
end

 -- ///////////////////////////////
 -- ///// onWaterLevelIncrease	//
 -- ///// Returns: void		//////
 -- ///////////////////////////////

function WeatherManager:onWaterLevelIncrease(bFix)
    if(self.m_iCurWaterLevel < self.m_iMaxWaterLevel) then
        if not(bFix) then
            self.m_iCurWaterLevel = self.m_iCurWaterLevel+1;
        else
            self.m_iCurWaterLevel = self.m_iMaxWaterLevel;
        end
    end

    setWaterLevel(self.m_uWater, self.m_iCurWaterLevel)
end

-- ///////////////////////////////
-- ///// onWaterLevelDecrease	//
-- ///// Returns: void		//////
-- ///////////////////////////////

function WeatherManager:onWaterLevelDecrease(bFix)
    if(self.m_iCurWaterLevel > self.m_iMinWaterLevel) then
        if not(bFix) then
            self.m_iCurWaterLevel = self.m_iCurWaterLevel-1;
            setWaterLevel(self.m_uWater, self.m_iCurWaterLevel)
        else
            destroyElement(self.m_uWater)
            self.m_bUeberschwommen = false;
        end
    end

end

-- ///////////////////////////////
-- ///// GetWeekweatherToPlayer	//
-- ///// Returns: void		//////
-- ///////////////////////////////

function WeatherManager:GetWeekweatherToPlayer(uPlayer)
	return triggerClientEvent(uPlayer, "onClientWeekweatherGetBack", uPlayer, self.weatherData)
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function WeatherManager:constructor(...)
	-- Klassenvariablen

	self.weatherData 					= {}

	self.generatedData 					= {}
	self.generatedData.currentWeather 	= 1
	self.generatedData.weatherData		= {}

	self.WeatherIDs						= WeatherIDs:New();

	self.WeatherSelectCount				= 0;

    self.m_uUeberschwemmTimer           = false;
    self.m_iCurWaterLevel               = 0;
    self.m_iMinWaterLevel               = 0;
    self.m_iMaxWaterLevel               = 12.7;
    self.m_bUeberschwommen              = false;

    self.tblChannelWater = {
      createWater(2538, -2117, 4, 2624, -2117, 4, 2538, -1455, 4, 2624, -1455, 4), --Hauptkanal
      createWater(1967, -1872, 4, 2538, -1872, 4, 1967, -1830, 4, 2538, -1830, 4), --Seitenkanal gerade
      createWater(1610, -1872, 4, 1967, -1872, 4, 1610, -1700, 4, 1967, -1700, 4), --Seitenkanal schräg bis PD
      createWater(1550, -1872, 4, 1610, -1872, 4, 1550, -1740, 4, 1610, -1740, 4), --Seitenkanal schräg ab PD
    }

--[[
    self.m_iWaterX1, self.m_iWaterY1    = 67.442245483398, -3271.51171875
    self.m_iWaterX2, self.m_iWaterY2    = 2811.7761230469, -3271.51171875
    self.m_iWaterX3, self.m_iWaterY3    = 2811.7761230469, 490.42959594727
    self.m_iWaterX4, self.m_iWaterY4    = 67.442245483398, 490.42959594727
]]
    self.m_iSizeVal = 2998
    -- Defining variables.
    self.m_isouthWest_X = -self.m_iSizeVal
    self.m_isouthWest_Y = -self.m_iSizeVal
    self.m_isouthEast_X = self.m_iSizeVal
    self.m_isouthEast_Y = -self.m_iSizeVal
    self.m_inorthWest_X = -self.m_iSizeVal
    self.m_inorthWest_Y = self.m_iSizeVal
    self.m_inorthEast_X = self.m_iSizeVal
    self.m_inorthEast_Y = self.m_iSizeVal
    self.m_iheight = 0;

	-- Methods
	self.refreshWeatherFunc				= function(...) self:RefreshWeather(...) end;
	self.weekdayWeatherFunc				= function(...) self:GetWeekweatherToPlayer(client, ...) end;

    self.m_funcCreateUeberschwemmung    = function(...) self:generateSturmflut(...) end
    self.m_funcIncreaseWaterLevel       = function(...) self:onWaterLevelIncrease(...) end
    self.m_funcDecreaseWaterLevel       = function(...) self:onWaterLevelDecrease(...) end
    self.m_funcStopSturmflut            = function(...) self:stopSturmflut(...)end
	-- Events
	self:LoadWeekWeather();
  resetWaterLevel()

	self.refreshTimer					= setTimer(self.refreshWeatherFunc, 60*60*1000, -1);

	addEventHandler("onClientWeekweatherGet", getRootElement(), self.weekdayWeatherFunc)

	--outputDebugString("[CALLING] WeatherManager: Constructor");
end



-- EVENT HANDLER --
