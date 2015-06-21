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
-- ## Name: ContainerKran.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

ContainerKran = {};
ContainerKran.__index = ContainerKran;

addEvent("onClientDownloadFinnished", true)

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function ContainerKran:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end


-- ///////////////////////////////
-- ///// RefreshPos			//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function ContainerKran:RefreshPos()
	setElementRotation(self.obenTeil, 0, 0, self.iRot);

	attachElements(self.bewegTeil, self.obenTeil, 0, self.teilPosition, self.teilZOffset)

	attachElements(self.camera, self.obenTeil, self.cameraPos.x, self.cameraPos.y, self.cameraPos.z, self.cameraPos.ox, self.cameraPos.oy, self.cameraPos.oz);

	attachElements(self.magnet, self.bewegTeil, 0, 0, self.magnetPosZ, 0, 0, self.crateRotation)

	attachElements(self.magnetCol, self.magnet)

	if(isElement(self.attachedCrate)) then
		attachElements(self.attachedCrate, self.magnet, 0, 0, -2.3, 0, 0, self.crateRotation)
	end
end

-- ///////////////////////////////
-- ///// MoveRight			//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function ContainerKran:MoveRight()
	self.iRot = self.iRot - self.rotationPos.Teil;
end

-- ///////////////////////////////
-- ///// MoveLeft			//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function ContainerKran:MoveLeft()
	self.iRot = self.iRot + self.rotationPos.Teil;
end

-- ///////////////////////////////
-- ///// MoveForward 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function ContainerKran:MoveForwards()
	if(self.teilPosition < self.maxTeilPosition) then
		self.teilPosition = self.teilPosition + self.rotationPos.Teil;

		self.cameraPos.y = self.cameraPos.y + self.rotationPos.Teil;
		self.cameraPos.ox = self.cameraPos.ox - self.rotationPos.Cam;

	end
end

-- ///////////////////////////////
-- ///// MoveDownward 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function ContainerKran:MoveDownwards()
	if(self.teilPosition > self.minTeilPosition) then
		self.teilPosition = self.teilPosition - self.rotationPos.Teil;

		self.cameraPos.y = self.cameraPos.y - self.rotationPos.Teil;
		self.cameraPos.ox = self.cameraPos.ox + self.rotationPos.Cam;
	end

end

-- ///////////////////////////////
-- ///// MoveDown	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function ContainerKran:MoveDown()
	if(self.magnetPosZ > self.maxMagnetPosZ) then
		self.magnetPosZ = self.magnetPosZ - self.rotationPos.Teil
	end
end

-- ///////////////////////////////
-- ///// MoveUp	 			//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function ContainerKran:MoveUp()
	if(self.magnetPosZ < -1) then
		self.magnetPosZ = self.magnetPosZ + self.rotationPos.Teil

	end
end

-- ///////////////////////////////
-- ///// RotateLeft	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function ContainerKran:RotateLeft()
	--	if(isElement(self.attachedCrate)) then
	self.crateRotation = self.crateRotation+self.rotationPos.Rot;
--	end
end

-- ///////////////////////////////
-- ///// RotateRight	 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function ContainerKran:RotateRight()
	--	if(isElement(self.attachedCrate)) then

	self.crateRotation = self.crateRotation-self.rotationPos.Rot;
--	end
end


