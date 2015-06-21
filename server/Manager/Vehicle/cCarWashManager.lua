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
-- ## Name: CarWashManager.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

CarWashManager = {};
CarWashManager.__index = CarWashManager;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function CarWashManager:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// MoveGate	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CarWashManager:MoveGate(sGate, bBool)
	if(sGate == "entrance_1") then
		if(bBool == true) then
			moveObject(self.gates["entrance_1"], 1000, 2506.599609375, -1462.8994140625, 17.89999961853, 0, 0, 0, "InOutQuad")
			moveObject(self.gates["entrance_2"], 1000, 2506.599609375, -1457.5, 17.89999961853, 0, 0, 0, "InOutQuad")

		else
			moveObject(self.gates["entrance_1"], 1000, 2506.599609375, -1462.8994140625, 23.89999961853, 0, 0, 0, "InOutQuad")
			moveObject(self.gates["entrance_2"], 1000, 2506.599609375, -1457.5, 23.89999961853, 0, 0, 0, "InOutQuad")
		end
	elseif(sGate == "exit") then
		if(bBool == true) then
			moveObject(self.gates["exit"], 1000, 2446.5, -1454.7998046875, 16.799999237061, 0, 0, 0, "InOutQuad")
		else
			moveObject(self.gates["exit"], 1000, 2446.5, -1454.7998046875, 22.799999237061, 0, 0, 0, "InOutQuad")
		end
	end
end

-- ///////////////////////////////
-- ///// Enable		 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CarWashManager:Enable(uPlayer)
	if not(self.enabled == true) then
		self:MoveGate("entrance_1", true)
		self.enabled 		= true;

		self:CreateBlockEntranceMarkerForPlayer();


		self.resetTimer	= setTimer(function() self:CheckReset(uPlayer) end, 2*60*1000, 1);
	end
end

-- ///////////////////////////////
-- ///// BlockEntrance	 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CarWashManager:BlockEntrance()
	self:MoveGate("entrance_1", false)


	toggleControl(self.currentUser, "enter_exit", false);

	triggerClientEvent(self.currentUser, "onCarwashStart", self.currentUser)


	self:CreateExitMarkerForPlayer()
end

-- ///////////////////////////////
-- ///// EnableExit			//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CarWashManager:EnableExit()
	self:MoveGate("exit", true)

	self:CreateFinalExit()
end

-- ///////////////////////////////
-- ///// DisableExit		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CarWashManager:DisableExit()
	self:MoveGate("exit", false)

	toggleControl(self.currentUser, "enter_exit", true);

	self.currentUser:showInfoBox("info", "Dein Auto ist nun sauber!");
	Achievements[30]:playerAchieved(self.currentUser);

	self:Disable();
end

-- ///////////////////////////////
-- ///// CreateFinalExit	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CarWashManager:CreateFinalExit()

	self.finalExitMarker		= createMarker(2439.2517089844, -1460.9321289063, 24, "corona", 3.0, 0, 0, 0);

	addEventHandler("onMarkerHit", self.finalExitMarker, function(uElement)
		if(getElementType(uElement) == "vehicle") then
			if(uElement == getPedOccupiedVehicle(self.currentUser))  then
				self:DisableExit()

				destroyElement(self.finalExitMarker)
			end
		end
	end)
end

-- ///////////////////////////////
-- ///// CreateBlockEntranceMarkerForPlayer
-- ///// Returns: void		//////
-- ///////////////////////////////

function CarWashManager:CreateBlockEntranceMarkerForPlayer()

	setMarkerColor(self.exitCorona, 0, 0, 0, 255);
	setMarkerColor(self.enterCorona1, 0, 255, 0, 255);
	setMarkerColor(self.enterCorona2, 0, 255, 0, 255);

	self.blockEntranceMarker		= createMarker(2499.7233886719, -1460.3656005859, 24.015474319458, "corona", 3.0, 0, 0, 0);

	addEventHandler("onMarkerHit", self.blockEntranceMarker, function(uElement)
		if(getElementType(uElement) == "vehicle") and (getVehicleOccupant(uElement)) then
			self.currentUser	= getVehicleOccupant(uElement);
			self:BlockEntrance()
			destroyElement(self.blockEntranceMarker)
		end
	end)
end

-- ///////////////////////////////
-- ///// CreateeExitMarkerForPlayer
-- ///// Returns: void		//////
-- ///////////////////////////////


function CarWashManager:CreateExitMarkerForPlayer()

	getPedOccupiedVehicle(self.currentUser):setDirtLevel(0);
	getPedOccupiedVehicle(self.currentUser):save();

	setMarkerColor(self.exitCorona, 255, 0, 0, 255);
	setMarkerColor(self.enterCorona1, 0, 0, 0, 255);
	setMarkerColor(self.enterCorona2, 0, 0, 0, 255);

	self.blockExitMarker		= createMarker(2453.4877929688, -1461.1901855469, 24, "corona", 3.0, 0, 0, 0);

	addEventHandler("onMarkerHit", self.blockExitMarker, function(uElement)
		if(getElementType(uElement) == "vehicle") then
			if(uElement == getPedOccupiedVehicle(self.currentUser))  then
				self:EnableExit(self.currentUser)

				destroyElement(self.blockExitMarker)
			end
		end
	end)
end

