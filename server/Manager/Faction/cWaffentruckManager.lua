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
-- Date: 22.12.2014
-- Time: 20:45
-- Project: MTA iLife
--

cWaffentruckManager = inherit(cSingleton);

WaffentruckActive = false;
--[[

]]

-- ///////////////////////////////
-- ///// StartWaffentruck	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cWaffentruckManager:event_startWaffentruck(uPlayer, iAmmount, iStartpunkt)
	if(self.m_bWaffentruckRunning == false) then
		if(uPlayer:getFaction():getType() == 2) then

			local price = self.m_iKistenPreis*iAmmount;

			if(uPlayer:getMoney() >= price) then
				if(iAmmount <= self:getPlayerMaxKisten(uPlayer)) then
					if(iAmmount > 0) then
						uPlayer:addMoney(-price);

						local iFaction      = uPlayer:getFaction():getID();
						local iAM           = (iAmmount or 10);

						local pos           = self.m_Vec3DefaultWaffentruckPosition[iStartpunkt];
						local rot           = self.m_Vec3DefaultWaffentruckRotation[iStartpunkt];

						local wo	= {[1] = "Leuchtturm", [2] = "Gelaendeparkplatz"}

						self.m_uWaffentruck =
							cWaffentruckTruck:new(iFaction, pos:getX(), pos:getY(), pos:getZ(), rot:getX(), rot:getY(), rot:getZ(), iAmmount, self.m_iWareProKiste, uPlayer:getID(), self.m_iKistenPreis, iStartpunkt);

						self.m_resetTimer   = setTimer(self.m_funcResetWT, 1*60*60*1000, 1) -- 1 Stunden
						setTimer(function()
							uPlayer:setLoading(false);
							outputChatBox("Dealer: Der Waffentruck steht am "..wo[iStartpunkt].." fuer dich bereit!", uPlayer, 255, 255, 255);
							triggerClientEvent(uPlayer, "onWaffentruckGUIClose", uPlayer);
							uPlayer:showInfoBox("info", "Du kannst nun in den Waffentruck einsteigen! Er steht am "..wo[iStartpunkt]..".");

							self:sendMessage("Achtung: Ein Waffentruck wurde beladen.", 200, 0, 0);
						end, 1500, 1)

						self.m_bWaffentruckRunning = true;
						self.m_bWaffentruckEnabled = false;

						WaffentruckActive = true;
					else
						uPlayer:showInfoBox("error", "Du bist noch zu jung dafuer!");
					end
				else
					uPlayer:showInfoBox("error", "Das sind zuviele Kisten!");
				end
			else
				uPlayer:showInfoBox("error", "Das kannst du dir nicht leisten!\nDir fehlen $"..price-uPlayer:getMoney());
			end

		else
			uPlayer:showInfoBox("error", "Das darfst du nicht!");
		end
	else
		uPlayer:showInfoBox("error", "Es kann momentan kein Waffentruck gestartet werden!");
	end

end

-- ///////////////////////////////
-- ///// IsStartpunktValid	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cWaffentruckManager:isStartpunktValid(iStartpunkt, iStartpunktToCheck)
	local tbl_validStartpunkte	= self.m_tblAblieferPunkte[iStartpunkt][1];

	for index, id in pairs(tbl_validStartpunkte) do
		if(tonumber(id) == iStartpunktToCheck) then
			return true;
		end
	end
	return false;
end

