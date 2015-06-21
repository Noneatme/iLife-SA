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
-- ## Name: MechanicFaction.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

MechanicFaction = {};
MechanicFaction.__index = MechanicFaction;

addEvent("onPlayerVehicleAbschlepp", true)
addEvent("onPlayerVehicleFreistell", true)

addEvent("onPlayerVehicleCallback", true)

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function MechanicFaction:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// CheckVehicle 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function MechanicFaction:CheckVehicleExit(uVehicle, uPlayer)
	if(self.onDuty[uPlayer] == true) then
		self:ToggleDuty(uPlayer, uVehicle)
	end
end

-- ///////////////////////////////
-- ///// CheckVehicleEnter 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function MechanicFaction:CheckVehicleEnter(uVehicle, uPlayer)
	if not(getElementType(uPlayer) == "player") then return end
	if(uPlayer:getFaction():getID() == 7) or (uPlayer:getFaction():getID() == 1) then
		if(uVehicle.Faction) and (uVehicle:getFaction():getID() == 7) then
			if(getElementModel(uVehicle) == 525) then -- Towtruck
				if(getVehicleSirensOn(uVehicle) == false) then
					if(self.onDuty[uPlayer] ~= true) then
						uPlayer:showInfoBox("Info", "Benutze /duty um deinen Dienst zu starten / beenden.");
					end
				else
					if(self.onDuty[uPlayer] ~= true) then
						self:ToggleDuty(uPlayer, uVehicle)
					end
				end
			end
		end
	end
end

-- ///////////////////////////////
-- ///// ToggleDuty	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function MechanicFaction:ToggleDuty(uPlayer, uVehicle2)
	if(uPlayer:getFaction():getID() == 7) or (uPlayer:getFaction():getID() == 1) then
		local uVehicle = getPedOccupiedVehicle(uPlayer);
		if(uVehicle) and (uVehicle.Faction) and (uVehicle:getFaction():getID() == 7) or (uVehicle2) or (uVehicle:getFaction():getID() == 1) then
			if(uVehicle2) then
				uVehicle = uVehicle2
			end
			self.onDuty[uPlayer] = not(self.onDuty[uPlayer]);

			if(self.onDuty[uPlayer] == false) then
				uPlayer:showInfoBox("info", "Du bist nun nicht mehr im Dienst.");
			else
				uPlayer:showInfoBox("sucess", "Du bist nun im Dienst.");
				setVehicleSirensOn(uVehicle, true)
			end

			setElementData(uPlayer, "OnDuty", self.onDuty[uPlayer]);
		end
	end
end

-- ///////////////////////////////
-- ///// DoAbschlepp		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function MechanicFaction:DoAbschlepp(uPlayer, uVehicle)
	if(getElementData(uVehicle, "v:AbgeschlepptVon") == uPlayer) then
		local x, y, z = getElementPosition(uVehicle)
		local rx, ry, rz = getElementRotation(uVehicle)
		local s = uVehicle:setAbstellPosition(x, y, z, rx, ry, rz);

		if(s) then
			uPlayer:showInfoBox("sucess", "Das Fahrzeug wurde erfolgreich abgeschleppt!");

			local vName = getVehicleNameFromModel(getElementModel(uVehicle));
			offlineMSGManager:AddOfflineMSG(uVehicle.OwnerName, "Dein(e) "..vName.." wurde abgeschleppt!\nDu musst es nun am Schrottplatz freikaufen.");
			
			logger:OutputPlayerLog(uPlayer, "Schleppte Fahrzeug ab", vName, uVehicle.OwnerName)
		else
			uPlayer:showInfoBox("error", "Fehler beim Abschleppen!");
		end
	end
end

-- ///////////////////////////////
-- ///// DoFreistell		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function MechanicFaction:DoFreistell(uPlayer, uVehicle)
	if(uPlayer:getFaction():getID() == 7)  or (uPlayer:getFaction():getID() == 1)then
		local s = uVehicle:setAbstellPosition(0, 0, 0, 0, 0, 0);
		uPlayer:showInfoBox("sucess", "Das Fahrzeug wurde erfolgreich freigestellt!");

	else
		uPlayer:showInfoBox("error", "Du bist nicht authorisiert!");
	end
end

-- ///////////////////////////////
-- ///// OnTrainerDetach	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function MechanicFaction:OnTrailerDetach(uVehicle, uTowtruck)
	setElementData(uVehicle, "Towed", false);
end

