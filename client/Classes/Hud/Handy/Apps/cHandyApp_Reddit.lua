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
-- ## Name: HandyApp_Reddit.lua				##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings

HandyApp_Reddit = {};

inherit(HandyApp, HandyApp_Reddit);

local app_settings = 
{
	["name"] 			= "app_browser_reddit",
	["display-name"] 	= "Reddit",
	["author"]			= _Gsettings.serverName.." Scriptmaschine",
	["version"] 		= "1.0.0",
	["pages"]			= 1,
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

function HandyApp_Reddit:Render(handy)
	-- Page 1 --
	self:BeginDrawing(1, false, "add");
	self:DrawBackgroundImage();
	
	local alpha = self:GetHandyAlpha();
	
	-- self:DrawImage(...)

	local curX, curY, curW, curH = 0, 0, HudComponent_Handy.DEFAULT_WIDTH, HudComponent_Handy.DEFAULT_HEIGHT;

	self:DrawImage(curX, curY, curW, curH, self.uBrowser)

	-- DAS FUNKTIONIERT! --> (DxDrawRectangle, aber das obrige nicht)
--	self:DrawRectangle(curX, curY, curW, curH, tocolor(255, 255, 255, 255))
	-- No Flip


	self:EndDrawing();
	-- Page 2 --
end


-- ///////////////////////////////
-- ///// GenerateButtons	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HandyApp_Reddit:GenerateButtons()

end


function HandyApp_Reddit:DoOpenCallback()
	-- On Open --
	requestBrowserPages({"reddit.com", "m.reddit.com"})

	loadBrowserURL(self.uBrowser, "http://www.reddit.com/.compact")

	hud:getHandy():SetBrowser(self.uBrowser);

	outputChatBox("Opened")
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HandyApp_Reddit:constructor()
	-- Hauptklasse aufrufen
	HandyApp.constructor(self, app_settings["name"], app_settings["author"], app_settings["pages"], app_settings["version"], app_settings["display-name"], app_settings["width"], app_settings["height"], app_settings["draging"]);
	
	self.customAppSettings = app_settings;

	self.uBrowser           = createBrowser(800, 600, false)

-- 	outputDebugString("[CALLING] HudComponent_Clock: Constructor");

	self:GenerateButtons();
end

-- EVENT HANDLER --
