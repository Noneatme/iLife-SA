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
cFireworkBoeller = {};

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function cFireworkBoeller:new(...)
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

function cFireworkBoeller:render()
	local x, y, z = self.m_iX, self.m_iY, self.m_iZ-0.5;
	fxAddSparks(x, y, z, 0,0, 1, 1, 1)

end

-- ///////////////////////////////
-- ///// bumm        		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cFireworkBoeller:bumm()
	local s = playSound3D("res/sounds/firework/explode_firecracker_"..math.random(1, 3)..".ogg", self.m_iX, self.m_iY, self.m_iZ);

	setSoundMaxDistance(s, 250)
	self:destructor();
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cFireworkBoeller:constructor(iX, iY, iZ)
	-- Klassenvariablen --
	self.m_iX           = iX;
	self.m_iY           = iY;
	self.m_iZ           = iZ;
	
	-- Funktionen --
	self.m_funcRender       = function(...) self:render(...) end
	self.m_funcBumm         = function(...) self:bumm(...) end
	addEventHandler("onClientRender", getRootElement(), self.m_funcRender)
	-- Events --

	setTimer(self.m_funcBumm, math.random(3000, 4000), 1);
end

-- ///////////////////////////////
-- ///// destructor        	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cFireworkBoeller:destructor()
	fxAddSparks(self.m_iX, self.m_iY, self.m_iZ-0.6, 0, 0, 1, 5, 25)
	fxAddBulletImpact(self.m_iX, self.m_iY, self.m_iZ-0.6, 0, 0, 1, 15, 3, 1)
	removeEventHandler("onClientRender", getRootElement(), self.m_funcRender)
end
-- EVENT HANDLER --


