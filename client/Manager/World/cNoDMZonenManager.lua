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
-- ## Name: NoDMZonenManager.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

NoDMZonenManager = {};
NoDMZonenManager.__index = NoDMZonenManager;

addEvent("onPlayerEnterNoDMCol", true)
--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function NoDMZonenManager:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// Toggle	Controls	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function NoDMZonenManager:ToggleControls(bBool)
	bBool = not(bBool);

	toggleControl("fire", bBool)
	toggleControl("vehicle_fire", bBool);
	toggleControl("aim_weapon", bBool);
	toggleControl("action", bBool);

end

-- ///////////////////////////////
-- ///// TriggerHit			//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function NoDMZonenManager:TriggerHit(bBool)
	self.inNoDMZone = bBool;
	--outputDebugString("Triggered No DM Zone: "..tostring(bBool))

	if(bBool) then
		showInfoBox("info", "Du hast eine stark bewachte Zone betreten!\n(DM nicht M\oeglich)")
	end

	setElementData(localPlayer, "nodmzone", bBool);

	self:ToggleControls(bBool)
	self.allowed = not(bBool);
end

-- ///////////////////////////////
-- ///// CheckDamageFunc	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function NoDMZonenManager:CheckDamageFunc(opfer, attacker)
	local cancel		= false;
	if(self.inNoDMZone) then
		if(attacker) then
			cancel = true;
		else
			cancel	= true;
		end
	end
	if(cancel) then
		cancelEvent();
	end
end

-- ///////////////////////////////
-- ///// CheckWeaponSwitch	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function NoDMZonenManager:CheckWeaponSwitch()
	if(self.inNoDMZone) then
		if(self.allowed ~= true) then
			setPedWeaponSlot(localPlayer, 0);
		end
	end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function NoDMZonenManager:Constructor(...)
	-- Klassenvariablen --
	self.inNoDMZone = false;
	self.allowed	= false;

	--[[
	self.allowedFactions =
	{
		[1] = true, -- LSPD
		[2] = true, -- Special Forces

	}]]

	-- Methoden --
	self.triggerFunc			= function(...) self:TriggerHit(...) end;
	self.checkDamageFunc		= function(...) self:CheckDamageFunc(source, ...) end;
	self.checkWeaponSwitchFunc	= function(...) self:CheckWeaponSwitch(...) end;

	-- Events --
	addEventHandler("onPlayerEnterNoDMCol", getLocalPlayer(), self.triggerFunc)
	--logger:OutputInfo("[CALLING] NoDMZonenManager: Constructor");

	addEventHandler("onClientPlayerDamage", localPlayer, self.checkDamageFunc)
	addEventHandler("onClientPlayerWeaponSwitch", localPlayer, self.checkWeaponSwitchFunc)
end

-- EVENT HANDLER --
