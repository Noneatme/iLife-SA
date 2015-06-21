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
-- ## Name: MainMenuManager.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings

MainMenuManager = {};
MainMenuManager.__index = MainMenuManager;

addEvent("onClientMainMenuPerformAction", true)
--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function MainMenuManager:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// PerformAction 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function MainMenuManager:PerformAction(uPlayer, iInt)
	if(iInt == 4) then
		redirectPlayer(uPlayer, "85.214.240.153", 22003);
	end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function MainMenuManager:Constructor(...)
	-- Klassenvariablen --
	
	
	-- Methoden --
	self.performActionFunc	= function(...) self:PerformAction(client, ...) end;
	
	-- Events --
	addEventHandler("onClientMainMenuPerformAction", getRootElement(), self.performActionFunc)
	--logger:OutputInfo("[CALLING] MainMenuManager: Constructor");
end

-- EVENT HANDLER --
