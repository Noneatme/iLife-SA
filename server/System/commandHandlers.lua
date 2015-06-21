--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

-- Player

addCommandHandler("admins",
function(player)
	if (getElementData(player,"online")) then
		outputChatBox("Folgende Admins sind online:",player,107,119,255)
		for i,v in ipairs(getElementsByType("player")) do
			if(v.LoggedIn) then
				if (v:getAdminLevel() == 1) then
					outputChatBox(getPlayerName(v).." - Supporter",player,004,179,006)
				end
				if (v:getAdminLevel() == 2) then
					outputChatBox(getPlayerName(v).." - Moderator",player,242,184,024)
				end
				if (v:getAdminLevel() == 3) then
					outputChatBox(getPlayerName(v).." - Administrator",player,219,002,002)
				end
				if (v:getAdminLevel() == 4) then
					outputChatBox(getPlayerName(v).." - Projektleiter",player,143,7,7)
				end
				if (v:getAdminLevel() > 4) then
					outputChatBox(getPlayerName(v).." - Entwickler",player, 143, 143, 143)
				end
			end
		end
	end
end
)

addCommandHandler("rebind",
function(thePlayer, cmd)
	if(toggleCursor) and (thePlayer) then
		bindKey (thePlayer, "m", "down", toggleCursor, thePlayer)
	else
		if(thePlayer) then
			thePlayer:showInfoBox("error", "Bitte erneut versuchen!\nOder Admin anschreiben.");
		end
	end
end
)

addCommandHandler("hausdistanz", function(thePlayer, cmd, ID, iDis)
	if (thePlayer:getAdminLevel()>= 4) then
		if(tonumber(ID)) and (tonumber(iDis)) then
			ID = tonumber(ID);
			iDis = tonumber(iDis);
			if(Houses[ID]) then
				Houses[ID].iObjektDistanz = iDis;
				Houses[ID]:save();
				setElementData(Houses[ID].colShape, "h:iObjektDistanz", iDis);

				thePlayer:showInfoBox("info", "Distanz erfolgreich geaendert!");
			else
				thePlayer:showInfoBox("error", "Dieses Haus existiert nicht!");
			end
		else
			thePlayer:showInfoBox("error", "Benutzung: /hausdistanz <ID> <Neue Distanz>");
		end
	else
		thePlayer:showInfoBox("error", "Du bist kein Moderator!");
	end
end)

addCommandHandler("me", function(uPlayer, cmd, ...)
	uPlayer:meCMD(table.concat({...}, " "))
end)

addCommandHandler("pay",
function(uPlayer, cmd, sPlayer, iAmmount)
	if(sPlayer) and (getPlayerFromName(sPlayer)) then
		sPlayer = getPlayerFromName(sPlayer)
		iAmmount = tonumber(iAmmount)
		iAmmount = math.round(iAmmount)
		if((iAmmount) and (iAmmount > 0)) then
			local x,y,z = getElementPosition(uPlayer)
			local x1, y1, z1 = getElementPosition(sPlayer)
			if (getDistanceBetweenPoints3D(x,y,z, x1, y1, z1) < 30) then
				local uGeld = tonumber(uPlayer:getMoney())
				if(uGeld >= iAmmount) then
					uPlayer:addMoney(-iAmmount);
					sPlayer:addMoney(iAmmount);

					uPlayer:showInfoBox("sucess", "Du hast "..getPlayerName(sPlayer).." $"..iAmmount.." gegeben!")
					sPlayer:showInfoBox("sucess", "Du hast von "..getPlayerName(uPlayer).." $"..iAmmount.." bekommen!");

					outputServerLog(getPlayerName(uPlayer).." hat "..getPlayerName(sPlayer).. "$"..iAmmount.." gegeben!");
					logger:OutputPlayerLog(uPlayer, "Gab Geld an ", getPlayerName(sPlayer), "$"..iAmmount);
				else
					uPlayer:showInfoBox("error", "Soviel Geld hast du nicht!");
				end
			else
				uPlayer:showInfoBox("error", "Dieser Spieler ist zu weit entfernt!");
			end
		else
			uPlayer:showInfoBox("error", "Bitte gebe eine g\ueltige Geldanzahl ein!");
		end
	else
		uPlayer:showInfoBox("error", "Der Spieler existiert nicht!");
	end
end
)

-- Factions
addCommandHandler("invite",
function(thePlayer, cmd, name)
	if (getPlayerFromName(name)) then
		local secPlayer = getPlayerFromName(name)
		if (thePlayer:getRank() >= 4) then
			if (isElement(secPlayer) and secPlayer:getFaction() == Factions[0]) then
				secPlayer:setFaction(thePlayer:getFaction())
				secPlayer:setRank(1)
				thePlayer:showInfoBox("info","Du hast "..name.." in die Fraktion eingeladen!")
				secPlayer:showInfoBox("info","Du wurdest in die Fraktion "..thePlayer:getFaction():getName().." aufgenommen!")
				thePlayer:getFaction():addMember(secPlayer)

				logger:OutputPlayerLog(thePlayer, "Invitete User", getPlayerName(secPlayer), thePlayer:getFaction():getName());

			else
				thePlayer:showInfoBox("error","Dieser Spieler existiert nicht oder ist bereits in einer anderen Fraktion!")
			end
		else
			thePlayer:showInfoBox("error","DafÃ¼r fehlen dir die nÃ¶tigen Rechte!")
		end
	else
		thePlayer:showInfoBox("error","Dieser Spieler existiert nicht oder ist bereits in einer anderen Fraktion!")
	end
end
)

