--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

--
-- Created by IntelliJ IDEA.
-- User: Noneatme
-- Date: 26.12.2014
-- Time: 00:26
-- Project: MTA iLife
--
cFireworkBattery = {};

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function cFireworkBattery:new(...)
	local obj = setmetatable({}, {__index = self});
	if obj.constructor then
		obj:constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// bumm        		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cFireworkBattery:bumm()
	if(self.m_iCur < self.m_iAm) then
		local x, y, z = self.m_iX, self.m_iY, self.m_iZ;

		self.m_tblExplos[self.m_iCur] = cRohrbombenBatteryRocket:new(x, y, z, true)
		self.m_iCur = self.m_iCur+1;

		setTimer(self.m_func_bum, math.random(4000, 5000), 1)
	end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cFireworkBattery:constructor(iX, iY, iZ, iAm)

	-- Klassenvariablen --
	self.m_iX           = iX;
	self.m_iY           = iY;
	self.m_iZ           = iZ;

	self.m_iAm          = iAm;

	self.m_iCur         = 0;


	self.m_tblExplos      = {}

	-- Funktionen --

	self.m_func_bum     = function() self:bumm() end

	self:bumm()
	
	-- Events --
end

-- ///////////////////////////////
-- ///// Destructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cFireworkBattery:destructor()
	destroyElement(self.m_uAbschuss);
end


