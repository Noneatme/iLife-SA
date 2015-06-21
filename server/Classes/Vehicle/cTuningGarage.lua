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
-- ## Name: TuningGarage.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

TuningGarage = {};
TuningGarage.__index = TuningGarage;

--[[

]]

local tuningGarageID = 1;

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function TuningGarage:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// EnterPlayerGarage	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function TuningGarage:EnterPlayerGarage(uPlayer, uVehicle, iDistance)
	local uElements = {uPlayer, uVehicle};

	--self.dimension		= 5;
	self.dimension = getEmptyDimension();

	for index, ele in pairs(uElements) do
		setElementInterior(ele, self.interior);
		setElementDimension(ele, self.dimension);
	end


	setElementPosition(uVehicle, self.carPosition[1], self.carPosition[2], self.carPosition[3], false);
	setElementRotation(uVehicle, self.carPosition[4], self.carPosition[5], self.carPosition[6]);
	
	
	setElementFrozen(uVehicle, true);
	
	toggleAllControls(uPlayer, false)
--[[
	local health = getElementHealth(uVehicle)
	fixVehicle(uVehicle);
	setElementHealth(uVehicle, health)
--]]


	triggerClientEvent(uPlayer, "onClientPlayerEnterTuningGarage", uPlayer, self.id, self.interior, self.dimension, self.sLogo)
end

-- ///////////////////////////////
-- ///// ExitPlayerGarage	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function TuningGarage:ExitPlayerGarage(uPlayer)

	local uVehicle = getPedOccupiedVehicle(uPlayer);

	local uElements = {uPlayer, uVehicle};

	for index, ele in pairs(uElements) do
		setElementInterior(ele, 0);
		setElementDimension(ele, 0);
	end

	toggleAllControls(uPlayer, true)

	setElementPosition(uVehicle, self.ausgangsPosition[1], self.ausgangsPosition[2], self.ausgangsPosition[3])
	setElementRotation(uVehicle, self.ausgangsPosition[4], self.ausgangsPosition[5], self.ausgangsPosition[6])

	setCameraTarget(uPlayer, uPlayer)
	setElementFrozen(uVehicle, false);

	fadeCamera(uPlayer, true);
	if(getVehicleType(uVehicle) == "Bike") or (getVehicleType(uVehicle) == "BMX") or (getVehicleType(uVehicle) == "Quad") then
		warpPedIntoVehicle(uPlayer, uVehicle);
	end
end


-- ///////////////////////////////
-- ///// MarkerHit			//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function TuningGarage:MarkerHit(uElement)
	if(getElementType(uElement) == "vehicle") and (getVehicleOccupant(uElement)) then
		local uPlayer = getVehicleOccupant(uElement);
		if(uPlayer) then
			local uVehicle = getPedOccupiedVehicle(uPlayer);

			if(uVehicle.OwnerName) and (uVehicle.OwnerName == getPlayerName(uPlayer)) then
				if(#getVehicleOccupants(uVehicle) == 0) then
					fadeCamera(uPlayer, false);
					setTimer(function()
						if(getVehicleType(uVehicle) == "Bike") or (getVehicleType(uVehicle) == "BMX") or (getVehicleType(uVehicle) == "Quad") then
							warpPedIntoVehicle(uPlayer, uVehicle, 1);
						end
						self:EnterPlayerGarage(uPlayer, uVehicle);
					end, 1000, 1)
				else
					uPlayer:showInfoBox("error", "Dein Auto ist nicht leer!");

				end
			else
				uPlayer:showInfoBox("error", "Dieses Auto gehoert dir nicht!");
		
			end

		end
	end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function TuningGarage:Constructor(fX, fY, fZ, iGarage, sName, aX, aY, aZ, aRX, aRY, aRZ, sLogo, iChain, iFilliale)
	-- Klassenvariablen --
	self.fX 			= fX;
	self.fY 			= fY;
	self.fZ 			= fZ;
	self.iGarage 		= iGarage;
	self.sName			= sName;
	self.sLogo			= sLogo;
	
	self.iChain			= iChain;
	self.iFilliale		= iFilliale;

	self.ausgangsPosition = {aX, aY, aZ, aRX, aRY, aRZ}

	self.id 			= tuningGarageID;
	tuningGarageID		= tuningGarageID+1;

	self.interior 		= 17;
	self.carPosition 	= {4645.3178710938, 612.74725341797, 796.22052001953, 0, 0, -180};

	self.blip 			= createBlip(fX, fY, fZ, 27)

	if(self.iGarage) then
		setGarageOpen(self.iGarage, true);
	end

	self.marker 		= createMarker(fX, fY, fZ, "corona", 2.0, 0, 255, 255, 255);

	-- Methoden --
	self.markerHitFunc	= function(...) self:MarkerHit(...) end;
	--addCommandHandler("enterdat", function(thePlayer)
	--	self:EnterPlayerGarage(thePlayer, getPedOccupiedVehicle(thePlayer));
	--end)
	-- Events --
	addEventHandler("onMarkerHit", self.marker, self.markerHitFunc);

--logger:OutputInfo("[CALLING] TuningGarage: Constructor");
end

-- EVENT HANDLER --