-- ///////////////////////////////
-- ///// Render		 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function ContainerKran:Render()
	if(self.enabled) then
		-- Controls --
		if(self.controlEnabled["left"]) then
			self:MoveLeft();
		end

		if(self.controlEnabled["right"]) then
			self:MoveRight();
		end

		if(self.controlEnabled["forward"]) then
			self:MoveForwards();
		end

		if(self.controlEnabled["downward"]) then
			self:MoveDownwards();
		end

		if(self.controlEnabled["up"]) then
			self:MoveUp();
		end

		if(self.controlEnabled["down"]) then
			self:MoveDown();
		end

		if(self.controlEnabled["rotleft"]) then
			self:RotateLeft();
		end

		if(self.controlEnabled["rotright"]) then
			self:RotateRight();
		end

		-- Instructions --
		if(self.instructions) then
			local sx, sy = guiGetScreenSize()
			local aesx, aesy = 1440, 900;

			dxDrawRectangle(1027/aesx*sx, 256/aesy*sy, 396/aesx*sx, 422/aesy*sy, tocolor(0, 0, 0, 77), true)
			dxDrawText("Steuerung des Krans:", 1035/aesx*sx, 267/aesy*sy, 1415/aesx*sx, 318/aesy*sy, tocolor(255, 255, 255, 255), 2/(aesx+aesy)*(sx+sy), "default-bold", "center", "center", false, false, true, false, false)
			dxDrawText("Pfeiltasten:", 1035/aesx*sx, 328/aesy*sy, 1412/aesx*sx, 363/aesy*sy, tocolor(255, 255, 255, 255), 2/(aesx+aesy)*(sx+sy), "default-bold", "center", "center", false, false, true, false, false)
			dxDrawText("Links & Rechts: Kran Bewegen\nHoch & Runter: Magnet Bewegen\n", 1037/aesx*sx, 369/aesy*sy, 1417/aesx*sx, 420/aesy*sy, tocolor(255, 255, 255, 255), 1.5/(aesx+aesy)*(sx+sy), "default-bold", "center", "center", false, false, true, false, false)
			dxDrawLine(1037/aesx*sx, 317/aesy*sy, 1416/aesx*sx, 317/aesy*sy, tocolor(255, 255, 255, 255), 1, true)
			dxDrawText("Numpad-Tasten:", 1037/aesx*sx, 425/aesy*sy, 1417/aesx*sx, 476/aesy*sy, tocolor(255, 255, 255, 255), 2/(aesx+aesy)*(sx+sy), "default-bold", "center", "center", false, false, true, false, false)
			dxDrawText("Numpad 8: Magnet nach Oben bewegen\nNumpad 2: Magnet nach Unten bewegen\nNumpad 4: Magnet nach Rechts drehen\nNumpad 6: Magnet nach Links drehen\nNumpad 5: Container fallenlassen\n(Alternativ: W, A, S, D, R)", 1037/aesx*sx, 466/aesy*sy, 1419/aesx*sx, 594/aesy*sy, tocolor(255, 255, 255, 255), 1.5/(aesx+aesy)*(sx+sy), "default-bold", "center", "center", false, false, true, false, false)
			dxDrawText("Enter zum Verlassen des Krans", 1037/aesx*sx, 604/aesy*sy, 1417/aesx*sx, 655/aesy*sy, tocolor(255, 255, 255, 255), 2/(aesx+aesy)*(sx+sy), "default-bold", "center", "center", false, false, true, false, false)
		end


		if(getTickCount()-self.tick >= 1000) then
			self.tick 	= getTickCount()
			self.FPS	= self.curFPS;

			self.curFPS	= 0;
		else
			self.curFPS	= self.curFPS+1;
		end
		
		
		self:RefreshPos();
	end
	-- Line --

	local x1, y1, z1 = getElementPosition(self.bewegTeil)
	local x2, y2, z2 = getElementPosition(self.magnet)

	dxDrawLine3D(x1, y1, z1, x2, y2, z2, tocolor(0, 0, 0, 255), 10)

	--[[


	for index, v in pairs(self.rotationPos) do
	self.rotationPos[index] = self.defaultRotPos[index]/self.FPS*60;
	outputChatBox(tostring(self.defaultRotPos[index]))
	end
	]]

end

-- ///////////////////////////////
-- ///// DoInput	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function ContainerKran:DoInput(sKey, sKey2, sState, sSound, iTeil)
	local bBool = false;
	if(sState == "down") then
		bBool = true;

		if(sSound) then
			self:PlayCraneSound("res/sounds/jobs/Container/"..sSound, iTeil, true);
		end
	else
		if(sSound) then
			self:StopCraneSound("res/sounds/jobs/Container/"..sSound, 3, false);
		end
	end
	self.controlEnabled[sKey] = bBool;
end

