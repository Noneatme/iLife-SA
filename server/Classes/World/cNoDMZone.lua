--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

-- #######################################
-- ## Project: MTA iLife				##
-- ## Name: NoDMZone.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

NoDMZone = {};
NoDMZone.__index = NoDMZone;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function NoDMZone:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// EnterCol	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function NoDMZone:EnterCol(uPlayer, bMatchDim)
	if(bMatchDim) then
		if(uPlayer) and (getElementType(uPlayer) == "player") then
			triggerClientEvent(uPlayer, "onPlayerEnterNoDMCol", uPlayer, true);
		end
	end
end

-- ///////////////////////////////
-- ///// ExitCol	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function NoDMZone:ExitCol(uPlayer, bMatchDim)
	if(bMatchDim) then
		if(uPlayer) and (getElementType(uPlayer) == "player") then
			triggerClientEvent(uPlayer, "onPlayerEnterNoDMCol", uPlayer, false);
		end
	end
end


-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function NoDMZone:Constructor(iID, iX, iY, iZ, iL, iW, iH, sName)
	-- Klassenvariablen --

	self.iID = iID;

	self.pos	= {iX, iY, iZ}
	self.r		= {iL, iW, iH}
	self.sName	= sName;
	self.col	= createColCuboid(iX, iY, iZ, iL, iW, iH);


	-- Methoden --

	self.colHitFunc		= function(...) self:EnterCol(...) end;
	self.colLeaveFunc 	= function(...) self:ExitCol(...) end;

	-- Events --
	addEventHandler("onColShapeHit", self.col, self.colHitFunc)
	addEventHandler("onColShapeLeave", self.col, self.colLeaveFunc)

	--logger:OutputInfo("[CALLING] NoDMZone: Constructor");
end

-- EVENT HANDLER --
