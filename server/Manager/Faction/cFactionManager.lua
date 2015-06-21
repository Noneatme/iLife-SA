--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CFactionManager = inherit(cSingleton)

function CFactionManager:constructor()
	local start = getTickCount()
	-- Factions
	local result = CDatabase:getInstance():query("SELECT * FROM factions")
	
	local members = CDatabase:getInstance():query("SELECT Name, Fraktion, Rank FROM userdata")
	local factionMembers = {}
	for i, v in ipairs(members) do
		if (not factionMembers[tonumber(v['Fraktion'])]) then factionMembers[tonumber(v['Fraktion'])] = {} end
		table.insert(factionMembers[tonumber(v['Fraktion'])], v)
	end
	
	local vehicles = CDatabase:getInstance():query("SELECT * FROM faction_vehicle")
	local factionVehicles = {}
	for i, v in ipairs(vehicles) do
		if (not factionVehicles[tonumber(v['FID'])]) then factionVehicles[tonumber(v['FID'])] = {} end
		table.insert(factionVehicles[tonumber(v['FID'])], v)
	end
		
	if(#result > 0) then
		for key, value in pairs(result) do
			new (CFaction, value["ID"], value["Name"], value["ShortName"], value["Depotmoney"], value["type"], value["Skins"], value["Color"],value["Ranknames"], value["Koords"], value["Distanz"], value["Inventory"], factionMembers[value["ID"]], factionVehicles[value["ID"]])
		end
		outputServerLog("Es wurden "..tostring(#result).." Fraktionen gefunden!")
	else
		outputServerLog("Es wurden keine Fraktionen gefunden!")
	end
	
	-- GangAreas
	local result = CDatabase:getInstance():query("SELECT * FROM gangareas")
	if(#result > 0) then
		for key, value in pairs(result) do
			if (value["Useable"] ~= 0) then
				new (CGangArea, value["ID"], value["Name"], fromJSON(value["ColShapes"]), value["FactionID"], value["LastAttacked"], value["Useable"], value["Income"])
			end
		end
		outputServerLog("Es wurden "..tostring(#result).." Ganggebiete gefunden!")
	else
		outputServerLog("Es wurden keine Ganggebiete gefunden!")
	end
	
	--Faction Peds
	
	local result = CDatabase:getInstance():query("SELECT * FROM faction_ped")
	local fails = 0
	if(#result > 0) then
		for key, value in pairs(result) do
			local pos = fromJSON(value["Position"])
			local x,y,z,rz = pos["X"], pos["Y"], pos["Z"], pos["RZ"]
			local skin = 60
			if (GangAreas[getZoneName(x,y,z)]) then
				skin = GangAreas[getZoneName(x,y,z)]:getFaction():getRankSkin(math.random(1,4))
			end
			local ped = createPed((skin or 60), x, y, z, rz, true)
			if (isElement(ped)) then
				enew(ped,CFactionPed, value["ID"], fromJSON(value["Items"]))
			else 
				fails = fails+1
			end
		end
		outputServerLog("Es wurden "..tostring(#result).." Faction Peds gefunden! Nicht gespawnt: "..fails)
	else
		outputServerLog("Es wurden keine Faction Peds gefunden!")
	end
	
	--CrashedHelis
	
	self.HeliSpawns = {}
	self.LastHeliSpawn = getTickCount()
	
	local result = CDatabase:getInstance():query("SELECT * FROM faction_crashedvehiclespawns")
	if(#result > 0) then
		for k, v in pairs(result) do
			table.insert(self.HeliSpawns, fromJSON(v["Position"]))
		end
		outputServerLog("Es wurden "..tostring(#result).." CrashedHeliSpawns gefunden!")
	else
		outputServerLog("Es wurden keine CrashedHeliSpawns gefunden!")
	end
	
	self.chooseTimer = setTimer(
		function() 
			if (getTickCount()-self.LastHeliSpawn > 4350000) then
				if (math.random(1,10) == 10) then
					self.LastHeliSpawn = getTickCount()
					local spawn = self.HeliSpawns[math.random(1, #self.HeliSpawns)]
					local heli = createVehicle(548 , spawn["X"], spawn["Y"], spawn["Z"], spawn["RX"], spawn["RY"], spawn["RZ"], "Staat")
					enew(heli, CCrashedHeli)
				end
			end
		end
	, 269481, 0)
	
	outputServerLog("cFactionManager completed! (" .. getTickCount() - start .. "ms)")
end

function CFactionManager:destructor()

end

addEvent("onPlayerFactionInventoryRequest", true);
addEventHandler("onPlayerFactionInventoryRequest", getRootElement(), function(iID)
	client:setLoading(false);
	local facID = client:getFaction():getID()

	if(getElementInterior(client) ~= 0) and (client.currentHouse) and (client.currentHouse:getFactionID() == facID) then
		if(iID == 1) then -- Lagern
			triggerClientEvent(client, "onClientInventoryRecieve", client, toJSON(client.Inventory));
			triggerClientEvent(client, "toggleInventoryGui", client, iID);
		elseif(iID == 2) then -- Storen
			if(client:getRank() < 4) then
				client:showInfoBox("error", "Du benoetist Rank 4 oder hoeher um Sachen zu entfernen.");
			end
			Factions[facID]:sendInventory(client)
			triggerClientEvent(client, "toggleInventoryGui", client, iID);
		end
	else
		client:showInfoBox("error", "Dies geht nur in einem Fraktionshaus!");
	end
end)

addEvent("onPlayerFactionDepositItem", true)
addEventHandler("onPlayerFactionDepositItem", getRootElement(), function(iID, am)
	client:setLoading(false);
	iID         = tonumber(iID)
	am          = tonumber(am)
	local facID = client:getFaction():getID()
	local item  = Items[iID]
	if(client:getInventory():hasItem(item, am)) then
		client:getInventory():removeItem(item, am);
		Factions[facID].Inventory:addItem(item, am, true);
		client:refreshInventory();
	else
		client:showInfoBox("error", "Soviel von dem Item besitzt du nicht!")
	end
end)

addEvent("onPlayerFactionWithdrawItem", true)
addEventHandler("onPlayerFactionWithdrawItem", getRootElement(), function(iID, am)
	client:setLoading(false);
	iID         = tonumber(iID)
	am          = tonumber(am)
	local facID = client:getFaction():getID()
	local item  = Items[iID]

	if(client:getRank() >= 4) then
		if(Factions[facID].Inventory:hasItem(item, am)) then
			if not(client:getInventory():hasItemFullStackWith(item, am)) then
				Factions[facID].Inventory:removeItem(item, am);
				client:getInventory():addItem(item, am);
				Factions[facID]:sendInventory(client)
			else
				client:showInfoBox("error", "Dafuer reicht dein Inventarplatz nicht!")
			end
		else
			client:showInfoBox("error", "Soviel von dem Item ist nicht mehr vorhanden!")
		end
	else
		client:showInfoBox("error", "Du benoetist Rank 4 oder hoeher um Sachen auszulagern.");
	end
end)