-- ///////////////////////////////
-- ///// PlayCraneSound 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function ContainerKran:PlayCraneSound(sSound, iTeil, bBool)
	if not(isElement(self.sounds[sSound])) then
		self.sounds[sSound]	= playSound3D(sSound, self.cameraPos.x, self.cameraPos.y, self.cameraPos.z, bBool)
		setSoundMaxDistance(self.sounds[sSound], 175);

		if(iTeil == 1) then
			attachElements(self.sounds[sSound], self.obenTeil);
		elseif(iTeil == 2) then
			attachElements(self.sounds[sSound], self.bewegTeil);
		end

		if(bBool == true) then
			self:PlayCraneSound("res/sounds/jobs/Container/crane_action_start.mp3", 1, false)
		end
	end
end

-- ///////////////////////////////
-- ///// StopCraneSound 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function ContainerKran:StopCraneSound(sSound, iTeil)
	if(isElement(self.sounds[sSound])) then
		destroyElement(self.sounds[sSound])
	end

	if(iTeil == 3) then
		self:PlayCraneSound("res/sounds/jobs/Container/crane_action_end.mp3", 1, false)
	end
end


-- ///////////////////////////////
-- ///// AttachCrate 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function ContainerKran:AttachCrate(uObject)
	self.attachedCrate = uObject;

	if(self.instructions) then

		self.instructions = false;
	end


	self:PlayCraneSound("res/sounds/jobs/Container/attach/hit_"..math.random(1, 4)..".mp3", 2, false)
end
-- ///////////////////////////////
-- ///// Start		 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function ContainerKran:Start()
	fadeCamera(false);

	setTimer(function()
		fadeCamera(true);
		
		self.enabled = true;
	
		bindKey("arrow_l", "both", self.moveLeftFunc)
		bindKey("arrow_r", "both", self.moveRightFunc)

		-- Teil --
		bindKey("arrow_u", "both", self.moveForwardFunc)
		bindKey("arrow_d", "both", self.moveDownwardFunc)

		-- Hoch und Runter --
		bindKey("num_8", "both", self.moveUpFunc)
		bindKey("num_2", "both", self.moveDownFunc)

		bindKey("w", "both", self.moveUpFunc)
		bindKey("s", "both", self.moveDownFunc)
		-- Absetzen --
		bindKey("num_5", "down", self.releaseCrateFunc)
		bindKey("r", "down",  self.releaseCrateFunc)

		-- Verlassen --
		bindKey("enter", "down", self.exitFunc)

		-- Rotate --
		bindKey("num_4", "both", self.rotateLeftFunc)
		bindKey("num_6", "both", self.rotateRightFunc)
		bindKey("a", "both", self.rotateLeftFunc)
		bindKey("d", "both", self.rotateRightFunc)

		toggleAllControls(false)

		self.instructions = true;

		setElementPosition(localPlayer, self.iX, self.iY, self.iZ)
		setElementFrozen(localPlayer, true)

		if(self.sMessage) then
			showInfoBox("info", self.sMessage)
		end
		--		self:CreateBlips();
		
		setElementData(localPlayer, "p:InJob", true)
	end, 1000, 1)
end

-- ///////////////////////////////
-- ///// Stop		 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////


function ContainerKran:Stop()
	fadeCamera(false);

	setTimer(function()
	
		self.enabled = false;
		
		fadeCamera(true);


		detachElements(self.camera);
		setCameraTarget(localPlayer);


		unbindKey("arrow_l", "both", self.moveLeftFunc)
		unbindKey("arrow_r", "both", self.moveRightFunc)

		unbindKey("arrow_u", "both", self.moveForwardFunc)
		unbindKey("arrow_d", "both", self.moveDownwardFunc)

		unbindKey("num_8", "both", self.moveUpFunc)
		unbindKey("num_2", "both", self.moveDownFunc)
		unbindKey("w", "both", self.moveUpFunc)
		unbindKey("s", "both", self.moveDownFunc)

		unbindKey("num_4", "both", self.rotateLeftFunc)
		unbindKey("num_6", "both", self.rotateRightFunc)
		unbindKey("a", "both", self.rotateLeftFunc)
		unbindKey("d", "both", self.rotateRightFunc)

		unbindKey("num_5", "down", self.releaseCrateFunc)
		unbindKey("r", "down",  self.releaseCrateFunc)

		unbindKey("enter", "down", self.exitFunc)


		toggleAllControls(true);

		local x, y, z = getElementPosition(self.enterMarker)
		setElementPosition(localPlayer, x, y+2, z)
		setElementFrozen(localPlayer, false)
		
		
		setElementData(localPlayer, "p:InJob", false)
		--	self:DeleteBlips();
	end, 1000, 1)