addCommandHandler("uninvite",
function(thePlayer, cmd, name)
	local secPlayer = getPlayerFromName(name)
	if (thePlayer:getRank() >= 4) then
		if (isElement(secPlayer)) then
			if (secPlayer:getFaction() == thePlayer:getFaction()) then
				local Faction = thePlayer:getFaction()
				thePlayer:showInfoBox("info","Du hast "..name.." aus der Fraktion geworfen!")
				secPlayer:showInfoBox("info","Du wurdest von "..thePlayer:getName().." aus der Fraktion geworfen!")
				thePlayer:getFaction():removeMember(secPlayer:getName())
				Faction:updateMembers()

				logger:OutputPlayerLog(thePlayer, "Uninvitete User", getPlayerName(secPlayer), thePlayer:getFaction():getName());
			else
				thePlayer:showInfoBox("error","Dieser Spieler ist nicht in deiner Fraktion!")
			end
		else
			local result = CDatabase:getInstance():query("SELECT Fraktion FROM userdata WHERE Name=?", name)
			if (result) and (#result >= 1) then
				if ( tonumber(result[1]["Fraktion"]) == tonumber(thePlayer:getFaction():getID())) then
					CDatabase:getInstance():exec("UPDATE userdata SET Fraktion =?, Rank=?, Skin=? WHERE Name =?", 0, 0, 137, name)
					local Faction = thePlayer:getFaction()
					Faction:updateMembers()
					thePlayer:showInfoBox("info", "Du hast "..name.." offline uninvited!")
				else
					thePlayer:showInfoBox("error","Dieser Spieler ist nicht in deiner Fraktion!")
				end
			else
				thePlayer:showInfoBox("error","Dieser Spieler existiert nicht!")
			end
		end
	else
		thePlayer:showInfoBox("error","Dafür fehlen dir die nötigen Rechte!")
	end
end
)

addCommandHandler("giverank",
function(thePlayer, cmd, name, rank)
	local secPlayer = getPlayerFromName(name)
	rank = math.round(rank)
	if (thePlayer:getRank() >= 4) and ( (tonumber(rank) < thePlayer:getRank()) or thePlayer:getRank() == 5 ) then
		if (isElement(secPlayer) and secPlayer:getFaction() == thePlayer:getFaction()) then
			if (tonumber(rank) >= 1 and tonumber(rank) <=5) then
				secPlayer:setRank(tonumber(rank))
				secPlayer:save()
				thePlayer:showInfoBox("info","Du hast "..name.." einen neuen Rank zugewiesen!")
				secPlayer:showInfoBox("info","Dir wurde der Fraktionsrang "..thePlayer:getFaction():getRankName(rank).." zugewiesen!")
				thePlayer:getFaction():updateMembers()

				logger:OutputPlayerLog(thePlayer, "Gab Rank", getPlayerName(secPlayer), thePlayer:getFaction():getName().." - "..rank);

			else
				thePlayer:showInfoBox("error","Dieser Rang existiert nicht!")
			end
		else
			thePlayer:showInfoBox("error","Dieser Spieler existiert nicht oder ist bereits in einer anderen Fraktion!")
		end
	else
		thePlayer:showInfoBox("error","Daf\uer fehlen dir die n\oetigen Rechte!")
	end
end)

addCommandHandler("dopayday", function(thePlayer)
	if (thePlayer:getAdminLevel()>= 3) and (DEFINE_DEBUG) then
		thePlayer:minuteTimer(true)
		outputChatBox("yes")
	end
end)



addCommandHandler("reloadmap", function(thePlayer, cmd, sMap)
	if (thePlayer:getAdminLevel()>= 3) then
		if(mapManager.tblServerMaps[sMap]) then

			elseif(mapManager.tblClientMaps[sMap]) then

		end
	end
end)

addCommandHandler("togglehouselock", function(thePlayer, cmd, iHouse)
    if (thePlayer:getAdminLevel()>= 3) then
        Houses[tonumber(iHouse)]:setLocked(not(Houses[tonumber(iHouse)]:isLocked()))
        thePlayer:showInfoBox("sucess", "All Roger Captain");
    end
end)

-- Vehicles
addCommandHandler("park",
function (thePlayer, cmd)
	if (isPedInVehicle(thePlayer)) then
		local theVehicle = thePlayer:getVehicle()
		if (theVehicle:getType() == "Faction") then
			if ( (theVehicle:getFaction() == thePlayer:getFaction()) and (thePlayer:getRank() >= 5) ) then
				local x,y,z = theVehicle:getPosition()
				local rx,ry,rz = theVehicle:getRotation()
				theVehicle:setKoords(x,y,z,rx,ry,rz)
				thePlayer:showInfoBox("info","Das Fraktionsauto wurde erfolgreich geparkt.")

				logger:OutputPlayerLog(thePlayer, "Parkte Fraktionsauto", getVehicleNameFromModel(getElementModel(theVehicle)), thePlayer:getFaction():getName());

			end
		end
		if (theVehicle:getType() == "User") then
			theVehicle:park(thePlayer)
		end
		if (theVehicle:getType() == "CorporationVehicle") then
			if(theVehicle.m_iCorpID == thePlayer:getCorporation():getID()) then
				if(thePlayer:hasCorpRole(5)) then
					theVehicle:park()
					thePlayer:showInfoBox("sucess", "Fahrzeug erfolgreich geparkt!")

					if(theVehicle:getTowedByVehicle()) then
						if(theVehicle:getTowedByVehicle().park) then
							theVehicle:getTowedByVehicle():park(thePlayer)
						end
					end
				end
			end

		end
	else
		thePlayer:showInfoBox("info","Daf\uer musst du in einem Fahrzeug sitzen!")
	end
end
)

addCommandHandler("respawn",
function(player, cmd, id)
	if(UserVehicles[tonumber(id)]) then
		UserVehicles[tonumber(id)]:respawn(player)
	else
		player:showInfoBox("error", "Es existiert kein Fahrzeug mit der ID!");
	end
end
)

addCommandHandler("towveh",
function(player, cmd, id)
	if(UserVehicles[tonumber(id)]) then
		UserVehicles[tonumber(id)]:respawn(player)
	else
		player:showInfoBox("error", "Es existiert kein Fahrzeug mit der ID!");
	end
end
)

addCommandHandler("eject", function(uPlayer, cmd, sPlayer)
	if(isPedInVehicle(uPlayer)) then
		local veh = getPedOccupiedVehicle(uPlayer)
		if(getVehicleOccupant(veh) == uPlayer) then
			if(getPlayerFromPartialName(sPlayer)) then
				sPlayer = getPlayerFromPartialName(sPlayer)
				if(getPedOccupiedVehicle(sPlayer)) and (getPedOccupiedVehicle(sPlayer) == veh) then
					sPlayer:removeFromVehicleOptic()
					uPlayer:showInfoBox("sucess", "Der Spieler wurde von diesem Fahrzeug entfernt!")

					sPlayer:showInfoBox("info", "Du wurdest aus dem Fahrzeug geworfen!");
					toggleAllControls(sPlayer, true)
				else
					uPlayer:showInfoBox("error", "Der Spieler sitzt nicht in deinem Fahrzeug!")
				end
			else
				uPlayer:showInfoBox("error", "Spieler nicht gefunden!");
			end
		else
			uPlayer:showInfoBox("error", "Du musst der Fahrer dieses Fahrzeugs sein!");
		end
	end
end)


-- Admins

addCommandHandler("i",
function(thePlayer, cmd, ...)
	if (thePlayer:getAdminLevel() > 0) then
		local parametersTable = {...}
		local stringWithAllParameters = table.concat( parametersTable, " " )
		if stringWithAllParameters == nil then
			thePlayer:showInfoBox("error", "Du kannst keinen leeren Text senden!")
		elseif stringWithAllParameters == "" or stringWithAllParameters == " " or stringWithAllParameters == "  " then
			thePlayer:showInfoBox("error", "Du kannst keinen leeren Text senden!")
		else
			for k,v in ipairs(getElementsByType("player")) do
				if (getElementData(v, "online")) then
					if (v) and ( v.Rank) and (v:getAdminLevel() > 0) then
						outputChatBox ( "[".._Gsettings.serverName.."] "..getPlayerName(thePlayer)..": "..stringWithAllParameters, v, 255, 209, 5 )
					end
				end
			end
		end
	end
end
)


addCommandHandler("o",
function(thePlayer, cmd, ...)
	if(thePlayer.LoggedIn) then
		if (getElementData(thePlayer,"online")) and (thePlayer:getAdminLevel() > 0) then
			local parametersTable = {...}
			local stringWithAllParameters = table.concat( parametersTable, " " )
			if stringWithAllParameters == nil then
				thePlayer:showInfoBox("error", "Du kannst keinen leeren Text senden!")
			elseif stringWithAllParameters == "" or stringWithAllParameters == " " or stringWithAllParameters == "  " then
				thePlayer:showInfoBox("error", "Du kannst keinen leeren Text senden!")
			else
				if (getElementData(thePlayer, "online")) then
					local tbl =
					{
						[1] = "[Supporter]",
						[2] = "[Moderator]",
						[3] = "[Admistrator]",
						[4] = "[Projektleiter]",
						[5] = "[Developer]",
						[6] = "[Developer]",
					}

					outputChatBox(tbl[tonumber(thePlayer:getAdminLevel())].." "..getPlayerName(thePlayer)..": "..stringWithAllParameters,getRootElement(),200,200,200)
				end
			end
		end
	end
end
)

addCommandHandler("gi2m",
function(thePlayer ,cmd, id, count, uPlayer)
	if(thePlayer.LoggedIn) then
		if (thePlayer:getAdminLevel() >= 3) then
			if(getPlayerFromName(uPlayer)) then
				uPlayer = getPlayerFromName(uPlayer)
			else
				uPlayer = thePlayer
			end
			uPlayer:getInventory():addItem(Items[tonumber(id)], tonumber(count))
			uPlayer:refreshInventory()
			outputChatBox("Du hast von "..thePlayer:getName().." Items erhalten! ("..id..", "..count..")", uPlayer, 0, 255, 0);
			outputChatBox("Du hast  "..uPlayer:getName().." Items gegeben! ("..id..", "..count..")", thePlayer, 0, 255, 0);
		end
	end
end
)

addCommandHandler("honor", function(thePlayer, cmd, name)
	if(thePlayer.LoggedIn) then
		if (thePlayer:getAdminLevel() >= 4) then
			if (getPlayerFromName(name)) then
				Achievements[41]:playerAchieved(getPlayerFromName(name))
				outputChatBox(getPlayerName(thePlayer).." hat dem Spieler "..name.." für besonderes Engagement die Medal of ".._Gsettings.serverName.." verliehen!", getRootElement(), 0,255,0)
			end
		end
	end
end
)

addCommandHandler("randweather", function(thePlayer, cmd, sCategory)
	if(thePlayer.LoggedIn) then
		if (thePlayer:getAdminLevel() >= 2) then
		local weather = sCategory and WeatherIDs:New():GetRandomWeatherIDFromCategory(sCategory) or WeatherIDs:New():GetRandomWeatherIDFromCategory("sunny") -- sonnig
			if(weather) then
				setWeather(weather);
			end
		end
	end
end)

addCommandHandler("givefeuerwerk", function(thePlayer)
	if(thePlayer.LoggedIn) then
		if (thePlayer:getAdminLevel() >= 2) then
			thePlayer:getInventory():addItem(Items[266], 10, true);
			thePlayer:getInventory():addItem(Items[267], 10, true);
			thePlayer:getInventory():addItem(Items[268], 10, true);
			thePlayer:getInventory():addItem(Items[269], 10, true);
			thePlayer:getInventory():addItem(Items[270], 10, true);
			thePlayer:getInventory():addItem(Items[271], 10, true);
			thePlayer:getInventory():addItem(Items[272], 10, true);
		end
	end
end)

addCommandHandler("showcheck",
	function(thePlayer, cmd)
		if getElementData(thePlayer,"online") and (thePlayer:getAdminLevel() > 0)  then
			triggerClientEvent(thePlayer,"showCheckGui",getRootElement())
		end
	end
)

-- Stealth Kill --
addEventHandler("onPlayerStealthKill", getRootElement(), function() cancelEvent(true) end)
-- Weapon Stats --
addEventHandler("onPlayerJoin", getRootElement(),
	function()
		for i = 69, 79, 1 do
			setPedStat(source, i, 999)
		end
		setPedStat(source, 75, 50)
		setPedStat(source, 73, 50)
	end
)

addCommandHandler("stats",
	function(pl, cmd)
		for i = 69, 79, 1 do
			setPedStat(pl, i, 999)
		end
		setPedStat(pl, 75, 50)
		setPedStat(pl, 73, 50)
		pl:showInfoBox("info", "Waffenskills erneuert!")
	end
)

function saveaplayer(player)
	player:save()
end
addCommandHandler("savep", saveaplayer)


function saveaplayer(player)
	player:save()
end

local restartTimer = {}

addCommandHandler("restartilife", function(thePlayer, cmd, iTime, ...)
	if(getElementData(thePlayer,"online")) and (thePlayer:getAdminLevel() >= 3) then
		local reason = table.concat({...}, " ");
		local function outputTime(sString)
			if(string.len(reason) > 1) then
				sString = sString.." ["..reason.."]";
			end
			outputChatBox(sString, root, 255, 0, 0);
		end

		if not(tonumber(iTime)) then
			restartTheGamemode()
		else
			if(isTimer(restartTimer.gTimer)) then
				killTimer(restartTimer.gTimer);

				for index, timer in pairs(restartTimer.blaTimer) do
					if(isTimer(timer)) then
						killTimer(timer);
					end
				end
			end
			restartTimer.blaTimer = {}
			local curTime = tonumber(iTime);
			outputTime("[!!] Gamemode wird in "..curTime.." Minuten neu gestartet!")
			restartTimer.gTimer	= setTimer(function()
				curTime = curTime-1;
				if(curTime > 0) and (curTime <= 5) then
					outputTime("[!!] Gamemode wird in "..curTime.." Minuten neu gestartet!");
				else
					if(curTime < 1) then
						restartTheGamemode()
						return
					end
					for i = 1, 5, 1 do
						if(curTime == i*10) then
							outputTime("[!!] Gamemode wird in "..(curTime*10).." Minuten neu gestartet!");
						end
					end
					if(curTime == 60) then
						outputTime("[!!] Gamemode wird in 1 Stunde neu gestartet!");
					elseif(curTime == 120) then
						outputTime("[!!] Gamemode wird in 2 Stunden neu gestartet!");
					elseif(curTime == 300) then
						outputTime("[!!] Gamemode wird in 5 Stunden neu gestartet!");
					end
				end
				if(curTime == 1) then
					restartTimer.blaTimer[1] = setTimer(outputTime, 30000, 1, "[!!] Gamemode wird in 30 Sekunden neu gestartet!")
					restartTimer.blaTimer[2] = setTimer(outputTime, 55000, 1, "[!!] Gamemode wird in 5 Sekunden neu gestartet!")
				end
			end, 60000, -1);
			if(curTime == 1) then
				restartTimer.blaTimer[3] = setTimer(outputTime, 30000, 1, "[!!] Gamemode wird in 30 Sekunden neu gestartet!")
				restartTimer.blaTimer[4] = setTimer(outputTime, 55000, 1, "[!!] Gamemode wird in 5 Sekunden neu gestartet!")
			end
 		end
	end
end)

addCommandHandler("getlastchangedate", function(thePlayer, cmd, nick)
	if(getElementData(thePlayer,"online")) and (thePlayer:getAdminLevel() >= 1) then
		local query = CDatabase:getInstance():query("SELECT * FROM user WHERE Name = '"..nick.."';");
		if(query) then
			local res = query[1];

			if(res) then
				local last_login    = res["Last_Login"]
				local time = getRealTime(last_login)

				outputChatBox("User war zuletzt Online am "..(time.monthday).."."..(time.month+1).."."..(time.year+1900).." "..(time.hour)..":"..(time.minute)..":"..(time.second), thePlayer, 150, 150, 150);
				return;
			end
		end

		outputChatBox("User nicht gefunden.", thePlayer, 255, 0, 0)
	end
end)


addCommandHandler("int", function (thePlayer, cmd, int)
	if (getElementData(thePlayer,"online")) and (thePlayer:getAdminLevel() > 2) then
		if (tonumber(int) == 0) then
			thePlayer:setPosition(pos[thePlayer:getName()]["X"],pos[thePlayer:getName()]["Y"], pos[thePlayer:getName()]["Z"])
			thePlayer:setInterior(0)
			thePlayer:setDimension(0)
		else
			if (thePlayer:getDimension() ~= 0) then

			else
				x,y,z = thePlayer:getPosition()
				pos[thePlayer:getName()]={}
				pos[thePlayer:getName()]["X"] = x
				pos[thePlayer:getName()]["Y"] = y
				pos[thePlayer:getName()]["Z"] = z
			end

			thePlayer:setFrozen(true)
			result = CDatabase:getInstance():query("SELECT * FROM House_Interiors WHERE ID="..tonumber(int))

			local int = result[1]["Int"]
			local x = result[1]["X"]
			local y = result[1]["Y"]
			local z = result[1]["Z"]

			outputConsole(tostring(result[1]["Int"]).." | "..tostring(result[1]["X"]).." | "..tostring(result[1]["Y"]).." | "..tostring(result[1]["Z"]))

			thePlayer:setInterior(int)
			thePlayer:setPosition(x,y,z)
			thePlayer:setDimension(1)
			thePlayer:setFrozen(false)
		end
	end
end
)

addCommandHandler("houseremove", function(thePlayer, cmd, ID)
	if (getElementData(thePlayer,"online")) and (thePlayer:getAdminLevel() >= 3) then
		CDatabase:getInstance():query("DELETE FROM Houses WHERE ID=?", tonumber(ID))
		if (Houses[tonumber(ID)]) then
			destroyElement(HousePickups[tonumber(ID)]);
		end
	end
end
)

addCommandHandler("houseadd", function(thePlayer, cmd, int, cost, iDistance)
	if (getElementData(thePlayer,"online")) and (thePlayer:getAdminLevel() >= 3) then
		local X,Y,Z = thePlayer:getPosition()

		local kats	=
		{
			["middle"]	= {9, 3, 5, 6},
			["bad"]		= {7, 16, 17, 18, 19},
			["motel"]	= {8, 1, 2, 4, 8},
			["good"]	= {10, 13, 15, 33, 34, 35, 37, 38},
			["rich"]	= {11, 12, 14, 36},
		}

		if not(tonumber(int)) then
			if(kats[int]) then
				int = tonumber(kats[int][math.random(1, #kats[int])]);
			else
				for index, tbl in pairs(kats) do
					local string = ""
					for i, _ in pairs(tbl) do
						string = i..", "..string
					end

					outputConsole(index..", "..string, thePlayer)
				end
				return;
			end
		end
		int				= tonumber(int) or 1;
		iDistance		= tonumber(iDistance) or 5;
		cost			= tonumber(cost) or math.random(0, 1000);

		CDatabase:getInstance():query("INSERT INTO Houses (`ID` , `Cost` , `Owner` , `Koords` , `Locked` , `Interior` ) VALUES ( NULL , ?,  '0', ?,  '0', ?);", tonumber(cost), tostring(thePlayer:getInterior()).."|"..tostring(thePlayer:getDimension()).."|"..tostring(X).."|"..tostring(Y).."|"..tostring(Z),tonumber(int))

		local result2 	= CDatabase:getInstance():query("SELECT * FROM House_Interiors WHERE ID = ?", tonumber(int))

		local result3	= CDatabase:getInstance():query("SELECT LAST_INSERT_ID() AS ID FROM Houses;");

		CHouseManager:getInstance():createHouse(tonumber(result3[1]["ID"]), result2[1]["Price"], (tonumber(cost) or 0), 0, "0|0|"..X.."|"..Y.."|"..Z, 0, {result2[1]["X"], result2[1]["Y"], result2[1]["Z"], result2[1]["Int"]}, iDistance, 0, {});

	end
end)

addCommandHandler("geige",
	function(pl, cmd)
		Achievements[43]:playerAchieved(pl)
		local x,y,z = getElementPosition(pl)
		createMessageSphere(x, y, z, 5, getPlayerName(pl).." musiziert auf der kleinsten Geige der Welt.")
	end
)

addCommandHandler("executePlayerFunction",
	function(pl, cmd, name, fname, ...)
		if(pl.LoggedIn) then
			if (pl:getAdminLevel() >= 4) then
				CPlayer[fname](getPlayerFromName(name), ...)
				outputChatBox("#executed", pl)
			end
		end
	end
)

addCommandHandler("changehouseinterior", function(uPlayer, cmd, iHouse, iInt)
	if(uPlayer:getAdminLevel() >= 3) then
		iHouse 	= tonumber(iHouse);
		iInt	= tonumber(iInt);

		local result = CDatabase:getInstance():query("SELECT X, Y, Z, Int, Rotation FROM House_Interiors WHERE ID = '"..iInt.."';");
		if(#result > 0) then
			Houses[iHouse].Interior		= {result[1]["X"], result[1]["Y"], result[1]["Z"], result[1]["Int"]};
			Houses[iHouse]:updateInterior();

			CDatabase:getInstance():query("UPDATE Houses SET Interior = '"..iInt.."' WHERE ID = '"..iHouse.."';");

			outputChatBox("Haus Interior geaendert!", uPlayer, 0, 255, 0);

		end

	end
end)


addCommandHandler("setpos", function(uPlayer, cmd, iX, iY, iZ, iInt)
	if(uPlayer:getAdminLevel() > 1) then
		local player = uPlayer
		if(player:getOccupiedVehicle()) then
			player = player:getOccupiedVehicle()
		end
		player:setPosition(tonumber(iX), tonumber(iY), tonumber(iZ));
		player:setInterior(iInt);
	end
end)


addCommandHandler("setfaction", function(uPlayer, cmd, iFaction, uPlayer2)
	if(uPlayer:getAdminLevel() >= 3) then
		if(getPlayerFromName(uPlayer2)) then
			uPlayer2 = getPlayerFromName(uPlayer2)
		else
			uPlayer2 = uPlayer;
		end

		uPlayer2:setFaction(Factions[tonumber(iFaction)]);
		outputChatBox("Deine Fraktion wurde geaendert! Eventuell ist ein Reconnect noetig.", uPlayer2, 0, 255, 0);
		outputChatBox("Fraktion des Spielers wurde geaendert!", uPlayer, 0, 255, 0);
	end
end)


addCommandHandler("setrank", function(uPlayer, cmd, iFaction, uPlayer2)
	if(uPlayer:getAdminLevel() >= 3) then
		if(getPlayerFromName(uPlayer2)) then
			uPlayer2 = getPlayerFromName(uPlayer2)
		else
			uPlayer2 = uPlayer;
		end

		uPlayer2:setRank(tonumber(iFaction));
		outputChatBox("Dein Rank wurde geaendert! ("..iFaction..")", uPlayer2, 0, 255, 0);
	end
end)

addCommandHandler("respawnfactionvehicles", function(uPlayer, cmd, iFaction)
	if(uPlayer:getAdminLevel() >= 2) then
		Factions[tonumber(iFaction)]:respawnVehicles()
		outputChatBox("Fraktionsfahrzeuge respawnt!", uPlayer, 0, 255, 0);
	end
end)

addCommandHandler("eventmodus", function(uPlayer)
	if(uPlayer:getAdminLevel() >= 3) then
		DEFINE_EVENT_MODUS = not(DEFINE_EVENT_MODUS);

		if(DEFINE_EVENT_MODUS) then
			outputChatBox("Event Modus wurde angeschaltet!", uPlayer, 0, 255, 0);
		else
			outputChatBox("Event Modus wurde ausgeschaltet!", uPlayer, 0, 255, 0);
		end
	end
end)

addCommandHandler("adminbefehle", function(uPlayer, cmd)
	if(uPlayer:getAdminLevel() > 2) then
		local befehle =
		{
			"/getlastchangedate <Name>",
			"/houseremove <ID>",
			"/houseadd <intID> <Extrakosten> <Hausdistanz>",
			"/givefeuerwerk",
			"/changehouseinterior <ID> <IntID>",
			"/eventmodus <(No Highping Kick und sowas)>",
			"/setfaction <iFaction> <uPlayer>",
			"/randweather <clear|sunny|cloudy|rainyfoggy|>",
			"/gi2m <Item> <Anzahl> <Spieler>",
			"/o <Text>, /i <Text>",
			"/restartilife <SAVE_RESTART_ILIFE_GAMEMODE>",
			"/hausdistanz <ID>, <Distanz>",
			"/showcheck /honor",
			"/reloadmap <sMap>",
			"/stats",
			"/kickall <Serverpasswort>",
			"/setpos <x> <y> <z> <interior>",
			"/respawnfaggios",
			"/setheadobject <ID> <Spieler2>",
			"/serverooc [Aktiviert/Deaktiviert OOC Chat]",
			"/airbreak",
			"/setrank <Rank> <Spielername>",
			"/respawnfactionvehicles <iFaction>",
			"/restartilife <Minuten> <Grund>",
      "/togglehouselock <iHouse>",
			"/clearchat",
			"/lockbiz <ID>",
			"/setbizowner <ID> <iCorp>",
			"/gotobiz <ID>",
			"/gotohouse <ID>",
			"/respawnartifacts [<Amount> or 50]",
			"/sethouseowner <HouseID> <OwnerID>",
			"/addhouseprice <HouseID> <Price>",
			"/removehouseprice <HouseID> <Price>",

		}

		outputConsole(" - - - - - - - - - - - - - ", uPlayer);
		for index, bef in ipairs(befehle) do
			outputConsole(bef, uPlayer);
		end
		outputConsole(" - - - - - - - - - - - - - ", uPlayer);
		outputConsole(" ", uPlayer)
		outputConsole("Head Objects: 1221 - Cardbox, 1425 - Detour Schild, Huetchen - 1238", uPlayer)
		outputConsole("Schrank - 2161, PC - 2190, Stuhl - 1715, Kasse - 2369, Mikrowelle - 2149", uPlayer)
		outputConsole("Fernseher - 2320, Toilette - 2525, Papierkorb - 1359, Nebelmaschine - 2780", uPlayer)
		outputConsole("Feuerloescher - 2690, Rote Lampe - 1213, Ampel - 1262", uPlayer)
	end
end)

local meFunc	= function(uPlayer, cmd, ...)
	local msg 		= string.gsub(table.concat({...}, " "), "#%x%x%x%x%x%x", "");

	local x, y, z	= uPlayer:getPosition();

	local col		= createColSphere(x, y, z, 35);

	for k,v in ipairs(getElementsWithinColShape(col, "player")) do
		if ((getElementDimension(v) == getElementDimension(uPlayer)) and (getElementInterior(v) == getElementInterior(uPlayer))) then
			outputChatBox ("* "..getPlayerName(uPlayer).." "..msg, v, 100, 0, 255, false);
		end
	end
	logger:OutputPlayerLog(uPlayer, "Schrieb Aktionsnachricht(me)", msg);

	destroyElement(col)
end

addCommandHandler("me", meFunc);
addCommandHandler("meCMD", meFunc);

addCommandHandler("s", function(uPlayer, cmd, ...)
	if({...}) then
		local msg 		= string.gsub(table.concat({...}, " "), "#%x%x%x%x%x%x", "");

		local x, y, z	= uPlayer:getPosition();

		local dista		= 50;
		local col		= createColSphere(x, y, z, dista);
		for k,v in ipairs(getElementsWithinColShape(col, "player")) do
			if ((getElementDimension(v) == getElementDimension(uPlayer)) and (getElementInterior(v) == getElementInterior(uPlayer))) then

				--[[
				-- SAMP ist doch zu was nutze!
				#define COLOR_GRAD1 0xB4B5B7FF
				#define COLOR_GRAD2 0xBFC0C2FF
				#define COLOR_GRAD3 0xCBCCCEFF
				#define COLOR_GRAD4 0xD8D8D8FF
				#define COLOR_GRAD5 0xE3E3E3FF
				#define COLOR_GRAD6 0xF0F0F0FF
				--]]

				local color		= "#B4B5B7FF";
				local vec		= Vector3(getElementPosition(v));
				local dist		= getDistanceBetweenPoints3D(Vector3(x, y, z), vec);
				local val		= dista / 4;


				local outputDone	= false;
				local function output(sColor)
					if not(outputDone) then
						outputChatBox(sColor..getPlayerName(uPlayer).." schreit: "..msg.."!!!", v, 255, 255, 255, true);
						outputDone = true;
					end
				end
				if(dist < dista-val*1) then
					output "#FFFFFF";
				end
				if(dist < dista-val*2) then
					output "#B4B5B7";
				end
				if(dist < dista-val*3) then
					output "#BFC0C2";
				end
				if(dist < dista-val*4) then
					output "#CBCCCE";
				end
				if(dist < dista-val*5) then
					output "#D8D8D8"
				end

			end
		end
		destroyElement(col);
		logger:OutputPlayerLog(uPlayer, "Schrieb Chatnachricht(Schrie)", msg);

	end
end)

addCommandHandler("t", function(uPlayer, cmd, ...)
	local msg = table.concat({...}, " ");
	if(msg) and (string.len(msg) > 0) then
		if(uPlayer:getFaction():getID() ~= 0) then
			local factionType 	= uPlayer:getFaction():getType()
			local factionID 	= uPlayer:getFaction():getID()
			local rankName		= uPlayer:getFaction():getRankName(uPlayer.Rank);
			if(factionType == 1) then
				CFaction:sendTypeMessage(1, "["..rankName.."] "..uPlayer:getName()..": "..msg, 156, 0, 0)
				logger:OutputPlayerLog(uPlayer, "Schrieb Departmentmessage", msg);
			else
				uPlayer:showInfoBox("error", "Du bist kein Beamter!")
			end
		else
			local corp			= uPlayer:getCorporation();

			if(corp ~= 0) then
				local connections		= corp:getConnections();

				for k, v in pairs(connections) do
					if(v[1]) and (v[1].sendFactionMessage) then
						v[1]:sendFactionMessage("["..corp.m_sShortName.."]["..uPlayer:getName()..": "..msg.."]", getColorFromString(corp.m_sColor))
					end
				end

				logger:OutputPlayerLog(uPlayer, "Schrieb Departmentmessage", msg);
			else
				uPlayer:showInfoBox("error", "Du bist kein Corporationsmitglied!")
			end
		end
	else
		uPlayer:showInfoBox("error", "Du musst einen Inhalt angeben!")
	end
end)

addCommandHandler("kickall", function(uPlayer, cmd, sPassword)
	if(uPlayer:getAdminLevel() >= 4) then
		for index, player in pairs(getElementsByType("player")) do
			if(player.save) then
				player:save();
			end
			if(player ~= uPlayer) then
				kickPlayer(player, "Update, Bitte Warten!");
			end
		end

		if(sPassword) then
			setServerPassword(sPassword);
			outputChatBox("Server Password: "..sPassword, uPlayer);
		end
	end
end)

addCommandHandler("clearchat", function(uPlayer, cmd)
	if(uPlayer:getAdminLevel() >= 2) then
		for i = 1, 10, 1 do
			outputChatBox(" ", root);
		end
	end
end)

addCommandHandler("getmysqlresultasjson", function(uPlayer, cmd, ...)
	if(uPlayer:getAdminLevel() >= 4) then
		local result = CDatabase:getInstance():query(table.concat({...}, " "));
		local s = toJSON(result)
		local s2 = fromJSON(s);
		outputChatBox(tostring(s2), uPlayer)
		triggerClientEvent(uPlayer, "onJSONResultGet", uPlayer, result)
	end
end)


addCommandHandler("respawnfaggios", function(uPlayer, cmd)
	if(uPlayer:getAdminLevel() >= 1) then
		for index, veh in pairs(Noobcars) do
			if not(veh:getOccupant()) then
				veh:respawn();
			end
		end
		uPlayer:showInfoBox("info", "Faggios wurden respawnt!");
	end
end)

addCommandHandler("setheadobject", function(uPlayer, cmd, iModell, uPlayer2, ...)
	if(uPlayer:getAdminLevel() >= 1) then
		if(getPlayerFromName(uPlayer2)) then
			getPlayerFromName(uPlayer2):setHeadObject(tonumber(iModell))
		else
			uPlayer:setHeadObject(tonumber(iModell), ...)
		end
	end
end)

addCommandHandler("airbreak", function(uPlayer, cmd, ...)
	if(uPlayer:getAdminLevel() >= 2) then
		triggerClientEvent(uPlayer, "onAirbreakToggle", uPlayer)
	end
end)

addCommandHandler("lockbiz", function(uPlayer, cmd, iBiz)
	if(uPlayer:getAdminLevel() >= 3) then
		iBiz = tonumber(iBiz)

		local locked = cBusinessManager:getInstance().m_uBusiness[iBiz].m_iLocked;

		if(locked == 1) then
			locked = 0
		else
			locked = 1
		end

		cBusinessManager:getInstance().m_uBusiness[iBiz].m_iLocked = locked
		cBusinessManager:getInstance().m_uBusiness[iBiz]:setSetting("locked", locked, true)
		uPlayer:showInfoBox("sucess", "Erfolg")
	end
end)

addCommandHandler("addhouseprice", function(uPlayer, cmd, iBiz, iOwner)
	if(uPlayer:getAdminLevel() >= 3) then
		iBiz 		= tonumber(iBiz)
		iOwner 		= tonumber(iOwner)

		local biz = Houses[iBiz]
		biz.XtraCost	= biz.XtraCost+tonumber(iOwner) or 0;
		biz:save();
		uPlayer:showInfoBox("sucess", "Erfolg")
	end
end)

addCommandHandler("removehouseprice", function(uPlayer, cmd, iBiz, iOwner)
	if(uPlayer:getAdminLevel() >= 3) then
		iBiz 		= tonumber(iBiz)
		iOwner 		= tonumber(iOwner)

		local biz = Houses[iBiz]
		biz.XtraCost	= biz.XtraCost-tonumber(iOwner) or 0;
		biz:save();
		uPlayer:showInfoBox("sucess", "Erfolg")
	end
end)

addCommandHandler("sethouseowner", function(uPlayer, cmd, iBiz, iOwner)
	if(uPlayer:getAdminLevel() >= 3) then
		iBiz 		= tonumber(iBiz)
		iOwner 		= tonumber(iOwner)

		local biz = Houses[iBiz]
		biz:setOwnerID(iOwner)
		uPlayer:showInfoBox("sucess", "Erfolg")
	end
end)


addCommandHandler("setbizowner", function(uPlayer, cmd, iBiz, iOwner)
	if(uPlayer:getAdminLevel() >= 3) then
		iBiz 		= tonumber(iBiz)
		iOwner 		= tonumber(iOwner)

		local biz = cBusinessManager:getInstance().m_uBusiness[iBiz]
		local corp = Corporations[iOwner];

		biz:setOwner(iOwner)
		biz:setLagereinheiten(0)
		biz:save()
		corp:updateBizes()
		uPlayer:showInfoBox("sucess", "Erfolg")
	end
end)

addCommandHandler("gotobiz", function(uPlayer, cmd, iBiz)
	if(uPlayer:getAdminLevel() >= 3) then
		iBiz 		= tonumber(iBiz)

		local biz = cBusinessManager:getInstance().m_uBusiness[iBiz]

		uPlayer:setPosition(biz.m_iPosX, biz.m_iPosY, biz.m_iPosZ)
	end
end)

addCommandHandler("gotohouse", function(uPlayer, cmd, iBiz)
	if(uPlayer:getAdminLevel() >= 3) then
		iBiz 		= tonumber(iBiz)

		local biz 	= Houses[iBiz]

		if(biz) then
			uPlayer:setPosition(biz.m_iX, biz.m_iY, biz.m_iZ)
		else
			uPlayer:showInfoBox("error", "Haus nicht gefunden.")
		end
	end
end)

addCommandHandler("lol", function(uPlayer)
	outputChatBox(uPlayer:getIP()..";"..uPlayer:getName()..";12345;dbs_rl", uPlayer)
end)

addCommandHandler("respawnartifacts", function(uPlayer, cmd, iAmount)
	if(uPlayer:getAdminLevel() >= 3) then
		cArtifactManager:getInstance():generateNewArtifacts(iAmount)

		uPlayer:showInfoBox("sucess", "Artefakte neu erstellt! ("..iAmount or "-"..")")
	end
end)


local alphaVehicles = {[564] = true, [501] = true, [465] = true, [464] = true, [441] = true, [594] = true}
addEventHandler("onVehicleEnter", getRootElement(), function(uPlayer)
	if(getElementModel(source)) then
		if(alphaVehicles[getElementModel(source)]) then
			setElementAlpha(uPlayer, 0)
		end
	end
end)

addEventHandler("onVehicleExit", getRootElement(), function(uPlayer)
	if(getElementModel(source)) then
		if(alphaVehicles[getElementModel(source)]) then
			setElementAlpha(uPlayer, 255)
		end
	end
end)


-- AC INFO --
addEventHandler("onPlayerModInfo", getRootElement(), function(sFilename, itemlist, itemlist2)
	local kick 			= false;
    local uPlayer       = source;
	for index, bla in pairs(itemlist) do
		local name 			= bla["name"];
		local sizea 		= bla["sizeY"];
		local sizeb			= bla["originalSizeY"];

		if(name) then
			if(string.find(name, ".col")) then
				kick 			= true;
				outputConsole("Unerlaubter Kollisionsmod! "..name, source);
			end
			if(string.find(name, "grassplant")) then
				kick 			= true;
				outputConsole("Drogenpflanzen modden ist Assozial! "..name, source);
			end
		end
		if(sizea) and (sizeb) and (bla["id"]) and (tonumber(bla["id"] >= 0)) and (tonumber(bla["id"]) < 350) then
			local dingens 		= sizeb-sizea;

			if(dingens > 0.3) then
				local string = "Invalid Skin!(["..sFilename.."], ID: "..bla["id"]..", Size: "..sizea.."m, At least: "..sizeb.."m)";
				outputConsole(string, uPlayer);
				kick 			= true;
			end
		end

	end
	if(kick) then
		outputDebugString("Spieler "..getPlayerName(source).." wurde wegen unerlaubten Skinmods gekickt.");
		kickPlayer(source, "Invalid Skinmods! Please press F8");
	end
end)
