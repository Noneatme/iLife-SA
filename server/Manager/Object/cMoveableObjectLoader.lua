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
-- ## Name: MoveableObjectLoader.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

MoveableObjectLoader = inherit(cSingleton);

--[[

]]



-- ///////////////////////////////
-- ///// HasUserPermissions	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function MoveableObjectLoader:HasUserPermissions(iUser, iOwner, tblTenands)
	if(tonumber(iUser) == tonumber(iOwner)) then
		return true;
	else
		return false;
	end

	return true;
end

-- ///////////////////////////////
-- ///// IsInFactionRange	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function MoveableObjectLoader:IsInFactionRange(uObject)
	for ID, Faction in pairs(Factions) do
		if(Faction.Distanz > 0) then
			local x1, y1, z1 = getElementPosition(uObject);
			local x2, y2, z2 = getElementPosition(Faction.FactionColshape);

			if(getDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2) <= Faction.Distanz) then
				return true;
			end
		end
	end
	return false;
end

-- ///////////////////////////////
-- ///// StartLoadingObjects//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function MoveableObjectLoader:startLoadingObjects()

	self.query1 	= CDatabase:getInstance():query("SELECT * FROM house_objects;");
	self.query2		= CDatabase:getInstance():query("SELECT * FROM houses;");

	outputDebugString("[ObjectLoader] Lade! Objekte: " ..#self.query1..", Haeuser: "..#self.query2);

	self.datObjects 		= {}
	self.objectLoading		= {};
	local count				= 0;
	local startTick			= getTickCount()

	for i, v in pairs(self.query1) do
		self:loadObject(i);
		count = count+1;
	end

	outputDebugString("[ObjectLoader] Fertig Geladen! Objekte: " ..#self.query1..", Geloescht(Inaktivitaet): "..self.deleted..", Zeit: "..((getTickCount()-startTick)/1000).. " Sekunden");

end


-- ///////////////////////////////
-- ///// LoadObjectRow 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function MoveableObjectLoader:loadObject(i)
	if not(self.objectLoading[i]) then
		self.objectLoading[i] = true;
		local v = self.query1[i];


		local x, y, z = tonumber(gettok(v["Position"], 1, "|")), tonumber(gettok(v["Position"], 2, "|")), tonumber(gettok(v["Position"], 3, "|"));
		local rx, ry, rz = tonumber(gettok(v["Rotation"], 1, "|")), tonumber(gettok(v["Rotation"], 2, "|")), tonumber(gettok(v["Rotation"], 3, "|"));

		local interior 	= tonumber(v["Interior"])
		local dim		= tonumber(v["Dimension"])

		local sonstiges	= v["Sonstiges"];
		local extras	= v["Extra"];

		local owner		= v["Owner"];
		if(tonumber(owner)) and (tonumber(owner) ~= 0) then
			if not(isOwnerInTheLastMonthsActive(owner)) then
				owner = 0;
			end
		end

		owner	= tonumber(owner)

		if(owner ~= 0) then
			self.datObjects[i] = MoveableObject:New(v["Modell"], x, y, z, rx, ry, rz, nil, owner, true, tonumber(v["ID"]), false, interior, dim, v["Werteattribut"]).uObject;

			if not(self.m_tblObjectsByPlayerID[owner]) then
				self.m_tblObjectsByPlayerID[owner] = {}
			end
			self.m_tblObjectsByPlayerID[owner][self.datObjects[i]] = self.datObjects[i];

        else
            cBasicFunctions:doArchiveRowIntoDatabaseTable(2, v);
			self.deleted = self.deleted+1;
            CDatabase:getInstance():query("DELETE FROM house_objects WHERE `ID` = ?;", tonumber(v["ID"]));
		end
		coroutine.yield();
	end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function MoveableObjectLoader:constructor(...)
	-- Klassenvariablen --

	self.m_tblObjectsByPlayerID	= {}

	self.loadFunc		= function() self:startLoadingObjects() end
	self.thread			= cThread:new("Object_Loading_Thread", self.loadFunc, 20)
	self.deleted		= 0;

	self.thread:start(50)
end

-- EVENT HANDLER --
