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
-- Time: 11:30
-- Project: MTA iLife
--

cWaffentruckManager = {};

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function cWaffentruckManager:new(...)
	local obj = setmetatable({}, {__index = self});
	if obj.constructor then
		obj:constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// CheckWTCrates		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cWaffentruckManager:event_checkWTCrates(uObject)
	if(uObject) and (uObject:getType() == "object") then
		if(uObject:getModel() == 1344) and not(self.m_uObjectDone[uObject]) then -- Muelltonne
			if(uObject:getData("wt:muelltonne") == true) then
				local uVehicle = uObject:getData("wt:uVehicle");
				if(uVehicle) and(isElement(uVehicle))then
					uObject:setMass(1);

					local vX, vY, vZ = uVehicle:getVelocity();
					uObject:setVelocity(vX, vY, vZ)

					self.m_uObjectDone[uObject] = true;
				end
			end
		end
	end
end

-- ///////////////////////////////
-- ///// DropKiste   		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cWaffentruckManager:event_dropKiste(uObject, uVehicle, iID)
	local pos       = uObject:getPosition();

	if not(self.m_uColShapes[uVehicle]) then
		self.m_uColShapes[uVehicle] = {};
		self.m_uColKisten[uVehicle] = {};
		self.m_uColIDS[uVehicle] = {};
		self.m_createEffects[uVehicle] = {};
		self.m_pickedUp[uVehicle] = {};
	end


	self.m_uColShapes[uVehicle][iID] = createColSphere(pos:getX(), pos:getY(), pos:getZ(), 5);
	self.m_uColShapes[uVehicle][iID]:attach(uObject);
	self.m_uColShapes[uVehicle][iID]:setData("wt:vehicle", uVehicle, false);

	self.m_uColKisten[uVehicle][self.m_uColShapes[uVehicle][iID]] = uObject;

	self.m_uColIDS[uVehicle][self.m_uColKisten[uVehicle][self.m_uColShapes[uVehicle][iID]]] = iID;

	self.m_createEffects[uVehicle][iID] = Effect("smoke50lit", pos:getX(), pos:getY(), pos:getZ());

	addEventHandler("onClientColShapeHit", self.m_uColShapes[uVehicle][iID], self.func_KistenPickup);
	addEventHandler("onClientElementDestroy", uObject, function()
		self.m_uColShapes[uVehicle][iID]:destroy();
	end)
end

-- ///////////////////////////////
-- ///// RenderSparks 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cWaffentruckManager:event_renderSparks()
	for vehicle, kisten in pairs(self.m_createEffects) do
		for id, effect in pairs(kisten) do
			if(isElement(self.m_uColShapes[vehicle][id])) then
				local pos = self.m_uColShapes[vehicle][id]:getPosition();

				effect:setPosition(pos);
			else
				self.m_createEffects[vehicle][id] = nil;
				effect:destroy();
			end
		end
	end
end

-- ///////////////////////////////
-- ///// PuckupKiste 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////
--[[
Folgende Logik steckt dahinter:
- Waffentruck wird erstellt mit 10 Kisten.
-> Falls eine Kiste runterfaellt, wird sie Serverseitig erstellt und Clientseitig Sychronisiert.
-> Falls ein User die Kiste bei seinem Clienten aufhebt mit einer Clientseitigen Colshape, wird die Kiste Serverseitig geloescht.
-> Bei jeden Spieler ist nun die Kiste weg.

 ]]

function cWaffentruckManager:event_pickupKiste(uKiste, uPlayer, bDim)
	if(bDim) then
		if(uPlayer == localPlayer) then
			if(isElement(uKiste)) then
				local vehicle = uKiste:getData("wt:vehicle");
				if not(self.m_pickedUp[vehicle][uKiste]) then
					triggerServerEvent("onWaffentruckKistePickup", self.m_uColKisten[vehicle][uKiste], self.m_uColIDS[vehicle][self.m_uColKisten[vehicle][uKiste]]);
					self.m_pickedUp[vehicle][uKiste] = true; -- Kleiner Check um Event-Spams zu verhindern. Ist egal, hat nichts mit der Sicherheit zu tun.
				end
			end
		end
	end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cWaffentruckManager:constructor(...)
	-- Klassenvariablen --
	self.m_uObjectDone      = {};
	self.m_uColShapes       = {};
	self.m_uColKisten       = {};
	self.m_uColIDS          = {};

	self.m_pickedUp         = {};

	self.m_createEffects    = {};

	self.m_uDealerPed       = Ped(183, Vector3(-2544.5532226563, 2353.0126953125, 4.984375), 0);
	self.m_uDealerPed:setAnimation("GANGS", "leanIDLE", -1, true, false, false, false);
	self.m_uDealerPed:setFrozen(true);
	addEventHandler("onClientPedDamage", self.m_uDealerPed, cancelEvent);
	Marker(-2544.5532226563, 2353.0126953125, 4.984375, "arrow", 0.5, 0, 255, 0, 255):attach(self.m_uDealerPed, Vector3(0, -0.5, 1.5));


	addCommandHandler("waffentruck", function(cmd, iAm)
		triggerServerEvent("onWaffentruckStart", localPlayer, tonumber(iAm))
	end)

	-- Funktionen --
	self.func_checkWTCrates = function(...) self:event_checkWTCrates(source, ...) end;
	self.func_dropKiste     = function(...) self:event_dropKiste(source, ...) end
	self.func_KistenPickup  = function(...) self:event_pickupKiste(source, ...) end
	self.func_renderSparks  = function(...) self:event_renderSparks(...) end

	setCameraClip(false);

	-- Events --
	addEvent("onClientWaffentruckKisteDrop", true);

	addEventHandler("onClientElementStreamIn", getRootElement(), self.func_checkWTCrates);
	addEventHandler("onClientWaffentruckKisteDrop", getRootElement(), self.func_dropKiste);

	addEventHandler("onClientRender", getRootElement(), self.func_renderSparks);
end


-- EVENT HANDLER --


cWaffentruckManager:new();
