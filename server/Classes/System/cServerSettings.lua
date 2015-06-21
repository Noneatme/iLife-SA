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
-- ## Name: ServerSettings.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings

ServerSettings = {};
ServerSettings.__index = ServerSettings;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function ServerSettings:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// GetSetting 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function ServerSettings:GetSetting(sAttribut)
	return ((self.settings[sAttribut]) or false)
end

-- ///////////////////////////////
-- ///// SetSetting 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function ServerSettings:SetSetting(sAttribut, sWert, bDontSave)
	self.settings[sAttribut] = sWert;
	
	if not(bDontSave) then
		self:UpdateServerSetting(sAttribut);
	end
end

-- ///////////////////////////////
-- ///// InsertNewSetting	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function ServerSettings:InsertNewSetting(sAttribut, sWert)
	CDatabase:getInstance():exec("INSERT INTO serversettings (Attribut, Wert) VALUES ('"..sAttribut.."', '"..sWert.."');");
end

-- ///////////////////////////////
-- ///// UpdateServerSetting//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function ServerSettings:UpdateServerSetting(sSetting)
	CDatabase:getInstance():exec("UPDATE serversettings SET Wert = '"..self.settings[sSetting].."' WHERE Attribut = '"..sSetting.."';");
	outputServerLog("Updated Setting: "..sSetting);
end

-- ///////////////////////////////
-- ///// ExecuteFirstSettings//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function ServerSettings:ExecuteFirstSettings()
	for setting, value in pairs(self.defaultSettings) do
		self:InsertNewSetting(setting, value);
	end
	
	self:LoadSettings();
end

-- ///////////////////////////////
-- ///// LoadSettings 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function ServerSettings:LoadSettings()
	local result = CDatabase:getInstance():query("SELECT * FROM serversettings;");
	local count = 0;
	local start = getTickCount();
	if(result) and (#result > 0) then
		for index, row in pairs(result) do
			local sWert = row["Wert"];
			
			-- Parse Wert --
			if(tonumber(sWert)) then
				sWert = tonumber(sWert);
			else
				sWert = tostring(sWert);
				
				if(sWert:lower() == "false") then
					sWert = false;
				elseif (sWert:lower() == "true")  then
					sWert = true;
				end
			end
			
			self.settings[tostring(row["Attribut"])] = sWert; 
			
			count = count+1;
		end
		
		outputServerLog("Es wurden "..count.." Serversettings in "..getTickCount()-start.." MS gefunden!")
	
	else
		outputServerLog("Es wurden keine Serversettings gefunden! Erstelle neue...")
		self:ExecuteFirstSettings();
	end
	
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function ServerSettings:Constructor(...)
	-- Klassenvariablen --
	self.settings			= {}
	self.defaultSettings 	= 
	{
		["lottojackpot"] = 0,
	}
	
	-- Methoden --
	self:LoadSettings();
	
	-- Events --
	
	--logger:OutputInfo("[CALLING] ServerSettings: Constructor");
end

-- EVENT HANDLER --
