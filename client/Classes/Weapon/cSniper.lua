--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

-- #######################################
-- ## Project: 	Sniper Resource			##
-- ## Name: Sniper.lua					##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings

Sniper = {};
Sniper.__index = Sniper;


addEvent("onClientDownloadFinnished", true)

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function Sniper:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// ImportSniperModel	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Sniper:ImportSniperModel()

end

-- ///////////////////////////////
-- ///// ToggleSound		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Sniper:ToggleSounds()
	setWorldSoundEnabled(5, 27, false)
	setWorldSoundEnabled(5, 26, false)
end

-- ///////////////////////////////
-- ///// CheckSniper 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Sniper:CheckSniper(weap, ammo, clip, hx, hy, hz, element)
	if(weap == 34) then

		local x, y, z = getPedWeaponMuzzlePosition(source);
		local sound = playSound3D("res/sounds/weapons/sniper/1.mp3", x, y, z);
		setSoundMaxDistance(sound, 150);

		for i = 1, 10, 1 do
			fxAddSparks(hx, hy, hz, 0, 0, 0, 15, 5, 0, 0, 0, true, 0.1, 5)
		end
		
		if(isElement(element)) and (getElementType(element) == "player") then
			local x1, y1 = hx, hy
			local x2, y2 = x, y
			local rot = math.atan2(y2 - y1, x2 - x1) * 180 / math.pi	
			
			local x2, y2 = getPointFromDistanceRotation(hx, hy, 5, -rot-90)
	
			setTimer(function()
			--for i = 1, 50, 1 do
				fxAddBlood(hx, hy, hz, (x2-x1), (y2-y1), 1, 200, 1)
			--end
			end, 50, 10)
		end
	end
end

-- ///////////////////////////////
-- ///// DamageSniper 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Sniper:DamageSniper(attacker, weapon, bodypart)
	if(weapon == 34) then
		local x, y, z = getPedBonePosition (source, bodypart)
		
		local sound = playSound3D("res/sounds/weapons/sniper/sniper_hit_"..math.random(1, 2)..".mp3", x, y, z);


	end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Sniper:Constructor(...)

	self:ToggleSounds()
	
	self.weaponFireFunc = function(...) self:CheckSniper(...) end;
	self.damageFunc = function(...) self:DamageSniper(...) end;

	addEventHandler("onClientPlayerWeaponFire", getRootElement(), self.weaponFireFunc)
	addEventHandler("onClientPlayerDamage", getRootElement(), self.damageFunc)
	addEventHandler("onClientPedDamage", getRootElement(), self.damageFunc)
	
	addEventHandler("onClientDownloadFinnished", getLocalPlayer(), function()
		self:ImportSniperModel()
	end)

end

-- EVENT HANDLER --