end

-- ///////////////////////////////
-- ///// CheckCollisionHit	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function ContainerKran:CheckCollisionHit(uElement)
	if(getElementType(uElement) == "object") and (getElementData(uElement, "cj:crate") == true) then
		if not(isElement(self.attachedCrate)) and not(self.cannotAttachCrate) and not(self.placedCrates[uElement]) then
			local _, _, z 			= getElementRotation(uElement)
			self.crateRotation 		= z;
			self:AttachCrate(uElement);


		end
	end
end

-- ///////////////////////////////
-- ///// ReleaseCrate 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function ContainerKran:ReleaseCrate()
	if(isElement(self.attachedCrate)) then
		local x, y, z 			= getElementPosition(self.attachedCrate)
		local _, _, z2 			= getGroundPosition(x, y, z, 50);

		detachElements(self.attachedCrate)

		--	moveObject(self.attachedCrate, 5000, x, y, z2, 0, 0, 0, "InQuad")
		-- Check --
		if not(self.placedCrates[self.attachedCrate]) then

			if(isElementWithinColShape(self.attachedCrate, self.platzierCol)) then
				self.placedCrates[self.attachedCrate] = true;

				triggerServerEvent("onServerContainerJobCrateAbgeb", localPlayer)

				local uObject = self.attachedCrate;

				playSound("res/sounds/shop/sell.wav", false)
				setTimer(function()
					respawnObject(uObject);
					self.placedCrates[uObject] = false;
				end, 60000*60, 1) -- 1. Stunde
			end
		end

		self.attachedCrate 		= false;
		self.cannotAttachCrate 	= true;

		setTimer(function() self.cannotAttachCrate = false end, 5000, 1);

	end
end

-- ///////////////////////////////
-- ///// CreateBlips 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function ContainerKran:CreateBlips()
	local x, y, z = getElementPosition(self.fussTeil)

	local col = createColSphere(x, y+5, z+200, 250);

	attachElements(col, self.fussTeil)
	for index, ele in pairs(getElementsWithinColShape(col, "object")) do
		outputChatBox(index)
		if(getElementData(ele, "cj:crate") == true) then
			self.blips[index] = createBlipAttachedTo(ele, 0, 2, 0, 255, 255, 255, 0, 1337);
		end
	end

end

