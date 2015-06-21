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
-- ## Name: NewsFaction.lua				##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

NewsFaction = {};
NewsFaction.__index = NewsFaction;

addEvent("onNewsfactionZeitungSchreib", true);

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function NewsFaction:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end



-- ///////////////////////////////
-- ///// DoNews		 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function NewsFaction:DoNews(uPlayer, sNews)
	if(isPedInVehicle(uPlayer) and (uPlayer:getVehicle().Faction) and (uPlayer:getVehicle().Faction:getID() == 6)) then
		if(uPlayer:getFaction():getID() == 6) then
			if(uPlayer:getRank() >= self.rankPermissions.NewsFunc) then
				if(#sNews > 1) and (#sNews <= 256) then
					-- Output News --
					if not(isTimer(self.newNewsTimer)) then
						local sText		= uPlayer:getFaction():getRankName(tonumber(uPlayer:getRank())).." ";
						sText			= sText..getPlayerName(uPlayer);
						sText			= sText..": "..sNews;
						if not(self.lastNewsText[uPlayer] == sText) then
							outputChatBox(sText, getRootElement(), 64, 70, 255);

							self.lastNewsText[uPlayer] = sText;

							uPlayer:addMoney((math.floor(#sNews/2.0) or 0))
							Factions[6]:addDepotMoney(math.floor(#sNews*3))
							logger:OutputPlayerLog(uPlayer, "Schrieb News", sNews, tostring(math.floor(#sNews/2.0)).."/"..tostring(math.floor(#sNews*3)));
							self.newNewsTimer = setTimer(function() end, self.newNewsSeconds, 1);
						else
							uPlayer:showInfoBox("error", "Deine Nachricht ist identisch zu deiner vorherigen!");
						end
					else
						uPlayer:showInfoBox("error", "Es kann immer nur "..(self.newNewsSeconds/1000).." Sekunden eine Nachricht geschrieben werden!");
					end
				else
					uPlayer:showInfoBox("error", "Benutzung: /news <Text>\nOder: /bind <Taste> chatbox news");
				end
			else
				uPlayer:showInfoBox("error", "Dafuer benoetigst du mindestens Rank "..self.rankPermissions.NewsFunc.."!");
			end
		else
			uPlayer:showInfoBox("error", "Du weisst nicht wie das geht!");
		end
	else
		uPlayer:showInfoBox("error", "Dafuer musst du in einem News-Fahrzeug sitzen!");
	end
end

-- ///////////////////////////////
-- ///// StopLive			//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function NewsFaction:StopLive(uMaster, uTarget)
	if(self.liveWith[uMaster]) and (self.liveWith[uMaster][uTarget] == true) then
		self.liveWith[uMaster][uTarget] = false;
		self.isLive[uTarget] = false;

		uTarget:showInfoBox("info", "Du wurdest von Reporter "..getPlayerName(uMaster).." vom Interview entfernt!");

		local count	= 0;
		for user, bool in pairs(self.liveWith[uMaster]) do
			if(bool == true) then
				count = count+1;
			end
		end
		if(count <= 0) then
			self:StopLive(uMaster, uMaster);
		else
			uMaster:showInfoBox("info", "Du bist mit "..count.." Personen weiter im Gespraech.");
		end
	elseif(uMaster == uTarget) then
		self.isLive[uMaster] = false;
		self.liveWith[uMaster] = {};
		uMaster:showInfoBox("info", "Das Gespraech wurde beendet.");
	end
end

-- ///////////////////////////////
-- ///// StopLiveCMD	 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function NewsFaction:StopLiveCMD(uMaster, sTarget)
	if(uMaster:getFaction():getID() == 6) then
		if(uMaster:getRank() >= self.rankPermissions.LiveFunc) then

			if(sTarget) and (getPlayerFromName(sTarget)) then
				uTarget = getPlayerFromName(sTarget);
				if(self.liveWith[uMaster][uTarget]) or (self.liveWith[uMaster] == uTarget) then
					self:StopLive(uMaster, uTarget);
				else
					uMaster:showInfoBox("error", "Dieser Spieler wurde nicht von dir Live gestellt!");
				end
			else
				uMaster:showInfoBox("error", "Dieser Spieler existiert nicht.");
			end
		else
			uMaster:showInfoBox("error", "Dafuer benoetigst du mindestens Rank "..self.rankPermissions.LiveFunc.."!");
		end
	else
		uMaster:showInfoBox("error", "Du weisst nicht wie das geht!");
	end
end

-- ///////////////////////////////
-- ///// StelleLive	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function NewsFaction:StelleLive(uMaster, uTarget)
	if(self.liveWith[uMaster]) and (self.liveWith[uMaster][uTarget] == true) then
		uMaster:showInfoBox("error", "Dieser Spiele wurde bereits von dir Livegestellt!");
	else
		self.isLive[uMaster] = true;
		self.isLive[uTarget] = true;

		if not(self.liveWith[uMaster]) then
			self.liveWith[uMaster] = {};
		end

		if(uMaster ~= uTarget) then
			self.liveWith[uMaster][uTarget] = true;
			uTarget:showInfoBox("info", "Du bist nun mit Reporter "..getPlayerName(uMaster).." in einem Interview!");
			uMaster:showInfoBox("info", "Du hast "..getPlayerName(uTarget).." zum Interview hinzugefuegt!");
		else
			self.liveWith[uTarget] = uMaster;
			uMaster:showInfoBox("info", "Du hast dich selber live gestellt!");
		end

	end
end

-- ///////////////////////////////
-- ///// StopAllPlayerInterview///
-- ///// Returns: void		//////
-- ///////////////////////////////

function NewsFaction:StopAllPlayerInterview(uPlayer)
	-- Master
	for player, bool in pairs(self.liveWith[uPlayer]) do
		if(bool == true) then
			-- Remove all from the Master --
			self:StopLive(uPlayer, player);
		end
	end
end

-- ///////////////////////////////
-- ///// LiveCMD	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function NewsFaction:LiveCMD(uPlayer, sTarget)
	if(uPlayer:getFaction():getID() == 6) then
		if(uPlayer:getRank() >= self.rankPermissions.LiveFunc) then
			if(getPlayerFromName(sTarget)) then
				local uTarget = getPlayerFromName(sTarget);
				if not(self.isLive[uTarget]) then
					self:StelleLive(uPlayer, uTarget);
				else
					uPlayer:showInfoBox("error", "Der Spieler ist gerade livegestellt!");
				end
			else
				uPlayer:showInfoBox("error", "Der Spieler existiert nicht!");
			end
		else
			uPlayer:showInfoBox("error", "Dafuer benoetigst du mindestens Rank "..self.rankPermissions.LiveFunc.."!");
		end
	else
		uPlayer:showInfoBox("error", "Du weisst nicht wie das geht!");
	end
end

-- ///////////////////////////////
-- ///// LiveToggle 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function NewsFaction:LiveToggle(uPlayer, cmd, sWas, sPlayer)
	if(uPlayer:getFaction():getID() == 6) then
		if(uPlayer:getRank() >= self.rankPermissions.LiveFunc) then
			if(sWas == "add") then
				self:LiveCMD(uPlayer, sPlayer);
			elseif(sWas == "remove") then
				if(sPlayer == "<all>") then
					self:StopAllPlayerInterview(uPlayer);
				else
					self:StopLiveCMD(uPlayer, sPlayer);
				end
			else
				uPlayer:showInfoBox("info", "Benutze: /live <add/remove> <Spielername / <all>>");
			end
		else
			uPlayer:showInfoBox("error", "Dafuer benoetigst du mindestens Rank "..self.rankPermissions.LiveFunc.."!");
		end
	else
		uPlayer:showInfoBox("error", "Du weisst nicht wie das geht!");

	end
end

-- ///////////////////////////////
-- ///// OutputChat 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function NewsFaction:OutputChat(uPlayer, sMessage)
	if(#sMessage < 256) then
		local sText	= "Gast ";
		if(uPlayer:getFaction():getID() == 6) then
			sText = uPlayer:getFaction():getRankName(tonumber(uPlayer:getRank())).." ";
		end

		sText = sText..getPlayerName(uPlayer)..": ";
		sText = sText..sMessage;
		outputChatBox(sText, getRootElement(), 110, 138, 255);

	else
		uPlayer:showInfoBox("error", "Deine Nachricht ist zu lang!");
	end
end

-- ///////////////////////////////
-- ///// CheckQuit	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function NewsFaction:CheckQuit(uPlayer)
	if(self.isLive[uPlayer]) then
		if(self.liveWith[uPlayer]) then
			if(isElement(self.liveWith[uPlayer])) then
				-- Einzelperson --
				self:StopLive(self.liveWith[uPlayer], uPlayer);
			else
				self:StopAllPlayerInterview(uPlayer);
			end
		end

	end
end

-- ///////////////////////////////
-- ///// ToggleNews 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function NewsFaction:ToggleNews(uPlayer, bBool)
	if(isPedInVehicle(uPlayer) and (uPlayer:getVehicle().Faction) and (uPlayer:getVehicle().Faction:getID() == 6)) or (bBool == false) then
		if(uPlayer:getFaction():getID() == 6) then
			if(uPlayer:getRank() >= self.rankPermissions.NewsFunc) then
				local suffix		= "";
				if not(self.doingNews[uPlayer]) then
					self.doingNews[uPlayer] = false;
				end
				if(bBool == true) then
					if(self.doingNews[uPlayer] == false) then
						self.doingNews[uPlayer] 	= true;
						suffix						= "eingeschaltet";

					end
				else
					if(self.doingNews[uPlayer] == true) then
						self.doingNews[uPlayer] 	= false;
						suffix						= "ausgeschaltet";

					end
				end
				uPlayer:showInfoBox("info", "Der News-Modus wurde "..suffix.."!");
			else
				uPlayer:showInfoBox("error", "Dafuer benoetigst du mindestens Rank "..self.rankPermissions.NewsFunc.."!");
			end
		else
			uPlayer:showInfoBox("error", "Du weisst nicht wie das geht!");
		end
	else
		uPlayer:showInfoBox("error", "Dafuer musst du in einem News-Fahrzeug sitzen!");
	end
end

-- ///////////////////////////////
-- ///// NewsCMD	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function NewsFaction:NewsCMD(uPlayer)
	if not(self.doingNews[uPlayer]) then
		self:ToggleNews(uPlayer, true);
	else
		self:ToggleNews(uPlayer, false);
	end
end
-- ///////////////////////////////
-- ///// CheckNewsvanNews	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function NewsFaction:CheckNewsvanNews(uPlayer)
	if(self.doingNews[uPlayer]) then
		self:ToggleNews(uPlayer, false);
	end
end

-- ///////////////////////////////
-- ///// ReloadLatestZeitung//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function NewsFaction:ReloadLatestZeitung()
	local result = CDatabase:getInstance():query("SELECT * FROM `newspaper` ORDER BY NewspaperID DESC;");

	self.latestZeitung = (type(result) == "table" and result[1] or {});
	outputDebugString("Es wurden "..#result.." Zeitungen gefunden!");
end

-- ///////////////////////////////
-- ///// PreviewNewspaper	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function NewsFaction:PreviewNewspaper(uPlayer)
	return triggerClientEvent(uPlayer, "onNewsfactionNewspaperOpen", uPlayer, self.latestZeitung)
end

-- ///////////////////////////////
-- ///// SchreibeZeitung	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function NewsFaction:SchreibeZeitung(uPlayer, sTitel, sText)
	if(uPlayer:getFaction():getID() == 6) then
		local result = CDatabase:getInstance():query("INSERT INTO newspaper (Title, Content, Editor) VALUES (?, ?, ?);", sTitel, sText, getPlayerName(uPlayer));

		if(result) then
			uPlayer:showInfoBox("info", "Zeitung erfolgreich geschrieben!");
			self:ReloadLatestZeitung();
		else
			uPlayer:showInfoBox("error", "Datenbankfehler!\nDeine Zeitung befindet sich in deinem Resourcen-ordner.");

		end
	end
end

--[[
-- ///////////////////////////////
-- ///// EventModus			//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function NewsFaction:EventModus(uPlayer, sModus)
	if(uPlayer:getFaction():getID() == 6) then
		if(uPlayer:getRank() >= self.rankPermissions.eventStarten) then
			sModus = string.lower(sModus);
			if(sModus == "starten") then
				if(DEFINE_EVENT_MODUS == false) then

				else
					uPlayer:showInfoBox("error", "Der Event-Modus ist bereits an!")
				end
			elseif(sModus == "beenden") then
				if(DEFINE_EVENT_MODUS == true) then

				else
					uPlayer:showInfoBox("error", "Der Event-Modus ist nicht an!")
				end
			else
				uPlayer:showInfoBox("info", "Benutze: /eventmodus <starten / beenden>")
			end
		else
			uPlayer:showInfoBox("error", "Daf\uer ben\oetigst du Rank "..self.rankPermissions.eventStarten.."!")
		end
	else
		uPlayer:showInfoBox("error", "Du bist kein SAT Member!")
	end
end
]]
-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function NewsFaction:Constructor(...)
	--[[
	-- Klassenvariablen --
	self.markerOben		= createMarker(919.21398925781, -1012.5350952148, 107.578125, "corona", 1.0, 0, 255, 0)
	-- Oben:
	-- 921.35919189453, -1012.5017089844, 107.578125

	self.markerUnten	= createMarker(914.19580078125, -1037.6943359375, 31.8984375, "corona", 1.0, 0, 255, 0)
	-- 914.04071044922, -1040.2518310547, 31.6015625
	]]
--	self.IntMapRoot = getResourceMapRootElement(getThisResource(), "res/maps/faction/News-Interior.map")

	self.Interior		= 5;
	self.Dimension		= 83;

	for index, object in pairs(mapManager:getMapRootObjects("res/maps/faction/News-Interior.map")) do
		setElementInterior(object, self.Interior);
		setElementDimension(object, self.Dimension);
	end
	-- Draussen vorm Innenraum
	self.markerDraussen				= createMarker(1684.9963378906, -1343.3433837891, 17.435161590576, "corona", 1.0, 0, 255, 0)
	-- Davor: 913.91131591797, -1001.1255493164, 38.049598693848

	self.markerLobby				= createMarker(948.49029541016, -1039.6270751953, 176.57186889648, "corona", 1.0, 0, 255, 0);
	-- Davor: 948.67895507813, -1040.9466552734, 176.57186889648

	-- Markerdraussen <-> MarkerLobby

	self.markerLobbyEingang 		= createMarker(962.71258544922, -1059.5946044922, 176.57186889648, "corona", 1.0, 0, 255, 0);
	-- Davor: 962.50469970703, -1057.8485107422, 176.57186889648

	self.markerLobbyAusgang 		= createMarker(967.40063476563, -1061.8762207031, 176.95156860352, "corona", 1.0, 0, 255, 0);
	-- Davor: 967.58074951172, -1063.5543212891, 176.95156860352

	-- MarkerLobbyEingang <-> MarkerLobbyAusgang

	self.markerLobbyEingangHelipad 	= createMarker(970.76983642578, -1075.9228515625, 176.95938110352, "corona", 1.0, 0, 255, 0);
	-- Davor: 970.60406494141, -1073.7940673828, 176.95938110352

	self.markerLobbyAusgangHelipad	= createMarker(1678.8100585938, -1349.5452880859, 158.4765625, "corona", 1.0, 0, 255, 0);
	-- Davor: 921.35919189453, -1012.5017089844, 107.578125

	-- MarkerLobbyEingangHelipad <-> MarkerLobbyAusgangHelipad

	self.markerZeitungsPreview		= createMarker(982.12475585938, -1060.0988769531, 176.95156860352, "corona", 3.0, 0, 255, 255);
	self.markerNewZeitung			= createMarker(981.38037109375, -1078.0821533203, 176.95938110352, "corona", 3.0, 0, 255, 255);


	self.markerKaufeZeitung			= createMarker(1703.7252197266, -1315.2917480469, 13.572368621826, "corona", 1.0, 0, 255, 255);
	self.getObjectsMarker			= createMarker(987.34765625, -1077.2445068359, 176.95938110352, "corona", 1.0, 0, 255, 255);

	self.InteriorElements 		= {self.markerLobby, self.markerLobbyEingang, self.markerLobbyAusgang, self.markerLobbyEingangHelipad, self.markerZeitungsPreview, self.markerNewZeitung, self.getObjectsMarker};




	for _, element in pairs(self.InteriorElements) do
		setElementInterior(element, self.Interior);
		setElementDimension(element, self.Dimension);
	end



	-- Zeitungen --
	self.latestZeitung		= {}
	self:ReloadLatestZeitung()

	-- Permissions Variablen --
	self.rankPermissions					= {};
	self.rankPermissions.NewsFunc			= 1;
	self.rankPermissions.LiveFunc			= 2;
	self.rankPermissions.zeitungSchreiben 	= 2;
	self.rankPermissions.getObjects			= 2;
	self.rankPermissions.eventStarten		= 4;



	-- Live Variablen --
	self.isLive						= {};
	self.liveWith					= {};
	self.newNewsTimer				= false;
	self.newNewsSeconds				= 5000;
	self.lastNewsText				= {};

	self.doingNews					= {};

	-- Andere --
	self.objectIds					=
	{[200] = 10, [201] = 10, [202] = 2, [203] = 10, [204] = 10, [205] = 10, [206] = 10};

	self.markerHitFunc          = function(...) self:HitMarker(...) end;
	self.newsFunction	        = function(...) self:NewsCMD(...) end;
	self.liveFunction	        = function(...) self:LiveToggle(...) end;
	self.checkQuitFunc	        = function(...) self:CheckQuit(source, ...) end;
	self.checkNewsvanNewsFunc	= function(...) self:CheckNewsvanNews(source, ...) end;
	self.zeitungSchreibFunc	    = function(...) self:SchreibeZeitung(client, ...) end;
	self.m_buyZeitungFunc       = function(...)
		local uPlayer = (client or false);
		if(uPlayer:getMoney() >= 25) then
			uPlayer:showInfoBox("info", "Du hast die die Zeitschrift der San Andreas Times gekauft!\nBenutzbar im Inventar.");
			uPlayer:addMoney(-25);
			Factions[6]:addDepotMoney(20)
			uPlayer:getInventory():addItem(Items[199],1);
			uPlayer:refreshInventory();
		else
			uPlayer:showInfoBox("error", "Eine Zeitung kostet $25!");
		end
	end
--	self.eventFunc		= function(...) self:EventModus(...) end;
	-- Methoden --
	--[[
	addEventHandler("onMarkerHit", self.markerUnten, self.markerHit1Func);
	addEventHandler("onMarkerHit", self.markerOben, self.markerHit2Func);
	]]

	addEventHandler("onMarkerHit", self.markerDraussen, function(uPlayer) self.markerHitFunc(uPlayer, 1) end);      -- Draussen
	addEventHandler("onMarkerHit", self.markerLobby, function(uPlayer) self.markerHitFunc(uPlayer, 2) end);
	addEventHandler("onMarkerHit", self.markerLobbyEingang, function(uPlayer) self.markerHitFunc(uPlayer, 3) end);
	addEventHandler("onMarkerHit", self.markerLobbyAusgang, function(uPlayer) self.markerHitFunc(uPlayer, 4) end);
	addEventHandler("onMarkerHit", self.markerLobbyEingangHelipad, function(uPlayer) self.markerHitFunc(uPlayer, 5) end);
	addEventHandler("onMarkerHit", self.markerLobbyAusgangHelipad, function(uPlayer) self.markerHitFunc(uPlayer, 6) end);
	addEventHandler("onMarkerHit", self.markerZeitungsPreview, function(uPlayer) self.markerHitFunc(uPlayer, 7) end)
	addEventHandler("onMarkerHit", self.markerNewZeitung, function(uPlayer) self.markerHitFunc(uPlayer, 8) end)
	addEventHandler("onMarkerHit", self.markerKaufeZeitung, function(uPlayer) self.markerHitFunc(uPlayer, 9) end)
	addEventHandler("onMarkerHit", self.getObjectsMarker, function(uPlayer) self.markerHitFunc(uPlayer, 10) end)

	addEventHandler("onPlayerQuit", getRootElement(), self.checkQuitFunc);


	addEventHandler("onPlayerQuit", getRootElement(), self.checkNewsvanNewsFunc);
	addEventHandler("onPlayerVehicleExit", getRootElement(), self.checkNewsvanNewsFunc);
	addEventHandler("onNewsfactionZeitungSchreib", getRootElement(), self.zeitungSchreibFunc)

	addEvent("onPlayerZeitungKauf", true);
	addEventHandler("onPlayerZeitungKauf", getRootElement(), self.m_buyZeitungFunc);


	-- Events --
	addCommandHandler("news", self.newsFunction);
	addCommandHandler("live", self.liveFunction);

--	addCommandHandler("eventmodus", self.eventFunc)

--logger:OutputInfo("[CALLING] NewsFaction: Constructor");
end

-- ///////////////////////////////
-- ///// HitMarker			//////
-- ///// Returns: void		//////
-- ///////////////////////////////


function NewsFaction:HitMarker(uPlayer, iID)
	if(uPlayer) and (getElementType(uPlayer) == "player") then
		if(iID == 1) then
			uPlayer:fadeInPosition(948.67895507813, -1040.9466552734, 176.57186889648, self.Dimension, self.Interior)       -- Draussen -> Lobby
		elseif(iID == 2) then
			uPlayer:fadeInPosition(1686.560546875, -1343.1506347656, 17.43004989624, 0, 0)                                     -- Lobby -> Draussen
		elseif(iID == 3) then
			if(uPlayer:getFaction():getID() == 6) then
				uPlayer:fadeInPosition(967.58074951172, -1063.5543212891, 176.95156860352, self.Dimension, self.Interior)
			else
				uPlayer:showInfoBox("error", "Du hast leider keinen Schluessel fuer diese Tuer!")
			end
		elseif(iID == 4) then
			if(uPlayer:getFaction():getID() == 6) then
				uPlayer:fadeInPosition(962.50469970703, -1057.8485107422, 176.57186889648, self.Dimension, self.Interior)
			else
				uPlayer:showInfoBox("error", "Du hast leider keinen Schluessel fuer diese Tuer!")
			end
		elseif(iID == 5) then
			if(uPlayer:getFaction():getID() == 6) then
				uPlayer:fadeInPosition(1678.9465332031, -1348.3792724609, 158.4765625, 0, 0)
			else
				uPlayer:showInfoBox("error", "Du hast leider keinen Schluessel fuer diese Tuer!")
			end
		elseif(iID == 6) then
			if(uPlayer:getFaction():getID() == 6) then
				uPlayer:fadeInPosition(970.60406494141, -1073.7940673828, 176.95938110352, self.Dimension, self.Interior)
			else
				uPlayer:showInfoBox("error", "Du hast leider keinen Schluessel fuer diese Tuer!")
			end
		elseif(iID == 7) then
			self:PreviewNewspaper(uPlayer);
		elseif(iID == 8) then
			if(uPlayer:getFaction():getID() == 6) then
				if(uPlayer:getRank() >= self.rankPermissions.zeitungSchreiben) then
					triggerClientEvent(uPlayer, "onNewsfactionNewspaperCreate", uPlayer);
				else
					uPlayer:showInfoBox("error", "Zeitungen schreiben kannst du erst ab Rank "..self.rankPermissions.zeitungSchreiben.."!")
				end
			else
				uPlayer:showInfoBox("error", "Du kannst keine Zeitungen schreiben!")
			end
		elseif(iID == 9) then
			if(uPlayer:getMoney() >= 25) then
				uPlayer:showInfoBox("info", "Du hast die die Zeitschrift der San Andreas Times gekauft!\nBenutzbar im Inventar.");
				uPlayer:addMoney(-25);
				Factions[6]:addDepotMoney(20)
				uPlayer:getInventory():addItem(Items[199],1);
				uPlayer:refreshInventory();
			else
				uPlayer:showInfoBox("error", "Eine Zeitung kostet $25!");
			end
		elseif(iID == 10) then
			if(uPlayer:getFaction():getID() == 6) then
				if(uPlayer:getRank() >= self.rankPermissions.getObjects) then
					for object, anzahl in pairs(self.objectIds) do
						uPlayer:getInventory():addItem(Items[object], anzahl);
					end
					uPlayer:refreshInventory();
					uPlayer:showInfoBox("info", "Die SAT Objekte befinden sich nun in deinem Inventar!");
				else
					uPlayer:showInfoBox("error", "Die Objekte bekommst du erst "..self.rankPermissions.zeitungSchreiben.."!")
				end
			else
				uPlayer:showInfoBox("error", "Nicht dein Job!")
			end
		end
	end
end

-- EVENT HANDLER --
