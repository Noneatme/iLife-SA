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
-- Date: 23.12.2014
-- Time: 17:47
-- Project: MTA iLife
--


cFontManager = inherit(cSingleton)

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function cFontManager:new(...)
	local obj = setmetatable({}, {__index = self});
	if obj.constructor then
		obj:constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// LoadFonts  		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cFontManager:loadFonts()
	self.m_FONT_PLAY_BOLD   = dxCreateFont(self.m_sFontFolder.."/play_bold.ttf", self.m_iDefaultScale);
	self.m_FONT_OSWALD   	= dxCreateFont(self.m_sFontFolder.."/oswald.ttf", self.m_iDefaultScale);
	self.m_FONT_DSDIGI		= dxCreateFont(self.m_sFontFolder.."/DS-DIGI.ttf", 30, true)

end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cFontManager:constructor(...)
	-- Klassenvariablen --
	self.m_iDefaultScale        = 64;
	self.m_sFontFolder          = "res/fonts/";

	-- Funktionen --

	addEventHandler("onClientDownloadFinnished", getLocalPlayer(), function()
		self:loadFonts();
	end)

	-- Events --
end

-- EVENT HANDLER --
