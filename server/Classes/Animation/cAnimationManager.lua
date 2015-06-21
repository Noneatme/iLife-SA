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
-- ## Name: AnimationManager.lua		##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings

AnimationManager = {};
AnimationManager.__index = AnimationManager;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function AnimationManager:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// StopAnimation 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function AnimationManager:StopAnimation(player)
	return setPedAnimation(player)
end

-- ///////////////////////////////
-- ///// ShowAnimations		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function AnimationManager:ShowAnimations(player)
	outputConsole("Available Animations:", player);
	local string = "";
	for index, object in pairs(self.animations) do
		string = string.."/"..object.sCommand.." - ";
	end
	outputConsole(string, player)
end


-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function AnimationManager:Constructor(...)
	-- Klassenvariablen --
	
	-- bDoCommand, sCommand, sBlock, sAnim, iTime, bLoop, bUpdatePosition, bInterruptable
	-- Interruptable nie auf false!

	self.animations = 
	{
		Animation:New(true, "handsup", "shop", "SHP_Rob_HandsUp", 0, false, false),
		Animation:New(true, "drunk", "ped", "WALK_drunk", 0, true, true),
		Animation:New(true, "walk", "ped", "WALK_civi", 0, true, true),
		Animation:New(true, "jog", "ped", "JOG_maleA", 0, true, true),
		Animation:New(true, "bomb", "bomber", "BOM_Plant_Loop", 0, true, false),
		Animation:New(true, "robman", "shop", "ROB_Loop_Threat", 0, true, false),
		Animation:New(true, "getarrested", "ped", "ARRESTgun", 1000, false, false),
		Animation:New(true, "laught", "rapping", "Laugh_01", 0, true, false),
		Animation:New(true, "lookout", "shop", "ROB_Shifty", 0, true, false),
		Animation:New(true, "crossarms", "cop_ambient", "Coplook_loop", 0, true, false),
		Animation:New(true, "crossarms2", "cop_ambient", "Coplook_think", 0, true, false),
		Animation:New(true, "lay", "beach", "bather", 0, true, false),
		Animation:New(true, "hide", "ped", "cower", 0, true, false),
		Animation:New(true, "vomit", "food", "EAT_Vomit_P", 0, true, false),
		Animation:New(true, "wave", "ON_LOOKERS", "wave_loop", 0, true, false),
		Animation:New(true, "slapass", "sweet", "sweet_ass_slap", 0, true, false),
		Animation:New(true, "deal", "dealer", "dealer_deal", 0, true, false),
		Animation:New(true, "crack", "crack", "crckdeth2", 0, true, false),
		Animation:New(true, "ground", "beach", "ParkSit_M_loop", 0, true, false),
		Animation:New(true, "fucku", "ped", "fucku", 0, true, false),
		Animation:New(true, "chat", "ped", "IDLE_chat", 0, true, false),
		Animation:New(true, "taijiquan", "park", "Tai_Chi_Loop", 0, true, false),
		Animation:New(true, "chairsit", "beach", "SitnWait_loop_W", 0, true, false),
		Animation:New(true, "piss", "PAULNMAC", "Piss_loop", 0, true, false),
		Animation:New(true, "wank", "PAULNMAC", "wank_loop", 0, true, false),
		Animation:New(true, "tired", "PAULNMAC", "PnM_Loop_A", 0, true, false),
		Animation:New(true, "dance", "DANCING", "dance_loop", 0, false, false, true, "dance"),
		Animation:New(true, "scratchballs", "MISC", "Scratchballs_01", 0, true, false),
		Animation:New(true, "scratchhead", "MISC", "plyr_shkhead", 0, true, false),
		Animation:New(true, "bitchslap", "MISC", "bitchslap", 0, true, false),
		Animation:New(true, "smoking", "SMOKING", "M_smk_loop", 0, true, false),
		Animation:New(true, "crossarms3", "MTB", "wtchrace_loop", 0, true, false),
		Animation:New(true, "swingarms", "RAPPING", "RAP_B_Loop", 0, true, false),

	}
	
	-- Methoden --
	self.stopAnimationFunc = function(...) self:StopAnimation(...) end;
	self.showAnimationFunc = function(...) self:ShowAnimations(...) end;
	
	-- Events --
	addCommandHandler("anims", self.showAnimationFunc);

	--logger:OutputInfo("[CALLING] AnimationManager: Constructor");
end

-- EVENT HANDLER --


