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
-- ## Name: Animation.lua				##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

Animation = {};
Animation.__index = Animation;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function Animation:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// ExecuteCommand		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Animation:ExecuteCommand(uPlayer, sCommand)
	if(sCommand == self.sCommand) then
		self:ApplyAnimation(uPlayer);
	end
end

-- ///////////////////////////////
-- ///// ExcuteDance		//////
-- ///// Returns: bool		//////
-- ///////////////////////////////

function Animation:ExecuteDance(uPlayer)
	if(isElement(uPlayer)) then
		self.randomDanceTimer[uPlayer] = setTimer(self.executePlayerDance, math.random(4000, 6000), 1, uPlayer);
		local iRandom 				= math.random(1, #self.randomDanceAnims);
		local randBlock, randAnim 	= self.randomDanceAnims[iRandom][1], self.randomDanceAnims[iRandom][2];

		setPedAnimation(uPlayer, randBlock, randAnim, self.iTime, self.bLoop, self.bUpdatePosition, self.bInterruptable);

	end
end

-- ///////////////////////////////
-- ///// ApplyAnimation		//////
-- ///// Returns: bool		//////
-- ///////////////////////////////

function Animation:ApplyAnimation(uPlayer)
	if not(isPedInVehicle(uPlayer)) then
		if not(uPlayer.Crack) then
			setPedAnimation(uPlayer, self.sBlock, self.sAnim, self.iTime, self.bLoop, self.bUpdatePosition, self.bInterruptable);
			if (self.sAnim == "SHP_Rob_HandsUp") then
				uPlayer.Handsup = true
			end
			if not(isKeyBound(uPlayer, self.stopKey, "down", self.stopAnimationFunc))then
				bindKey(uPlayer, self.stopKey, "down", self.stopAnimationFunc)
			end
			if(self.sCustomAnimation == "dance") then
				if(isTimer(self.randomDanceTimer[uPlayer])) then
					killTimer(self.randomDanceTimer[uPlayer]);
				end
				self:ExecuteDance(uPlayer);
			end
		end
	end
end

-- ///////////////////////////////
-- ///// StopAnimation 		//////
-- ///// Returns: bool		//////
-- ///////////////////////////////

function Animation:StopAnimation(uPlayer)
	setPedAnimation(uPlayer);
	unbindKey(uPlayer, self.stopKey, "down", self.stopAnimationFunc)
	
	uPlayer.Handsup = false
	
	if(isTimer(self.randomDanceTimer[uPlayer])) then
		killTimer(self.randomDanceTimer[uPlayer]);
	end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Animation:Constructor(bDoCommand, sCommand, sBlock, sAnim, iTime, bLoop, bUpdatePosition, bInterruptable, sCustomAnimation)

	-- Klassenvariablen --
	self.bDoCommand			= bDoCommand;
	self.sCommand 			= sCommand;
	self.sBlock				= sBlock;
	self.sAnim				= sAnim;
	self.iTime				= (iTime or -1);
	self.bLoop				= (bLoop or true);
	self.bUpdatePosition	= (bUpdatePosition or false);
	self.bInterruptable		= (bInterruptable or true);
	self.stopKey			= "jump";
	self.sCustomAnimation 	= sCustomAnimation;

	self.randomDanceTimer	= {}

	-- Sonstiges
	self.randomDanceAnims	=
	{
		[1] = {"DANCING", "dance_loop"},
		[2] = {"DANCING", "DAN_Down_A"},
		[3] = {"DANCING", "DAN_Left_A"},
		[4] = {"DANCING", "DAN_Loop_A"},
		[5] = {"DANCING", "DAN_Right_A"},
		[6] = {"DANCING", "DAN_Up_A"},
		[7] = {"DANCING", "dnce_M_a"},
		[7] = {"DANCING", "dnce_M_e"},

	}

	-- Methoden --
	self.applyAnimationToFunc		= function(...) self:ApplyAnimation(...) end;
	self.commandFunction			= function(...) self:ExecuteCommand(...) end;
	self.stopAnimationFunc			= function(...) self:StopAnimation(...) end;
	self.executePlayerDance			= function(...) self:ExecuteDance(...) end;

	-- Events --
	if(self.bDoCommand) then
		addCommandHandler(sCommand, self.commandFunction);
	end

	--logger:OutputInfo("[CALLING] Animation: Constructor");
end

-- EVENT HANDLER --
