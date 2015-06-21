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
-- ## Name: ObjectMover.lua				##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

ObjectMover = {};
ObjectMover.__index = ObjectMover;

addEvent("onObjectMoverSoundPlay", true);

--[[

Neue IDS:

-- AUSSENOBJEKTE --
1209 	- Sodaautomat
1343	- Muelltonne 1
1334	- Muelltonne 2
1349	- Einkaufswagen
1346	- Telefonhaus

-- POLIZEI --
1459	- Sperre 1
1423	- Sperre 2
1422	- Sperre 3
1427	- Sperre 4
3091	- Sperre 5
1252	- C4


-- KAUFBARE --
627		- Palme 2
651		- Kaktus



-- INNENOBJEKTE --
-- DEKO --
630		- Palme 3
2252	- Blumentopf 3
2253	- Blumentopf 4
2245	- Blumentopf 5
2811	- Blumentopf 6



-- HAUSHALTSGERAETE --
2361	- Tiefkuehltruhe

-- WOHNZIMMER --
2091	- TV Einheit 3



]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function ObjectMover:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// RenderSpinObject	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function ObjectMover:RenderSpinObject()
	for object, bool in pairs(self.doObjectScale) do
		if(isElement(object)) then
			local add 	= 0.020/self.FPS*60;
			if(bool == true) then
				self.objectScale[object] = self.objectScale[object]+add

				if(self.objectScale[object] > self.maxScale) then
					self.objectScale[object] = self.maxScale
				end
				setObjectScale(object, self.objectScale[object])
			else

				self.objectScale[object] = self.objectScale[object]-add

				if(self.objectScale[object] < 1) then
					self.objectScale[object] = 1
				end
				setObjectScale(object, self.objectScale[object])
			end
		else
			self.doObjectScale	= {}
		end
	end
end

-- ///////////////////////////////
-- ///// SpinObject			//////
-- ///// Returns: void		//////
-- ///////////////////////////////
-- AADLI Easter Egg :D

function ObjectMover:SpinObject(uObject)
	if not(self.objectSpinning[uObject]) then

		local x, y, z 		= getElementPosition(uObject)
		local rx, ry, rz 	= getElementRotation(uObject)
		local modell		= getElementModel(uObject);
		local colObj 		= createObject(modell, x, y, z, rx, ry, rz)
		setElementAlpha(colObj, 0)
		setObjectScale(colObj, 0);
		setTimer(destroyElement, 2000, 1, colObj);

		setElementCollisionsEnabled(uObject, false)
		self.objectSpinning[uObject] = true;
		local maxTime = 1100;
		local parts	  = 4;

		local timePerPart	= maxTime/parts;

		local currentTime	= 0;

		local add	=
		{
			[1] = {10, 25, 90, "InQuad", true},
			[2] = {0, 25, 90, "Linear", true},
			[3] = {0, -25, 90, "Linear", false},
			[4] = {-10, -25, 90, "OutQuad", false},
		}

		self.doObjectScale[uObject] = false;
		self.objectScale[uObject] = 1;
		local oldrx, oldry, oldrz 	= getElementRotation(uObject);

		local x, y, z 	= getElementPosition(uObject);
		local s 		= playSound3D(self.pfade.sounds.."obj_default_action.mp3", x, y, z)
		setSoundMaxDistance(s, 50)
		setElementInterior(s, getElementInterior(localPlayer));
		setElementDimension(s, getElementDimension(localPlayer))
		for i = 1, parts, 1 do

			local x, y, z 		= getElementPosition(uObject);
			local rx, ry, rz 	= getElementRotation(uObject);

			local newRX, newRY, newRZ	= add[i][1], add[i][2], add[i][3]
			local wat			= add[i][4]

			if(currentTime < 1) then
				moveObject(uObject, timePerPart, x, y, z, newRX, newRY, newRZ, wat)
			else
				setTimer(function()
					if(isElement(uObject)) then
						moveObject(uObject, timePerPart, x, y, z, newRX, newRY, newRZ, wat);
						if(i < 3) then
							self.doObjectScale[uObject] = true;
						else
							self.doObjectScale[uObject] = false;
						end
					end
				end, currentTime, 1)

			end
			currentTime	= currentTime+timePerPart;

		end

		setTimer(function()
			if(isElement(uObject)) then
				stopObject(uObject)
				self.objectSpinning[uObject] = false
				setElementRotation(uObject, oldrx, oldry, oldrz)
				setObjectScale(uObject, 1)
				setElementCollisionsEnabled(uObject, true)
			end
		end, maxTime, 1);
	end
end

-- ///////////////////////////////
-- ///// CancelObjectMoving	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function ObjectMover:CancelMoving()
	if(self.currentlyMoving == true) then
		self:StopObjectMoving();
		self.currentlyMoving 	= false;

		setElementPosition(self.movingObject, unpack(self.oldPosition));
		setElementRotation(self.movingObject, unpack(self.oldRotation));

		showCursor(false);

		clientBusy = false;

		local x, y, z = getElementPosition(self.movingObject);
		local rx, ry, rz = getElementRotation(self.movingObject);

		triggerServerEvent("onClientObjectMovingDone", localPlayer, x, y, z, rx, ry, rz, false);

		self.movingObject = false;

		setTimer(function()
			self.renderObject		= false;
			self.fadeAlpha			= 0;
		end, 1000, 1)
	end
end

-- ///////////////////////////////
-- ///// StopObjectMoving	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function ObjectMover:StopObjectMoving()
	setElementFrozen(self.movingObject, false)
	setElementCollisionsEnabled(self.movingObject, true);

	setTimer(function()
		self.renderObject		= false;
		self.fadeAlpha			= 0;
	end, 1000, 1)
end

-- ///////////////////////////////
-- ///// StartObjectMoving	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function ObjectMover:StartObjectMoving(uElement)
	-- Fehlervermeidung
	if(isElement(uElement)) then
		-- Wenn man noch kein Objekt bewegt
		if(self.currentlyMoving == false) then

			-- Tut man es spaetestens hier
			self.fadeAlpha			= 0;
			self.z					= 0;

			self.currentlyMoving 	= true;
			self.movingObject		= uElement;

			self.oldPosition		= {getElementPosition(uElement)};
			self.oldRotation		= {getElementRotation(uElement)};
			-- Lade Rotation
			self.rX, self.rY, self.rZ	= getElementRotation(uElement);
			self.renderObject = self.movingObject;

			-- Setze Attribute
			setElementFrozen(self.movingObject, true)
			setElementCollisionsEnabled(self.movingObject, false);


			if((#getElementsByType("object", getRootElement(), true)) >= 450) then
				showInfoBox("warning", "Es sind zu viele Objekte in der Naehe, dein Objekt koennte nicht angezeigt werden!");
			end
			-- Trigger Event
			triggerServerEvent("onClientObjectMovingStart", localPlayer, self.movingObject);
			clientBusy = true;

		end
	end
end

-- ///////////////////////////////
-- ///// RenderObject		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function ObjectMover:RenderObject()
	-- Wenn das Objekt noch da ist


	if(isElement(self.movingObject)) then
		showCursor(true);

		-- Bildschirmgroesse und Position bekommen
		local iSX, iSY 	= guiGetScreenSize()
		local iX, iY 	= getCursorPosition();

		-- Konvertieren in Absolute Koordinaten
		iX = iX*iSX;
		iY = iY*iSY;

		-- Konvertierung der Screen-Koordinaten in Welt-Kooordinaten
		local wX, wY, wZ = getWorldFromScreenPosition(iX, iY, 50);

		setElementRotation(self.movingObject, self.rX, self.rY, self.rZ);


		-- Wenn welche Vorhanden sind...
		if(wX and wY and wZ) and not(self.m_bRotMode) then
			-- Spielerposition
			local pX, pY, pZ 			= getCameraMatrix()

			-- Und die hitposition nehmen
			local lX, lY, lZ			= getElementPosition(localPlayer);
			local bHit, iHX, iHY, iHZ 	= processLineOfSight(wX, wY, wZ, pX, pY, pZ, true, true, false)

			--	dxDrawLine3D(wX, wY, wZ, pX+2, pY, pZ, tocolor(255, 255, 255, 200), 5, false);

			if(self.canPlaceSound == false) then
				if(self.canPlace == false) then
					playSound(self.pfade.sounds.."obj_error.mp3", false);
					self.canPlaceSound = true;
				end
			else
				if(self.canPlace == true) then
					self.canPlaceSound = false;
				end
			end
			-- Wenn ein Hitpunkt gefunden wurde
			if(bHit) and (iHX) and (iHY) and (iHZ) and (getDistanceBetweenPoints3D(lX, lY, lZ, iHX, iHY, iHZ) < 25) then
				-- Ground Position
				if((iHX) and (iHY) and (iHZ)) then
					local x, y, z = getElementPosition(self.movingObject)

					local hit, hitX, hitY, hitZ = processLineOfSight(x, y, z+0.5, x, y, z-100, true, true, true, true, true, false, false, false, self.movingObject)

					--	if(getElementInterior(localPlayer) == 0) then
					if(hit) and (z-hitZ > 10) then
						hitZ = z
					else
						if(hit) then
							hitZ = hitZ+getElementDistanceFromCentreOfMassToBaseOfModel(self.movingObject)

							if(getElementModel(self.movingObject) == 1772) then
								hitZ = hitZ-2.3;
							end
						end
					end

					if not(hitZ) then
						hitZ = iHZ;
					end

					hitZ = hitZ+self.z

					--	else
					--			hitZ = iHZ;
					--		hitZ = hitZ+getElementDistanceFromCentreOfMassToBaseOfModel(self.movingObject)

					--	end

					setElementPosition(self.movingObject, iHX, iHY, hitZ);
					self.canPlace = true;
				end

			else
				--[[
				-- Andererseits
				if(wX and wY and wZ) then
				-- Auch noch
				self.canPlace = true;
				setElementPosition(self.movingObject, wX, wY, wZ);
				else

				end]]
				self.canPlace = false;

			end

			-- Render
			local x, y, z		= getElementPosition(self.movingObject);

			if(iHZ) then
				dxDrawLine3D(x, y, z, x, y, iHZ, tocolor(255, 0, 0, 200), 1, false)
				dxDrawLine3D(x, y-1, iHZ, x, y+1, iHZ, tocolor(0, 255, 0, 200), 1, false)
				dxDrawLine3D(x+1, y, iHZ, x-1, y, iHZ, tocolor(0, 255, 0, 200), 1, false)
			end
		else
			if(self.m_bRotMode) then
				local x, y, z		= getElementPosition(self.movingObject);
				local rx, ry, rz	= self.movingObject:getRotation()
				local sx, sy = getScreenFromWorldPosition(x, y, z+1, 100)
				if(sx) and (sy) then
					dxDrawText("Rotation: "..rx..", "..ry..", "..rz, sx, sy, sx, sy, tocolor(0, 255, 0, 200), 1, "default-bold", "center", "center")
				end
			end
			self.canPlace = false;
		end
	end

	if(self.lastTick-getTickCount() >= 1000) then
		self.FPS 		= self.tempFPS;
		self.tempFPS	= 0;
		self.lastTick	= getTickCount()
	else
		self.tempFPS	= self.tempFPS+1;
	end


	if(isElement(self.renderObject)) then
		local osx, osy, osz = getElementPosition(self.renderObject);
		local ostx, osty = getScreenFromWorldPosition(osx, osy, osz);

		if(ostx and osty) then
			-- DxText
			if not(self.fadeAlpha) then
				self.fadeAlpha = 0;
			else
				if(self.currentlyMoving == true) then
					if(self.fadeAlpha < 240) then
						self.fadeAlpha = self.fadeAlpha+10;
					end
				else
					if(self.fadeAlpha > 0) then
						self.fadeAlpha = self.fadeAlpha-10;
					end
				end
			end
			dxDrawText("Rechte Maustaste zum abbrechen,\nMausrad zum Drehen des Objektes.", ostx-2, osty-2, ostx-2, osty-2, tocolor(0, 0, 0, self.fadeAlpha), 1, "default-bold", "center", "center")
			dxDrawText("Rechte Maustaste zum abbrechen,\nMausrad zum Drehen des Objektes.", ostx, osty, ostx, osty, tocolor(0, 255, 0, self.fadeAlpha), 1, "default-bold", "center", "center")
		end
	end
end

-- ///////////////////////////////
-- ///// IsObjectMoveable	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function ObjectMover:IsObjectMoveable(uElement)
	-- Element Datas erhalten
	local sAllowed 			= getElementData(uElement, "wa:CurrentMoving");
	local sMovingAllowed	= getElementData(uElement, "wa:MovingAllowed");
	local sOwner			= tonumber(getElementData(uElement, "wa:Owner"));
	local sFraktion			= "-";
	-- Fraktion hier Eintragen

	-- Wenn der Spieler online ist und es jemand schon Kontrolliert
	if(sAllowed) and (getPlayerFromName(sAllowed)) then
		-- Nope
		return 1, sAllowed;
	else
		-- Andererseits wenn man in der Fraktion ist
		if (sOwner == tonumber(getElementData(localPlayer, "p:ID"))) then
			-- Jawoll
			return 0;
		elseif((sOwner == tonumber(getElementData(localPlayer, "p:Fraktion"))) and tonumber(getElementData(localPlayer, "p:Rank")) >= 4) then
			-- Jawoll
			return 0;
		elseif(getElementData(localPlayer, "Adminlevel") > 2) then	-- Admin
			return 0;
		else
			-- Andererseits nope.
			return 2;
		end
	end

end

-- ///////////////////////////////
-- ///// IsElementSaved		//////
-- ///// Returns: bool		//////
-- ///////////////////////////////

function ObjectMover:IsElementSaved()
	for index, marker in pairs(getElementsByType("colshape", getRootElement(), true)) do
		local iOwner			= getElementData(marker, "h:iOwner2");
		local iObjektDistanz	= getElementData(marker, "h:iObjektDistanz");


		local FactionID			= (getElementData(marker, "faction:ID") or tonumber(getElementData(marker, "h:iFactionID")));

		local FactionDistance	= (tonumber(getElementData(marker, "faction:Distanz")) or 60)


		if(iOwner and iObjektDistanz) or ((FactionID) and (FactionID == tonumber(getElementData(localPlayer, "p:Fraktion")) and (tonumber(getElementData(localPlayer, "p:Rank")) >= 4))) then
			local x1, y1, z1 = getElementPosition(marker);
			local x2, y2, z2 = getElementPosition(self.movingObject);

			if(FactionID and FactionDistance) then
				if(getDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2) <= FactionDistance) then
					return true;
				end
			else
				if(getDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2) <= iObjektDistanz) and (tonumber(getElementData(localPlayer, "p:ID")) == tonumber(iOwner)) then
					return true;
				end
			end
		end
	end
	return false;
end

-- ///////////////////////////////
-- ///// PickUpElement		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function ObjectMover:PickUpElement(uObject)
	triggerServerEvent("onClientObjectMovingPickUp", localPlayer, uObject);
end

-- ///////////////////////////////
-- ///// PlayClickSound		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function ObjectMover:PlayClickSound()
	playSound(self.pfade.sounds.."obj_action.mp3", false);
end


-- ///////////////////////////////
-- ///// PerformObjectAction//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function ObjectMover:PerformObjectAction(uElement, iWas)
	local needAllowed	= {[1463] = true, [1481] = true, [1209] = false, [2969] = true, [1772] = true};

	local model 		= getElementModel(uElement)
	local allowed 		= false;
	if(needAllowed[model]) and (needAllowed[model] == true) or (self.radioModels[model]) then
		if(iWas == 0) then
			allowed = true;
		end
	else
		allowed = true;
	end
    if(getElementData(localPlayer, "Adminlevel")) and (tonumber(getElementData(localPlayer, "Adminlevel")) > 3) then
        allowed = true
    end

	if(allowed == true) then
		if(self.radioModels[getElementModel(uElement)]) then
			self.radioGui:BuildGui(uElement);
		elseif(getElementModel(uElement) == 1463) then	-- Holz
			triggerServerEvent("onMoveableObjectExtraToggle", localPlayer, uElement, 1, "feuer")
			self:PlayClickSound();

		elseif(getElementModel(uElement) == 1481) then	-- Grill
			triggerServerEvent("onMoveableObjectExtraToggle", localPlayer, uElement, 2, "rauch")
			self:PlayClickSound();

		elseif(getElementModel(uElement) == 1209) then	-- Soda
			triggerServerEvent("onMoveableObjectExtraToggle", localPlayer, uElement, 3)
		elseif(self.toiletModels[model]) then			-- Toilette
			triggerServerEvent("onMoveableObjectExtraToggle", localPlayer, uElement, 4)
		elseif(getElementModel(uElement) == 3013) then -- Geldschachtel
			triggerServerEvent("onClientGeldschachtelOpen", localPlayer, uElement)
		elseif(getElementModel(uElement) == 2046) then -- Waffenschrank
			triggerServerEvent("onClientWaffenschrankOpen", localPlayer, uElement)
		elseif(getElementModel(uElement) == 2969) then -- StorageBox
			triggerServerEvent("onClientStorageBoxOpen", localPlayer, uElement)
		elseif(getElementModel(uElement) == 1286) then -- SAT Zeitungsstand
			triggerServerEvent("onPlayerZeitungKauf", localPlayer)
		elseif(getElementModel(uElement) == 2453) then -- SAT Zeitungsstand
			triggerServerEvent("onMoveableObjectExtraToggle", localPlayer, uElement, 3)
		elseif(getElementModel(uElement) == 1772) then -- Radarfalle
			triggerServerEvent("onMoveableObjectExtraToggle", localPlayer, uElement, 5)
		elseif(getElementModel(uElement) == 17950) then -- Garage
			triggerServerEvent("onMoveableObjectExtraToggle", localPlayer, uElement, 6)
		else
			if(getElementData(uElement, "wa:OwnerName")) then
				self:SpinObject(uElement);
			else
				showInfoBox("error", "Dieses Objekt hat keine Aktion!");
			end
		end
	else
		showInfoBox("error", "Du hast keine Berechtigung dieses Objekt zu benutzen!");
	end
end

-- ///////////////////////////////
-- ///// ToggleGuiAction	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function ObjectMover:ToggleGuiAction(sAction, uElement)
	if(clientBusy ~= true) then
		if(self.currentlyMoving == false) then

			if(sAction == "move") then
				if(uElement) and (getElementData(uElement, "wa:Owner")) then
					-- Wenn es ein erlaubtes Element ist
					if(self.elementsToCheck[getElementType(uElement)]) then
						-- Abfrage ob es gerade angehieft wird
						local iWas, sSonstNochWas = self:IsObjectMoveable(uElement)
						if(iWas == 0) then
							self:StartObjectMoving(uElement);

						elseif(iWas == 1) then
							-- Nein, wird von %s Kontrolliert
							showInfoBox("error", "Dieses Objekt wird momentan verwendet!");

						elseif(iWas == 2) then
							-- Nein, keine Rechte
							showInfoBox("error", "Dieses Objekt darfst du nicht verschieben/benutzen!");
						end
					end
				end

			elseif(sAction == "pickup") then
				if(uElement) and (getElementData(uElement, "wa:Owner")) then
					-- Wenn es ein erlaubtes Element ist
					if(self.elementsToCheck[getElementType(uElement)]) then
						local iWas, sSonstNochWas = self:IsObjectMoveable(uElement)
						if(iWas == 0) then
							-- Ja, Erlauben
							self:PickUpElement(uElement);
						elseif(iWas == 1) then
							-- Nein, wird von %s Kontrolliert
							showInfoBox("error", "Dieses Objekt wird momentan verwendet!");

						elseif(iWas == 2) then
							-- Nein, keine Rechte
							-- Scheiss drauf, wird Serverseitig abgefragt
							self:PickUpElement(uElement);
						end
					end
				end
			elseif(sAction == "interact") then
				local iWas, sSonstNochWas = self:IsObjectMoveable(uElement)
				self:PerformObjectAction(uElement, iWas);
			end
		end
	end
end

-- ///////////////////////////////
-- ///// MouseClick			//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function ObjectMover:MouseClick(sButton, sState, iAX, iAY, iX, iY, iZ, uElement)
	-- Linker Knopf und Runter gedrueckt

	if(sButton == "left") and (sState == "down") then
		-- Wenn man momentan ein Objekt NICHT Bewegt
		if(self.currentlyMoving == false) then
			if(getKeyState("lalt") == true) then
				self:ToggleGuiAction("interact", uElement)
			else
				self:ToggleGuiAction("move", uElement)

			end
			--[[
			if(clientBusy ~= true) then
			-- Wenn ein Element geklickt wurde
			if(uElement) and (getElementData(uElement, "om:Owner")) then
			-- Wenn es ein erlaubtes Element ist
			if(self.elementsToCheck[getElementType(uElement)]) then
			-- Abfrage ob es gerade angehieft wird
			local iWas, sSonstNochWas = self:IsObjectMoveable(uElement)
			if(getKeyState("lalt") == true) then
			self:PerformObjectAction(uElement, iWas);
			else
			if(iWas == 0) then
			self:StartObjectMoving(uElement);

			elseif(iWas == 1) then
			-- Nein, wird von %s Kontrolliert
			showInfoBox("error", "Dieses Objekt wird momentan verwendet!");

			elseif(iWas == 2) then
			-- Nein, keine Rechte
			showInfoBox("error", "Dieses Objekt darfst du nicht verschieben/benutzen!");
			end
			end
			end
			end
			end]]
		else
			-- Andererseits
			-- Wenn man die Abstellposition hat
			iX, iY, iZ = getElementPosition(self.movingObject)
			if(iX and iY and iZ) then

				local saved = self:IsElementSaved();


				-- Objekt vom Speicher loeschen
				self:StopObjectMoving();
				self.m_funcRotUp();
				self.movingObject = nil;
				self.currentlyMoving = false;
				showCursor(false);

				-- Server Event triggern

				triggerServerEvent("onClientObjectMovingDone", localPlayer, iX, iY, iZ, self.rX, self.rY, self.rZ, saved);
				clientBusy = false;
			end
		end
		-- Andererseits
	elseif(sButton == "right") and (sState == "down") then
		if(self.currentlyMoving == true) then
			-- Moven Abbrechen
			self:CancelMoving();
		else
		--[[
		if(uElement) and (getElementData(uElement, "om:Owner")) then
		-- Wenn es ein erlaubtes Element ist
		if(self.elementsToCheck[getElementType(uElement)]) then
		local iWas, sSonstNochWas = self:IsObjectMoveable(uElement)
		if(iWas == 0) then
		-- Ja, Erlauben
		self:PickUpElement(uElement);
		elseif(iWas == 1) then
		-- Nein, wird von %s Kontrolliert
		showInfoBox("error", "Dieses Objekt wird momentan verwendet!");

		elseif(iWas == 2) then
		-- Nein, keine Rechte
		-- Scheiss drauf, wird Serverseitig abgefragt
		self:PickUpElement(uElement);
		end
		end
		end]]
		end
	end
end

-- ///////////////////////////////
-- ///// RotateLeft			//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function ObjectMover:RotateLeft(...)
	if(self.currentlyMoving == true) then
		local increm = 3
		if(getKeyState("lshift")) then
			increm = 10;
		end
		if(getKeyState("lalt")) then
			increm = 1;
		end
		self.rZ = self.rZ+increm;
	end
end

-- ///////////////////////////////
-- ///// RotateRight		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function ObjectMover:RotateRight(...)
	if(self.currentlyMoving == true) then
		local increm = 3
		if(getKeyState("lshift")) then
			increm = 10;
		end
		if(getKeyState("lalt")) then
			increm = 1;
		end
		self.rZ = self.rZ-increm;
	end
end

-- ///////////////////////////////
-- ///// PageUp				//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function ObjectMover:pageUp(...)
	if(self.currentlyMoving == true) then
		local increm = 0.2
		if(getKeyState("lshift")) then
			increm = 0.5;
		end
		if(getKeyState("lalt")) then
			increm = 0.05;
		end
		self.z = self.z+increm;

		if(self.z > 5) then
			self.z = 5
		end
	end
end
-- ///////////////////////////////
-- ///// PageUp				//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function ObjectMover:pageDown(...)
	if(self.currentlyMoving == true) then
		local increm = 0.2
		if(getKeyState("lshift")) then
			increm = 0.5;
		end
		if(getKeyState("lalt")) then
			increm = 0.05;
		end
		self.z = self.z-increm;

		if(self.z < -5) then
			self.z = -5
		end
	end
end
-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function ObjectMover:Constructor(...)
	-- Klassenvariablen --
	-- Element Datas:
	-- om:CurrentMoving	-> String
	-- om:MovingAllowed	-> String
	self.currentlyMoving	= false;
	self.movingObject		= false;
	self.canPlace			= false;

	self.oldPosition		= {}

	self.rX					= 0;
	self.rY					= 0;
	self.rZ					= 0;

	self.z					= 0;

	self.radioGui 			= RadioGui:New();
	self.geldschachtelGUI 	= GeldschachtelGUI:New();
	self.waffenschrankGUI	= WaffenschrankGUI:New();
	self.storageBoxGUI		= StorageBoxGUI:New();


	self.radioModels		= {[2103] = true, [1809] = true, [1212] = true, [2104] = true, [2102] = true, [2099] = true};
	self.toiletModels		= {[2738] = true, [2528] = true, [2525] = true, [2521] = true, [2514] = true};

	-- Elements to Check
	self.elementsToCheck 	=
	{
		["object"] = true,
	}

	self.pfade				= {};
	self.pfade.sounds		= "res/sounds/object/";

	self.objectSpinning		= {};

	self.canPlaceSound		= false;
	self.objectScale		= {};
	self.doObjectScale		= {}
	self.maxScale			= 2;

	self.FPS				= 60;
	self.lastTick			= getTickCount()
	self.tempFPS			= 0;

	-- Methoden --
	self.mouseClickFunc		= function(...) self:MouseClick(...) end;
	self.renderFunc			= function(...) self:RenderObject(...) self:RenderSpinObject(...) end;


	self.rotateLeftFunc		= function(...) self:RotateLeft(...) end;
	self.rotateRightFunc	= function(...) self:RotateRight(...) end;

	self.pageUpFunc			= function(...) self:pageUp(...) end
	self.pageDownFunc		= function(...) self:pageDown(...) end



	self.playSoundFunc		= function(a) playSound(self.pfade.sounds..a, false) end;

	-- Events --
	addEventHandler("onClientClick", getRootElement(), self.mouseClickFunc)

	addEventHandler("onClientRender", getRootElement(), self.renderFunc)

	addEventHandler("onObjectMoverSoundPlay", getRootElement(), self.playSoundFunc);

	bindKey("mouse_wheel_up", "down", self.rotateLeftFunc);
	bindKey("mouse_wheel_down", "down", self.rotateRightFunc);

	bindKey("pgup", "down", self.pageUpFunc);
	bindKey("pgdn", "down", self.pageDownFunc);

	self.m_bRotMode		= false;

	self.m_lastCX, self.m_lastCY = 0, 0;


	self.m_funcMoveCursor = function(_, _, x, y)
		if(self.m_lastCX ~= 0) and (self.m_lastCY ~= 0) and (self.movingObject)  then
			local addx, addy = self.m_lastCX-x, self.m_lastCY-y;
			local x	= localPlayer:getPosition()
			local x2, y2 = self.movingObject:getPosition()
			local rot = findRotation(x.x, x.y, x2, y2)

			self.rX, self.rY, self.rZ = self.rX, self.rY+((addy)), self.rZ+((addx))
		end

		self.m_lastCX, self.m_lastCY = x, y;
	end


	self.m_funcRotDown	= function()
		if(self.currentlyMoving == true) then
			if not(self.m_bRotMode) then
				self.m_bRotMode = true

				addEventHandler("onClientCursorMove", getRootElement(), self.m_funcMoveCursor)
			end
		end
	end
	self.m_funcRotUp	= function()
		if(self.currentlyMoving == true) then
			if(self.m_bRotMode) then
				self.m_bRotMode = false

				removeEventHandler("onClientCursorMove", getRootElement(), self.m_funcMoveCursor)
			end
		end
	end

	bindKey("r", "down", self.m_funcRotDown)
	bindKey("r", "up", self.m_funcRotUp)


	if(setInteriorFurnitureEnabled) then
		for i = 1, 4, 1 do
			setInteriorFurnitureEnabled(i, false);
		end
		--outputDebugString("MTA Version > 6100, Moebel werden Deaktiviert");
	end


	addCommandHandler("pickall", function()
		local pos		= localPlayer:getPosition()
		local col		= createColSphere(pos.x, pos.y, pos.z, 5)
		loadingSprite:setEnabled(true)
		setTimer(setElementPosition, 500, 1, col, pos.x, pos.y, pos.z-0.1)
		col:setInterior(localPlayer:getInterior())
		col:setDimension(localPlayer:getDimension())
		setTimer(function()
			local objects	= col:getElementsWithin("object")
			col:destroy()
			confirmDialog:showConfirmDialog("Moechtest du alle Objekte in einem Umkreis von 5 Einheiten aufheben? ("..#objects.." Objekte)", function()
				for index, ob in pairs(objects) do
					triggerServerEvent("onClientObjectMovingPickUp", localPlayer, ob, false)
				end

				showInfoBox("sucess", "Objekte wurden aufgenommen!")
			end, false, false, false, false)

			loadingSprite:setEnabled(false)
		end, 1000, 1)
	end)
	--logger:OutputInfo("[CALLING] ObjectMover: Constructor");
end

-- EVENT HANDLER --
