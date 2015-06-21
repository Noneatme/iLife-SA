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
-- ## Name: HandyApp_Chat.lua				##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings

HandyApp_Chat = {};

inherit(HandyApp, HandyApp_Chat);

local app_settings = 
{
	["name"] 			= "app_chat",
	["display-name"] 	= "iLife Chat",
	["author"]			= "iLife Scriptmaschine",
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

function HandyApp_Chat:Render(handy)
	-- Page 1 --
	self:BeginDrawing(1, false, "add");
	self:DrawBackgroundImage();
	
	local alpha = self:GetHandyAlpha();
	
	-- self:DrawImage(...)

	local curX, curY, curW, curH = 0, 0, HudComponent_Handy.DEFAULT_WIDTH, HudComponent_Handy.DEFAULT_HEIGHT;


	self:EndDrawing();
	-- Page 2 --
end


-- ///////////////////////////////
-- ///// GenerateButtons	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HandyApp_Chat:GenerateButtons()

end

-- ///////////////////////////////
-- ///// DoOpenCallback 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////


function HandyApp_Chat:DoOpenCallback()
	-- On Open --

	self:LoadContacts()

end

-- ///////////////////////////////
-- ///// DCloseCallback 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////


function HandyApp_Chat:DoCloseCallback()
	-- On Open --

	self:SaveContacts();
end
-- ///// /////////////////////////
-- ///// loadSettings 	    //////
-- ///// Returns: void		//////
-- ///////////////////////////////


function HandyApp_Chat:LoadContacts()
	local jsonTblContacts       = self:GetAppSetting("contacts");

	if not(jsonTblContacts) then
		self.tblContacts        = {}
	else
		self.tblContacts        = fromJSON(base64Decode(jsonTblContacts));
	end

	outputConsole("Loaded Contacts")
end

-- ///// /////////////////////////
-- ///// loadSettings 	    //////
-- ///// Returns: void		//////
-- ///////////////////////////////


function HandyApp_Chat:SaveContacts()
	local jsonTblContacts       = toJSON(self.tblContacts);

	self:SetAppSetting("contacts", base64Encode(jsonTblContacts));
	self:Save()

	outputConsole("Saved Contacts")
end
-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HandyApp_Chat:constructor()
	-- Hauptklasse aufrufen
	HandyApp.constructor(self, app_settings["name"], app_settings["author"], app_settings["pages"], app_settings["version"], app_settings["display-name"], app_settings["width"], app_settings["height"], app_settings["draging"]);
	
	self.customAppSettings = app_settings;


-- 	outputDebugString("[CALLING] HudComponent_Clock: Constructor");

	self:GenerateButtons();
end

-- EVENT HANDLER --
