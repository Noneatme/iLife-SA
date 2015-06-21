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
-- Time: 23:47
-- Project: MTA iLife
--

cFireworkManager = {};

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function cFireworkManager:new(...)
	local obj = setmetatable({}, {__index = self});
	if obj.constructor then
		obj:constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// GenerateFirework	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cFireworkManager:generateFirework(sFirework, tblFirework)
	sFirework       = string.lower(sFirework);
	local x, y, z   = tblFirework[1], tblFirework[2], tblFirework[3];
	local rand      = tblFirework[4];
	if(sFirework == "rakete") then
		cFireworkRocket:new(x, y, z)
	end
	if(sFirework == "kugelbombe") then
		cRohrbombenRocket:new(x, y, z);
	end
	if(sFirework == "raketenbatterie") then
		cFireworkBattery:new(x, y, z, rand);
	end
	if(sFirework == "roemischekerze") then
		cFireworkRomanCandle:new(x, y, z, rand);
	end
	if(sFirework == "roemischekerzebatterie") then
		cRomanCandleBattery:new(x, y, z, rand);
	end
	if(sFirework == "groundshell") then
		cFireworkGroundShell:new(x, y, z)
	end -- cFireworkBoeller:new(x, y, z-0.6)
	if(sFirework == "boeller") then
		cFireworkBoeller:new(x, y, z)
	end
end

-- ///////////////////////////////
-- ///// ReplaceObject 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cFireworkManager:replaceObject()
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cFireworkManager:constructor(...)
	-- Klassenvariablen --
	self:replaceObject();
	
	-- Funktionen --

	self.m_startFirework        = function(...) self:generateFirework(...) end

	-- Events --
	addEvent("onClientFireworkStart", true)
	addEventHandler("onClientFireworkStart", getLocalPlayer(), self.m_startFirework)

--[[	addCommandHandler("firework", function(cmd, sF)
		local x, y, z = getElementPosition(localPlayer);
		local tbl = {x, y, z, math.random(10, 15) }
		self:generateFirework(sF, tbl)
	end)]]
end

-- EVENT HANDLER --
