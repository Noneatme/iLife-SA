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
-- ## Name: PunchSoundManager.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

PunchSoundManager = {};
PunchSoundManager.__index = PunchSoundManager;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function PunchSoundManager:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end
-- ///////////////////////////////
-- ///// isPedBlocking		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function PunchSoundManager:IsPedBlocking(uPed)
	if(getPedControlState(uPed, "aim_weapon") == true) and (getPedControlState(uPed, "jump") == true) then
		return true;
	end
	return false;
end

-- ///////////////////////////////
-- ///// PedHit		 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function PunchSoundManager:PedHit(uPed, uAttacker, iWeapon, iBodypart, iLoss)
	local sSoundPath	= self.path.sounds;
	local sSoundPraefix	= nil;
	local iSound		= 0;
	local sUsingSound	= "block";
	local iBloodAmmount	= 0;

	local x, y, z		= getElementPosition(uPed);

	if(self.allowedWeapons[iWeapon]) then
		if(self:IsPedBlocking(uPed)) then
			sSoundPraefix	= "pnch_blck_";
			sUsingSound		= "block";
			iBloodAmmount	= 0;
		elseif(iLoss > 0 and iLoss < 5) then
			-- Normaler Hit
			sSoundPraefix	= "pnch_av_";
			sUsingSound		= "average";
			iBloodAmmount 	= 10;
		elseif(iLoss > 5) and (iLoss < 30) then
			sSoundPraefix	= "pnch_lss_";
			sUsingSound		= "less";
			iBloodAmmount 	= 20;
		elseif(iLoss > 30) then
			sSoundPraefix	= "pnch_hrd_";
			sUsingSound		= "hard";
			iBloodAmmount 	= 50;
		else
			sSoundPraefix 	= false;
		end
	end

	if(sSoundPraefix) then
		iSound			= math.random(1, self.sounds[sUsingSound]);

		sSoundPath			= sSoundPath..sUsingSound.."/"..sSoundPraefix..iSound..".mp3";
		local sound			= playSound3D(sSoundPath, x, y, z, false);
		setElementDimension(sound, getElementDimension(uPed));
		setElementInterior(sound, getElementInterior(uPed));
		if(self.useBlood and iBloodAmmount) then
			local iRandBone	= 8;
			local x, y, z = getPedBonePosition(uPed, iRandBone);
			fxAddBlood(x, y, z, 0, 0, 1, iBloodAmmount);
		end
	end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function PunchSoundManager:Constructor(...)
	-- Klassenvariablen --
	self.disabledIndex	= 5;
	--[[

	82: Auf dem Boden drauftrampeln-Sound
	42: Block-Sound (Oder so)
	--]]
	self.disabledSounds	= {87, 60, 61, 58, 43, 42, 82, 59, 62, 40, 41, 38, 39, 86, 75, 37, 36};
	self.path			= {};
	self.path.sounds	= "res/sounds/punch/";

	self.sounds			=
	{
		["less"]		= 4,
		["average"]		= 6,
		["hard"]		= 1,
		["block"]		= 5,
	}
	
	-- Blut benutzen?
	self.useBlood		= true;
	
	self.randomBones	= 
	{
		[1] = 8,
		[2] = 32,
		[3] = 42,
		[4] = 52,
		[5] = 42,
		[6] = 4,
		[7] = 31,
	
	}
	
	self.allowedWeapons	=
	{
		[0] = true,
		[3] = true,
		[5] = true,
		[6] = true,
	}

	for i = 1, #self.disabledSounds, 1 do setWorldSoundEnabled(self.disabledIndex, self.disabledSounds[i], false) end;

	self.pedHitFunc		= function(...) self:PedHit(source, ...) end;

	-- Methoden --
	addEventHandler("onClientPedDamage", getRootElement(), self.pedHitFunc);
	addEventHandler("onClientPlayerDamage", getRootElement(), self.pedHitFunc);
	
-- Events --

--logger:OutputInfo("[CALLING] PunchSoundManager: Constructor");
end

-- EVENT HANDLER --
