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
-- ## Name: CO_Geldschachtel.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

CO_Geldschachtel = {};
CO_Geldschachtel.__index = CO_Geldschachtel;

addEvent("onGeldschachtelEinzahl", true);
addEvent("onGeldschachtelAuszahl", true);
addEvent("onGeldschachtelPermissionGebe", true);
addEvent("onGeldschachtelPermissionLoesche", true);

addEvent("onClientGeldschachtelOpen", true);

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function CO_Geldschachtel:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// HasPermissions		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CO_Geldschachtel:HasPermissions(uPlayer, uObject)
	local tblPermissions = uObject:GetWAData("permissions")
	if(tblPermissions) then
		if(tonumber(uPlayer:getID()) == tonumber(uObject:GetOwner())) or (uPlayer:getAdminlevel() >= 3) then
			return true;
		else
			for id, boolean in pairs(tblPermissions) do
				if(tonumber(id) == tonumber(uPlayer:getID())) then
					return true
				end
			end
		end
	else
		uObject:SetWAData("permissions", {});
		return false;
	end

	return false;
end


-- ///////////////////////////////
-- ///// SendPlayerData		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CO_Geldschachtel:SendPlayerData(uPlayer, uObject)
	local tblList = {}
	for id, boolean in pairs(uObject:GetWAData("permissions")) do
		id = tonumber(id)
		if(id) and (PlayerNames[id]) then
			tblList[PlayerNames[id]] = boolean;
		end
	end

	return triggerClientEvent(uPlayer, "onClientGeldschachtelInfosRefresh", uPlayer, uObject, tblList)
end

-- ///////////////////////////////
-- ///// RemovePermission	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CO_Geldschachtel:RemovePermission(uPlayer, sPlayer, uObject)
	if(self:HasPermissions(uPlayer, uObject)) then
		if(getPlayerFromName(sPlayer)) then
			sPlayer = getPlayerFromName(sPlayer)
			local iID = sPlayer:getID()

			if(sPlayer ~= uPlayer) then
				if(self:HasPermissions(sPlayer, uObject)) then
					local tblPerm = uObject:GetWAData("permissions");
					local newTBL = {};
					for id, boolean in pairs(tblPerm) do
						if(tonumber(id) == tonumber(sPlayer:getID())) then
							
						else
							newTBL[id] = boolean;
						end

					end
					uObject:SetWAData("permissions", newTBL);
					uPlayer:showInfoBox("sucess", "Der Spieler hat nun keine Rechte mehr!");

					self:SendPlayerData(uPlayer, uObject);
				else
					uPlayer:showInfoBox("error", "Der Spieler hat keine Rechte!");
				end
			else
				uPlayer:showInfoBox("error", "Du kannst dich nicht selbst entfernen!");
			end
		else
			uPlayer:showInfoBox("error", "Der Spieler ist nicht Online!");
		end
	else
		uPlayer:showInfoBox("error", "Du hast keine Berechtigung, Leute hinzuzuf\uegen!");
	end
end

-- ///////////////////////////////
-- ///// AddPermission		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CO_Geldschachtel:AddPermission(uPlayer, sPlayer, uObject)
	if(self:HasPermissions(uPlayer, uObject)) then
		if(getPlayerFromName(sPlayer)) then
			sPlayer = getPlayerFromName(sPlayer)
			local iID = sPlayer:getID()

			if not(self:HasPermissions(sPlayer, uObject)) then
				local tblPerm = uObject:GetWAData("permissions");
				tblPerm[iID] = true;
				uObject:SetWAData("permissions", tblPerm);

				uPlayer:showInfoBox("sucess", "Der Spieler kann nun die Geldschachtel benutzen!(Auch Rechte geben & entfernen)");

				self:SendPlayerData(uPlayer, uObject);
			else
				uPlayer:showInfoBox("error", "Der Spieler hat schon Rechte!");
			end
		else
			uPlayer:showInfoBox("error", "Der Spieler ist nicht Online!");
		end
	else
		uPlayer:showInfoBox("error", "Du hast keine Berechtigung, Leute hinzuzuf\uegen!");
	end
end

