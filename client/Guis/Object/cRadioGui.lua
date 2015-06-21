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
-- ## Name: RadioGui.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

RadioGui = {};
RadioGui.__index = RadioGui;

addEvent("onClientRadioStart", true);
addEvent("onClientRadioStop", true);
--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function RadioGui:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// getMiddleGuiPositio//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function RadioGui:getMiddleGuiPosition(lol, lol2)
	local sWidth, sHeight = guiGetScreenSize()

	local Width,Height = lol, lol2
	local X = (sWidth/2) - (Width/2)
	local Y = (sHeight/2) - (Height/2)

	return X, Y, Width, Height

end


-- ///////////////////////////////
-- ///// DestroyGui	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function RadioGui:DestroyGui()
	destroyElement(self.guiEle.window[1]);
	showCursor(false);

	clientBusy = false;

	unbindKey("m", "up", self.noCursorFunc);
end

-- ///////////////////////////////
-- ///// BuildGui	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function RadioGui:BuildGui(theRadio)
	if not(isElement(self.guiEle.window[1])) then

		clientBusy = true;
		showCursor(true);
		guiSetInputMode("no_binds_when_editing");
		local X, Y, Width, Height = self:getMiddleGuiPosition(406, 119)

		local url 		= getElementData(theRadio, "wa:radio_url");
		local looped 	= getElementData(theRadio, "wa:radio_looped");

		if(url == 0) or not(url) then
			url = "";
		end

		if(looped == 1) then
			looped = true;
		else
			looped = false;
		end

		self.guiEle.window[1] = guiCreateWindow(X, Y, Width, Height, "Radio GUI", false)
		guiWindowSetSizable(self.guiEle.window[1], false)

		self.guiEle.label[1] = guiCreateLabel(10, 23, 178, 15, "URL des Liedes eingeben:", false, self.guiEle.window[1])
		guiSetFont(self.guiEle.label[1], "default-bold-small")
		self.guiEle.edit[1] = guiCreateEdit(9, 42, 387, 24, url, false, self.guiEle.window[1])
		self.guiEle.button[1] = guiCreateButton(10, 81, 125, 28, "Abspielen", false, self.guiEle.window[1])
		guiSetFont(self.guiEle.button[1], "default-bold-small")
		guiSetProperty(self.guiEle.button[1], "NormalTextColour", "FFAAAAAA")
		self.guiEle.button[2] = guiCreateButton(145, 81, 125, 28, "Stoppen", false, self.guiEle.window[1])
		guiSetFont(self.guiEle.button[2], "default-bold-small")
		guiSetProperty(self.guiEle.button[2], "NormalTextColour", "FFAAAAAA")
		self.guiEle.checkbox[1] = guiCreateCheckBox(286, 78, 104, 31, "Wiederholen?", false, false, self.guiEle.window[1])
		guiSetFont(self.guiEle.checkbox[1], "default-bold-small")
		guiCheckBoxSetSelected(self.guiEle.checkbox[1], looped);

		self.guiEle.button[3] = guiCreateButton(337, 19, 53, 19, "[X]", false, self.guiEle.window[1])
		guiSetProperty(self.guiEle.button[3], "NormalTextColour", "FFAAAAAA")

		addEventHandler("onClientGUIClick", self.guiEle.button[3], self.closeGuiFunc, false);

		addEventHandler("onClientGUIClick", self.guiEle.button[1], function()
			local url 		= guiGetText(self.guiEle.edit[1]);
			local looped 	= guiCheckBoxGetSelected(self.guiEle.checkbox[1]);
			if(#url > 5) then

				if(string.find(url, ".youtube.")) then
					showInfoBox("error", "Du kannst keine Youtube-Videos in einem Radio abspielen!\n(Logisch, oder?)")
				elseif not(string.find(url, "://")) then
					showInfoBox("error", "Dein Link muss ein http(s):// beinhalten.")
				else

					triggerServerEvent("onCustomObjectRadioPlay", localPlayer, theRadio, url, looped);
					self:DestroyGui();
				end
			else
				showInfoBox("error", "Ungueltige URL!");
			end
		end, false)

		addEventHandler("onClientGUIClick", self.guiEle.button[2], function()
			triggerServerEvent("onCustomObjectRadioStop", localPlayer, theRadio);
			guiSetText(self.guiEle.edit[1], "");
		end, false)


		bindKey("m", "up", self.noCursorFunc);
	end
end

-- ///////////////////////////////
-- /////	RadioStart 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function RadioGui:RadioStart(uRadio, sUrl, bLooped)
	if(isElement(self.radioSounds[uRadio])) then
		self:RadioStop(uRadio);
	end

	local x, y, z = getElementPosition(uRadio);
	local int, dim	= getElementInterior(uRadio), getElementDimension(uRadio);

	self.radioSounds[uRadio] = playSound3D(sUrl, x, y, z, bLooped);

	addEventHandler("onClientSoundBeat", self.radioSounds[uRadio], self.soundBeatFunc)
	addEventHandler("onClientSoundChangedMeta", self.radioSounds[uRadio], function(sTitle)
		if((source:getPosition()-localPlayer:getPosition()).length < 10) and not (isPedInVehicle(localPlayer))  then
			showInfoBox("radio", sTitle, 5000, "none")
		end
	end)

	if(isElement(self.radioSounds[uRadio])) then
		attachElements(self.radioSounds[uRadio], uRadio);
		setElementInterior(self.radioSounds[uRadio], int);
		setElementDimension(self.radioSounds[uRadio], dim);
		setSoundMaxDistance(self.radioSounds[uRadio], 30)
	end
end

-- ///////////////////////////////
-- /////	RadioStop 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function RadioGui:RadioStop(uRadio, sUrl, bLooped)

	if(isElement(self.radioSounds[uRadio])) then
		destroyElement(self.radioSounds[uRadio]);
	end

	setObjectScale(uRadio, 1)
end


-- ///////////////////////////////
-- ///// CheckRadio			//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function RadioGui:CheckRadio(uRadio)
	self:RadioStop(uRadio);
end

-- ///////////////////////////////
-- ///// CreateRadioSoundFunc//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function RadioGui:CreateRadioSound(uRadio)
	if(self.bRadiosEnabled) then
		if(getElementData(uRadio, "wa:radio_url")) and (getElementModel(uRadio) == 2103) then
			if(toboolean(cConfig_RadioConfig:getInstance():getConfig("radenabled_object"))) then
				if not(self.radioSounds[uRadio]) then
					local sUrl, bLooped = getElementData(uRadio, "wa:radio_url"), getElementData(uRadio, "wa:radio_looped");

					if(tonumber(bLooped) == 1) then
						bLooped = true;
					else
						bLooped = false;
					end

					if(sUrl) and (#sUrl > 5) then
						self:RadioStart(uRadio, sUrl, bLooped)
					end
				end
			end
		end
	end
end

-- ///////////////////////////////
-- ///// SoundBeat	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function RadioGui:SoundBeat(uSound)
	self.soundBeatValue[uSound] = 30;
end

-- ///////////////////////////////
-- ///// Render		 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function RadioGui:Render()
	for radio, sound in pairs(self.radioSounds) do
		if not(isElement(sound)) then
			self.radioSounds[radio] = nil;
		end
		if(self.soundBeatValue[sound]) and (isElement(sound)) then
			if(self.soundBeatValue[sound] > 0) then
				self.soundBeatValue[sound] = self.soundBeatValue[sound]-5;
			end

			setObjectScale(radio, 1+((self.soundBeatValue[sound]/100))+(math.random(10, 50)/1000));
		end
	end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function RadioGui:Constructor(...)
	-- Klassenvariablen --
	self.guiEle = {
		checkbox = {},
		edit = {},
		button = {},
		window = {},
		label = {}
	}

	self.radioSounds	= {}
	self.soundBeatValue = {}

	self.bRadiosEnabled = true;

	self.closeGuiFunc	= function(...) self:DestroyGui(...) end;

	self.noCursorFunc	= function(...) showCursor(true) end;
	self.renderFunc		= function(...) self:Render() end;

	-- Methoden --

	self.radioStartFunc		= function(...) self:RadioStart(...) end;
	self.radioStopFunc		= function(...) self:RadioStop(...) end;

	self.checkRadioFunc				= function(...) self:CheckRadio(source, ...) end;
	self.createRadioSoundFunc		= function(...) self:CreateRadioSound(source, ...) end;
	self.soundBeatFunc				= function(...) self:SoundBeat(source, ...) end;
	-- Events --

	addEventHandler("onClientRadioStart", getRootElement(), self.radioStartFunc);
	addEventHandler("onClientRadioStop", getRootElement(), self.radioStopFunc);

	addEventHandler("onClientElementDestroy", getRootElement(), self.checkRadioFunc);
	addEventHandler("onClientElementStreamIn", getRootElement(), self.createRadioSoundFunc);

	addEventHandler("onClientRender", getRootElement(), self.renderFunc)


	addCommandHandler("stopradios", function() self.bRadiosEnabled = not(self.bRadiosEnabled) outputChatBox("Radios de/aktiviert.", 255, 255, 0) end)
	--logger:OutputInfo("[CALLING] RadioGui: Constructor");
end

-- EVENT HANDLER --
