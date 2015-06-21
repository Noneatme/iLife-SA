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
-- ## Name: Logger.lua					##
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
-- ///// GetDate	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Logger:GetDate()
	local time 		= getRealTime();
	local day 		= time.monthday;
	local month 	= time.month+1;
	local year 		= time.year+1900;
	local hour 		= time.hour;
	local minute	= time.minute;
	local second 	= time.second;

	if(day < 10) then
		day = "0"..day;
	end
	if(month < 10) then
		month = "0"..month;
	end
	if(hour < 10) then
		hour = "0"..hour;
	end
	if(minute < 10) then
		minute = "0"..minute;
	end
	if(second < 10) then
		second = "0"..second;
	end
	return day, month, year, hour, minute, second, (day.."."..month.."."..year.." "..hour..":"..minute..":"..second)
end

-- ///////////////////////////////
-- ///// WriteDefaultFileHeade////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Logger:WriteDefaultFileHeader(file)
	local iDay, iMonth, iYear, iHour, iMinute, iSecond = self:GetDate();

	fileWrite(file, "Log gestartet am "..iDay.."."..iMonth.."."..iYear.." um "..iHour..":"..iMinute..":"..iSecond.."\n");
	fileWrite(file, "_____________\n\n");

end

-- ///////////////////////////////
-- ///// UpdateBase64Files	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Logger:UpdateBase64File(sFilePath, sString)
	sFilePath = string.gsub(sFilePath, ".log", ".base64")


	local base64File;

	if not(fileExists(sFilePath)) then
		base64File = fileCreate(sFilePath);
	else

		base64File = fileOpen(sFilePath);
	end


	fileSetPos(base64File, fileGetSize(base64File));
	fileWrite(base64File, base64Encode(sString).."\n");

	fileFlush(base64File);
	fileClose(base64File);
end

-- ///////////////////////////////
-- ///// WriteDefaultFileHeade////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Logger:WriteLogLine(file, sString, iR, iG, iB, filePath)
	local iDay, iMonth, iYear, iHour, iMinute, iSecond = self:GetDate();

	-- Entfernung der Sonderzeichen
	sString = string.gsub(string.gsub(sString, '#%x%x%x%x%x%x', ''), '#%x%x%x%x%x%x', '');

	--
	fileSetPos(file, fileGetSize(file));
	fileWrite(file, "["..iHour..":"..iMinute..":"..iSecond.."] "..sString.."\n");

	self:UpdateBase64File(filePath, sString);

end

-- ///////////////////////////////
-- ///// WriteDebugLogLine	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Logger:WriteDebugLogLine(file, sString, iLevel, sFile, iLine)
	local iDay, iMonth, iYear, iHour, iMinute, iSecond = self:GetDate();

	-- Entfernung der Sonderzeichen
	sString = string.gsub(string.gsub(sString, '#%x%x%x%x%x%x', ''), '#%x%x%x%x%x%x', '');

	--
	fileSetPos(file, fileGetSize(file));

	local praefix = "";
	if(iLevel == 0) then
		praefix = " ";
	elseif(iLevel == 1) then
		praefix = "ERROR: ";
	elseif(iLevel == 2) then
		praefix = "WARNING: ";
	elseif(iLevel == 3) then
		praefix = "INFO: ";
	end


	if not(sFile) then
		sFile = "unknow";
	end
	if not(iLine) then
		iLine = "unknow";
	end

	sString = praefix.."("..sFile..") Line "..iLine..": "..sString;

	fileWrite(file, "["..iHour..":"..iMinute..":"..iSecond.."]"..sString.."\n");

end

-- ///////////////////////////////
-- ///// Println	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Logger:LogChat(sString, iR, iG, iB)
	local iDay, iMonth, iYear, iHour, iMinute, iSecond = self:GetDate();


	local filePath = self.path..iDay.."."..iMonth.."."..iYear.."/"..iHour.."_00.log";

	local file;
	if(fileExists(filePath)) then
		file = fileOpen(filePath);
	else
		file = fileCreate(filePath);
		self:WriteDefaultFileHeader(file);
	end
	local sString		= sString.." ["..teaEncode(sString, (getElementData(localPlayer, "Serial") or "-")).."]";
	self:WriteLogLine(file, sString, iR, iG, iB, filePath)

	-- Logs --
	fileFlush(file);
	fileClose(file);
-- Ende des Logs
end

-- ///////////////////////////////
-- ///// LogDebug	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Logger:LogDebug(sString, iLevel, sFile, iLine)
	local iDay, iMonth, iYear, iHour, iMinute, iSecond = self:GetDate();

	if not(isDebugViewActive()) and (toboolean(config:getConfig("log_debug"))) then
		if(toboolean(cConfiguration:getInstance():getConfig("log_actions"))) then
			local filePath = self.debugpath..iDay.."."..iMonth.."."..iYear.."/"..iHour.."_00.log";

			local file;
			if(fileExists(filePath)) then
				file = fileOpen(filePath);
			else
				file = fileCreate(filePath);
				self:WriteDefaultFileHeader(file);
			end

			self:WriteDebugLogLine(file, sString, iLevel, sFile, iLine)


			-- Logs --
			fileFlush(file);
			fileClose(file);
		-- Ende des Logs
		end
	end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Logger:Constructor(...)
	-- Klassenvariablen --
	self.path = "logs/chatlogs/";
	self.debugpath = "logs/debug/";
	-- Methoden --

	-- Events --
	self.logChatFunc = function(...) self:LogChat(...) end;
	self.logDebugFunc = function(...) self:LogDebug(...) end;

	self.m_bLogConsole	= toBoolean(config:getConfig("log_console"));

	--logger:OutputInfo("[CALLING] Logger: Constructor");
	addEventHandler("onClientChatMessage", getRootElement(), self.logChatFunc);
	addEventHandler("onClientDebugMessage", getRootElement(), self.logDebugFunc);


	addEventHandler("onClientConsole", getLocalPlayer(), function(sText)
		if(self.m_bLogConsole) then
			local time		= getRealTime();
			local day 		= time.monthday;
			local month 	= time.month+1;
			local year 		= time.year+1900;

			local sName		= "logs/console/"..day.."-"..month.."-"..year..".log"

			local _, _, _, _, _, _, date	= self:GetDate();

			if not(fileExists(sName)) then
				local file = fileCreate(sName)
				fileWrite(file, "[LOG STARTED: "..date.."]\n\n");
				fileClose(file)
			end

			local file		= fileOpen(sName);
			fileSetPos(file, fileGetSize(file));
			fileWrite(file, "[.."..date.."] "..sText.."\n");
			fileFlush(file);		-- SPUELUNG BETAETIGEN!
			fileClose(file);
		end
	end)
end

-- EVENT HANDLER --