-- ///////////////////////////////
-- ///// Auszahlen			//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CO_Geldschachtel:Auszahlen(uPlayer, uObject, iGeld)
	if(self:HasPermissions(uPlayer, uObject)) then
		iGeld = tonumber(iGeld)
		if(iGeld) and (iGeld > 0) then
			local iVorhanden = (tonumber(uObject:GetWAData("geld")) or 0)

			if(iVorhanden >= iGeld) then
				uObject:SetWAData("geld", (tonumber(uObject:GetWAData("geld")) or 0)-iGeld);
				uPlayer:addMoney(iGeld);

				uPlayer:showInfoBox("sucess", "Du hast erfolgreich $"..iGeld.." ausgezahlt!");

				outputServerLog(getPlayerName(uPlayer).." hat $"..iGeld.." aus der Geldschachtel "..uObject:GetOwner().." ausgezahlt.");

				self:SendPlayerData(uPlayer, uObject);
				
				local x, y, z = getElementPosition(uObject);
				logger:OutputPlayerLog(uPlayer, "Nahm Geld aus Geldschachtel", PlayerNames[uObject:GetOwner()], getZoneName(x, y, z, false)..", "..getZoneName(x, y, z, true), "$"..iGeld);
	
			else
				uPlayer:showInfoBox("error", "Es ist nicht soviel Geld in der Kasse vorhanden!");
			end
		else
			uPlayer:showInfoBox("error", "Bitte gebe einen positiven Betrag ein!");
		end
	else
		uPlayer:showInfoBox("error", "Du hast keine Rechte hier was zu machen!");
	end
end

-- ///////////////////////////////
-- ///// Einzahlen			//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CO_Geldschachtel:Einzahlen(uPlayer, uObject, iGeld)
	if(self:HasPermissions(uPlayer, uObject)) then
		iGeld = tonumber(iGeld)
		if(iGeld) and (iGeld > 0) then
			if(uPlayer:getMoney() >= iGeld) then
				uObject:SetWAData("geld", (tonumber(uObject:GetWAData("geld")) or 0)+iGeld);
				uPlayer:addMoney(-iGeld);

				uPlayer:showInfoBox("sucess", "Du hast erfolgreich $"..iGeld.." eingezahlt!");

				outputServerLog(getPlayerName(uPlayer).." hat $"..iGeld.." in die Geldschachtel "..uObject:GetOwner().." eingezahlt.");
				local x, y, z = getElementPosition(uObject);
				logger:OutputPlayerLog(uPlayer, "Zahlte Geld in Geldschachtel ein", PlayerNames[uObject:GetOwner()], getZoneName(x, y, z, false)..", "..getZoneName(x, y, z, true), "$"..iGeld);
	
				self:SendPlayerData(uPlayer, uObject);

			else
				uPlayer:showInfoBox("error", "Du hast nicht soviel Geld bei dir!");
			end
		else
			uPlayer:showInfoBox("error", "Bitte gebe einen positiven Betrag ein!");
		end
	else
		uPlayer:showInfoBox("error", "Du hast keine Rechte hier was zu machen!");
	end
end

-- ///////////////////////////////
-- ///// Open		 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CO_Geldschachtel:Open(uPlayer, uObject)
	if(self:HasPermissions(uPlayer, uObject)) then
		self:SendPlayerData(uPlayer, uObject)
	else
		uPlayer:showInfoBox("error", "Diese Schachtel kannst du nicht \oeffnen!");
	end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CO_Geldschachtel:Constructor(...)
	-- Klassenvariablen --


	-- Methoden --
	self.einzahlFunc = function(...) self:Einzahlen(client, ...) end;
	self.auszahlFunc = function(...) self:Auszahlen(client, ...) end;
	self.permGiveFunc = function(...) self:AddPermission(client, ...) end;
	self.permRemoveFunc = function(...) self:RemovePermission(client, ...) end;
	self.openFunc		= function(...) self:Open(client, ...) end;
	
	-- Events --
	addEventHandler("onGeldschachtelEinzahl", getRootElement(), self.einzahlFunc)
	addEventHandler("onGeldschachtelAuszahl", getRootElement(), self.auszahlFunc)
	addEventHandler("onGeldschachtelPermissionGebe", getRootElement(), self.permGiveFunc)
	addEventHandler("onGeldschachtelPermissionLoesche", getRootElement(), self.permRemoveFunc)
	addEventHandler("onClientGeldschachtelOpen", getRootElement(), self.openFunc)

	--logger:OutputInfo("[CALLING] CO_Geldschachtel: Constructor");
end

-- EVENT HANDLER --