-- ///////////////////////////////
-- ///// LiefereFinalWTAb	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cWaffentruckManager:LiefereFinalWTAb(uElement, iFaction)
	if((uElement) and (uElement.getType) and (uElement:getType() == "BasicVehicle") and (uElement:getData("wt:wt") == true)) and (getElementHealth(uElement) > 100) then
		-- Abgeben
			-- HIER KOENNTE EINE FRAKTIONSABFRAGE REIN: if(tonumber(uElement:getData("wt:faction")) == tonumber(tbl[1]) then
			local veh = uElement;

			local kisten                = WaffenTrucks[veh].m_iCounterCrates;
			local money                 = WaffenTrucks[veh].m_iWarenWert;

			local frakID				= iFaction;
			-- GELD
			--		Factions[tonumber(tbl[1])]:addDepotMoney(math.floor(money/2));
			WaffenTrucks[veh]:removeCrates(WaffenTrucks[veh].m_iMAX_KISTEN, true, true)

			-- Zufaellige Waffenteile
			for i2 = 1, kisten, 1 do
				-- Waffenteile --
				for i = 229, 240, 1 do
					if(math.random(0, 7) == 1) then
						Factions[frakID].Inventory:addItem(Items[i], 1, true)
					end
				end

				-- Munitionspakete --
				for i = 253, 258, 1 do
					if(math.random(0, 5) == 1) then
						Factions[frakID].Inventory:addItem(Items[i], 1, true)
					end
				end

				-- Waffenpakete --
				Factions[frakID].Inventory:addItem(Items[262], math.random(1, 4), true)

			end
			-- Donuts, immer lecker --
			Factions[frakID].Inventory:addItem(Items[4], math.random(1, 20), true)
		end
end

-- ///////////////////////////////
-- ///// generateVerteidigunsgcol
-- ///// Returns: void		//////
-- ///////////////////////////////

function cWaffentruckManager:GenerateVerteidigungsCol(uElement)
	local x, y, z = getElementPosition(uElement);

	self.m_tblVerteidigungsCol[uElement]		= createColSphere(x, y, z, 50);
	attachElements(self.m_tblVerteidigungsCol[uElement], uElement);

	setElementData(self.m_tblVerteidigungsCol[uElement], "startTick", getTickCount());
	setElementData(self.m_tblVerteidigungsCol[uElement], "endTick", getTickCount()+self.m_iVerteidigungsTime2);


	addEventHandler("onColShapeHit", self.m_tblVerteidigungsCol[uElement], function(uElement2)
		if(getElementType(uElement2) == "player") then

			triggerClientEvent(uElement2, "onWaffentruckAbladungShow", uElement2, self.m_tblVerteidigungsCol[uElement], getTickCount());
		end
	end)

	addEventHandler("onColShapeLeave", self.m_tblVerteidigungsCol[uElement], function(uElement2)
		if(getElementType(uElement2) == "player") then
			triggerClientEvent(uElement2, "onWaffentruckAbladungHide", uElement2, self.m_tblVerteidigungsCol[uElement], getTickCount());
		end
	end)

	addEventHandler("onElementDestroy", uElement, function() destroyElement(self.m_tblVerteidigungsCol[uElement]) end)

	for index, ele in pairs(getElementsWithinColShape(self.m_tblVerteidigungsCol[uElement])) do
		if(getElementType(ele) == "player") then
			triggerClientEvent(ele, "onWaffentruckAbladungShow", ele, self.m_tblVerteidigungsCol[uElement], getTickCount());
		end
	end
end


-- ///////////////////////////////
-- ///// GeneratePickups	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cWaffentruckManager:generatePickups()
	for index, tbl in pairs(self.m_tblAblieferPunkte) do
		self.m_uAblieferPunktePickups[index]    = createPickup(tbl[2]:getX(), tbl[2]:getY(), tbl[2]:getZ()-0.5, 3, 1239, 50);
		self.m_uAblieferPunkteColshapes[index]  = enew(createColSphere(tbl[2]:getX(), tbl[2]:getY(), tbl[2]:getZ(), 10), CColShape);

		tbl[2].z = tbl[2].z+0.2
		cInformationWindowManager:getInstance():addInfoWindow({tbl[2]:getX(), tbl[2]:getY(), tbl[2]:getZ()}, "Waffentruckabgabe", 30)

		addEventHandler("onColShapeHit", self.m_uAblieferPunkteColshapes[index], function(uElement)
			if((uElement) and (uElement:getType() == "BasicVehicle") and (uElement:getData("wt:wt") == true)) then
				-- Fraktionsabfrage, startpunkt
				local id_startpunkt			= tonumber(uElement:getData("wt:startpunkt"))

				if(self:isStartpunktValid(index, id_startpunkt)) then

					local uPlayer		= getVehicleOccupant(uElement);

					if(uPlayer) then

						local iFaction		= uPlayer:getFaction():getID();
						local iKisten		= (WaffenTrucks[uElement].m_iCurrentCrates) or 5;

						if(iFaction) and (iFaction ~= 0) then
							local time = self.m_iVerteidigungsTime*iKisten;
							self.m_iVerteidigungsTime2 = time;

							self.m_tblAblieferTimer[uElement]		= setTimer(function() self:LiefereFinalWTAb(uElement, iFaction) end, time, 1);

							local min	= math.floor(time/1000/60);

							outputChatBox("Verteidige den Waffentruck "..min.." Minuten lang!", uPlayer, 0, 200, 0);
							local x, y, z = getElementPosition(uPlayer)
							removePedFromVehicle(uPlayer);
							setElementPosition(uPlayer, x, y, z+3);
							setElementFrozen(uElement, true)
							setVehicleLocked(uElement, true);

							local x, y, z = getElementPosition(uElement);

							local zone	= getZoneName(x, y, z, false)..", "..getZoneName(x, y, z, true);

							local msg	= "Ein Waffentruck wird in "..zone.." abgeladen!";


							CFaction:sendTypeMessage(1, msg, 0, 200, 0);
							Factions[iFaction]:sendMessage(msg, 0, 200, 0);

							self:GenerateVerteidigungsCol(uElement)
						end
					end
				end
			end
		end)
	end
end

-- ///////////////////////////////
-- ///// getPlayerMaxKisten	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cWaffentruckManager:getPlayerMaxKisten(uPlayer)
	local tbl =
	{
		[0] = 0,
		[1] = 3,
		[2] = 7,
		[3] = 10,
		[4] = 13,
		[5] = 15,
	}
	local max_kisten = 0;

	if(tbl[uPlayer.Rank]) then
		max_kisten = tbl[uPlayer.Rank];
	end
	return max_kisten;
end

-- ///////////////////////////////
-- ///// GivePlayerInfos	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cWaffentruckManager:event_givePlayerInfos(uPlayer, iStartPos)
	uPlayer:setLoading(false);
	local max_kisten = self:getPlayerMaxKisten(uPlayer);
	if(uPlayer.getFaction and (uPlayer:getFaction():getType() == 2)) then
		if(max_kisten > 0) then
			return triggerClientEvent(uPlayer, "onClientWaffentruckGUIStart", uPlayer, self.m_bWaffentruckEnabled, max_kisten, self.m_iKistenPreis, self.m_iWareProKiste, iStartPos)
		else
			uPlayer:showInfoBox("info", "Sorry mein Junge, du darfst das noch nicht.");
		end
	else
		uPlayer:showInfoBox("info", "Dieser Dealer bedient nur echte Kameraden.");
	end
end

-- ///////////////////////////////
-- ///// SendMessage 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////
-- Informationsmessage an bestimmte Fraktionen!

function cWaffentruckManager:sendMessage(sMessage, r, g, b)
	local factions = {[1] = true, [2]= true, [3] = true, [4] = true, [5] = true};

	for id, _ in pairs(factions) do
		Factions[id]:sendMessage(sMessage, r, g, b);
	end
end

-- ///////////////////////////////
-- ///// ResetWaffentruck	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cWaffentruckManager:resetWaffentruck()
	self.m_bWaffentruckRunning                  = false;
	self.m_bWaffentruckEnabled                  = true;

	self.m_iKistenPreis                         = math.random(2000, 4000);

	if(self.m_uWaffentruck) then
		self.m_uWaffentruck:destructor();
	end

	outputDebugString("Der Waffentruck wurde resettet.");

	if(isTimer(self.m_resetTimer)) then
		killTimer(self.m_resetTimer)
	end

	WaffentruckActive = false;
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cWaffentruckManager:constructor(...)
	-- Klassenvariablen --
	self.m_Vec3DefaultWaffentruckPosition       =
	{
		Vector3(-2422.82421875, 2227.1789550781, 5.5202498435974), 	-- BAYSIDE
		Vector3(2571.328125, 2789.7939453125, 10.8203125),			-- LV
	}
	self.m_Vec3DefaultWaffentruckRotation       =
	{
		Vector3(359.67462158203, 0.00244140625, 254.39172363281-180),
		Vector3(0, 0, 0),											-- LV
	}

	self.m_bWaffentruckRunning                  = false;
	self.m_bWaffentruckEnabled                  = true;

	self.m_uWaffentruck                         = nil;
	self.m_uAblieferPunktePickups               = {};
	self.m_uAblieferPunkteColshapes             = {};

	self.m_iKistenPreis                         = math.random(2000, 4000);
	self.m_iWareProKiste                        = 30;


	self.m_tblAblieferTimer						= {}
	self.m_tblVerteidigungsCol					= {}
	self.m_iVerteidigungsTime					= 50*1000;

	--[[
	self.m_tblAblieferPunkte                    =
	{
		{5, Vector3(915.51037597656, -932.41009521484, 42.6015625)}, -- Vagos
		{3, Vector3(2488.8684082031, -1669.5073242188, 13.335947036743)}, -- Groove
		{4, Vector3(2309.0617675781, -1234.5295410156, 23.889991760254)}, -- Ballas
		{1, Vector3(1592.4652099609, -1690.2125244141, 5.890625)}, -- PD
	}]]

	self.m_tblAblieferPunkte					=
	{
		{{1, 2}, Vector3(-2070.8540039063, -2434.4729003906, 30.625)},				-- Angel Pine
		{{1, 2}, Vector3(2786.7412109375, -2456.3061523438, 13.633918762207)},		-- LS Docks, Hangar 2
		{{1, 2}, Vector3(2375.990234375, -647.98138427734, 127.41072845459)},		-- North Rock, Red Country (Bauer Jenkins, Schrotthof)
		{{1, 2}, Vector3(-75.206199645996, -1552.6455078125, 2.6107201576233)},		-- Flint Intersection, neben LS
		{{1}, Vector3(2566.6242675781, 2780.9008789063, 10.8203125)}, 				-- K.A.C.C. Mitiliary Fuels, Anlage in LV
		{{1}, Vector3(2867.0603027344, 941.66955566406, 10.75)},					-- Rockshore East, Las Venturas
		{{1, 2}, Vector3(29.103778839111, -2636.2907714844, 40.41471862793)},		-- Flint Country
		{{2}, Vector3(-2295.3864746094, 2281.9375, 4.984375)},						-- Bayside
	}

	-- Funktionen --
	self.m_funcStartWaffentruckFunc         = function(...) self:event_startWaffentruck(client, ...) end
	self.m_funcWaffentruckGUIfunc           = function(...) self:event_givePlayerInfos(client, ...) end
	self.m_funcResetWT                      = function(...) self:resetWaffentruck() end

	self:generatePickups();
	-- Events --

	addEvent("onWaffentruckStart", true);
	addEvent("onWaffentruckGUIStart", true)


	addEventHandler("onWaffentruckStart", getRootElement(), self.m_funcStartWaffentruckFunc);
	addEventHandler("onWaffentruckGUIStart", getRootElement(), self.m_funcWaffentruckGUIfunc);
end

-- EVENT HANDLER --
