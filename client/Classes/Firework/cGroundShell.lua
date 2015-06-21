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
cFireworkGroundShell = {};

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function cFireworkGroundShell:new(...)
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

function cFireworkGroundShell:render()
	if(self.m_explosion) then
		self.m_explosion:render()
	end

	if not(self.m_exploded) then
		local x, y, z = getElementPosition(self.m_uRocket)
		fxAddSparks(x, y, z, 0,0, 1, 1, 1)
	end
end

-- ///////////////////////////////
-- ///// playSound     		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cFireworkGroundShell:playSound(sSound, iDist)
	local sound = playSound3D("res/sounds/firework/"..sSound, self.m_iX, self.m_iY, self.m_iZ);
	setSoundMaxDistance(sound, (iDist or 250))
end

-- ///////////////////////////////
-- ///// bumm        		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cFireworkGroundShell:explode()
	self.m_exploded         = true;
	self.m_explosion        = cFireworkRocketExplosionSimple:new(self, 16, {}, false);

	destroyElement(self.m_uRocket)
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cFireworkGroundShell:constructor(iX, iY, iZ)
	-- Klassenvariablen --
	self.m_uRocket      = createObject(1598, iX, iY, iZ)
	setObjectScale(self.m_uRocket, 0.5);

	self.m_iX           = iX;
	self.m_iY           = iY;
	self.m_iZ           = iZ;

	self.m_iTimer       = 5000;

	-- Funktionen --

	self.m_funcExplode      = function() self:explode() end
	self.m_destructorFunc     = function() self:destructor() end
	self.m_renderFunc       = function() self:render() end

	addEventHandler("onClientRender", getRootElement(), self.m_renderFunc)
	-- Events --

	setTimer(self.m_destructorFunc, self.m_iTimer+5000, 1)
	setTimer(self.m_funcExplode, self.m_iTimer, 1)
end

-- ///////////////////////////////
-- ///// Desstructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cFireworkGroundShell:destructor()
	if(self.m_explosion) then
		self.m_explosion:destructor()
	end

	removeEventHandler("onClientRender", getRootElement(), self.m_renderFunc)

end
-- EVENT HANDLER --
