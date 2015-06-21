--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

-- #######################################
-- ## Project: 		 iLife				##
-- ## For MTA: San Andreas				##
-- ## Name: cAsservatenkammer.lua		        	##
-- ## Author: Noneatme(Gunvarrel)		##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- ## Date: March 2015                  ##
-- #######################################

cAsservatenkammer = inherit(cSingleton);

--[[

]]

-- ///////////////////////////////
-- ///// loadItems	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cAsservatenkammer:load(...)
	local result		= CDatabase:getInstance():query("SELECT * FROM asservatenkammer;");

	if(result) and (#result > 0) then
		for index, row in pairs(result) do
			self.m_tblItems[tonumber(row['ItemID'])] = tonumber(row['iAnzahl']);
		end
	else
		outputDebugString("Keine Items in der Asservatenkammer des LSPD's!")
	end
end

-- ///////////////////////////////
-- ///// addItem		 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cAsservatenkammer:addItem(iItemID, iAnzahl)
	if not(self.m_tblItems[iItemID]) then
		self.m_tblItems[iItemID] = 0;

		CDatabase:getInstance():exec("INSERT INTO asservatenkammer (ItemID, iAnzahl) VALUES (?, ?);", iItemID, iAnzahl);
	end

	self.m_tblItems[iItemID] = self.m_tblItems[iItemID]+iAnzahl

	CDatabase:getInstance():exec("UPDATE asservatenkammer SET iAnzahl = ? WHERE ItemID = ?;", self.m_tblItems[iItemID], iItemID);
end

-- ///////////////////////////////
-- ///// removeItem		 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cAsservatenkammer:removeItem(iItemID)
	if not(self.m_tblItems[iItemID]) then
		self.m_tblItems[iItemID] = 0;
	end

	self.m_tblItems[iItemID] = nil

	CDatabase:getInstance():exec("DELETE FROM asservatenkammer WHERE ItemID = ?;", iItemID);
end

-- ///////////////////////////////
-- ///// sendPlayerInfo		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cAsservatenkammer:sendPlayerInfo(uPlayer)
	triggerClientEvent(uPlayer, "onClientPlayerAsservatenKammerInfoGet", uPlayer, self.m_tblItems)
end

-- ///////////////////////////////
-- ///// unsendPlayerInfo		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cAsservatenkammer:unsendPlayerInfo(uPlayer)
	triggerClientEvent(uPlayer, "onClientPlayerAsservatenKammerInfoRemove", uPlayer)
end


-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cAsservatenkammer:constructor(...)
    -- Klassenvariablen --
	self.m_tblItems		= {}

    -- Funktionen --
	self:load();

    -- Events --

end

-- EVENT HANDLER --