-- ///////////////////////////////
-- ///// Disable	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CarWashManager:Disable()
	if(self.enabled == true) then


		if(isElement(self.currentUser)) then
			triggerClientEvent(self.currentUser, "onCarwashStop", self.currentUser)
		end

		self.enabled 	= false;
		self.currentUser = nil;

		setMarkerColor(self.exitCorona, 255, 0, 0, 255);
		setMarkerColor(self.enterCorona1, 0, 0, 0, 255);
		setMarkerColor(self.enterCorona2, 0, 0, 0, 255);


		if(isTimer(self.resetTimer)) then
			killTimer(self.resetTimer);
		end
	end
end

-- ///////////////////////////////
-- ///// Reset				//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CarWashManager:Reset()
	self:Disable();

	if(isElement(self.blockExitMarker)) then
		destroyElement(self.blockExitMarker);
	end

	if(isElement(self.blockEntranceMarker)) then
		destroyElement(self.blockEntranceMarker);
	end

	if(isElement(self.finalExitMarker)) then
		destroyElement(self.finalExitMarker);
	end

	self:MoveGate("entrance_1", false)
	self:MoveGate("exit", false)

end

-- ///////////////////////////////
-- ///// CheckReset 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CarWashManager:CheckReset(uPlayer)
	if(uPlayer == self.currentUser) then
		self:Reset()
	end
end

-- ///////////////////////////////
-- ///// MarkerHit	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CarWashManager:MarkerHit(uElement)
	if(getElementType(uElement) == "player") and (isPedInVehicle(uElement) == false) then
		if(self.enabled ~= true) and not (isElement(self.currentUser) and getElementType(self.currentUser) == "player") then
			if(uElement:getMoney() > self.preis) then
				local vehicle = getElementsWithinColShape(self.parkingCol, "vehicle")[1];
				if(vehicle) then
					if(getElementData(vehicle, "OwnerName") == getPlayerName(uElement)) then
						local einheitenCost;
						local biz = BusinessBizes[165];
						if(biz) then
							einheitenCost	= math.floor((self.preis)*biz:getLagereinheitenMultiplikator())

							if(biz:getLagereinheiten() >= einheitenCost) then
								canBuy 			= true;
								bizPurchase 	= true;
							else
								canBuy = false;
								self:showInfoBox("error", "Diese Waschanlage ist leer! Er muss erst wieder aufgefuellt werden. ("..einheitenCost..", "..biz:getLagereinheiten()..")")
							end
						end
						if(canBuy) then
							setPedAnimation(uElement, "VENDING", "VEND_Use", -1, false, false, false);
							setTimer(function()
								setPedAnimation(uElement);
								uElement:addMoney(-self.preis);
								self:Enable(uElement);
								uElement:showInfoBox("info", "-$"..self.preis.."!\nFahre nun mit deinem Auto in die Waschanlage!");
								-- Biz Purchase
								if(bizPurchase) then
									local businessGeld = math.floor(self.preis/2);
									biz:addLagereinheiten(-einheitenCost)
									if(biz:getCorporation() ~= 0) then
										biz:getCorporation():addSaldo(businessGeld);
									end
								end
								
							end, 2000, 1)
						end
					else
						uElement:showInfoBox("error", "Dein Auto wurde nicht in der Parkluecke erkannt!")
					end
				else
					uElement:showInfoBox("error", "Es wurde kein Fahrzeug in der Parkluecke erkannt!");
				end
			else
				uElement:showInfoBox("error", "Dafuer benoetigst du $"..self.preis.."!");
			end
		else
			uElement:showInfoBox("error", "Die Waschanlage wird momentan von "..getPlayerName(self.currentUser).." besetzt!");
		end
	end
end


-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CarWashManager:Constructor(...)

	-- Klassenvariablen --

	self.enabled	= true;

	self.gates		=
	{
		["entrance_1"] 	= createObject(988, 2506.599609375, -1462.8994140625, 23.89999961853, 0, 0, 90),
		["entrance_2"] 	= createObject(988, 2506.599609375, -1457.5, 23.89999961853, 0, 0, 90),
		["exit"]		= createObject(987, 2446.5, -1454.7998046875, 22.799999237061, 0, 0, 270),
	}


	self.exitCorona		= createMarker(2507.0666503906, -1465.8275146484, 26.035091400146, "corona", 0.5, 255, 0, 0);
	self.enterCorona1	= createMarker(2507.0666503906, -1465.5275146484, 25.035091400146, "corona", 0.5, 0, 0, 0);
	self.enterCorona2	= createMarker(2507.0666503906, -1466.1275146484, 25.035091400146, "corona", 0.5, 0, 0, 0);

	self.enterMarker	= createMarker(2508.1901855469, -1456.0286865234, 23.973415374756, "corona", 1.0, 0, 255, 0);

	self.parkingCol		= createColSphere(2512.1188964844, -1471.6975097656, 24.020885467529, 5);


	self.preis			= 250;

	self.markerHitFunc	= function(...) self:MarkerHit(...) end;

	self.currentUser = false;

	self.resetFunc		= function(...) self:CheckReset(source, ...) end;
	self.warpFunc		= function(uVehicle)
		if(self.currentUser == source) then
			warpPedIntoVehicle(self.currentUser, uVehicle);
		end
	end
	self.resetTimer	= false;

	-- X - 3 !!

	self:Disable();


	-- Methoden --

	addEventHandler("onPlayerQuit", getRootElement(), self.resetFunc);
	addEventHandler("onPlayerVehicleExit", getRootElement(), self.warpFunc)


	addEventHandler("onMarkerHit", self.enterMarker, self.markerHitFunc);

-- Events --

--logger:OutputInfo("[CALLING] CarWashManager: Constructor");
end

-- EVENT HANDLER --
