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
cFireworkRocketSchweif = {};

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function cFireworkRocketSchweif:new(...)
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

function cFireworkRocketSchweif:render()
	local pos = Vector3(getElementPosition(self.m_uRocket.m_uRocket));
	local rot = Vector3(getElementRotation(self.m_uRocket.m_uRocket));

	if(self.m_bSparks) then
		setElementPosition(self.m_uSparkEffect, pos:getX(), pos:getY(), pos:getZ()+0.8);
		setElementRotation(self.m_uSparkEffect, rot:getX()+90, rot:getY(), rot:getZ());
		fxAddSparks(pos:getX(), pos:getY(), pos:getZ(), 0, 0, -5, 4, 5)
	end

end

-- ///////////////////////////////
-- ///// Launch       		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cFireworkRocketSchweif:launch()
	moveObject(
		self.m_uRocket.m_uRocket, self.m_iTime,
		self.m_uRocket.m_V3Position:getX()+(math.random(50, 150)/10), self.m_uRocket.m_V3Position:getY()+(math.random(50, 150)/10), self.m_uRocket.m_V3Position:getZ()+self.m_iHeight,
		0, 0, math.random(-90, 90),
		"InBack", 0.0, 0.0, math.random(1, 5)/10
	)
	if(self.m_bSparks) then
		self.m_uSparkEffect     = createEffect("prt_spark", getElementPosition(self.m_uRocket.m_uRocket));
		setEffectSpeed(self.m_uSparkEffect, 1)
	end
	if(self.m_bLight) then
		local x, y, z = getElementPosition(self.m_uRocket.m_uRocket)
		self.m_uMarker = createMarker(x, y, z, "corona", 0.5, unpack(self.m_cLightColor));
		attachElements(self.m_uMarker, self.m_uRocket.m_uRocket, 0, 0, 0.8);
	end

	self.m_uRocket:playSound("launch_rocket_"..math.random(1, 3)..".ogg");

end

-- ///////////////////////////////
-- ///// Desstructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cFireworkRocketSchweif:destructor()


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

function cFireworkRocketSchweif:constructor(uRocket)
	-- Klassenvariablen --
	self.m_uRocket      = uRocket;

	self.m_iHeight      = math.random(50, 90);       -- Hoehe
	self.m_bSparks      = true;     -- Spakrs
	self.m_bLight       = true;     -- Glow

	self.m_iTime        = self.m_uRocket.m_tblTimer["doExplosion"][1]-self.m_uRocket.m_tblTimer["launchRocket"][1];     -- Zeit in MS wie lange er Braucht

	self.m_cLightColor  = {255, 255, 255, 200}


	-- Funktionen --
	self:launch();
	
	-- Events --
end

-- EVENT HANDLER --



