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
-- Date: 25.12.2014
-- Time: 17:10
-- Project: MTA iLife
--
cFireworkRocket = {};

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function cFireworkRocket:new(...)
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

function cFireworkRocket:event_render()
	if(self.m_iState == 0) then
		-- Am Boden
		local x, y, z = self.m_V3Position:getX(), self.m_V3Position:getY(), self.m_V3Position:getZ();
		fxAddSparks(x, y, z, 0,0, 1, 1, 1)
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

function cFireworkRocket:launchRocket()
	self.m_iState = 1;

	if(self.m_bRohrBombe) or (self.m_bRohrBombenSound) then
		self.m_FRR              = cFireworkRohrbombenSchweif:new(self);
	else
		self.m_FRR              = cFireworkRocketSchweif:new(self);
	end
end

-- ///////////////////////////////
-- ///// doExplosion  	    //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cFireworkRocket:doExplosion()
	self.m_iState = 2;
	if(self.m_FRR) then self.m_FRR:destructor(); end
	if(self.m_bRohrBombe) then
		self.m_FRE              = cFireworkRohrbombenExplosion:new(self);
	else
		self.m_FRE              = cFireworkRocketExplosionSimple:new(self);

	end

	destroyElement(self.m_uRocket)
end


-- ///////////////////////////////
-- ///// initTimer  	    //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cFireworkRocket:initTimer()

	self.m_tblTimer =
	{
		["launchRocket"]   = {3000},
		["doExplosion"]    = {5000},
		["destructor"]     = {10000},
	}

	self.m_tblTimer_RB =
	{
		["launchRocket"]   = {5000},
		["doExplosion"]    = {7000},
		["destructor"]     = {15000},
	}
	for event, ms in pairs(self.m_tblTimer) do
		local ms2 = ms[1]

		if(self.m_bRohrBombe) then
			ms2 = self.m_tblTimer_RB[event][1]
		end
		self.m_timer[event] = setTimer(function() self["bindedFunc_"..event]() end, ms2, 1);

	end
end

-- ///////////////////////////////
-- ///// PlaySound   		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cFireworkRocket:playSound(sSound, iMax, bAttach)
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

function cFireworkRocket:constructor(iX, iY, iZ, bRohrBombe, bRohrBombenSound)
	-- Klassenvariablen --
	self.m_V3Position       = Vector3(iX, iY, iZ);

	if(bRohrBombe) then
		self.m_uRocket          = createVehicle(594, iX, iY, iZ-1);
		setElementFrozen(self.m_uRocket, true);
		setElementAlpha(self.m_uRocket, 0)

		self.m_uAbschuss        = createObject(3675, iX, iY+0.25, iZ-2, 0, 180, 0);
		setObjectScale(self.m_uAbschuss, 0.3);
		setElementCollisionsEnabled(self.m_uAbschuss, false);

	else
		self.m_uRocket          = createObject(1337, iX, iY, iZ-1);
		setObjectScale(self.m_uRocket, 2); -- Rausnehmen
		setElementRotation(self.m_uRocket, 0, math.random(1, 10), math.random(0, 360))
		setElementCollisionsEnabled(self.m_uRocket, false);

	end

	self.m_FRR              = false; --cFireworkRocketSchweif:new(self);
	self.m_FRE              = false; --cFireworkRocketExplosion:new(self);
	self.m_bRohrBombe       = bRohrBombe;

	self.m_bRohrBombenSound = bRohrBombenSound;

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

function cFireworkRocket:destructor()
	if(self.m_FRR) then self.m_FRE:destructor() end
	self.m_FRR:destructor();
--	destroyElement(self.m_uRocket);

	if(self.m_uAbschuss) then
		destroyElement(self.m_uAbschuss, true);
	end
	removeEventHandler("onClientRender", getRootElement(), self.m_funcRender);
end


-- EVENT HANDLER --
