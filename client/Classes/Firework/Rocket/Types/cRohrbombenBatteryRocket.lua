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

cRohrbombenBatteryRocket = {};

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function cRohrbombenBatteryRocket:new(...)
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

function cRohrbombenBatteryRocket:event_render()
	if(self.m_iState == 0) then
		-- Am Boden
		local x, y, z = self.m_V3Position:getX(), self.m_V3Position:getY(), self.m_V3Position:getZ();
		fxAddSparks(x, y, z-0.5, 0,0, 1, 1, 1)
	elseif(self.m_iState == 1) then
		-- Luft
		self.m_FRR:render();
	elseif(self.m_iState == 2) then
		-- Explosion
		if(self.m_FRE.render) then
			self.m_FRE:render();
		end
	end
end

-- ///////////////////////////////
-- ///// launchRocket  	    //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cRohrbombenBatteryRocket:launchRocket()
	self.m_iState = 1;

	self.m_FRR              = cDynamicRocketSchweif:new(self);
end

-- ///////////////////////////////
-- ///// doExplosion  	    //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cRohrbombenBatteryRocket:doExplosion()
	self.m_iState = 2;
	self.m_FRR:destructor();

	self.m_FRE              = cFireworkRocketExplosionSimple:new(self);
end


-- ///////////////////////////////
-- ///// initTimer  	    //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cRohrbombenBatteryRocket:initTimer()

	self.m_tblTimer =
	{
		["launchRocket"]   = {5000},
		["doExplosion"]    = {7000},
		["destructor"]     = {15000},
	}

	for event, ms in pairs(self.m_tblTimer) do
		local ms2 = ms[1]

		self.m_timer[event] = setTimer(function() self["bindedFunc_"..event]() end, ms2, 1);
	end
end

-- ///////////////////////////////
-- ///// PlaySound   		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cRohrbombenBatteryRocket:playSound(sSound, iMax, bAttach)
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

function cRohrbombenBatteryRocket:constructor(iX, iY, iZ)
	-- Klassenvariablen --
	self.m_V3Position       = Vector3(iX, iY, iZ);


	self.m_uRocket          = createVehicle(594, iX, iY, iZ-1);
	setElementFrozen(self.m_uRocket, true);
	setElementAlpha(self.m_uRocket, 0)
		
	self.m_uAbschuss        = createObject(3675, iX, iY+0.25, iZ-2.5, 0, 180, 0);
	setObjectScale(self.m_uAbschuss, 0.3);
	setElementCollisionsEnabled(self.m_uAbschuss, false);

	self.m_FRR              = false; --cRohrbombenBatteryRocketSchweif:new(self);
	self.m_FRE              = false; --cRohrbombenBatteryRocketExplosion:new(self);

	self.m_bLaunched        = false;
	self.m_iState           = 0; -- am Boden
	
	self.m_tblTimer         = {};
	self.m_timer            = {};
	
	-- Funktionen --
	
	self.m_funcRender       = function(...) self:event_render(...) end
	
	self.bindedFunc_launchRocket        = function(...) self:launchRocket() end
	self.bindedFunc_doExplosion         = function(...) self:doExplosion() end
	self.bindedFunc_destructor          = function(...) self:destructor() end
	
	self:initTimer();
	-- Events --
	
	addEventHandler("onClientRender", getRootElement(), self.m_funcRender);
end

-- ///////////////////////////////
-- ///// deStructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cRohrbombenBatteryRocket:destructor()
	self.m_FRE:destructor()
	self.m_FRR:destructor();

	destroyElement(self.m_uRocket);
	destroyElement(self.m_uAbschuss, true);

	removeEventHandler("onClientRender", getRootElement(), self.m_funcRender);
end


-- EVENT HANDLER --
