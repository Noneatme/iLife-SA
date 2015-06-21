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
-- ## Name: TuningGarageManager.lua		##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

TuningGarageManager = {};
TuningGarageManager.__index = TuningGarageManager;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function TuningGarageManager:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end


--[[
1822.1617431641, -1285.9521484375, 132.92500305176
1822.4227294922, -1271.6213378906, 132.92500305176
1832.0877685547, -1271.9663085938, 132.93453979492
1832.0637207031, -1285.818359375, 132.92500305176

]]

-- ///////////////////////////////
-- ///// ExitTuninggarage	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function TuningGarageManager:ExitTuninggarage(id, sColorString, sHeadlightColors, sPlateText, iPaintJob)
	self.garages[id]:ExitPlayerGarage(client);
	local uVehicle = getPedOccupiedVehicle(client);

	local upgradeString = "";

	for i = 0, 17, 1 do

		local upgrade = getVehicleUpgradeOnSlot(uVehicle, i);
		if(upgrade) and (tonumber(upgrade) ~= nil) then
			upgradeString = upgradeString..upgrade.."|";
		end
	end

	if (uVehicle.Color and uVehicle.Color ~= sHeadlightColors) then
		Achievements[28]:playerAchieved(client)
	end

	if(uVehicle.Tuning ~= nil) then
		uVehicle.Tuning 	= upgradeString;
		uVehicle.Color 		= sColorString;
		uVehicle.HeadLights = sHeadlightColors
		uVehicle.Plate		= sPlateText;
		uVehicle.Paintjob	= iPaintJob;

		uVehicle:tune();
		uVehicle:save();
	else
		outputDebugString("Wrong Car at Tuning Station! ")
	end
	--[[
	outputChatBox(upgradeString);
	outputChatBox(sColorString);
	outputChatBox(sHeadlightColors);]]

	--outputDebugString("Exiting Garage: "..id)
end

-- ///////////////////////////////
-- ///// addCustomUpgrade	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function TuningGarageManager:AddVehicleCustomUpgrade(vehicle, iUpgradeID)
	vehicle:setSpezialtuningEnabled(iUpgradeID, true)
	return true;
end

-- ///////////////////////////////
-- ///// removeCustomUpgrade//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function TuningGarageManager:RemoveVehicleCustomUpgrade(vehicle, iUpgradeID)
	vehicle:setSpezialtuningEnabled(iUpgradeID, false)
	return true;
end


-- ///////////////////////////////
-- ///// BuyTuningteil		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function TuningGarageManager:BuyTuningteil(iSlotID, iUpgradeID, iPreis, iID)
	local vehicle = getPedOccupiedVehicle(client);
	-- !TODO: Geld Abziehen & Abfrage!

	local money = client:getMoney()
	local canBuy		= false;
	local bizPurchase	= false;

	if(money >= iPreis) then

		local iChain, iFilliale = self.garages[iID].iChain, self.garages[iID].iFilliale


		local biz		= cBusinessManager:getInstance().m_uBusiness[iFilliale]
		local einheitenCost;
		if(biz) then
			einheitenCost	= math.floor((iPreis/10)*biz:getLagereinheitenMultiplikator())

			if(biz:getLagereinheiten() >= einheitenCost) then
				canBuy 			= true;
				bizPurchase 	= true;
			else
				canBuy = false;
				client:showInfoBox("error", "Dieser Laden ist leer! Er muss erst wieder aufgefuellt werden.")
			end
		else
			canBuy = true;
		end
		-- PReis --
		local bizPreis = math.floor(iPreis/100*50);

		if(canBuy) then
			client:addMoney(-iPreis);
			client:showInfoBox("info", "Tuningteil gekauft!");

			Achievements[9]:playerAchieved(client);


			if(bizPurchase) then
				local businessGeld = math.floor(iPreis/100*50);
				biz:addLagereinheiten(-einheitenCost)

				if(biz:getCorporation() ~= 0) then
					biz:getCorporation():addSaldo(businessGeld);
				end
			end
		end
	else
		client:showInfoBox("error", "Du hast nicht genug Geld!");
	end

	-- Am Schluss:

	if(canBuy) then
		if(self.tuningTeilPreise.ItemPrices[iUpgradeID]) then
			self:AddVehicleCustomUpgrade(vehicle, iUpgradeID, iUpgradeID);

			logger:OutputPlayerLog(client, "Kaufte Spezialtuning", getVehicleNameFromModel(getElementModel(vehicle)), iUpgradeID);
		else
			addVehicleUpgrade(vehicle, iUpgradeID);
		end
	else
		removeVehicleUpgrade(vehicle, iSlotID, iUpgradeID);
		triggerClientEvent(client, "onClientPlayerTuninggarageCantBuyUpgrade", client, iSlotID, iUpgradeID)
	end
