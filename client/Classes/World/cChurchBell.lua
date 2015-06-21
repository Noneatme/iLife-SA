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
-- ## Name: ChurchBell.lua					##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings

ChurchBell = {};
ChurchBell.__index = ChurchBell;

addEvent("onChurchbellEvent", true)

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function ChurchBell:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// PlayChurchbellSound /////
-- ///// Returns: sound		//////
-- ///////////////////////////////

function ChurchBell:PlayChurchbellSound(sName, iX, iY, iZ)

	local sound = playSound3D(self.soundFolder..sName, iX, iY, iZ)
	setSoundVolume(sound, 1)
	setSoundMaxDistance(sound, 500);
	setSoundEffectEnabled (sound, "chorus", true)
	
	return sound;
end

-- ///////////////////////////////
-- ///// FullBell			//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function ChurchBell:FullBell(hour, min)

	local iRepeat = hour;
	
	if(hour > 12) then
		iRepeat = hour-12;
	elseif(hour < 1) then
		iRepeat = 12;
	end
	
	setTimer(function()
		for index, soundTable in pairs(self.churchPositions) do
	--		if not(isElement(self.bellSound[index])) then
				if not(self.ringing[index]) then
					self.bellSound[index] = self:PlayChurchbellSound("bell.mp3", soundTable[1], soundTable[2], soundTable[3]);
				end
	--		end
		end
	end, 2000, iRepeat)
	
	--outputDebugString("Full bell: "..hour..":"..min..", Repeat: "..iRepeat)
end

-- ///////////////////////////////
-- ///// Ring				//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function ChurchBell:Ring(church, hour, min)
	church = tonumber(church)

	self.ringing[church] = true;
	
	local iRepeat = 60;
	
	setTimer(function()
	--	for index, soundTable in pairs(self.churchPositions) do
	--		if not(isElement(self.bellSound[index])) then
				self.bellSound[church] = self:PlayChurchbellSound("bell.mp3", self.churchPositions[church][1], self.churchPositions[church][2], self.churchPositions[church][3]);
	--		end
	--	end
	end, 1000, iRepeat)
	
	setTimer(function()
	--	for index, soundTable in pairs(self.churchPositions) do
	--		if not(isElement(self.bellSound[index])) then
				self.bellSound[church] = self:PlayChurchbellSound("bell_half.mp3", self.churchPositions[church][1], self.churchPositions[church][2], self.churchPositions[church][3]);
	--		end
	--	end
	end, 1235, iRepeat/1.2)	
	
	
	setTimer(function()
		self.ringing[church] = false;
	end, iRepeat*1000, 1)
	
	--outputDebugString("Ringing: "..hour..":"..min..", Repeat: "..iRepeat)
end

-- ///////////////////////////////
-- ///// HalfBell			//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function ChurchBell:HalfBell(hour, min)

	local iRepeat = 1;

	for index, soundTable in pairs(self.churchPositions) do
	--	if not(isElement(self.bellSound[index])) then
			if not(self.ringing[index]) then
				self.bellSound[index] = self:PlayChurchbellSound("bell_half.mp3", soundTable[1], soundTable[2], soundTable[3]);
			end
	--	end
	end

	
	--outputDebugString("Half bell: "..hour..":"..min..", Repeat: "..iRepeat)
end

-- ///////////////////////////////
-- ///// CheckChurchBell	//////
-- ///// Returns: void		//////
-- ///////////////////////////////
--[[
function ChurchBell:CheckChurchBell()
	local time = getRealTime();
	
	local hour, mins = time.hour, time.minute
	
	if(self.fullHours[hour]) and (mins == 0) then
		self:FullBell(hour, mins)
	elseif(mins == 30) then
		self:HalfBell(hour, mins)
	end
	
end
]]
-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function ChurchBell:Constructor(...)

	-- Instanzen --
	self.soundFolder = "res/sounds/church/"
	self.churchPositions = 
	{
		{1732.3634033203, -1869.5926513672, 40.109931945801},	-- Los Santos Bahnhof
		{-2026.2469482422, 1118.51171875, 75.407325744629},		-- San Fierro Kirche
		{2252.8701171875, -1313.3132324219, 51.6637840271},		-- Los Santos Kirche (Groove Street)
		{1564.5859375, -1675.4067382813, 61.894607543945},		-- Los Santos Police Department
		{2194.8198242188, -990.12286376953, 72.6484375},		-- Vagos Base
	}
	
--[[
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
]]
	
	self.bellSound	= {}
	self.ringing = {};

	self.churchBellEventFunc = function(sevent, church, hour, min)
	
		if(sevent == "half") then
			self:HalfBell(hour, min)
		elseif(sevent == "full") then
			self:FullBell(hour, min)
		elseif(sevent == "ring") then
			self:Ring(church, hour, min);
		end
	end

-- 	Timer --
-- 	Nope: Serverseitig nun!
--	setTimer(self.checkChurchBellFunc, 1*60000, -1)		-- Jede Minute
	
	addEventHandler("onChurchbellEvent", getRootElement(), self.churchBellEventFunc)
	--outputDebugString("[CALLING] ChurchBell: Constructor");
end

-- EVENT HANDLER --
