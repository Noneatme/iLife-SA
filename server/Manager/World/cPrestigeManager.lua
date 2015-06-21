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
-- ## Name: PrestigeManager.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings

PrestigeManager = {};
PrestigeManager.__index = PrestigeManager;

addEvent("onPrestigeBuy", true)
addEvent("onPrestigeSell", true)

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function PrestigeManager:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// LoadPrestige 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function PrestigeManager:LoadPrestige()
	local start = getTickCount()
	local prestige = 0;
	local result = CDatabase:getInstance():query("SELECT * FROM prestige;")
	if(result) then
		for index, tbl in pairs(result) do
			prestige = prestige+1;
			local ownerID = tbl["OwnerID"]
			if(tonumber(ownerID) ~= 0) then
				if not(isOwnerInTheLastMonthsActive(ownerID)) then
					ownerID = 0;
				end
			end
			self.prestige[prestige] = Prestige:New(tbl["ID"], tbl["PosX"], tbl["PosY"], tbl["PosZ"]-0.5, tonumber(tbl["Cost"]), ownerID, tbl["Title"], tbl["Description"])
			cInformationWindowManager:getInstance():addInfoWindow({tbl["PosX"], tbl["PosY"], tbl["PosZ"]+0.25}, "Prestige", 30)
		end
	end
	outputServerLog("Es wurden "..prestige.." Prestige-Objekte in "..(getTickCount() - start).." MS gefunden!")
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function PrestigeManager:Constructor(...)
	-- Klassenvariablen --
	self.prestige	= {}
	
	-- Methoden --
	self:LoadPrestige();
	
	self.buyFunc = function(iID)
		if(self.prestige[iID]) then
			self.prestige[iID]:Buy(client);
		end
	end
		
	self.sellFunc = function(iID)
		if(self.prestige[iID]) then
			self.prestige[iID]:Sell(client);
		end
	end
	
	-- Events --
	addEventHandler("onPrestigeBuy", getRootElement(), self.buyFunc)
	addEventHandler("onPrestigeSell", getRootElement(), self.sellFunc)
	
	--logger:OutputInfo("[CALLING] PrestigeManager: Constructor");
end

-- EVENT HANDLER --
