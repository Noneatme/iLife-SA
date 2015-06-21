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
-- Time: 17:40
-- Project: MTA iLife
--
--

cDynamicRocketSchweif = {};

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function cDynamicRocketSchweif:new(...)
	local obj = setmetatable({}, {__index = self});
	if obj.constructor then
		obj:constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// Render      		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cDynamicRocketSchweif:render()
	local pos = Vector3(getElementPosition(self.m_uRocket.m_uRocket));
	local rot = Vector3(getElementRotation(self.m_uRocket.m_uRocket));


	if(self.m_bSparks) then
		setElementPosition(self.m_uSparkEffect, pos:getX(), pos:getY(), pos:getZ());
		setElementRotation(self.m_uSparkEffect, rot:getX()+90, rot:getY(), rot:getZ());
		fxAddSparks(pos:getX(), pos:getY(), pos:getZ(), 0, 0, -5, 4, 5)
	end
end

-- ///////////////////////////////
-- ///// Launch       		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cDynamicRocketSchweif:launch()

	local x, y, z = getElementPosition(self.m_uRocket.m_uRocket);

	if(self.m_bSparks) then
		self.m_uSparkEffect     = createEffect("prt_spark", getElementPosition(self.m_uRocket.m_uRocket));
		setEffectSpeed(self.m_uSparkEffect, 1)
		setElementRotation(self.m_uSparkEffect, 0, -90, 0);
	end

	if(self.m_bLight) then
		local x, y, z = getElementPosition(self.m_uRocket.m_uRocket)
		self.m_uMarker = createMarker(x, y, z, "corona", 0.5, unpack(self.m_cLightColor));
		attachElements(self.m_uMarker, self.m_uRocket.m_uRocket);
	end

	setElementPosition(self.m_uRocket.m_uRocket, x, y, z+1)
	setElementFrozen(self.m_uRocket.m_uRocket, false);
	setElementVelocity(self.m_uRocket.m_uRocket, (math.random(-3, 3)/10), (math.random(-3, 3)/10), self.m_iHeight)

	self.m_uRocket:playSound("launch_motar_"..math.random(1, 2)..".ogg", 150, true);
end

-- ///////////////////////////////
-- ///// Desstructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cDynamicRocketSchweif:destructor()
	if(isElement(self.m_uMarker)) then
		destroyElement(self.m_uMarker);
	end
	if (isElement(self.m_uSparkEffect)) then
		destroyElement(self.m_uSparkEffect)
	end
	if (isElement(self.m_uMarker)) then
		destroyElement(self.m_uMarker)
	end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cDynamicRocketSchweif:constructor(uRocket)
	-- Klassenvariablen --
	self.m_uRocket      = uRocket;
	
	self.m_uMarker      = false;
	
	self.m_iHeight      = 1.5;       -- Hoehe

	self.m_bSparks      = true;     -- Spakrs
	self.m_bLight       = true;     -- Glow

	self.m_iTime        = self.m_uRocket.m_tblTimer["doExplosion"][1]-self.m_uRocket.m_tblTimer["launchRocket"][1];     -- Zeit in MS wie lange er Braucht
	
	self.m_cLightColor  = {math.random(200, 255), math.random(200, 255), math.random(200, 255), 200}
	
	-- Funktionen --
	self:launch();
	
	-- Events --
end

-- EVENT HANDLER --



