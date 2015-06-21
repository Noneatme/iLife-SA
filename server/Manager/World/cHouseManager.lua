--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

-- #######################################
-- ## Project: 		 iLife				        ##
-- ## For MTA: San Andreas				      ##
-- ## Name: cHouseManager.lua						##
-- ## Author: various       		        ##
-- ## Version: 1.0						          ##
-- ## License: See top Folder			      ##
-- ## Date: unknown		                  ##
-- #######################################


CHouseManager 		= inherit(cSingleton)
FactionHouses 		= {}
CorporationHouses 	= {}

HousePickups		= {}

local tbl_HousesByOwner = {}


-- ///////////////////////////////
-- ///// constructor			  //////
-- ///// Returns: void		  //////
-- ///////////////////////////////

function CHouseManager:constructor()
	self.loadHousesFunc	= function() self:loadHouses() end
	self.thread			= cThread:new("House_Loading_Thread", self.loadHousesFunc, 5)
	self.m_iLastHouseID	= 0;
	self.m_iFreeHouses	= 0;
	self.thread:start(50);
end


-- ///////////////////////////////
-- ///// createHouse			  //////
-- ///// Returns: void		  //////
-- ///////////////////////////////

function CHouseManager:createHouse(id, price, cost, owner, koords, locked, tblIntPos, distanz, fraktion, hausKey, corp, ...)

	self.m_iLastHouseID = id;
	self.m_tblHousesByOwner = {} -- fuer Payday usw.

	local X = gettok(koords, 3, "|")
	local Y = gettok(koords, 4, "|")
	local Z = gettok(koords, 5, "|")
	local Int = gettok(koords, 1, "|")
	local Dim = gettok(koords, 2, "|")

	local theModel, blipID;

	if(tonumber(owner)) and (tonumber(owner) ~= 0) and (tonumber(fraktion) == 0) and (tonumber(corp) == 0) then
		if not(cBasicFunctions:isOwnerInTheLastMonthsActive(tonumber(owner))) then
			owner = 0;
			self.m_iFreeHouses = self.m_iFreeHouses+1;
		else
			if not tbl_HousesByOwner[tonumber(owner)] then
				tbl_HousesByOwner[tonumber(owner)] = {}
			end
			tbl_HousesByOwner[tonumber(owner)][tonumber(id)] = price+cost
		end
	end
	if (owner == 0) and (fraktion == 0) and (corp == 0) then
		theModel = 1273
		blipID = 31
	else
		theModel = 1272
		blipID = 32
	end

	local thePickup = createPickup(X,Y,Z, 3, theModel, 1)
	enew(thePickup, CHouse, id, price, cost, owner, koords, locked, tblIntPos, distanz, fraktion, hausKey, corp, ...)

	HousePickups[id] = thePickup;

	thePickup:setInterior(Int)
	thePickup:setDimension(Dim)
	cInformationWindowManager:getInstance():addInfoWindow({X, Y, Z+0.9}, "Haus", 30)
end


-- ///////////////////////////////
-- ///// loadHouses				  //////
-- ///// Returns: void		  //////
-- ///////////////////////////////

function CHouseManager:loadHouses()
	local start = getTickCount()

	for k,v in pairs(Factions) do
		FactionHouses[v:getID()] = {}
	end
	local keys = CDatabase:getInstance():query("SELECT HK.HID, U.Name FROM house_keys AS HK LEFT JOIN User AS U ON (U.ID = HK.UID);")
	local houseKeys
	if (#keys > 0) then
		houseKeys = {}
		for i, v in ipairs(keys) do
			if (not houseKeys[v.HID]) then houseKeys[v.HID] = {} end
			houseKeys[v.HID][v.Name] = true
			table.insert(houseKeys[v.HID], v)
		end
	end

	local result = CDatabase:getInstance():query("SELECT H.ID, H.Cost, H.Owner, H.Koords, H.Locked, H.Interior, H.Objektdistanz, H.Faction, H.Corporation, HI.Int, HI.X, HI.Y, HI.Z, HI.Rotation, HI.Desc, HI.Price FROM houses AS H LEFT JOIN house_interiors AS HI ON (HI.ID = H.Interior)")
	if (#result > 0) then
		for key, value in pairs(result) do
			--Koords --> Int|Dim|X|Y|Z
			local Int = gettok(value["Koords"], 1, "|")
			local Dim = gettok(value["Koords"], 2, "|")
			local X = gettok(value["Koords"], 3, "|")
			local Y = gettok(value["Koords"], 4, "|")
			local Z = gettok(value["Koords"], 5, "|")

			if (value["Owner"] == 0) and (value["Faction"] == 0) then
				theModel = 1273
				blipID = 31
			else
				theModel = 1272
				blipID = 32
			end

			self:createHouse(value["ID"], (value["Price"] or 0), (value["Cost"] or 0), value["Owner"], value["Koords"], value["Locked"], {value['X'], value['Y'], value['Z'], value['Int']}, value["Objektdistanz"], value["Faction"], houseKeys[value['ID']], value["Corporation"])


			--thePickup:setBlip(createBlip(X,Y,Z, blipID, 1, 0, 0, 0, 0,0,150, getRootElement()))
			coroutine.yield(self.thread.thread);
		end
	end
	outputDebugString("Es wurden "..tostring(#result).." Haueser gefunden! Entmachtet: "..self.m_iFreeHouses.." (Ende: " .. getTickCount() - start .. "ms)")
end


-- ///////////////////////////////
-- ///// getHousesByOwnerID //////
-- ///// Returns: tblHouse  //////
-- ///////////////////////////////

function CHouseManager:getHousesByOwnerID(iOwnerID)
	iOwnerID = tonumber(iOwnerID)
	if tbl_HousesByOwner[iOwnerID] then
		return tbl_HousesByOwner[iOwnerID]
	else
		outputChatBox("_debug {}")
		return {}
	end
end
