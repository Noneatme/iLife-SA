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
-- ## Name: TrainSoundManager.lua		##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings

TrainSoundManager = {};
TrainSoundManager.__index = TrainSoundManager;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function TrainSoundManager:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// PlayTrainSound		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function TrainSoundManager:PlayTrainSound(train, sound)
	return triggerClientEvent(getRootElement(), "onTrainSoundPlayClient", getRootElement(), train, sound)
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function TrainSoundManager:Constructor(...)
	-- Instanzen && Klassenvariablen --
	addEvent("onTrainSoundPlay", true)
	
	self.trainSoundPlayFunc = function(...) self:PlayTrainSound(...) end;
	
	-- Event Handler
	
	addEventHandler("onTrainSoundPlay", getRootElement(), self.trainSoundPlayFunc)
	--outputDebugString("[CALLING] TrainSoundManager: Constructor");
end

-- EVENT HANDLER --

trainSoundManager = TrainSoundManager:New();