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
-- ## Name: CO_Radio.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings

CO_Radio = {};
CO_Radio.__index = CO_Radio;

addEvent("onCustomObjectRadioPlay", true);
addEvent("onCustomObjectRadioStop", true);
--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function CO_Radio:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// PlayRadio	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CO_Radio:PlayRadio(uRadio, sUrl, bLooped)
	if(self.radioPlayed[uRadio] == true) then
		self:StopRadio(uRadio, sUrl, bLooped);
	end
	local iLooped = 1;
	if(bLooped == false) then
		iLooped = 0;
	end



	uRadio:SetWAData("radio_url", sUrl);
	uRadio:SetWAData("radio_looped", iLooped);


	triggerClientEvent(getRootElement(), "onClientRadioStart", getRootElement(), uRadio, sUrl, bLooped);
	self.radioPlayed[uRadio] = true;
end

-- ///////////////////////////////
-- ///// StopRadio	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CO_Radio:StopRadio(uRadio, sUrl, bLooped)
	if(self.radioPlayed[uRadio] == true) then

		uRadio:SetWAData("radio_url", false);
		uRadio:SetWAData("radio_looped", false);
		
		uRadio:Save();
		triggerClientEvent(getRootElement(), "onClientRadioStop", getRootElement(), uRadio);

		self.radioPlayed[uRadio] = false;
	else
		client:showInfoBox("error", "Das Radio l\aeuft nicht!");
	end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CO_Radio:Constructor(...)
	-- Klassenvariablen --
	self.radioPlayed = {}
	
	-- Methoden --
	
	self.playRadioFunc				= function(...) self:PlayRadio(...) end;
	self.stopRadioFunc				= function(...) self:StopRadio(...) end;
	
	
	-- Events --
	
	addEventHandler("onCustomObjectRadioPlay", getRootElement(), self.playRadioFunc);
	addEventHandler("onCustomObjectRadioStop", getRootElement(), self.stopRadioFunc);
	--logger:OutputInfo("[CALLING] CO_Radio: Constructor");
end

-- EVENT HANDLER --
