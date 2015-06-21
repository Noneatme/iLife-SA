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
-- ## Name: TrainHelper.lua					##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings

TrainHelper = {};
TrainHelper.__index = TrainHelper;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function TrainHelper:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// IsTrain			//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function TrainHelper:IsTrain(model)
	if(self.trainModels[model]) and (self.trainModels[model] == true) then
		return true;
	end

	return false;
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function TrainHelper:Constructor(...)
	-- Klassenvariablen --
		
	self.trainModels =
	{
		[449] = true,
		[537] = true,
		[538] = true,
		[569] = true,
		[590] = true,
	}
	
	-- Methoden --
	
	
	-- Events --
	
	--logger:OutputInfo("[CALLING] TrainHelper: Constructor");
end

-- EVENT HANDLER --
