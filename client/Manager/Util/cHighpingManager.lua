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
-- Date: 02.01.2015
-- Time: 16:34
-- Project: MTA iLife
--

cHighpingManager = {};

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function cHighpingManager:new(...)
	local obj = setmetatable({}, {__index = self});
	if obj.constructor then
		obj:constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- /////  killHighping      //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cHighpingManager:killHighping()
	self.b_doFreeze     = true;
	--[[
	if(isPedInVehicle(localPlayer)) then
		setElementFrozen(getPedOccupiedVehicle(localPlayer), true)
	else
		setElementFrozen(localPlayer, true);
	end
	toggleControl("fire", false)]]

	loadingSprite:setEnabled(true);
	triggerServerEvent("onPlayerKickHighPing", localPlayer, getPlayerPing(localPlayer), self.m_iMaxPing)
end

-- ///////////////////////////////
-- /////  resetHighping      //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cHighpingManager:resetHighping()
	self.b_doFreeze     = false;
	--[[
	if(isPedInVehicle(localPlayer)) then
		setElementFrozen(getPedOccupiedVehicle(localPlayer), false)
	else
		setElementFrozen(localPlayer, false);
	end

	toggleControl("fire", true)]]
end

-- ///////////////////////////////
-- /////  render          ///////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cHighpingManager:render()
	if(getTickCount()-self.m_iStartTick > 500) then
		if(getPlayerPing(localPlayer) >= self.m_iMaxPing) then
			if not(self.m_bHighPing) then
				self.m_iHighPingTimer = setTimer(function() self:killHighping() end, 30000, 1)
			end
			self.m_bHighPing        = true;
			setElementData(localPlayer, "b:highPing", true);

			if(self.b_doFreeze == true) then
				self:killHighping()
			end
		else
			if(self.m_bHighPing) then
				if(isTimer(self.m_iHighPingTimer)) then killTimer(self.m_iHighPingTimer) end
				self:resetHighping()
			end
			self.m_bHighPing        = false;
			setElementData(localPlayer, "b:highPing", false);
		end

		self.m_iStartTick = getTickCount();

		if(self.m_bAlpha == 0) then
			self.m_bAlpha = 255;
		else
			self.m_bAlpha = 0;
		end
	end

	if(self.m_bHighPing)  then
		local sx, sy    = guiGetScreenSize()
		local w, h      = 250, 80

		dxDrawImage((sx/2)-(w/2), (sy/3)-(h/2), w, h, "res/images/render/highping.png", 0, 0, 0, tocolor(255, 255, 255, self.m_bAlpha))
	end

	if(self.m_iCurFPS <= self.m_iMinFPS) then
		local sx, sy    = guiGetScreenSize()
		local w, h      = 250, 80

		dxDrawImage((sx/2)-(w/2), (0)+(h/2), w, h, "res/images/render/lowfps.png", 0, 0, 0, tocolor(255, 255, 255, 255))
	end

	-- FPS --
	if(getTickCount()-self.m_iFPSStartick >= 1000) then
		self.m_iCurFPS      = self.m_iTempFPS;

		self.m_iTempFPS     = 0;
		self.m_iFPSStartick = getTickCount();
	else
		self.m_iTempFPS = self.m_iTempFPS+1;
	end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cHighpingManager:constructor(...)
	-- Klassenvariablen --
	self.m_iMaxPing     = 325;
	self.m_iMinFPS      = 15;
	self.m_iCurFPS      = 50;
	self.m_iFPSStartick = getTickCount();
	self.m_iTempFPS     = 0;

	self.m_iStartTick   = getTickCount();
	self.m_bHighPing    = false;

	self.m_bAlpha       = 0;

	-- Funktionen --
	self.m_tickFunc     = function(...) self:tick(...) end
	self.m_funcRender   = function(...) self:render(...) end

	-- Events --
--	addCommandHandler("highping", function(cmd, i) self.m_iMaxPing = tonumber(i) end)

	addEventHandler("onClientPreRender", getRootElement(), self.m_funcRender)
end

-- EVENT HANDLER --

