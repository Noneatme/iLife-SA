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
-- ## Name: RadialMenuManager.lua					##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings

RadialMenuManager = {};
RadialMenuManager.__index = RadialMenuManager;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function RadialMenuManager:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// Trigger	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function RadialMenuManager:Trigger(ePlayer, sBefehl, tblArguments)
	local sArguments = "";
	for i = 2, #tblArguments, 1 do
		sArguments = sArguments..tblArguments[i];
	end
	
	return executeCommandHandler(sBefehl, ePlayer, sArguments)
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function RadialMenuManager:Constructor(...)
	-- Events
	addEvent("onRadialMenuTrigger", true);
	
	self.triggerFunc = function(...) self:Trigger(source, ...) end;
	
	-- Event Handlers --
	addEventHandler("onRadialMenuTrigger", getRootElement(), self.triggerFunc)
	--outputDebugString("[CALLING] RadialMenuManager: Constructor");
end

-- EVENT HANDLER --
