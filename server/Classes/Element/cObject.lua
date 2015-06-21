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
-- ## Name: Object.lua					##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

CObject = inherit(CElement)

-- ///////////////////////////////
-- ///// Save				//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CObject:Save(x, y, z, rx, ry, rz)
	if(self.iID) then	-- Moveable Object

		if not(x and y and z and rx and ry and rz) then
			x, y, z = getElementPosition(self);
			rx, ry, rz = getElementRotation(self);
		end
		local int, dim		= getElementInterior(self), getElementDimension(self);
		local model			= getElementModel(self);
		local owner			= self.sOwner;
		local sonstiges		= (self.sSonstiges or "0|0");
		local extras		= (self.sExtras or "0|0|0|0|0");


		CDatabase:getInstance():exec("UPDATE house_objects SET `Owner`=?, `Interior`=?, `Dimension`=?, `Position`=?, `Modell`=?, `Rotation`=?, `Werteattribut`=?  WHERE `ID`=?;", owner, int, dim, x.."|"..y.."|"..z, model, rx.."|"..ry.."|"..rz, toJSON(self.werteAttribut), self.iID)
	end
end

-- ///////////////////////////////
-- ///// CreateNewEntry		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CObject:CreateNewEntry()
	local x, y, z 		= getElementPosition(self);
	local rx, ry, rz	= getElementRotation(self);
	local int, dim		= getElementInterior(self), getElementDimension(self);
	local model			= getElementModel(self);
	CDatabase:getInstance():query("INSERT INTO house_objects(Owner, Interior, Dimension, Position, Modell, Rotation, Werteattribut) VALUES(?, ?, ?, ?, ?, ?, ?);", self.sOwner, int, dim, x.."|"..y.."|"..z, model, rx.."|"..ry.."|"..rz, "[ [ ] ]")

	local result 	= CDatabase:getInstance():query("SELECT LAST_INSERT_ID() AS ID;");
	self.iID		= result[1]["ID"];

end

-- ///////////////////////////////
-- ///// GetOwner			//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CObject:GetOwner()
	return self.sOwner;
end

-- ///////////////////////////////
-- ///// SetData			//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CObject:SetWAData(sData, sWert, bDontSave)
	self.werteAttribut[sData] = sWert;

	if not(bDontSave) then
		self:Save();
	end
	setElementData(self, "wa:"..sData, sWert);
end

-- ///////////////////////////////
-- ///// GetData			//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CObject:GetWAData(sData)
	return (self.werteAttribut[sData] or false);
end


-- ///////////////////////////////
-- ///// Delete				//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CObject:Delete()
	CDatabase:getInstance():exec("DELETE FROM house_objects WHERE `ID`=?;", self.iID)
	if(isElement(self)) then
		destroyElement(self);
	end
end

function CObject:setScale(...)
	return setObjectScale(self, ...)
end


-- ///////////////////////////////
-- ///// Constructor		//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function CObject:constructor()
	self.werteAttribut = {}
end

-- ///////////////////////////////
-- /////	Destructor		//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function CObject:destructor()

end
