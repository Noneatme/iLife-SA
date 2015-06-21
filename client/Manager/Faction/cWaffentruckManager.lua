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
	if(uObject) and(type(uObject == "table")) and(uObject.getType) and (uObject:getType() == "object") then
		if(uObject:getModel() == 8330) then
			if(uObject:getData("wt:frame") == true) then
				if not(self.m_texturesReplaced[uObject]) then
					local s = FrameTextur:New(uObject, "eris_4", "objects/waffentruck.jpg", true)
					s:ApplyShader();

					self.m_texturesReplaced[uObject] = true;
				end
			end
		end
		if(uObject:getModel() == 1344) and not(self.m_uObjectDone[uObject]) then -- Muelltonne
			if(uObject:getData("wt:muelltonne") == true) then
				local uVehicle = uObject:getData("wt:uVehicle");
				if(uVehicle) and(isElement(uVehicle))then
					if not(uVehicle.getVelocity) then
						enew(uVehicle, CVehicle)
					end

					uObject:setMass(50);

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
	local pos       = uObject:getPosition(true);

	if not(self.m_uColShapes[uVehicle]) then
		self.m_uColShapes[uVehicle] = {};
		self.m_uColKisten[uVehicle] = {};
		self.m_uColIDS[uVehicle] = {};
		self.m_createEffects[uVehicle] = {};
		self.m_pickedUp[uVehicle] = {};
	end


	self.m_uColShapes[uVehicle][iID] = enew(createColSphere(pos:getX(), pos:getY(), pos:getZ(), 5), CColShape);
	self.m_uColShapes[uVehicle][iID]:attach(uObject);
	self.m_uColShapes[uVehicle][iID]:setData("wt:vehicle", uVehicle, false);

	self.m_uColKisten[uVehicle][self.m_uColShapes[uVehicle][iID]] = uObject;

	self.m_uColIDS[uVehicle][self.m_uColKisten[uVehicle][self.m_uColShapes[uVehicle][iID]]] = iID;

	self.m_createEffects[uVehicle][iID] = enew(createEffect("smoke50lit", pos:getX(), pos:getY(), pos:getZ()), CEffect);

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
				local pos = self.m_uColShapes[vehicle][id]:getPosition(true);

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
-- ///// showAbladeGUI 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cWaffentruckManager:event_showAbladeGUI(uVehicle, tick)
	if(self.abladeShowing) then

		self:event_hideAbladeGUI(uVehicle)
	end

	self.abladeGUI		= cWaffentruckStatusGUI:new();
	self.abladeGUI:show(uVehicle, tick);

	self.abladeShowing 	= true;
end

-- ///////////////////////////////
-- ///// hideAbladeGUI 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cWaffentruckManager:event_hideAbladeGUI(uVehicle)
	if(self.abladeShowing) then
		self.abladeGUI:hide()
		self.abladeShowing = false;
	end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cWaffentruckManager:constructor()
	-- Klassenvariablen --
	self.m_uObjectDone      = {};
	self.m_uColShapes       = {};
	self.m_uColKisten       = {};
	self.m_uColIDS          = {};

	self.m_pickedUp         = {};

	self.m_createEffects    = {};

	self.m_texturesReplaced = {};

	self.m_WaffentruckGUI   = cWaffentruckGUI:new();

	self.abladeShowing		= false;
	self.abladeGUI			= false;


	self.m_uDealerPed       = enew(createPed(183, Vector3(-2544.5532226563, 2353.0126953125, 4.984375), 0), CPed);
	self.m_uDealerPed:setAnimation("GANGS", "leanIDLE", -1, true, false, false, false);
	self.m_uDealerPed:setFrozen(true);


	self.m_uDealerPed2		= enew(createPed(183, Vector3(2591.8215332031, 2846.63671875, 10.8203125), 270), CPed);
	self.m_uDealerPed2:setFrozen(true);

	self.m_uColShape		=
	{
		enew(createColSphere(-2544.5532226563, 2353.0126953125, 4.984375, 2), CColShape),
		enew(createColSphere(2591.8215332031, 2846.63671875, 10.8203125, 2), CColShape),
	}


	for i = 1, 2, 1 do
		addEventHandler("onClientColShapeHit", self.m_uColShape[i], function(lp) if(lp == localPlayer) then
			triggerServerEvent("onWaffentruckGUIStart", localPlayer, i)
			cLoadingSprite:setEnabled(true);
		end end)
	end
	addEventHandler("onClientPedDamage", self.m_uDealerPed, cancelEvent);
	addEventHandler("onClientPedDamage", self.m_uDealerPed2, cancelEvent);

	enew(createMarker(-2544.5532226563, 2353.0126953125, 4.984375, "arrow", 0.5, 0, 255, 0, 255), CMarker):attach(self.m_uDealerPed, Vector3(0, -0.5, 1.5));
	enew(createMarker(2591.8215332031, 2846.63671875, 10.8203125, "arrow", 0.5, 0, 255, 0, 255), CMarker):attach(self.m_uDealerPed2, Vector3(0, -0.5, 1.5));


	--addCommandHandler("waffentruck", function(cmd, iAm)
	--	triggerServerEvent("onWaffentruckStart", localPlayer, tonumber(iAm))
	--end)

	-- Funktionen --
	self.func_checkWTCrates = function(...) self:event_checkWTCrates(source, ...) end;
	self.func_dropKiste     = function(...) self:event_dropKiste(source, ...) end
	self.func_KistenPickup  = function(...) self:event_pickupKiste(source, ...) end
	self.func_renderSparks  = function(...) self:event_renderSparks(...) end

	self.func_showWTAblade	= function(...) self:event_showAbladeGUI(...) end
	self.func_hideWTAblade	= function(...) self:event_hideAbladeGUI(...) end

--	setCameraClip(false, true);

	-- Events --
	addEvent("onClientWaffentruckKisteDrop", true);
	addEvent("onWaffentruckAbladungShow", true);
	addEvent("onWaffentruckAbladungHide", true);

	addEventHandler("onClientElementStreamIn", getRootElement(), self.func_checkWTCrates);
	addEventHandler("onClientWaffentruckKisteDrop", getRootElement(), self.func_dropKiste);

	addEventHandler("onWaffentruckAbladungShow", getLocalPlayer(), self.func_showWTAblade)
	addEventHandler("onWaffentruckAbladungHide", getLocalPlayer(), self.func_hideWTAblade)


	addEventHandler("onClientRender", getRootElement(), self.func_renderSparks);

	addEventHandler("onClientVehicleEnter", getRootElement(), function(uPlayer)
		if(uPlayer == localPlayer) and (getElementData(source, "wt:wt") == true) then
			setCameraClip(false, false)
		end
	end)
	addEventHandler("onClientVehicleExit", getRootElement(), function(uPlayer)
		if(uPlayer == localPlayer) and (getElementData(source, "wt:wt") == true) then
			setCameraClip(true, true)
		end
	end)


end


-- EVENT HANDLER --