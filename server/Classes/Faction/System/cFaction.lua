--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

Factions    = {}

CFaction    = {}

function CFaction:constructor(iID, sName, sShortName, iDepotmoney, iType, sSkins, sColor, sRanknames, sKoords, iDistanz, iInventory, tMembers, tVehicles)
	self.start = getTickCount()
	self.ID 		= iID
	self.Name 		= sName
	self.ShortName 	= sShortName
	self.Depotmoney = iDepotmoney
	self.Type 		= iType
	self.Vehicles 	= {}
	self.Skins 		= {}
	self.Koords		= sKoords;
	self.iInventoryID   = iInventory;

	if (iInventory == 0) then
		CDatabase:getInstance():query("INSERT INTO  inventory (`ID` ,`Type` ,`Categories` ,`Items` ,`Slots`) VALUES (NULL ,  '1',  ' [ { \"7\": true, \"1\": true, \"2\": true, \"4\": true, \"8\": true, \"9\":  true, \"5\": true, \"3\": true, \"6\": true } ]',  '[ {\"17\": 2 } ]',  '250');")
		local val = CDatabase:getInstance():query("SELECT * FROM inventory WHERE ID=(LAST_INSERT_ID())")
		local value = val[1]
		self.Inventory = new (CInventory, value["ID"], value["Type"], value["Categories"], value["Items"], value["Slots"])
		outputConsole("Die Fraktion "..sName.." besitzt nun das Inventar mit der Nummer "..value["ID"])
		self:save()
	else
		self.Inventory = Inventories[iInventory]

		if not(self.Inventory) then
			outputConsole("Inventar fuer Fraktion: "..self.Name.." nicht gefunden! Erstelle Neues.")
            local val = CDatabase:getInstance():query("SELECT (MAX(ID)) AS ID FROM inventory;")

			self.Inventory = new (CInventory, tonumber(val[1]["ID"])+1, 1, "[ [ ] ]", "[ [ ] ]", 250)
		end
	end

	self.Distanz	= iDistanz;
	self.Members 	= {}

	for k,v in ipairs(tMembers or {}) do
		local index = #self.Members+1
		self.Members[index] = {}
		self.Members[index]["Name"] = v["Name"]
		self.Members[index]["Rang"] = v["Rank"]
	end

	for i=1, 5, 1 do
		self.Skins[i] = gettok(sSkins, i, "|")
	end

	self.Color 		= sColor
	self.Ranknames 	= {}

	for i=1, 5, 1 do
		self.Ranknames[i] = gettok(sRanknames, i, "|")
	end

	local koords	= split(self.Koords, "|", -1);
	local x, y, z	= tonumber(koords[1]), tonumber(koords[2]), tonumber(koords[3]);

	if(x ~= 0) and (y ~= 0) and (z ~= 0) then
		self.FactionPickup	= createPickup(x, y, z, 3, 1272, 50);
		cInformationWindowManager:getInstance():addInfoWindow({x, y, z+0.7}, "Fraktion", 30)
		local leaderString 		= "-";
		local coLeaderString	= "-";

		for Member, tbl in pairs(self.Members) do
			local rang = tonumber(tbl["Rang"])
			if(rang >= 5) then
				if(#leaderString > 1) then
					leaderString = leaderString..", "..tbl["Name"]
				else
					leaderString = tbl["Name"]
				end
			elseif(rang == 4) then
				if(#coLeaderString > 1) then
					coLeaderString = coLeaderString..", "..tbl["Name"]
				else
					coLeaderString = tbl["Name"]
				end
			end
		end


		self.colShapeHitFunc	= bind(self.colShapeHit, self);
		self.colShapeLeaveFunc	= bind(self.colShapeLeave, self);

		self.FactionColshape	= createColSphere(x, y, z, 20);


		setElementData(self.FactionColshape, "faction:Name", self.Name);
		setElementData(self.FactionColshape, "faction:ID", self.ID);
		setElementData(self.FactionColshape, "faction:Leader", leaderString);
		setElementData(self.FactionColshape, "faction:CoLeader", coLeaderString);
		setElementData(self.FactionColshape, "faction:Distanz", iDistanz);

		addEventHandler("onColShapeHit", self.FactionColshape, self.colShapeHitFunc)
		addEventHandler("onColShapeLeave", self.FactionColshape, self.colShapeLeaveFunc)
	end

	Factions[self.ID] = self
	self:spawnCars(tVehicles)
end

function CFaction:colShapeHit(uElement, dim)
	if(getElementType(uElement) == "player") then
		local tbl = getElementData(uElement, "p:visitedFaction");
		if not(tbl) then
			tbl = {}
		end
		tbl[self.FactionColshape] = self.FactionColshape;
		setElementData(uElement, "p:visitedFaction", tbl)
	end
end

function CFaction:colShapeLeave(uElement, dim)
	if(getElementType(uElement) == "player") then
		local tbl = getElementData(uElement, "p:visitedFaction");
		if not(tbl) then
			tbl = {}
		end
		tbl[self.FactionColshape] = nil;
		setElementData(uElement, "p:visitedFaction", tbl)
	end
end

function CFaction:destructor()

end
function CFaction:sendInventory(uPlayer)
	if not(self.Inventory) then
		self.Inventory =  Inventories[self.iInventoryID]
	end
	self.Inventory:refreshGewicht();
	triggerClientEvent(uPlayer, "onClientInventoryRecieve", uPlayer, toJSON(self.Inventory));
end

function CFaction:save()
	CDatabase:getInstance():query("UPDATE factions SET Depotmoney = ?, Inventory = ? WHERE ID =?", self.Depotmoney, self.Inventory.ID, self.ID)
end

function CFaction:getName()
	return self.Name
end

function CFaction:getID()
	return self.ID
end

function CFaction:getType()
	return self.Type
end

function CFaction:getRankName(Rank)
	return self.Ranknames[tonumber(Rank)]
end

function CFaction:getRankSkin(Rank)
	return self.Skins[tonumber(Rank)]
end

function CFaction:getColors()
	return tonumber(gettok(self.Color, 1, "|")),tonumber(gettok(self.Color, 2, "|")),tonumber(gettok(self.Color, 3, "|"))
end

function CFaction:spawnCars(tVehicles)
	for key, value in ipairs(tVehicles or {}) do
		local theVehicle = createVehicle(value["VID"], gettok(value["Koords"],1,"|"), gettok(value["Koords"],2,"|"), gettok(value["Koords"],3,"|"), gettok(value["Koords"],4,"|"), gettok(value["Koords"],5,"|"), gettok(value["Koords"],6,"|"), "Faction "..self.ID)
		enew(theVehicle, CFactionVehicle, value["ID"], value["VID"], value["FID"], value["Int"], value["Dim"], value["Koords"], value["Color"], value["Tuning"], value["KM"], value["Typ"], value["Left"])
	end
	outputServerLog("Es wurden " .. (tVehicles and #tVehicles or "0") .." Vehicles fuer die Fraktion "..self.ShortName.." gefunden. (" .. getTickCount() - self.start .. "ms)")
end

function CFaction:getMembers()
	return self.Members
end

function CFaction:getData()
	return {
		["Name"] = self.Name,
		["Money"] = self.Depotmoney,
		["Boni"] = {[1]=200, [2]=400, [3]=600, [4]=800, [5]=1000},
		["Type"] = self.Type
	}
end

function CFaction:sendMessage(sMessage, r, g, b)
	for k,v in ipairs(getElementsByType("player")) do
		if (getElementData(v, "online") and (v:getFaction() == self) ) then
			local rf,gf,bf = self:getColors()
			rf = r or rf
			gf = g or gf
			bf = b or bf
			outputChatBox(sMessage, v, rf, gf, bf, false)
		end
	end
end

function CFaction:addMember(thePlayer)
	table.insert(self.Members, {["Name"]=thePlayer:getName(),["Rang"]=thePlayer:getRank()})
	thePlayer:save()
	self:updateMembers()
end

function CFaction:removeMember(PlayerName)
	for k,v in ipairs(self.Members) do
		if (v["Name"] == PlayerName) then
			if (getPlayerFromName(v["Name"])) then
				getPlayerFromName(v["Name"]):setFaction(Factions[0])
				getPlayerFromName(v["Name"]):setRank(0)
				getPlayerFromName(v["Name"]):setSkin(137)
			end
			table.remove(self.Members, k)
		end
	end
	self:updateMembers()
end

function CFaction:updateMembers()

	self.Members = {}

	local tMembers = CDatabase:getInstance():query("SELECT Name, Fraktion, Rank FROM Userdata WHERE Fraktion =? ",self.ID)

	for k,v in ipairs(tMembers or {}) do
		local index = #self.Members+1
		self.Members[index] = {}
		self.Members[index]["Name"] = v["Name"]
		self.Members[index]["Rang"] = v["Rank"]
	end
end

function CFaction:getOnlinePlayers()
	local tblOnlinePlayers 	= {};
	local iInt				= 0;
	for k,v in ipairs(self.Members) do
		if(getPlayerFromName(v["Name"])) then
			local uPlayer = getPlayerFromName(v["Name"]);

			iInt = iInt+1;
			table.insert(tblOnlinePlayers, uPlayer)
		end
	end

	return tblOnlinePlayers, iInt;
end

function CFaction:addDepotMoney(iAmount)
	self.Depotmoney = self.Depotmoney+iAmount
	self:save()
	self:updateDataForAllMember()
end

function CFaction:removeDepotMoney(iAmount)
	if (self.Depotmoney-iAmount >= 0) then
		self.Depotmoney = self.Depotmoney-iAmount
		self:save()
		self:updateDataForAllMember()
		return true
	else
		return false
	end
end

function CFaction:updateDataForAllMember()
	local onlinePlayers = self:getOnlinePlayers()
		for k,v in ipairs(onlinePlayers) do
			triggerClientEvent(v, "onServerSendsFactionInfo", getRootElement(), self:getData())
		end
end

function CFaction:updateMemberName(player, newName)
	if self.ID == 0 then
		return false
	end
	for k,v in ipairs(self.Members) do
		if (v["Name"] == getPlayerName(player)) then
			self.Members[k]["Name"] = newName
			self:sendMessage(getPlayerName(player).." änderte seinen Namen zu "..newName.."!")
			return true
		end
	end
end

function CFaction:sendTypeMessage(iType, sMessage, r, g, b)
	for index, faction in pairs(Factions) do
		if(faction.Type == iType) then
			faction:sendMessage(sMessage, r, g, b);
		end
	end
end

function CFaction:respawnVehicles()
	for id, vehicle in pairs(FactionVehicles) do
		if(vehicle.FID == self.ID) then
			vehicle:respawn();
		end
	end
end
