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
-- ## Name: ChurchBellManager.lua					##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings

ChurchBellManager = {};
ChurchBellManager.__index = ChurchBellManager;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function ChurchBellManager:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// CheckChurchBell	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function ChurchBellManager:CheckChurchBell()
	local time = getRealTime();
	
	local hour, min = time.hour, time.minute
	local day = time.weekday;
	
	local cancelRinging = false;

	if(day == 0) then	-- Sunday
		if(self.sundayBells[hour]) and (min == 0) then
			self:Ring(2)	-- LS Kirche
			self:Ring(3)	-- SF Kirche
			
			cancelRinging = true;
			
			--outputDebugString("Ringing Churches: "..hour..":"..min..", Sunday")
		end
	end
	
	if(cancelRinging == false) then
		if(self.fullHours[hour]) and (min == 0) then
			triggerClientEvent(getRootElement(), "onChurchbellEvent", getRootElement(), "full", nil, hour, min)
		elseif(min == 30) then
			triggerClientEvent(getRootElement(), "onChurchbellEvent", getRootElement(), "half", nil, hour, min)
		end
	end

end

-- ///////////////////////////////
-- ///// Ring				//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function ChurchBellManager:Ring(church)
	local time = getRealTime()
	local hour, min = time.hour, time.minute
	
	triggerClientEvent(getRootElement(), "onChurchbellEvent", getRootElement(), "ring", church, hour, min)
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function ChurchBellManager:Constructor(...)
	-- Klassenvariablen 
	self.fullHours = 
	{
		[0] = true,
		[1] = true,
		[2] = true,
		[3] = true,
		[4] = true,
		[5] = true,
		[6] = true,
		[7] = true,
		[8] = true,
		[9] = true,
		[10] = true,
		[11] = true,
		[12] = true,
		[13] = true,
		[14] = true,
		[15] = true,
		[16] = true,
		[17] = true,
		[18] = true,
		[19] = true,
		[20] = true,
		[21] = true,
		[22] = true,
		[23] = true,
	}
	
	self.fullBellChurches = {
		[1] = true,
		[2] = true,
		[3] = true,
		[4] = true,
		[5] = true,
	}
	
	self.halfBellChurches = {
		[1] = true,
		[2] = true,
		[3] = true,
		[4] = true,
		[5] = true,
	}
	
	self.sundayBells = {	-- Sonntagsgelaeute
		[6] = true,		-- 6 Uhr
		[7] = true,		-- 7 Uhr
		[12] = true,	-- 12 Uhr
		
	}
		
	-- Funktionen
	self.checkChurchBellFunc	= function() self:CheckChurchBell() end;
	
	-- Events Timer
	setTimer(self.checkChurchBellFunc, 1*60000, 0)		-- Jede Minute

	--outputDebugString("[CALLING] ChurchBellManager: Constructor");
end

-- EVENT HANDLER --
