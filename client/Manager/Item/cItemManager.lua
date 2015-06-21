--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

-- #######################################
-- ## Project: 		 iLife				##
-- ## For MTA: San Andreas				##
-- ## Name: cItemManager.lua		        	##
-- ## Author: Noneatme(Gunvarrel)		##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- ## Date: March 2015                  ##
-- #######################################

cItemManager = inherit(cSingleton);

--[[

]]

-- ///////////////////////////////
-- ///// getItems 			//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cItemManager:getItems()
	return self.m_tblItems;
end

-- ///////////////////////////////
-- ///// onItemsReceive 			//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cItemManager:onItemsReceive(tblItems)
	if(tblItems) then
		tblItems				= fromJSON(tblItems);
		self.m_tblItems	= tblItems;
		outputDebugString("Got Server Items: "..#tblItems)
	end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cItemManager:constructor(...)
    -- Klassenvariablen --
	self.m_tblItems		= {}

    -- Funktionen --
	addEvent("onClientItemsReceive", true)

	self.m_funcOnItemsReceive		= function(...) self:onItemsReceive(...) end

    -- Events --

	addEventHandler("onClientItemsReceive", getLocalPlayer(), self.m_funcOnItemsReceive)
end

-- EVENT HANDLER --
