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
cRomanCandleBattery = {};

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function cRomanCandleBattery:new(...)
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

function cRomanCandleBattery:bumm()
	for i = 1, self.m_iAm, 1 do
		self.m_tblExplos[i] = cFireworkRomanCandle:new(self.m_iX, self.m_iY, self.m_iZ, math.random(25, 35))
	end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cRomanCandleBattery:constructor(iX, iY, iZ, iAm)
	-- Klassenvariablen --
	self.m_iX           = iX;
	self.m_iY           = iY;
	self.m_iZ           = iZ;

	self.m_iAm          = iAm;

	self.m_iCur         = 0;


	self.m_tblExplos      = {}


	self:bumm()
	
	-- Events --
end

-- ///////////////////////////////
-- ///// Destructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cRomanCandleBattery:destructor()

end
-- EVENT HANDLER --

