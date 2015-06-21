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
-- Date: 27.12.2014
-- Time: 01:41
-- Project: MTA iLife
--


cFireworkManager = {};

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
-- ///// launchPlayerFW 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cFireworkManager:launchPlayerFW(uPlayer, sFirework, tblFirework)
	setElementFrozen(uPlayer, true);
	toggleControl(uPlayer, "all", false)
	setPedAnimation(uPlayer, "BOMBER", "BOM_Plant_Loop", -1, true, false, false);

	local vars = tblFirework;

	setTimer(function()
		setPedAnimation(uPlayer);
		setElementFrozen(uPlayer, false);

		triggerClientEvent(getRootElement(), "onClientFireworkStart", getRootElement(), sFirework, tblFirework)
		toggleControl(uPlayer, "all", true)
	end, 2000, 1)
end


-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cFireworkManager:constructor(...)
--[[
	addCommandHandler("firework", function(thePlayer, cmd, parm)
		local x, y, z = getElementPosition(thePlayer);
		local tbl = {x, y, z, math.random(10, 15) }

		triggerClientEvent(getRootElement(), "onClientFireworkStart", getRootElement(), parm, tbl)
	end)]]
	
		-- ITEM SHOP --
--	self.m_ShopMarker = ItemShops[25].addMarker(ItemShops[25], 0, 0, 2713.1118164063, -1103.4870605469, 69.577560424805)
--	setElementInterior(self.m_ShopMarker, 0)
end


cFireworkManager:new();