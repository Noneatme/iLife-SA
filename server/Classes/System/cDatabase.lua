--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

--[[
@Class Database
- Database management

---- Functions ------

CDatabase:excec(sQuery [, ...args])
Excecutes a Query without any result or callback. Use for one-way Querys.

CDatabase:query(sQuery [, ...args])
Excecutes a SQL-Query. You will get a Table as result.

]]

local using_localhost = true;
CDatabase = inherit(cSingleton)

function CDatabase:constructor(sType, sHost, sUser, sPass, sDBName, iPort)
	self.sType = sType
	self.sHost = sHost
	self.sUser = sUser
	self.sPass = sPass
	self.sDBName = sDBName
	self.iPort = iPort

	if (self.sType == "mysql") then
		self.hCon = dbConnect(self.sType, "dbname="..self.sDBName..";host="..self.sHost..";port="..iPort..";unix_socket=/run/mysqld/mysqld.sock;", self.sUser, self.sPass)
		if ((self.hCon ~= false) and (self.hCon)) then
			outputServerLog("Datenbankverbindung hergestellt!")
			self.tSaveAllDatas = bind (self.saveAllDatas, self)
			setTimer(self.tSaveAllDatas, 300000, 0)
		else
			outputServerLog("Datenbankverbindung konnte nicht hergestellt werden!")
			stopResource(getThisResource())
		end
	else
		outputServerLog("Please add specific Database Connection!")
		stopResource(getThisResource())
	end
end

function CDatabase:destructor()
	self.sType = nil
	self.sHost = nil
	self.sUser = nil
	self.sPass = nil
	self.sDBName = nil
	self.iPort = nil
	destroyElement(self.hCon)
end

function CDatabase:query(sQuery, ...)
	-- Anti Linux --
	--[[local tables =
	{
		["System"]          = true,
		["User"]            = true,
		["Radio_Streams"]   = true,
		["Userdata"]        = true,
		["Faction_Vehicle"] = true,
		["Factions"]        = true,
		["Inventory"]       = true,
		["Gangareas"]       = true,
		["Item_Category"]   = true,
		["Item"]            = true,
		["achievement"]     = true,
		["achievement_category"] = true,
		["achievement_reward"] = true,
		["advertisments"]   = true,
		["bankvendors"]     = true,
		["bans"]            = true,
		["business"]        = true,
		["chains"]          = true,
		["drivein"]         = true,
		["faction_crashedvehiclespawns"] = true,
		["faction_ped"]     = true,
		["faction_vehicle"] = true,
		["gates"]           = true,
		["houses"]          = true,
		["house_interiors"] = true,
		["house_keys"]      = true,
		["house_objects"]   = true,
		["infopickups"]     = true,
		["serversettings"]  = true,
		["itemshop"]        = true,
		["shop"]            = true,
		["item"]            = true,
		["item_Crafting"]   = true,
	}]]
	-- Dieser Scheiss muss gemacht werden, da es Linux anscheinend NICHT EGAL IST OB DER TABELLENNAMEN GROSS ODER KLEIN GESCHRIEBEN IST! Was fuer ein SCHEISS

	--[[
	for index, _ in pairs(tables) do
		sQuery = string.gsub(sQuery, index, string.lower(index));
	end]]

	local qHandler = dbQuery(self.hCon,sQuery, ...)
	local result, iRows, sError = dbPoll ( qHandler, 90)
	if (result == nil) then
		result, iRows, sError = dbPoll ( qHandler, -1)
		if(result == nil) then
			dbFree(qHandler)
			outputDebugString("Max query runtime reached: "..sQuery)
			return false
		end
	end

	if (result == false) then
		outputDebugString("Error Excecuting Query: "..tostring(sQuery).." ||"..tostring(iRows).."| "..tostring(sError))
		return false
	end
	return result, iRows, (sError or "-");
end

function CDatabase:exec(sQuery, ...)
	return dbExec(self.hCon, sQuery, ...)
end

function CDatabase:queryAsync(sQuery, mCallBack, ...)
	local function doCallBack(qh, tag, score)
		local args = {dbPoll(qh, 0)}
		if(mCallBack) then
			mCallBack(unpack(args));
		end
	end
	return dbQuery(doCallBack, self.hCon, sQuery, ...)
end

function CDatabase:savePlayer(thePlayer)
	thePlayer:save()
end

function CDatabase:saveAllPlayers()
	local players = getElementsByType("player")
	if (#players > 0) then
		for i,thePlayer in ipairs(players) do
			if (thePlayer.LoggedIn == true) then
				thePlayer:save()
			end
		end
	end
end

function CDatabase:saveAllUserVehicles()
	if (table.size(UserVehicles) > 0) then
		for i,theVehicle in pairs(UserVehicles) do
			theVehicle:save()
		end
	end
end


function CDatabase:saveAllDatas()
	self:saveAllPlayers()
	self:saveAllUserVehicles()
end

-- Dimensionspeicherung

UsedDimensions = {}

_setElementDimension = setElementDimension

function setElementDimension(theElement, Dim)
	Dim = tonumber(Dim)

	local oldDim = getElementDimension(theElement)

	if (oldDim ~= 0) then
		if (type(UsedDimensions[oldDim]) == "table") then
			UsedDimensions[oldDim][theElement] = nil
			if (table.size(UsedDimensions[oldDim]) == 0) then
				UsedDimensions[oldDim] = nil
			end
		end
	end

	if not(Dim == 0) and (Dim < 10000) then
		if ( not (type(UsedDimensions[Dim]) == "table")) then
			UsedDimensions[Dim] = {}
		end
		UsedDimensions[Dim][theElement] = true
	end
	_setElementDimension(theElement, Dim)
end

function getEmptyDimension()
	for i=1, 9999, 1 do
		if not(type(UsedDimensions[i]) == "table") then
			return i
		end
	end
	return 9999
end

setTimer(
	function()
		for k,v in pairs(UsedDimensions) do
			if table.size(v) == 0 then
				UsedDimensions[k] = nil
			end
		end
	end
	, 125000, 0)
