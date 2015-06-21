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
-- ## Name: Logger.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings

Logger = {};
Logger.__index = Logger;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function Logger:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// OutputPlayerLog	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Logger:OutputPlayerLog(uPlayer, sMessage1, sMessage2, sMessage3, sMessage4)
	local time = getRealTime();
	local date = time.monthday.."."..(time.month+1).."."..(time.year+1900).." "..time.hour..":"..time.minute;
	local ausdruecke = {"'", "\\", "/"};
	
	if not(sMessage1) then
		sMessage1 = "-"
	end
	if not(sMessage2) then
		sMessage2 = "-"
	end
	if not(sMessage3) then
		sMessage3 = "-"
	end
	if not(sMessage4) then
		sMessage4 = "-"
	end
	for _, ausdruck in pairs(ausdruecke) do
		sMessage1 = tostring(sMessage1):gsub(ausdruck, "");
		sMessage2 = tostring(sMessage2):gsub(ausdruck, "");
		sMessage3 = tostring(sMessage3):gsub(ausdruck, "");
		sMessage4 = tostring(sMessage4):gsub(ausdruck, "");

	end
	local name, id
	
	if(type(uPlayer) == "string") then
		name = uPlayer;
		id	= (PlayerIDS[name] or 0)
	else
		name = uPlayer:getName();
		id = uPlayer:getID()
	end

	if not(id) then id = 0 end
	
	
	CDatabase:getInstance():exec("INSERT INTO logs(Datum, Playername, PlayerID, Aktion, Message2, Message3, Message4) VALUES ('"..date.."', '"..name.."', '"..id.."', '"..sMessage1.."', '"..sMessage2.."', '"..sMessage3.."', '"..sMessage4.."');");
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Logger:Constructor(...)
	-- Klassenvariablen --
	
	
	-- Methoden --
	
	
	-- Events --
	
	--logger:OutputInfo("[CALLING] Logger: Constructor");
end

-- EVENT HANDLER --
