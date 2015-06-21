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
-- ## Name: EasterEgg.lua					##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

EasterEgg = {};
EasterEgg.__index = EasterEgg;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function EasterEgg:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// Doge		 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function EasterEgg:Doge()
	outputConsole(self.dogeString);
	triggerServerEvent("onClientUnlockedAchievement", getRootElement(), 25)
end


-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function EasterEgg:Constructor(...)
	-- Klassenvariablen --
	self.dogeFunc		= function(...) self:Doge(...) end;

	self.dogeString		=
	[[
		░░░░░░░░░▄░░░░░░░░░░░░░░▄░░░░ wow
		░░░░░░░░▌▒█░░░░░░░░░░░▄▀▒▌░░░
		░░░░░░░░▌▒▒█░░░░░░░░▄▀▒▒▒▐░░░ such iLife
		░░░░░░░▐▄▀▒▒▀▀▀▀▄▄▄▀▒▒▒▒▒▐░░░
		░░░░░▄▄▀▒░▒▒▒▒▒▒▒▒▒█▒▒▄█▒▐░░░ 
		░░░▄▀▒▒▒░░░▒▒▒░░░▒▒▒▀██▀▒▌░░░ 
		░░▐▒▒▒▄▄▒▒▒▒░░░▒▒▒▒▒▒▒▀▄▒▒▌░░ so MTA
		░░▌░░▌█▀▒▒▒▒▒▄▀█▄▒▒▒▒▒▒▒█▒▐░░
		░▐░░░▒▒▒▒▒▒▒▒▌██▀▒▒░░░▒▒▒▀▄▌░
		░▌░▒▄██▄▒▒▒▒▒▒▒▒▒░░░░░░▒▒▒▒▌░
		▀▒▀▐▄█▄█▌▄░▀▒▒░░░░░░░░░░▒▒▒▐░ much driving
		▐▒▒▐▀▐▀▒░▄▄▒▄▒▒▒▒▒▒░▒░▒░▒▒▒▒▌
		▐▒▒▒▀▀▄▄▒▒▒▄▒▒▒▒▒▒▒▒░▒░▒░▒▒▐░
		░▌▒▒▒▒▒▒▀▀▀▒▒▒▒▒▒░▒░▒░▒░▒▒▒▌░
		░▐▒▒▒▒▒▒▒▒▒▒▒▒▒▒░▒░▒░▒▒▄▒▒▐░░
		░░▀▄▒▒▒▒▒▒▒▒▒▒▒░▒░▒░▒▄▒▒▒▒▌░░
		░░░░▀▄▒▒▒▒▒▒▒▒▒▒▄▄▄▀▒▒▒▒▄▀░░░ very impressive
		░░░░░░▀▄▄▄▄▄▄▀▀▀▒▒▒▒▒▄▄▀░░░░░
		░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▀▀░░░░░░░░
	]]
	
	self.qrFrame		= createObject(2257, 1102.8000488281, -841.70001220703, 108.19999694824, 345, 0, 7.25);
	setObjectScale(self.qrFrame, 1.5);
	FrameTextur:New(self.qrFrame, "cj_painting15", "ea_qr.jpg");

	-- Methoden --



	-- Events --
	addCommandHandler("doge", self.dogeFunc);
--logger:OutputInfo("[CALLING] EasterEgg: Constructor");
end

-- EVENT HANDLER --
