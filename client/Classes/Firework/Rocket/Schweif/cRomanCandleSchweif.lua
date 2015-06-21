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

cRomanCandleRocketSchweif = {};

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function cRomanCandleRocketSchweif:new(...)
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

function cRomanCandleRocketSchweif:render()
	if(self.b_enabled) then
		local pos = Vector3(getElementPosition(self.m_uRocket.m_uRocket));
		local rot = Vector3(getElementRotation(self.m_uRocket.m_uRocket));


		if(self.m_bSparks) then
			setElementPosition(self.m_uSparkEffect, pos:getX(), pos:getY(), pos:getZ());
			setElementRotation(self.m_uSparkEffect, rot:getX()+90, rot:getY(), rot:getZ());
		end

		if(self.m_bLight) then
			local sWert = 1-math.abs((getTickCount()-self.m_iStartTick)/self.m_iDuration)

			self.m_Alpha = sWert*200

			if(self.m_Alpha >= 255) then
				self.m_Alpha = 255;
			end
			if(self.m_Alpha <= 0) then
				self.m_Alpha = 0;
			--	self:destructor();
			end
			setMarkerColor(self.m_uMarker, self.m_cLightColor[1], self.m_cLightColor[2], self.m_cLightColor[3], self.m_Alpha)
		end
	end
end

-- ///////////////////////////////
-- ///// Launch       		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cRomanCandleRocketSchweif:launch()

	local x, y, z = getElementPosition(self.m_uRocket.m_uRocket);

	if(self.m_bSparks) then
		self.m_uSparkEffect     = createEffect("prt_spark", getElementPosition(self.m_uRocket.m_uRocket));
		setEffectSpeed(self.m_uSparkEffect, 1)
		setElementRotation(self.m_uSparkEffect, 0, -90, 0);
	end

	if(self.m_bLight) then
		local x, y, z = getElementPosition(self.m_uRocket.m_uRocket)
		self.m_uMarker = createMarker(x, y, z, "corona", math.random(10, 15)/10, unpack(self.m_cLightColor));
		attachElements(self.m_uMarker, self.m_uRocket.m_uRocket);
	end

	setElementPosition(self.m_uRocket.m_uRocket, x, y, z+1)
	setElementFrozen(self.m_uRocket.m_uRocket, false);
	setElementVelocity(self.m_uRocket.m_uRocket, (math.random(-10, 10)/100), (math.random(-10, 10)/100), self.m_iHeight)

	self.m_uRocket:playSound("launch_motar_"..math.random(1, 2)..".ogg", 150, true);
end

-- ///////////////////////////////
-- ///// Desstructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cRomanCandleRocketSchweif:destructor()
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

function cRomanCandleRocketSchweif:constructor(uRocket)
	-- Klassenvariablen --
	self.m_uRocket      = uRocket;
	
	self.m_uMarker      = false;
	
	self.m_iHeight      = 0.5;       -- Hoehe
	self.m_iAlpha       = 255;

	self.m_iDuration    = math.random(1500, 2000);

	self.m_iStartTick   = getTickCount()

	self.m_bSparks      = true;     -- Spakrs
	self.m_bLight       = true;     -- Glow

	self.b_enabled      = true;


	self.m_cLightColor  = {math.random(0, 255), math.random(0, 255), math.random(0, 255), 255}
	
	-- Funktionen --
	self:launch();
	
	-- Events --
end

-- EVENT HANDLER --