-- ///////////////////////////////
-- ///// OnTrainerAttach	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function MechanicFaction:OnTrailerAttach(uVehicle, uTowtruck)
	local uPlayer = getVehicleOccupant(uTowtruck)
	if not(uPlayer) or not(getElementType(uPlayer) == "player") then return end
	setElementSyncer(uVehicle, uPlayer);

	if(uTowtruck.Faction) then
		if(uTowtruck:getFaction():getID() == 7) or (uTowtruck:getFaction():getID() == 1)  then
			if(self.onDuty[uPlayer] == true) then
				if(uVehicle.OwnerName) then

					uPlayer:showInfoBox("info", "Um das Fahrzeug abzuschleppen, stell es in deine Basis und klicke es an.");

					--		self.abgeschleppt[uVehicle] = true;
					setElementData(uVehicle, "v:AbgeschlepptVon", uPlayer);
					setElementData(uVehicle, "Towed", uPlayer);

				else
					uPlayer:showInfoBox("info", "Dieses Fahrzeug ist nicht abschleppf\aehig.");

				end
			else
				cancelEvent()
				uPlayer:showInfoBox("error", "Du kannst nur im Dienst Fahrzeuge abschleppen!");
			end
		end
	end
end

-- ///////////////////////////////
-- ///// RemoveMeldungAbgegeben///
-- ///// Returns: void		//////
-- ///////////////////////////////

function MechanicFaction:RemoveMeldungAbgegeben(uPlayer, uVehicle)
	if(uPlayer and uVehicle) then
		self.meldungAbgegeben[uPlayer][uVehicle] = false;
	end
end

-- ///////////////////////////////
-- ///// CallVehicleBack	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function MechanicFaction:CallVehicleBack(uPlayer, uVehicle)
	if(isElementWithinColShape(uPlayer, self.colShape)) then
		if not(self.meldungAbgegeben[uPlayer]) then
			self.meldungAbgegeben[uPlayer] = {}
		end

		if not(self.meldungAbgegeben[uPlayer][uVehicle] == true) then
			local tbl, iOnline = self.Faction:getOnlinePlayers();
			if(iOnline > 0) then
				self.meldungAbgegeben[uPlayer][uVehicle] = true;
				setTimer(self.removeMeldungFunc, 60000, 1, uPlayer, uVehicle);

				local sVehicle = getVehicleNameFromModel(getElementModel(uVehicle))

				for index, player in pairs(tbl) do
					outputChatBox("Der Spieler "..getPlayerName(uPlayer).." möchte sein(en) "..sVehicle.." freikaufen!", player, 96, 191, 0);

				end

				uPlayer:showInfoBox("sucess", "Die Mechaniker wurden benachrichtig.");
			else
				uPlayer:showInfoBox("error", "Momentan ist kein Mechaniker online! Du musst leider warten.");
			end
		else
			uPlayer:showInfoBox("error", "Du kannst jedes Fahrzeug nur jede Minute dich zum Freikaufen melden.");
		end
	else
		uPlayer:showInfoBox("error", "Daf\uer musst du bei der Mechanikerbasis sein.");
	end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function MechanicFaction:Constructor(...)
	-- Klassenvariablen --
	self.gate		= createObject(968, 2749.3000488281, -2059.1999511719, 12.60000038147, 0, 0, 0)
	self.colShape	= createColSphere(2761.2255859375, -2102.724609375, 11.915635108948, 55);

	self.Faction	= Factions[7];

	self.onDuty		= {}
	self.abgeschleppt = {}

	self.meldungAbgegeben = {}

	-- Methoden --
	self.checkVehicleEnterFunc	= function(...) self:CheckVehicleEnter(source, ...) end;
	self.checkVehicleExitFunc	= function(...) self:CheckVehicleExit(source, ...) end;
	self.attachFunc				= function(towtruck) self:OnTrailerAttach(source, towtruck) end;
	self.detachFunc				= function(towtruck) self:OnTrailerDetach(source, towtruck) end;
	self.dutyFunction			= function(uPlayer, ...) self:ToggleDuty(uPlayer) end;
	self.vehicleAbschlepp		= function(uVehicle) self:DoAbschlepp(client, uVehicle) end;
	self.vehicleFreistell		= function(uVehicle) self:DoFreistell(client, uVehicle) end;
	self.removeMeldungFunc		= function(uPlayer) self:RemoveMeldungAbgegeben(uPlayer) end;
	self.vehicleCallbackFunc	= function(uVehicle) self:CallVehicleBack(client, uVehicle) end;


	-- Events --
	addEventHandler("onVehicleEnter", getRootElement(), self.checkVehicleEnterFunc);
	addEventHandler("onVehicleExit", getRootElement(), self.checkVehicleExitFunc);

	addEventHandler("onTrailerAttach", getRootElement(), self.attachFunc);
	addEventHandler("onTrailerDetach", getRootElement(), self.detachFunc);

	addEventHandler("onPlayerVehicleAbschlepp", getRootElement(), self.vehicleAbschlepp);
	addEventHandler("onPlayerVehicleFreistell", getRootElement(), self.vehicleFreistell);
	addEventHandler("onPlayerVehicleCallback", getRootElement(), self.vehicleCallbackFunc);

	addCommandHandler("duty", self.dutyFunction)
	--logger:OutputInfo("[CALLING] MechanicFaction: Constructor");
end

-- EVENT HANDLER --