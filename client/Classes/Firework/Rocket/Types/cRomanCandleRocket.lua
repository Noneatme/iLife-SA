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
-- Time: 20:27
-- Project: MTA iLife
--

cRomanCandleRocket = {};

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function cRomanCandleRocket:new(...)
	local obj = setmetatable({}, {__index = self});
	if obj.constructor then
		obj:constructor(...);
	end
	return obj;
end


-- ///////////////////////////////
-- ///// render   		    //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cRomanCandleRocket:event_render()
	if(self.m_iState == 0) then
		-- Am Boden

	elseif(self.m_iState == 1) then
		-- Luft
		self.m_FRR:render();
	end
end

-- ///////////////////////////////
-- ///// launchRocket  	    //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cRomanCandleRocket:launchRocket()
	self.m_iState = 1;

	self.m_FRR              = cRomanCandleRocketSchweif:new(self);
end


-- ///////////////////////////////
-- ///// initTimer  	    //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cRomanCandleRocket:initTimer()

	self.bindedFunc_launchRocket();
	self.m_timer[1] = setTimer(self.bindedFunc_destructor, 2000, 1);
end

-- ///////////////////////////////
-- ///// PlaySound   		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cRomanCandleRocket:playSound(sSound, iMax, bAttach)
	local sound = playSound3D("res/sounds/firework/"..sSound, self.m_V3Position:getX(), self.m_V3Position:getY(), self.m_V3Position:getZ());
	
	if(bAttach ~= true) then
		attachElements(sound, self.m_uRocket);
	end
	setSoundMaxDistance(sound, (iMax or 50));
end

-- ///////////////////////////////
-- ///// Desstructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cRomanCandleRocket:constructor(iX, iY, iZ)
	-- Klassenvariablen --
	self.m_V3Position       = Vector3(iX, iY, iZ);

	self.m_uRocket          = createVehicle(594, iX, iY, iZ-1);
	setElementFrozen(self.m_uRocket, true);
	setElementAlpha(self.m_uRocket, 0)

	self.m_FRR              = false; --cRomanCandleRocketSchweif:new(self);

	self.m_bLaunched        = false;
	self.m_iState           = 0; -- am Boden
	
	self.m_tblTimer         = {};
	self.m_timer            = {};
	
	-- Funktionen --
	
	self.m_funcRender       = function(...) self:event_render(...) end
	
	self.bindedFunc_launchRocket        = function(...) self:launchRocket() end
	self.bindedFunc_destructor          = function(...) self:destructor() end
	
	self:initTimer();
	-- Events --
	
	addEventHandler("onClientRender", getRootElement(), self.m_funcRender);
end

-- ///////////////////////////////
-- ///// deStructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cRomanCandleRocket:destructor()
	self.m_FRR:destructor();

	destroyElement(self.m_uRocket);

	removeEventHandler("onClientRender", getRootElement(), self.m_funcRender);
end


-- EVENT HANDLER --