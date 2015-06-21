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
-- ## Name: CustomWeaponSoundManager.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

CustomWeaponSoundManager = {};
CustomWeaponSoundManager.__index = CustomWeaponSoundManager;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function CustomWeaponSoundManager:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// WeaponFire 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CustomWeaponSoundManager:WeaponFire(uPlayer, iWeapon)
	if(self.sounds[iWeapon]) then
		local iMaxSounds, sSoundPath 	= self.sounds[iWeapon][1], self.sounds[iWeapon][3];
		local iMaxFarSounds				= self.sounds[iWeapon][2];

		local tblWorldSound				= self.sounds[iWeapon][4];
	
		if(tblWorldSound) then
			for index, wsTable in pairs(tblWorldSound) do
				local iWorldSoundIndex, iWorldSound = tblWorldSound[index][1], tblWorldSound[index][2];
	
				if(isWorldSoundEnabled(iWorldSoundIndex, iWorldSound)) then
					setWorldSoundEnabled(iWorldSoundIndex, iWorldSound, false);
				end
			end
		end

		if(iMaxSounds) and (sSoundPath) then
			local iX, iY, iZ = getPedWeaponMuzzlePosition(uPlayer);
			local int, dim = getElementInterior(uPlayer), getElementDimension(uPlayer);
			local prefix = ".wav";

			local path = self.pfade.sounds..""..sSoundPath.."/"..math.random(1, iMaxSounds)

			if not(fileExists(path..prefix)) then
				prefix = ".mp3"
			end
			path = path..prefix

			if(fileExists(path)) then
				local s = playSound3D(path, iX, iY, iZ, false);



				setElementInterior(s, int);
				setElementDimension(s, dim);

				setSoundMaxDistance(s, 50);
				setSoundVolume(s, 0.5);

				--				attachElements(s, uPlayer);


				if(iMaxFarSounds > 0) then
					local x2, y2, z2 = getElementPosition(localPlayer)

					if(getDistanceBetweenPoints3D(iX, iY, iZ, x2, y2, z2) > 70) then
						-- Play Sound
						prefix = ".wav";

						local path = self.pfade.sounds..""..sSoundPath.."/far/"..math.random(1, iMaxFarSounds)

						if not(fileExists(path..prefix)) then
							prefix = ".mp3"
						end

						path = path..prefix

						local s = playSound3D(path, iX, iY, iZ, false);


						setElementInterior(s, int);
						setElementDimension(s, dim);
						setSoundMaxDistance(s, 250);
						setSoundMinDistance(s, 0);
					--						attachElements(s, uPlayer);
					end

				end
			end
		end
	end
end

function CustomWeaponSoundManager:DoFarExplosion(iX, iY, iZ, iType)
--	if(self.validSmallExploType[iType]) then
		local x2, y2, z2 = getElementPosition(localPlayer)

		if(getDistanceBetweenPoints3D(iX, iY, iZ, x2, y2, z2) > 70) then
			local s = playSound3D(self.pfade.sounds2.."far/explode_"..math.random(1, self.randomFarExplodeSounds)..".mp3", iX, iY, iZ);

			setElementInterior(s, getElementInterior(localPlayer));
			setElementDimension(s, getElementDimension(localPlayer));

			setSoundMaxDistance(s, 250);
			setSoundMinDistance(s, 0);


		else
			local s = playSound3D(self.pfade.sounds2.."near/explode_"..math.random(1, self.randomNearExplodeSounds)..".mp3", iX, iY, iZ);

			setElementInterior(s, getElementInterior(localPlayer));
			setElementDimension(s, getElementDimension(localPlayer));

			setSoundMaxDistance(s, 70);
			setSoundVolume(s, 1);

			Explosion:New(iX, iY, iZ, iType);
		-- Kleiner Sound
		end
--	end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CustomWeaponSoundManager:Constructor(...)
	--Disabled
	return false
		
	--[[	
		
	-- Klassenvariablen --
	self.sounds	=
	{
		[35] = {1, 0, "rocket2", {{5, 68}}},
		[36] = {1, 0, "rocket1", {{5, 68}}},
		[30] = {1, 1, "ak47", {{5, 3}, {5, 4}, {5, 5}}},
		[31] = {1, 1, "m4", {{5, 3}, {5, 4}, {5, 5}}},
		[29] = {1, 1, "mp5"},
		[34] = {1, 0, "sniper", {{5, 27}, {5, 26}, {5, 23}, {5, 55}, {5, 53}, {5, 52}}}	
	
	};

	self.validSmallExploType =
	{
		[9] = true,
		[2] = true,
		[3] = true,
	}

	self.randomFarExplodeSounds = 3;
	self.randomNearExplodeSounds = 3;

	self.pfade					= {}
	self.pfade.sounds			= "res/sounds/weapons/";
	self.pfade.sounds2			= "res/sounds/explosions/";

	-- Methoden --
	self.weaponFireFunc	= function(weapon) self:WeaponFire(source, weapon) end;
	self.farExplosionFunc = function(...) self:DoFarExplosion(...) end;

	-- Events --
	addEventHandler("onClientPlayerWeaponFire", getRootElement(), self.weaponFireFunc)
	addEventHandler("onClientExplosion", getRootElement(), self.farExplosionFunc)

	--logger:OutputInfo("[CALLING] CustomWeaponSoundManager: Constructor");
	]]
end

-- EVENT HANDLER --
