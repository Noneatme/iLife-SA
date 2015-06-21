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
-- ## Name: HandyApp_HomeScreen.lua				##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings

HandyApp_HomeScreen = {};


inherit(HandyApp, HandyApp_HomeScreen);


local app_settings =
{
	["name"] 			= "app_homescreen",
	["display-name"] 	= "Home Screen",
	["author"]			= "iLife Scriptmaschine",
	["version"] 		= "1.0.0",
	["pages"]			= 2,
	["width"]			= HudComponent_Handy.DEFAULT_WIDTH,
	["height"]			= HudComponent_Handy.DEFAULT_HEIGHT,
	["draging"]         = true,
}

--[[

]]
-- ///////////////////////////////
-- ///// Render		 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HandyApp_HomeScreen:Render()
	-- Page 1 --
	self:BeginDrawing(1, false, "add");
	self:DrawBackgroundImage();
	
	local alpha = self:GetHandyAlpha();
	
	-- self:DrawImage(...)

	local curX, curY, curW, curH;

	-- Wichtige Info @ReWrite und andere
	-- Ich habe mich dazu entscheiden, NICHT Widgeds wie Clock oder Google Suche als Klasse an sich zu erstellen
	-- (Also cHandyAppWidget --> cHanndyAppWidget_Clock --> usw.)
	-- Grund ist folgender: Widgets werden zu wenig benutzt und bringen nicht viel. Ausserdem ist es zu viel Arbeit das ins Script zu implementieren obwohl
	-- es schon die MTA CEF funktionen gibt.
	-- Theoretisch könnte man das ganze Handy als CEF machen.

	local function getTimeStr()
		local time = getRealTime()
		if(time.hour < 10) then time.hour = "0"..time.hour end
		if(time.minute < 10) then time.minute = "0"..time.minute end

		--	return (("0"..time.hour and time.hour < 10) or time.hour)..":"..(("0"..time.minute and time.minute < 10) or time.minute)
		return time.hour..":"..time.minute
	end

	local function drawClockWidged()
		curX, curY, curW, curH = 15, 65, HudComponent_Handy.DEFAULT_WIDTH-30, 250
		self:DrawImage(curX, curY, curW, curH, self.pfade.images.."clock_background.png")

		curX, curY, curW, curH = 25, 75, HudComponent_Handy.DEFAULT_WIDTH-30, 230

		self:DrawText(getTimeStr(), curX, curY, 0, 0, tocolor(255, 255, 255, 255), 1.5, hud.fonts.oswald)
	end

	-- No Flip
	-- Rectangle
	curX, curY, curW, curH = 0, HudComponent_Handy.DEFAULT_HEIGHT-150, HudComponent_Handy.DEFAULT_WIDTH, 150;
	self:DrawRectangle(curX, curY, curW, curH, tocolor(0, 0, 0, alpha/2));


	-- Icons --
	-- Lock
--	curX, curY, curW, curH = curX+(HudComponent_Handy.DEFAULT_WIDTH/2-100/2), curY+15, 100, 100
--	self:DrawImage(curX, curY, curW, curH, self.pfade.iconimages.."lock.png")

	drawClockWidged();

	self:EndDrawing();
	-- Page 2 --


	self:BeginDrawing(2, false, "add");
	self:DrawBackgroundImage();


	self:EndDrawing();
end


-- ///////////////////////////////
-- ///// GenerateButtons	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HandyApp_HomeScreen:GenerateButtons()
	-- Seite 1 --
--	self:CreateButton(1, false, 0, 0, self.handyW, self.handyH)
	
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HandyApp_HomeScreen:constructor()
	-- Hauptklasse aufrufen
	HandyApp.constructor(self, app_settings["name"], app_settings["author"], app_settings["pages"], app_settings["version"], app_settings["display-name"], app_settings["width"], app_settings["height"], app_settings["draging"]);


	self.m_bPageSwitchingEnabled	= true;			-- Page Switching

	self.customAppSettings = app_settings;
-- 	outputDebugString("[CALLING] HudComponent_Clock: Constructor");
end

-- EVENT HANDLER --
