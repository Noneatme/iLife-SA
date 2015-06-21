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
-- ## Name: CO_Waffenschrank.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

CO_Waffenschrank = {};
CO_Waffenschrank.__index = CO_Waffenschrank;

addEvent("onWaffenschrankWaffeEinlager", true);
addEvent("onWaffenschrankWaffeHerausnehm", true);


addEvent("onClientWaffenschrankOpen", true);

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function CO_Waffenschrank:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// GetWeapons			//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CO_Waffenschrank:GetWeapons(uObject)
	local weapons = 0;
	for id, schuss in pairs(uObject:GetWAData("weapons")) do
		id = tonumber(id)
		schuss = tonumber(schuss)
		if(id) and (schuss) then
			weapons = weapons+1;
		end
	end
	return weapons;
end

-- ///////////////////////////////
-- ///// HasPermissions		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CO_Waffenschrank:HasPermissions(uPlayer, uObject)
	if(tonumber(uPlayer:getID()) == tonumber(uObject:GetOwner())) or (uPlayer:getAdminLevel() >= 3) then
		return true;
	else
		return false;
	end

	return false;
end

-- ///////////////////////////////
-- ///// SendPlayerData		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CO_Waffenschrank:SendPlayerData(uPlayer, uObject)
	local tblList = {}
	for id, schuss in pairs(uObject:GetWAData("weapons")) do
		id = tonumber(id)
		schuss = tonumber(schuss)
		if(id) and (schuss) then
			tblList[id] = schuss;
		end
	end

	return triggerClientEvent(uPlayer, "onClientWaffenschrankInfosRefresh", uPlayer, uObject, tblList)
end

-- ///////////////////////////////
-- ///// Open		 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CO_Waffenschrank:Open(uPlayer, uObject)
	if(self:HasPermissions(uPlayer, uObject)) then
		self:SendPlayerData(uPlayer, uObject)
	else
		uPlayer:showInfoBox("error", "Diesen Waffenschrank kannst du nicht \oeffnen!");
	end
end

-- ///////////////////////////////
-- ///// Rausnehmen 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CO_Waffenschrank:Rausnehmen(uPlayer, sWaffe, uObject)

	if(self:HasPermissions(uPlayer, uObject)) then
		if(getWeaponIDFromName(sWaffe)) then
			local iWaffe = tostring(getWeaponIDFromName(sWaffe));

			local tblVorhanden = uObject:GetWAData("weapons");

			if(tblVorhanden[iWaffe]) and (tblVorhanden[iWaffe] ~= false) then
				local iAmmo = tblVorhanden[iWaffe];
				tblVorhanden[iWaffe] = false;
				-- Vorsicht, koennte nicht gehen! falls Fehler kommt, das Table.remove entfernen ! --
				table.remove(tblVorhanden, iWaffe);
				uObject:SetWAData("weapons", tblVorhanden);

				giveWeapon(uPlayer, iWaffe, iAmmo, true);
				uPlayer:showInfoBox("sucess", "Du hast deine Waffe erfolgreich aus dem Schrank genommen!");


				local x, y, z = getElementPosition(uObject);
				logger:OutputPlayerLog(uPlayer, "Nahm Waffe aus Waffenschrank", PlayerNames[uObject:GetOwner()], getZoneName(x, y, z, false)..", "..getZoneName(x, y, z, true), sWaffe..", "..iAmmo);

				self:SendPlayerData(uPlayer, uObject);
			else

			end
		else

		end
	end
end

-- ///////////////////////////////
-- ///// Reinpacken 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CO_Waffenschrank:Reinpacken(uPlayer, uObject)
	if(self:HasPermissions(uPlayer, uObject)) then
		local iWeapon = getPedWeapon(uPlayer)
		if(iWeapon ~= 0) then
			iWeapon = tostring(iWeapon)
			local iAmmo = getPedTotalAmmo(uPlayer);
			if(iWeapon and iAmmo) then
				if(self:GetWeapons(uObject) < 2) then
					local tblVorhanden = uObject:GetWAData("weapons");
					if not(tblVorhanden[iWeapon]) or (tblVorhanden[iWeapon] == false) or (tblVorhanden[iWeapon] == "false") then
						tblVorhanden[iWeapon] = iAmmo;
						uObject:SetWAData("weapons", tblVorhanden);
						uPlayer:showInfoBox("sucess", "Deine Waffe wurde erfolgreich einglagert!");
						takeWeapon(uPlayer, iWeapon);

						self:SendPlayerData(uPlayer, uObject);
						
						
						local x, y, z = getElementPosition(uObject);
						logger:OutputPlayerLog(uPlayer, "Packte Waffe in Waffenschrank", PlayerNames[uObject:GetOwner()], getZoneName(x, y, z, false)..", "..getZoneName(x, y, z, true), getWeaponNameFromID(tonumber(iWeapon))..", "..iAmmo);

					else
						uPlayer:showInfoBox("error", "Diese Waffe hast du bereits eingelagert!\nNehme Sie raus, um Munition einzulagern.");
					end
				else
					uPlayer:showInfoBox("error", "Dieser Waffenschrank ist leider Voll. Platziere einen neuen.");
				end
			else
				uPlayer:showInfoBox("error", "Bitte nehme die Waffe in deine Hand die du einlagern willst!")
			end
		else
			uPlayer:showInfoBox("error", "Bitte nehme die Waffe in deine Hand die du einlagern willst!")
		end
	end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CO_Waffenschrank:Constructor(...)
	-- Klassenvariablen --


	-- Methoden --

	self.openFunc		= function(...) self:Open(client, ...) end;
	self.reinFunc		= function(...) self:Reinpacken(client, ...) end;
	self.rausFunc		= function(...) self:Rausnehmen(client, ...) end;

	-- Events --
	addEventHandler("onWaffenschrankWaffeEinlager", getRootElement(), self.reinFunc)
	addEventHandler("onWaffenschrankWaffeHerausnehm", getRootElement(), self.rausFunc)

	addEventHandler("onClientWaffenschrankOpen", getRootElement(), self.openFunc)

	--logger:OutputInfo("[CALLING] CO_Waffenschrank: Constructor");
end

-- EVENT HANDLER --
