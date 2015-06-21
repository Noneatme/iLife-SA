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
-- ## Name: BoneAttachManager.lua					##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

BoneAttachManager = {};
BoneAttachManager.__index = BoneAttachManager;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function BoneAttachManager:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// DestroyPlayerObject ////
-- ///// Returns: void		//////
-- ///////////////////////////////

function BoneAttachManager:DestroyPlayerObject(uPlayer)
	if(isElement(self.playerObject[uPlayer])) then
		destroyElement(self.playerObject[uPlayer])
	end

	if(isTimer(self.playerTimer[uPlayer])) then
		killTimer(self.playerTimer[uPlayer]);
	end
	
	if(self.drinking[uPlayer]) then
		self:SetPlayerDrinking(uPlayer, false);
	end
	
	self.drinking[uPlayer]	= false;
end

-- ///////////////////////////////
-- ///// AttachToPlayerBone //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function BoneAttachManager:AttachToPlayerBone(uPlayer, iModell, iTime, iBone, fX, fY, fZ, iRX, iRY, iRZ, iEatAmmount)
	if(isElement(self.playerObject[uPlayer])) then
		destroyElement(self.playerObject[uPlayer]);

		if(isTimer(self.playerTimer[uPlayer])) then
			killTimer(self.playerTimer[uPlayer]);
		end
	end
	if(iModell ~= 0) then
		self.playerObject[uPlayer] = createObject(iModell, fX, fY, fZ, iRX, iRY, iRZ);
		setElementInterior(self.playerObject[uPlayer], getElementInterior(uPlayer))
		setElementDimension(self.playerObject[uPlayer], getElementDimension(uPlayer))
		setElementDoubleSided(self.playerObject[uPlayer], true)

		self.playerAmmount[uPlayer] = (iEatAmmount or 5);

		if(exports.bone_attach) then
			exports.bone_attach:attachElementToBone(self.playerObject[uPlayer], uPlayer, iBone, fX, fY, fZ, iRX, iRY, iRZ);

		else
			outputDebugString("ERROR: Bone Attach is not running");
			self.destroyPlayerObjectFunc(uPlayer);
		end
		if(iTime) and (iTime > 0) then
			self.playerTimer[uPlayer] = setTimer(self.destroyPlayerObjectFunc, iTime*1000*60, 1, uPlayer);
		end
	end
end

-- ///////////////////////////////
-- ///// SetPlayerDrinking	 //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function BoneAttachManager:SetPlayerDrinking(uPlayer, bBool)
	if(bBool == true) then
		if(self.drinking[uPlayer] ~= true) then
			self.drinking[uPlayer] = true;
			bindKey(uPlayer, "fire", "down", self.doPlayerDrinkFunc);
			toggleControl(uPlayer, "fire", false)
		end
	else
		if(self.drinking[uPlayer] == true) then
			unbindKey(uPlayer, "fire", "down", self.doPlayerDrinkFunc);
			toggleControl(uPlayer, "fire", true)
		end
	end
end

-- ///////////////////////////////
-- ///// DoPlayerDrink 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function BoneAttachManager:DoPlayerDrink(uPlayer)
	if not(self.drinkAnimation[uPlayer]) and not(isPedInVehicle(uPlayer)) then
		self.drinkAnimation[uPlayer] = true;
		setPedAnimation(uPlayer, "BAR", "dnk_stndM_loop", -1, false, false, true);
		setTimer(function()
			setPedAnimation(uPlayer);
			self.drinkAnimation[uPlayer] = false;
			uPlayer:eat(10);

			triggerClientEvent(uPlayer, "onAlcoholDrink", uPlayer);

			self.playerAmmount[uPlayer] = self.playerAmmount[uPlayer]-1;
			
			if(self.playerAmmount[uPlayer] == 0) then
				self:DestroyPlayerObject(uPlayer);
			end
		end, 2500, 1)
	end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function BoneAttachManager:Constructor(...)
	-- Klassenvariablen --
	self.playerObject 	= {};
	self.playerTimer 	= {};
	self.drinking		= {};
	self.drinkAnimation = {};
	self.playerAmmount	= {};
	
	-- Methoden --
	self.destroyPlayerObjectFunc 	= function(...) self:DestroyPlayerObject(...) end;
	self.quitFunc					= function(...) self:DestroyPlayerObject(source) end;
	self.doPlayerDrinkFunc			= function(...) self:DoPlayerDrink(...) end;
	
	-- Events --
	addEventHandler("onPlayerQuit", getRootElement(), self.quitFunc);
--logger:OutputInfo("[CALLING] BoneAttachManager: Constructor");
end

-- EVENT HANDLER --
