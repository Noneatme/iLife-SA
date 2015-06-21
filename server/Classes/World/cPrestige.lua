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
-- ## Name: Prestige.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

Prestige = {};
Prestige.__index = Prestige;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function Prestige:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// PickupHit	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Prestige:PickupHit(uPlayer)
	if(uPlayer) and (getElementType(uPlayer) == "player") then
		local iID = self.iOwnerID;

		if(iID ~= 0) then
			if(PlayerNames[iID]) then
				iID = PlayerNames[iID];
			end
		end

		triggerClientEvent(uPlayer, "onClientPrestigeOpen", uPlayer, self.iID, self.iCost, iID, self.sTitle, self.sDescription);
	end
end

-- ///////////////////////////////
-- ///// Buy		 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Prestige:Buy(uPlayer)
	if(uPlayer.LoggedIn) then
		if(self.iOwnerID == 0) then
			if(uPlayer:getMoney() >= self.iCost) then
				self.iOwnerID	= uPlayer:getID();
				self:Save();
				uPlayer:addMoney(-self.iCost);
				uPlayer:showInfoBox("sucess", "Prestige gekauft!");
				
				logger:OutputPlayerLog(uPlayer, "Prestige gekauft", self.sTitle, "$"..self.iCost)
				Achievements[137]:playerAchieved(uPlayer)
			else
				uPlayer:showInfoBox("error", "Du hast nicht soviel Geld auf der Hand!")
			end
		else
			uPlayer:showInfoBox("error", "Das Prestige-Objekt ist bereits gekauft!")
		end
	end
end

-- ///////////////////////////////
-- ///// Reset		 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Prestige:Reset(uPlayer)
	if(uPlayer.LoggedIn) then
		if(uPlayer:getAdminLevel() >= 2) then
			self.iOwnerID = 0;
			self:Save()
			
			uPlayer:showInfoBox("sucess", "Das Prestige: "..self.sTitle.." wurde resettet!");
			uPlayer:addMoney(self.iCost);
			logger:OutputPlayerLog(uPlayer, "Prestige resettet", self.sTitle, "$"..self.iCost)
			
		else
			uPlayer:showInfoBox("error", "Du bist kein Admin!")
		end
	end
end

-- ///////////////////////////////
-- ///// Sell		 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Prestige:Sell(uPlayer)
	if(uPlayer.LoggedIn) then
		if(self.iOwnerID == uPlayer:getID()) then
			self.iOwnerID 	= 0;
			self:Save()

			uPlayer:addMoney(self.iCost);
			logger:OutputPlayerLog(uPlayer, "Prestige verkauft", self.sTitle, "$"..self.iCost)
			uPlayer:showInfoBox("sucess", "Du hast das Prestige-Objekt verkauft!");
		else
			uPlayer:showInfoBox("error", "Das Prestige-Objekt ist nicht von dir gekauft!")
		end
	end
end


-- ///////////////////////////////
-- ///// Save		 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Prestige:Save()
	CDatabase:getInstance():exec("UPDATE prestige SET OwnerID = "..self.iOwnerID.." WHERE ID = "..self.iID..";")
	self.sOwnerName = (PlayerNames[self.iOwnerID] or "Niemand");

	setElementData(self.pickup, "OwnerName", self.sOwnerName)

end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Prestige:Constructor(iID, iX, iY, iZ, iCost, iOwnerID, sTitle, sDescription)

	-- Klassenvariablen --
	self.iID 			= iID;
	self.pos			= {iX, iY, iZ};
	self.iCost			= iCost;

	self.iOwnerID 		= iOwnerID;
	self.sOwnerName		= (PlayerNames[self.iOwnerID] or "Niemand");
	self.sTitle			= sTitle;
	self.sDescription	= sDescription;

	self.pickup			= createPickup(iX, iY, iZ, 3, 1239, 50);
	self.colShape		= createColSphere(iX, iY, iZ, 25);

	setElementData(self.pickup, "Title", self.sTitle)
	setElementData(self.pickup, "OwnerName", self.sOwnerName)

	-- Methoden --

	self.pickupHitFunc = function(...) self:PickupHit(...) end;

	-- Events --
	addEventHandler("onPickupHit", self.pickup, self.pickupHitFunc)

	addEventHandler("onColShapeHit", self.colShape, function(uPlayer)
		if(uPlayer) and (getElementType(uPlayer) == "player") then
			triggerClientEvent(uPlayer, "onPrestigeColToggle", uPlayer, self.pickup, true)
		end
	end)
	addEventHandler("onColShapeLeave", self.colShape, function(uPlayer)
		if(uPlayer) and (getElementType(uPlayer) == "player") then
			triggerClientEvent(uPlayer, "onPrestigeColToggle", uPlayer, self.pickup, false)
		end
	end)
	--logger:OutputInfo("[CALLING] Prestige: Constructor");
end

-- EVENT HANDLER --
