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
-- Time: 22:43
-- Project: MTA iLife
--

cFireworkRohrbombenExplosion = {};

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function cFireworkRohrbombenExplosion:new(...)
	local obj = setmetatable({}, {__index = self});
	if obj.constructor then
		obj:constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// Render       		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cFireworkRohrbombenExplosion:render()
	self.m_FirstExplo:render()

	for index, expl in pairs(self.m_tblNewExplos) do
		expl:render()
	end
	for index, expl in pairs(self.m_tblNewExplos2) do
		expl:render()

	end
	if(getTickCount()-self.m_iStartTick > 1000) then
		if not(self.m_bNextExplosionDone1) then
			self:createNewExplo();
			self.m_bNextExplosionDone1 = true;
		end

		--[[
		if(getTickCount()-self.m_iStartTick > 2000) then
			if(math.random(0, 1) == 1) or true then
				if not(self.m_bNextExplosionDone2) then
					self:createNewExplo(true);
					self.m_bNextExplosionDone2 = true;
				end
			end
		end]]
	end

end

-- ///////////////////////////////
-- ///// PlaySound      	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cFireworkRohrbombenExplosion:playSound(...)
	return self.m_uRocket:playSound(...);
end

-- ///////////////////////////////
-- ///// CreateNextExplo	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cFireworkRohrbombenExplosion:createNewExplo(bBool)
	if not(bBool) then
		for i = 1, self.m_iMaxRoc, 1 do
			local uEle = self.m_FirstExplo.m_Vehicle[i];
			if(uEle) then
				local x, y, z = getElementPosition(uEle);
				local rt = {}
				rt.m_uRocket = uEle

				self.m_tblNewExplos[i] = cFireworkRocketExplosionSimple:new(rt, math.random(7, 15), self)
			end
		end
	else
	--[[
		for index, expl in pairs(self.m_tblNewExplos) do
			for i = 1, expl.m_iMaxVehicles, 1 do
				local uEle = expl.m_Vehicle[i];
				if(uEle) then
					local x, y, z = getElementPosition(uEle);
					local rt = {}
					rt.m_uRocket = uEle

					self.m_tblNewExplos2[i] = cFireworkRocketExplosionSimple:new(rt, 1, self)
				end
			end
		end]]
	end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cFireworkRohrbombenExplosion:constructor(uRocket)
	-- Klassenvariablen --

	self.m_uRocket          = uRocket;
	self.m_iMaxRoc          = 3;
	self.m_FirstExplo       = cFireworkRocketExplosionSimple:new(uRocket, self.m_iMaxRoc, self)
	
	-- Funktionen --
	self.m_iStartTick           = getTickCount();
	self.m_bNextExplosionDone1   = false;
	self.m_bNextExplosionDone2   = false;

	self.m_tblNewExplos         = {};
	self.m_tblNewExplos2        = {};

	-- Events --
end

-- ///////////////////////////////
-- ///// Destructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cFireworkRohrbombenExplosion:destructor(...)
	-- Klassenvariablen --


	-- Funktionen --


	-- Events --
end
-- EVENT HANDLER --



