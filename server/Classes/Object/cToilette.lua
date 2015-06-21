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
-- ## Name: CO_Toilette.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings

CO_Toilette = {};
CO_Toilette.__index = CO_Toilette;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function CO_Toilette:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// FlushToilet 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CO_Toilette:FlushToilet(uPlayer, uObject)
	if not(self.toiletFlush[uObject]) and (isElement(uPlayer)) then
		triggerClientEvent(getRootElement(), "onClientObjectAction", getRootElement(), 4, uObject);

		self.toiletFlush[uObject]	= true;
		setTimer(function() self.toiletFlush[uObject] = false end, 5000, 1);
	end
end


-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CO_Toilette:Constructor(...)
	-- Klassenvariablen --
	self.toiletFlush = {}
	
	-- Methoden --
	
	
	-- Events --
	
	--logger:OutputInfo("[CALLING] CO_Toilette: Constructor");
end

-- EVENT HANDLER --
