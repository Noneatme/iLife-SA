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
-- ## Name: HandyApp_LockScreen.lua				##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

HandyApp_LockScreen = {};

inherit(HandyApp, HandyApp_LockScreen);

local app_settings =
{
	["name"] 			= "app_lockscreen",
	["display-name"] 	= "Lock Screen",
	["author"]			= "iLife Scriptmaschine",
	["version"] 		= "1.0.0",
	["pages"]			= 1,
	["width"]			= HudComponent_Handy.DEFAULT_WIDTH,
	["height"]			= HudComponent_Handy.DEFAULT_HEIGHT,
	["draging"]         = false;                    -- No Draging
}

--[[

]]
-- ///////////////////////////////
-- ///// Render		 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HandyApp_LockScreen:Render(handy)
	-- Page 1 --
	self:BeginDrawing(1, false, "add");
	self:DrawBackgroundImage();

	local alpha = self:GetHandyAlpha();

	-- self:DrawImage(...)

	local curX, curY, curW, curH = 0, HudComponent_Handy.DEFAULT_HEIGHT-150, HudComponent_Handy.DEFAULT_WIDTH, 150;
	-- No Flip
	-- Rectangle
	self:DrawRectangle(curX, curY, curW, curH, tocolor(0, 0, 0, alpha/2));

	-- Ueber Rectangle
	-- Zeit
	curX, curY, curW, curH = curX+15, curY-55, curW, curH;

	self:DrawText(self:GetDayString(), curX+2, curY+2, curW-2, curH-2, tocolor(0, 0, 0, alpha), 0.35, hud.fonts.droidsans);
	self:DrawText(self:GetDayString(), curX, curY, curW, curH, tocolor(255, 255, 255, alpha), 0.35, hud.fonts.droidsans);

	curX, curY, curW, curH = curX+30, curY-180, curW, curH;
	self:DrawText(self.oHandy:GetTime(), curX+6, curY+6, curW-6, curH-6, tocolor(0, 0, 0, alpha), 1.7, hud.fonts.droidsans);
	self:DrawText(self.oHandy:GetTime(), curX, curY, curW, curH, tocolor(255, 255, 255, alpha), 1.7, hud.fonts.droidsans);


	curX, curY, curW, curH = HudComponent_Handy.DEFAULT_WIDTH/2-50, 60, 50, 50;

	self:DrawText(_Gsettings.serverName.." Mobile", curX, curY, curW, curH, tocolor(255, 255, 255, alpha), 0.3, hud.fonts.droidsans)
	-- Icons --
	-- Lock


	self:EndDrawing();
	-- Page 2 --
end

-- ///////////////////////////////
-- ///// GetDayString		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HandyApp_LockScreen:GetDayString()
	local weekdays 	= {"Mo", "Di", "Mi", "Do", "Fr", "Sa", "So"};
	local months	= {"Januar", "Februar", "Maerz", "April", "Mai", "Juni", "Juli", "August", "September", "Oktober", "November", "Dezember"};

	local string = "";

	local time = getRealTime();

	local x, y, z = getElementPosition(localPlayer)

	string	= string..weekdays[time.weekday+1].."., "..time.monthday..". "..months[time.month+1].." "..(time.year+1900).." | "..getZoneName(x, y, z, false)

	return string;
end

-- ///////////////////////////////
-- ///// GenerateButtons	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HandyApp_LockScreen:GenerateButtons()
	-- Seite 1 --
	local curX, curY, curW, curH = 0, HudComponent_Handy.DEFAULT_HEIGHT-150, HudComponent_Handy.DEFAULT_WIDTH, 150;

	curX, curY, curW, curH = curX+40, curY+175, 100, 100
	local btn_call = self:CreateButton(1, false, curX, curY, curW, curH, "Call", self.pfade.iconimages.."2b.png")

	curX, curY, curW, curH = curX+125, curY, 100, 100
	local btn_google = self:CreateButton(1, false, curX, curY, curW, curH, "Search", self.pfade.iconimages.."6b.png")

	curX, curY, curW, curH = curX+(125*1), curY, 100, 100

	local btn_lock = self:CreateButton(1, false, curX, curY, curW, curH, "Lock", self.pfade.iconimages.."lock.png")

	curX, curY, curW, curH = curX+125, curY, 100, 100

	local btn_chat = self:CreateButton(1, false, curX, curY, curW, curH, "Chat", self.pfade.iconimages.."14b.png")

	curX, curY, curW, curH = curX+125, curY, 100, 100

	local btn_email = self:CreateButton(1, false, curX, curY, curW, curH, "E-Mail", self.pfade.iconimages.."8b.png")

	-- Click Functions --
	btn_lock:AddOnClickFunction(function()
		hud:getHandy():OpenApp(hud:getHandy():GetAppInstance("app_homescreen"))

		hud:getHandy().bUnlocked    = true;
	end)

	btn_chat:AddOnClickFunction(function()
		hud:getHandy():OpenApp(hud:getHandy():GetAppInstance("app_chat"))
	end)
end

-- ///////////////////////////////
-- ///// DoOpenCallback 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HandyApp_LockScreen:DoOpenCallback()
	-- Locked
	if(hud.hudObjects) then hud:getHandy().bUnlocked    = false; end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HandyApp_LockScreen:constructor()
	-- Hauptklasse aufrufen
	HandyApp.constructor(self, app_settings["name"], app_settings["author"], app_settings["pages"], app_settings["version"], app_settings["display-name"], app_settings["width"], app_settings["height"], app_settings["draging"]);

	self.customAppSettings = app_settings;
-- 	outputDebugString("[CALLING] HudComponent_Clock: Constructor");

	self:GenerateButtons();
end

-- EVENT HANDLER --