end

-- ///////////////////////////////
-- ///// SellTuningteil		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function TuningGarageManager:SellTuningteil(iSlotID, iUpgradeID, iPreis)
	local vehicle = getPedOccupiedVehicle(client);

	if(self.tuningTeilPreise.ItemPrices[iUpgradeID]) then
		self:RemoveVehicleCustomUpgrade(vehicle, iUpgradeID);
		client:showInfoBox("info", "Tuningteil gelöscht!");

		logger:OutputPlayerLog(client, "Verkaufte Spezialtuning", getVehicleNameFromModel(getElementModel(vehicle)), iUpgradeID);
	else
		-- GELD GEBEN HIER
		-- !TODO: Geld Geben

		client:showInfoBox("info", "Tuningteil verkauft!");

		-- Am Schluss:
		removeVehicleUpgrade(vehicle, iUpgradeID);
	end
end

-- ///////////////////////////////
-- ///// onVariantPreview	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function TuningGarageManager:onVariantPreview(uPlayer, iVariant1, iVariant2)
	local vehicle = client:getOccupiedVehicle();
	vehicle:setVariant(iVariant1, iVariant2);
	triggerClientEvent(uPlayer, "onTuninggarageCameraReset", uPlayer)
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function TuningGarageManager:Constructor(...)
	-- Klassenvariablen --
	self.garageIDs =
	{

	};

	self.garages =
	{
		TuningGarage:New(1041.3575439453, -1016.9569702148, 32.107528686523, 10, "Transfender Temple", 1035.8043212891, -1044.8853759766, 31.276628494263, 0, 0, 90, "transfender.jpg", 23, 166),
		TuningGarage:New(1043.8614501953, -911.669921875, 42.806991577148, nil, "Werkstatt BSN", 1070.5379638672, -885.89324951172, 43.581619262695, 0, 0, 0, "transfender.jpg", 23, 167),
		TuningGarage:New(-1935.9497070313, 246.07160949707, 34.498077392578, 18, "Werkstatt Doherty", -1953.3729248047, 222.47564697266, 33.201808929443, 0, 0, 90, "transfender.jpg", 23, 170),
		TuningGarage:New(-2721.9064941406, 217.21923828125, 4.484375, 15, "Wheel Archangels", -2686.6123046875, 212.60385131836, 4.328125, 0, 0, 90, "transfender.jpg", 23, 171),
		TuningGarage:New(2387.0102539063, 1052.9444580078, 10.8203125, 33, "Transfender CAL", 2394.2419433594, 1013.6850585938, 10.8203125, 0, 0, 0, "transfender.jpg", 23, 172),
		TuningGarage:New(1961.8618164063, -2629.8630371094, 13.552010536194, nil, "Helituning: WAA", 2034.6791992188, -2593.2006835938, 13.552010536194, 0, 0, -90, "transfender.jpg", 23, 171),
		TuningGarage:New(908.59606933594, -1952.6639404297, 0.87898629903793, nil, "Boottuning: WAA", 907.60650634766, -2119.2607421875, 6.5082068443298, 0, 0, 0, "transfender.jpg", 23, 171),
	}

	self.tuningTeilPreise = TuningTeilPreise:New();


	-- Methoden --
	self.exitFunc 	= function(...) self:ExitTuninggarage(...) end
	self.buyFunc 	= function(...) self:BuyTuningteil(...) end;
	self.sellFunc	= function(...) self:SellTuningteil(...) end;
	self.m_funcVariantPreview	= function(...) self:onVariantPreview(client, ...) end
	-- Events --
	addEvent("onPlayerExitTuningGarage", true);
	addEvent("onPlayerTuningteilKauf", true);
	addEvent("onPlayerTuningteilVerkauf", true);
	addEvent("onPlayerTuninggarageVariantPreview", true);

	addEventHandler("onPlayerExitTuningGarage", getRootElement(), self.exitFunc)
	addEventHandler("onPlayerTuningteilKauf", getRootElement(), self.buyFunc);
	addEventHandler("onPlayerTuningteilVerkauf", getRootElement(), self.sellFunc);
	addEventHandler("onPlayerTuninggarageVariantPreview", getRootElement(), self.m_funcVariantPreview)

--logger:OutputInfo("[CALLING] TuningGarageManager: Constructor");
end

-- EVENT HANDLER --
