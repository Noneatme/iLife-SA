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
-- ## Name: CO_Sodaautomat.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings

CO_Sodaautomat = {};
CO_Sodaautomat.__index = CO_Sodaautomat;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function CO_Sodaautomat:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// TrinkCola	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CO_Sodaautomat:TrinkCola(uPlayer, uObject)
	if(isElement(uPlayer)) then
		if(uPlayer:getMoney() >= self.m_iKosten) then
			local x, y, z = getElementPosition(uPlayer);
			local x2, y2, z2 = getElementPosition(uObject);

			if(getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) < 3) then
				if(boneAttachManager.drinking[uPlayer] ~= true) then
					uPlayer:addMoney(-self.m_iKosten);


					boneAttachManager:AttachToPlayerBone(uPlayer, 1546, 5, 12, 0, 0.05, 0.025, 0, -90, 0)
					boneAttachManager:SetPlayerDrinking(uPlayer, true);
					triggerClientEvent(getRootElement(), "onClientObjectAction", getRootElement(), 3, uObject);

					local ownerID       = tonumber(getElementData(uObject, "wa:Owner"));

					if(ownerID) and (Players[ownerID]) then
						Players[ownerID]:addMoney(self.m_iKosten);
						Players[ownerID]:showInfoBox("info", uPlayer:getName().." hat deinen Sodaautomaten benutzt! (+$"..self.m_iKosten..")");
					end
				else
					uPlayer:showInfoBox("error", "Du hast bereits eine Dose!");
				end
			else
				uPlayer:showInfoBox("error", "Du bist zu weit entfernt!");
			end
		else
			uPlayer:showInfoBox("error", "Das Kostet $"..self.m_iKosten.."! (Umweltsteuern)")
		end
	end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CO_Sodaautomat:Constructor(...)
	-- Klassenvariablen --
	self.m_iKosten      = 50;
	
	-- Methoden --
	
	
	-- Events --
	
	--logger:OutputInfo("[CALLING] CO_Sodaautomat: Constructor");
end

-- EVENT HANDLER --
