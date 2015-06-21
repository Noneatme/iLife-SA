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
-- Date: 28.12.2014
-- Time: 15:14
-- Project: MTA iLife
--

cBloodScreen = {};

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function cBloodScreen:new(...)
	local obj = setmetatable({}, {__index = self});
	if obj.constructor then
		obj:constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// REnder      		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cBloodScreen:render()
	if(self.m_bEnabled) then

		local wert              = 1 - (getTickCount()-self.m_iCurTickCount)/self.m_iTimeToFade;

		if(wert < 0) then
			wert = 0;
		end

		local alpha             = wert*255;

		dxDrawImage(0, 0, self.m_iSX, self.m_iSY, "res/images/render/bloodscreen.png", 0, 0, 0, tocolor(255, 255, 255, alpha));


		if(alpha < 0) then
			self:reset();
		end
	end
end

-- ///////////////////////////////
-- ///// reset      		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cBloodScreen:reset()
	self.m_bEnabled = false;
	removeEventHandler("onClientRender", getRootElement(), self.m_renderFunc)
end

-- ///////////////////////////////
-- ///// treffe      		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cBloodScreen:treffe()
	if(self.m_bEnabled) then
		self:reset();
	end
	self.m_bEnabled             = true;
	self.m_iCurTickCount        = getTickCount();
	self.m_iCurrentAlpha        = 255;

	addEventHandler("onClientRender", getRootElement(), self.m_renderFunc)
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cBloodScreen:constructor(...)
	-- Klassenvariablen --

	self.m_iCurrentAlpha        = 255;
	self.m_bEnabled             = false;
	self.m_iTimeToFade          = 500;

	self.m_iSX, self.m_iSY      = guiGetScreenSize();

	self.m_iCurTickCount        = getTickCount();

	self.m_renderFunc           = function(...) self:render(...) end
	self.m_treffFunc            = function(...) self:treffe(...) end
	-- Funktionen --

	-- Events --
	addEvent("onClientPlayerDamageGet", true);

	addEventHandler("onClientPlayerDamageGet", getLocalPlayer(), self.m_treffFunc)
end

-- ///////////////////////////////
-- ///// destructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cBloodScreen:destructor(...)
	removEventHandler("onClientRender", getRootElement(), self.m_renderFunc)
end

-- EVENT HANDLER --

