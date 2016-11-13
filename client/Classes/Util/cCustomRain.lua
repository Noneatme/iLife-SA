--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

-- #######################################
-- ## Project: 	HUD iLife				##
-- ## For MTA: San Andreas				##
-- ## Name: CustomRain.lua					##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

CustomRain = {};
CustomRain.__index = CustomRain;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function CustomRain:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// CreateSounds 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

-- Volume is only for fading
--

function CustomRain:CreateSounds()
	self.sounds = {};
	local soundCount = 0;
	local x, y, z = getElementPosition(localPlayer)

	--[[
	for name, soundfile in pairs(self.soundIndexes) do
		-- Play the Sound

		self.sounds[name] = playSound3D(self.soundIndex..soundfile, x, y, z, true);
		setSoundVolume(self.sounds[name], 0);

		setSoundMaxDistance(self.sounds[name], 100);

		attachElements(self.sounds[name], localPlayer)

		if(isElement(self.sounds[name])) then
			soundCount = soundCount+1;
		end
	end]]

	if(soundCount < #self.sounds) then
		outputConsole("Rain Sounds nicht korrekt geladen!")
	else
		outputConsole("Rain Sounds geladen");
	end
end

-- ///////////////////////////////
-- ///// DestroySounds 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CustomRain:DestroySounds()
	for index, sound in pairs(self.sounds) do
		if(isElement(sound)) then
			destroyElement(sound);
		end
	end
end

-- ///////////////////////////////
-- ///// Enable		 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CustomRain:Enable(thunder)
	if(self.state == false) then
		self.state =  true;

		self:CreateSounds();


		self.checkSurfaceTimer 	= setTimer(self.cursorMoveFunc, 1000, 0);
		self.soundFadeTimer		= setTimer(self.fadeSoundsFunc, 50, 0);

		self.thunder = thunder;

		self.surface = 1337
		self:CheckSurface()
	end
end


-- ///////////////////////////////
-- ///// Disable	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CustomRain:Disable()
	if(self.state == true) then
		self.state =  false;

		self:DestroySounds();

		if(isTimer(self.checkSurfaceTimer)) then
			killTimer(self.checkSurfaceTimer)
			killTimer(self.soundFadeTimer);
		end
	end
end

-- ///////////////////////////////
-- ///// DoChangeSound 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

-- TODO: Fade
--[[
function CustomRain:DoChangeSound()
	for index, sound in pairs(self.sounds) do
		setSoundVolume(sound, 0.0)

		if(index == self.materialSounds[self.surfaces:GetTypeFromID(self.surface)]) then
			setSoundVolume(sound, self.overallVolume);
		end
	end
end]]

-- ///////////////////////////////
-- ///// FadeSounds 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CustomRain:FadeSounds()
	for index, sound in pairs(self.sounds) do
		if(isElement(sound)) then

			local volume = getSoundVolume(sound);

			local maxVolume = self.overallVolume


		--	outputChatBox(self.soundsToFade[sound])
			if(self.soundsToFade[sound] == true) then		-- Einfaden
				if(volume < maxVolume) then
					setSoundVolume(sound, volume+0.005);
				--	outputChatBox("sound volume up")
				end

				if(volume > maxVolume) then
					setSoundVolume(sound, volume-0.005);
				--	outputChatBox("sound volume up")
				end
			elseif(self.soundsToFade[sound] == false) then	-- Ausfaden
				if(volume > 0) then
					setSoundVolume(sound, volume-0.0025);
				--	outputChatBox("sound volume down")
				end

			end
		end
	end
end

-- ///////////////////////////////
-- ///// FadeSoundOut 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CustomRain:FadeSoundOut(sound)
	if(self.soundsToFade[sound] == true) then
		self.soundsToFade[sound] = false;
--		self.soundFade[sound] = "out";
	end
end

-- ///////////////////////////////
-- ///// FadeSoundIn		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CustomRain:FadeSoundIn(sound)
	if(self.soundsToFade[sound] == false) or not(self.soundsToFade[sound]) then
		self.soundsToFade[sound] = true;
--		self.soundFade[sound] = "in";
	end
end

-- ///////////////////////////////
-- ///// DoChangeSound 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CustomRain:DoChangeSound()
	for index, sound in pairs(self.sounds) do
		self:FadeSoundOut(sound);

		if(index == self.materialSounds[self.surfaces:GetTypeFromID(self.surface)] and getElementInterior(localPlayer) == 0) then
			self:FadeSoundIn(sound);
	--		outputChatBox("sound fade")
			self.currentSound = sound;
		end
	end
end
-- ///////////////////////////////
-- ///// CheckSurface 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CustomRain:CheckSurface()
	if(self.state) then
		local x, y, z = getCameraMatrix()

		local istInSache, distanz = self.surfaces:IsAboveThing(x, y, z);

		local mat;

		if not(istInSache) then
			mat = self.surfaces:GetSurfaceID(x, y, z);

			if not(mat) then
				x, y, z = getElementPosition(localPlayer)
				mat = self.surfaces:GetSurfaceID(x, y, z)
			end
		else

			if(distanz < 2) then
				mat = -2;
			else
				mat = -1;
			end

		end
		--outputChatBox(tostring(mat)..", "..tostring(self.surfaces:GetTypeFromID(mat)))

	--	outputChatBox(tostring(mat)..", "..tostring(self.surfaces:GetTypeFromID(mat)))

		if(mat) and (self.surface ~= mat) then
			self.surface = mat;
			self:DoChangeSound();
		end

		-- CHECK THUNDER --

		if(self.thunder == true) then
			if not(isElement(self.thunderSound)) then
				local rand = math.random(1, 10)

				if(rand == 5) then
					self.thunderSound = playSound(self.thunderIndex.."thunder"..math.random(1, self.maxThunderSounds)..".mp3", false);
					setSoundVolume(self.thunderSound, 0.5)

				end
			end
		end
	end
end

-- ///////////////////////////////
-- ///// RenderSounds 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CustomRain:RenderSounds()
	-- Renders volume for sounds

	local x, y, z = getCameraMatrix()

	local istInSache, distanz = self.surfaces:GetSurfaceID(x, y, z);

	if(distanz) then

		distanz = getDistanceBetweenPoints3D(x, y, z, distanz[1], distanz[2], distanz[3])

		self.overallVolume = math.abs((5-distanz)/10);

		if(self.overallVolume < self.defaultVolume) then

			self.overallVolume = self.defaultVolume
		elseif(self.overallVolume > self.defaultVolume*2) then
			self.overallVolume = self.defaultVolume*2
		end

	else
		self.overallVolume = self.defaultVolume
	end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CustomRain:Constructor(...)
	self.worldSoundIndexes		=
	{
		[4] = false,	-- Thunder
--		[5] = false,	-- Regen
--		[6] = false,	-- Regen

	}

	self.soundIndexes			=
	{
		["canopy"]				= "rain_canopy.mp3",
		["cement"]				= "rain_cement.mp3",
		["constant"]			= "rain_constant.mp3",
		["default"]				= "rain_default.mp3",
		["interior"]			= "rain_interior.mp3",
		["metal"]				= "rain_metal.mp3",
		["roof"]				= "rain_roof.mp3",
		["vegetation"]			= "rain_vegetation.mp3",
		["window"]				= "rain_window.mp3",

	}

	self.materialSounds			=
	{
		["tarmac"]				= "constant",
		["concrete"]			= "cement",
		["gravel"]				= "vegetation",
		["grass"]				= "vegetation",
		["dirt"]				= "vegetation",
		["vegetation"]			= "vegetation",
		["sand"]				= "vegetation",
		["stone"]				= "concrete",
		["water"]				= "constant",
		["wood"]				= "vegetation",
		["glass"]				= "window",
		["metal"]				= "metal",
		["rubbish"]				= "constant",
		["misc"]				= "constant",
		["interior"]			= "interior",
		["roof"]				= "roof",

	}

	self.rainWeather			=
	{
		[8] = true,
		[16] = true,
	}

	self.state					= false;
	self.overallVolume			= 0.25;
	self.defaultVolume			= 0.25;
	self.maxThunderSounds		= 7;

	self.sounds 				= {};

	self.soundIndex				= "http://noneatme.de/sound/public/rain/";

	self.thunderIndex			= "res/sounds/thunder/";

	self.targetSound			= false;

	self.surfaces				= Surfaces:New();

	self.surface				= 1337;

	self.soundsToFade			= {};
--	self.soundFade				= {};

	for sound, bool in pairs(self.worldSoundIndexes) do
		setWorldSoundEnabled(sound, bool);
	end

	self.cursorMoveFunc			= function(...) self:CheckSurface(...) end;
	self.fadeSoundsFunc			= function(...) self:FadeSounds(...) end;
	self.renderSounds			= function(...) self:RenderSounds() end;
	self.checkRainFunc			= function(...)
		local rain = false;
		local thunder = false;
		if(getWeather() == 8) then
			rain = true;
			thunder = true;
		elseif(getWeather() == 16) then
			rain = true;
			thunder = false;
		else
			rain = false;
			thunder = false;
		end


		if(rain == true) then
			self:Enable(thunder)
		else
			self:Disable();
		end
	end


	--outputDebugString("[CALLING] CustomRain: Constructor");

	self.checkTimer				= setTimer(self.checkRainFunc, 1000, 0)

	addEventHandler("onClientRender", getRootElement(), self.renderSounds)

	--self:Enable(true);
end


-- EVENT HANDLER --