-- ///////////////////////////////
-- ///// DeleteBlips 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function ContainerKran:DeleteBlips()
	for index, blip in pairs(self.blips) do
		if(isElement(blip)) then
			destroyElement(blip)
		end
	end

	self.blips = {}
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function ContainerKran:Constructor(iX, iY, iZ, iRot, iDim, cX, cY, cZ, iLange, iBreite, iHoehe, sMessage)

	self.camera 			= getCamera();
	self.iRot				= iRot;
	self.controlEnabled		= {}

	self.sMessage			= sMessage;

	self.iX					= iX;
	self.iY					= iY;
	self.iZ					= iZ;

	-- Magnet ID: 1301

	self.cameraPos			= {}

	self.cameraPos.x		= 25
	self.cameraPos.y		= -35
	self.cameraPos.z		= 10
	self.cameraPos.ox		= -25
	self.cameraPos.oy		= 0
	self.cameraPos.oz		= 20


	self.rotationPos		= {}
	self.rotationPos.Teil	= 0.1;
	self.rotationPos.Cam	= 0.025;
	self.rotationPos.Rot	= 0.5;

	self.defaultRotPos		= self.rotationPos;


	self.defaultCameraPos	= self.cameraPos;

	self.placedCrates		= {}
	self.blips				= {}
	self.sounds				= {}

	-- Klassenvariablen --
	iZ = iZ+31;

	self.teilZOffset 		= 3.2;
	self.teilPosition 		= 15;

	self.minTeilPosition 	= 6;

	self.maxTeilPosition 	= 38;

	self.magnetPosZ			= -5;
	self.maxMagnetPosZ		= -43.7;
	self.defaultMaxMagnetPosZ = self.maxMagnetPosZ;

	self.fussTeil 	= createObject(1391, iX, iY, iZ, 0, 0, self.iRot);
	self.obenTeil	= createObject(1388, iX, iY, iZ+12.5, 0, 0, self.iRot);
	FrameTextur:New(self.obenTeil, "ws_finalbuild", "objects/ws_finalbuild.jpg")

	self.bewegTeil	= createObject(1392, iX, iY, iZ, 0, 0, self.iRot);

	self.magnet		= createObject(1381, iX, iY, iZ, 0, 0, 0);

	self.magnetCol	= createColSphere(iX, iY, iZ, 5)

	self.enterMarker = createMarker(iX, iY, iZ, "corona", 1.0, 0, 255, 0, 255);
	attachElements(self.enterMarker, self.fussTeil, 6, 0, -31, 0, 0, self.iRot)

	attachElements(self.magnetCol, self.magnet)
	attachElements(self.bewegTeil, self.obenTeil, 0, self.teilPosition, self.teilZOffset)
	attachElements(self.magnet, self.bewegTeil, 0, 0, self.magnetPosZ)


	self.platzierCol	= createColCuboid(cX, cY, cZ, iLange, iBreite, iHoehe);


	self.elements	= {self.magnet, self.fussTeil, self.obenTeil, self.bewegTeil, self.magnetCol, self.platzierCol, self.craneSound};

	for index, ele in pairs(self.elements) do setElementDimension(ele, (iDim or 0)) end


	self.attachedCrate 	= false;
	self.crateRotation	= 0;


	self.FPS			= 60;
	self.curFPS			= 0;
	self.tick			= getTickCount();

	-- Methoden --
	self.doInput			= function(...) self:DoInput(...) end;
	self.renderFunc			= function(...) self:Render(...) end;
	self.moveLeftFunc 		= function(key, state) self:DoInput("left", key, state, "crane_action_loop.mp3", 1) end;
	self.moveRightFunc 		= function(key, state) self:DoInput("right", key, state, "crane_action_loop.mp3", 1) end;

	self.moveForwardFunc 	= function(key, state) self:DoInput("forward", key, state, "crane_magnet.mp3", 2) end;
	self.moveDownwardFunc 	= function(key, state) self:DoInput("downward", key, state, "crane_magnet.mp3", 2) end;

	self.rotateLeftFunc 	= function(key, state) self:DoInput("rotleft", key, state) end;
	self.rotateRightFunc 	= function(key, state) self:DoInput("rotright", key, state) end;

	self.exitFunc 			= function(...) self:Stop(...) end;
	self.startFunc			= function(uPlayer) if(uPlayer == localPlayer) and not(isPedInVehicle(uPlayer)) then self:Start() end end;

	self.moveUpFunc 		= function(key, state) self:DoInput("up", key, state, "crane_magnet.mp3", 2) end;
	self.moveDownFunc 		= function(key, state) self:DoInput("down", key, state, "crane_magnet.mp3", 2) end;
	self.colHitFunc			= function(...) self:CheckCollisionHit(...) end;

	self.releaseCrateFunc 	= function(...) self:ReleaseCrate(...) end;

	-- Events --
	addEventHandler("onClientColShapeHit", self.magnetCol, self.colHitFunc)
	addEventHandler("onClientMarkerHit", self.enterMarker, self.startFunc)
	addEventHandler("onClientRender", getRootElement(), self.renderFunc)

	addEventHandler("onClientDownloadFinnished", localPlayer, function()
		self.craneSound		= playSound3D("res/sounds/jobs/Container/crane_loop.mp3", iX, iY, iZ, true)
		attachElements(self.craneSound, self.fussTeil);
		setSoundMaxDistance(self.craneSound, 100)
	end)

	--logger:OutputInfo("[CALLING] ContainerKran: Constructor");
end



-- EVENT HANDLER --
