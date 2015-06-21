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
-- Time: 18:11
-- Project: MTA iLife
--



cInformationWindowManager = inherit(cSingleton);

--[[

]]


-- ///////////////////////////////
-- ///// addInfoWindow 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cInformationWindowManager:addInfoWindow(V3Position, sText, iMaxDistance)
	self.m_iINT = self.m_iINT +1;
	self.m_tblWindows[self.m_iINT] = {V3Position, sText, iMaxDistance or 25};
end
-- ///////////////////////////////
-- ///// RequestReturn 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cInformationWindowManager:requestReturn(uPlayer)
	return triggerClientEvent(uPlayer, "onInformationWindowRequestItemsBack", uPlayer, self.m_tblWindows);
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cInformationWindowManager:constructor(...)
	-- Klassenvariablen --
	self.m_iINT         = 0;
	self.m_tblWindows   = {}
	
	-- Funktionen --
	addEvent("onInformationWindowRequestItems", true);

	self.m_funcRequest      = function(splayer, ...)
		if not(client) then
			client = splayer
		end
		self:requestReturn(client, ...)
	end


	-- Events --
	addEventHandler("onInformationWindowRequestItems", getRootElement(), self.m_funcRequest)
end

-- EVENT HANDLER --

