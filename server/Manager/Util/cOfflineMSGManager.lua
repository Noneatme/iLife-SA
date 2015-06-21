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
-- ## Name: OfflineMSGManager.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings

OfflineMSGManager = {};
OfflineMSGManager.__index = OfflineMSGManager;

addEvent("onOfflineMSGWrite", true)

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function OfflineMSGManager:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// OutputOfflineMSG	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function OfflineMSGManager:OutputOfflineMSG(uPlayer, sNachricht)
	return outputChatBox("Hinweis: "..sNachricht, uPlayer, 181, 139, 0)
end

-- ///////////////////////////////
-- ///// CheckUserMSG 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function OfflineMSGManager:CheckUserMSG(uPlayer)
	local sName = getPlayerName(uPlayer);
	
	local result = CDatabase:getInstance():query("SELECT * FROM Offlinemsg WHERE User = '"..sName.."';");
	if(#result > 0) then
		for index, tbl in pairs(result) do
			local iID 	= tbl["ID"];
			local sMSG	= tbl["Message"];
			
			self:OutputOfflineMSG(uPlayer, sMSG);
			
			CDatabase:getInstance():exec("DELETE FROM Offlinemsg WHERE iID = '"..iID.."';");
		end
	end
end

-- ///////////////////////////////
-- ///// AddOfflineMSG 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function OfflineMSGManager:AddOfflineMSG(sUser, sNachricht)
	sNachricht = string.gsub(sNachricht, "'", "");
	if(getPlayerFromName(sUser)) then
		self:OutputOfflineMSG(getPlayerFromName(sUser), sNachricht)
	else
		CDatabase:getInstance():query("INSERT INTO Offlinemsg(User, Message) VALUES ('"..sUser.."', '"..sNachricht.."');")
	end
end

-- ///////////////////////////////
-- ///// AddCustom	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function OfflineMSGManager:AddCustom(sTarget, sMessage)
	local uPlayer = client;
	if(uPlayer:getAdminLevel() > 0) then
		local uTarget = sTarget;
		
		self:AddOfflineMSG(sTarget, sMessage);
		
		uPlayer:showInfoBox("sucess", "Nachricht gesendet!");
	end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function OfflineMSGManager:Constructor(...)
	-- Klassenvariablen --
	
	
	-- Methoden --
	self.writeFunc		= function(...) self:AddCustom(...) end;
	
	-- Events --
	addEventHandler("onOfflineMSGWrite", getRootElement(), self.writeFunc)
	--logger:OutputInfo("[CALLING] OfflineMSGManager: Constructor");
end

-- EVENT HANDLER --
