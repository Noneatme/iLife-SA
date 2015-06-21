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
cFireworkRomanCandle = {};

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function cFireworkRomanCandle:new(...)
	local obj = setmetatable({}, {__index = self});
	if obj.constructor then
		obj:constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// render        		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cFireworkRomanCandle:render()
	local x, y, z = self.m_iX, self.m_iY, self.m_iZ-0.5;
	fxAddSparks(x, y, z, 0,0, 1, 1, 1)

	if(self.m_iCur == self.m_iAm) then
		self:destructor()
	end
end

-- ///////////////////////////////
-- ///// bumm        		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cFireworkRomanCandle:bumm()
	if(self.m_iCur < self.m_iAm) then
		local x, y, z = self.m_iX, self.m_iY, self.m_iZ;

		self.m_tblExplos[self.m_iCur] = cRomanCandleRocket:new(x, y, z)
		self.m_iCur = self.m_iCur+1;

		setTimer(self.m_func_bum, math.random(1000, 1500), 1)
	end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cFireworkRomanCandle:constructor(iX, iY, iZ, iAm)

	-- Klassenvariablen --
	self.m_iX           = iX;
	self.m_iY           = iY;
	self.m_iZ           = iZ;

	self.m_iAm          = iAm;

	self.m_iCur         = 0;


	self.m_uAbschuss    = createObject(2774, iX, iY, iZ-1);
	setObjectScale(self.m_uAbschuss, 0.05);
	setElementCollisionsEnabled(self.m_uAbschuss, false)
	setElementDoubleSided(self.m_uAbschuss, true)

	self.m_tblExplos      = {}

	-- Funktionen --

	self.m_func_bum     = function() self:bumm() end
	self.m_funcRender   = function(...) self:render(...) end

	setTimer(self.m_func_bum, math.random(3500, 4500), 1)
	
	-- Events --

	addEventHandler("onClientRender", getRootElement(), self.m_funcRender)

end

-- ///////////////////////////////
-- ///// Destructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cFireworkRomanCandle:destructor()
	destroyElement(self.m_uAbschuss);

	removeEventHandler("onClientRender", getRootElement(), self.m_funcRender)
end
-- EVENT HANDLER --


