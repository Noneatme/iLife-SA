--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

--
-- Created by IntelliJ IDEA.
-- User: Noneatme
-- Date: 01.01.2015
-- Time: 14:23
-- Project: MTA iLife
--

cMapManager = {};

--[[
		local metaRoot = xmlLoadFile(':'..resourceName..'/meta.xml')
			if metaRoot then
				for i, v in ipairs( xmlNodeGetChildren( metaRoot ) ) do
					if xmlNodeGetName( v ) == 'custommap' then
					local mapPath = xmlNodeGetAttribute(v,'src')
					local mapRoot = xmlLoadFile(':'..resourceName..'/'..mapPath)
						if mapRoot then
						local mapContent = {}
							for i, v in ipairs( xmlNodeGetChildren( mapRoot ) ) do
							local typ = xmlNodeGetName( v )
								if typ == 'object' then
								table.insert( mapContent, { typ, -- 1
															xmlNodeGetAttribute(v,'interior'), -- 2
															xmlNodeGetAttribute(v,'alpha'), -- 3
															xmlNodeGetAttribute(v,'doublesided'), -- 4
															xmlNodeGetAttribute(v,'model'), -- 5
															xmlNodeGetAttribute(v,'scale'), -- 6
															xmlNodeGetAttribute(v,'dimension'), -- 7
															xmlNodeGetAttribute(v,'posX'), -- 8
															xmlNodeGetAttribute(v,'posY'), -- 9
															xmlNodeGetAttribute(v,'posZ'), -- 10
															xmlNodeGetAttribute(v,'rotX'),-- 11
															xmlNodeGetAttribute(v,'rotY'), -- 12
															xmlNodeGetAttribute(v,'rotZ') } ) -- 13
								end
							end
				--		triggerClientEvent(player, 'onServerSendMapContent', player, mapContent )
						loadMapContent(mapContent)
						xmlUnloadFile( mapRoot )
						end
					end
				end
			xmlUnloadFile( metaRoot )
			end
		end
]]

-- GARAGES --

for index, bla in pairs({13, 49, 42, 48}) do
	setGarageOpen(tonumber(bla), true);
end


-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function cMapManager:new(...)
	local obj = setmetatable({}, {__index = self});
	if obj.constructor then
		obj:constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// getMapRootElement   //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMapManager:getMapRootElement(sMap)
	return self.tblServerMapElements[sMap];
end

-- ///////////////////////////////
-- ///// getMapRootObjects   //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMapManager:getMapRootObjects(sMap)
	if(self.tblServerMapElements[sMap]) then
		return self.tblServerMapElements[sMap]["object"];
	end
	return false;
end

-- ///////////////////////////////
-- ///// toBoolean  	    //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMapManager:toBoolean(strBool)
	if(type(strBool) == "string") then
		if(string.lower(strBool) == "true") or (string.lower(strBool) == 'true') then
			return true;
		else
			return false;
		end
	else
		return strBool;
	end
	return false;
end

-- ///////////////////////////////
-- ///// loadMap            //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMapManager:loadMap(sPath)
	if(self.tblMapLoaded[sPath] ~= true) then

		local tbl                               = self.tblServerMaps[sPath];
		self.tblServerMapElements[sPath]        = {};

		for elementType, elementTable in pairs(tbl) do
			self.tblServerMapElements[sPath][elementType]  = {};

			if(elementType == "object") then
				for index, eleTBL in pairs(elementTable) do
					self.tblServerMapElements[sPath][elementType][index]         = Object(eleTBL[5], eleTBL[8], eleTBL[9], eleTBL[10], eleTBL[11], eleTBL[12], eleTBL[13])
					local obj                                                    = self.tblServerMapElements[sPath][elementType][index];

				--	outputChatBox("createdObject")
					if(obj) then

						setElementInterior(obj, tonumber(eleTBL[1]))
						setElementCollisionsEnabled(obj, self:toBoolean(eleTBL[2]));

						setElementAlpha(obj, tonumber(eleTBL[3]) or 255);
						setElementDoubleSided(obj, self:toBoolean(eleTBL[4]))
						setObjectScale(obj, tonumber(eleTBL[6]) or 1)
						setElementParent(obj, self.mainMapElement)

						setElementDimension(obj, tonumber(eleTBL[7]));
					end
				end
			end
			if(elementType == "removeWorldObject") then
				for index, eleTBL in pairs(elementTable) do
					removeWorldModel(tonumber(eleTBL[3]), tonumber(eleTBL[1]), tonumber(eleTBL[5]), tonumber(eleTBL[6]), tonumber(eleTBL[7]), tonumber(eleTBL[2]))
					-- LOD --
					removeWorldModel(tonumber(eleTBL[4]), tonumber(eleTBL[1]), tonumber(eleTBL[5]), tonumber(eleTBL[6]), tonumber(eleTBL[7]), tonumber(eleTBL[2]))
				end
			end
		end

		self.tblMapLoaded[sPath] = true;
		outputDebugString("Loaded Map: "..sPath)
	end
end

-- ///////////////////////////////
-- ///// unloadMap          //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMapManager:unloadMap(sPath)
	if(self.tblMapLoaded[sPath] == true) then

		for eleType, tbl1 in pairs(self.tblServerMapElements[sPath]) do
			if(eleType == "object") then
				for index, element in pairs(tbl1) do
					destroyElement(element);
					self.tblServerMapElements[sPath][eleType][index] = nil;
				end
			end
		end
		for eleType, tbl1 in pairs(self.tblServerMaps[sPath]) do
			if(eleType == "removeWorldObject") then
				for index, eleTBL in pairs(tbl1) do
					restoreWorldModel(tonumber(eleTBL[3]), tonumber(eleTBL[1]), tonumber(eleTBL[5]), tonumber(eleTBL[6]), tonumber(eleTBL[7]), tonumber(eleTBL[2]))
					-- LOD --
					restoreWorldModel(tonumber(eleTBL[4]), tonumber(eleTBL[1]), tonumber(eleTBL[5]), tonumber(eleTBL[6]), tonumber(eleTBL[7]), tonumber(eleTBL[2]))
				end
			end
		end

		self.tblMapLoaded[sPath]    = false;
		outputDebugString("Unloaded Map: "..sPath)
	end
end


-- ///////////////////////////////
-- ///// sendMapInfoToPlayer//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMapManager:sendMapInfotoPlayer(uPlayer)
	uPlayer:setLoading(true);
	triggerLatentClientEvent(uPlayer, "onMapManagerMapInfoSend", 225000, false, uPlayer, self.tblClientMaps, self.tblClientMapSettings);
end

-- ///////////////////////////////
-- ///// init        		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMapManager:init_maps()
	local startTick         = getTickCount();
	outputDebugString("[MapManager] Loading Maps, please Wait")

	local resourceName      = getResourceName(getThisResource())
	local metaRoot          = xmlLoadFile(':'..resourceName..'/meta.xml')

	local iMaps             = 0;
	if(metaRoot) then
		for i, v in pairs(xmlNodeGetChildren(metaRoot))do
			if(xmlNodeGetName(v) == "custommap") then
				iMaps               = iMaps+1;
				local mapPath       = xmlNodeGetAttribute(v, "src")
				local mapDim        = (xmlNodeGetAttribute(v, "dimension") or false)
				local serverLoad    = (self:toBoolean(xmlNodeGetAttribute(v, "serverload")) or false)
				local dat			= toboolean(xmlNodeGetAttribute(v, "dontloadmap"))
				local ghost			= toboolean(xmlNodeGetAttribute(v, "ghost"))
				local loadMap		= true;

				if(dat == true) then
					loadMap = false
				end

				self.tblClientMapSettings[mapPath] = {mapPath, loadMap, ghost};

				local mapRoot = xmlLoadFile(':'..resourceName.."/"..mapPath)

				self.tblClientMaps[mapPath]                       = {};
				self.tblClientMaps[mapPath]["object"]             = {};
				self.tblClientMaps[mapPath]["removeWorldObject"]  = {};

				self.tblServerMaps[mapPath]                       = {};
				self.tblServerMaps[mapPath]["object"]             = {};
				self.tblServerMaps[mapPath]["removeWorldObject"]  = {};

				if(mapRoot) then
					for i, v in pairs(xmlNodeGetChildren(mapRoot)) do
						local typ           = xmlNodeGetName(v)
						local curTable      = {};

						if(typ == "object") then
							curTable  =
							{
								xmlNodeGetAttribute(v, "interior"),             -- 1
								(xmlNodeGetAttribute(v, "collisions") or true),           -- 2
								xmlNodeGetAttribute(v, "alpha"),                -- 3
								(xmlNodeGetAttribute(v, "doublesided") or true),          -- 4
								xmlNodeGetAttribute(v, "model"),                -- 5
								xmlNodeGetAttribute(v, "scale"),                -- 6
								(mapDim or xmlNodeGetAttribute(v, "dimension")),-- 7
								xmlNodeGetAttribute(v, "posX"),                 -- 8
								xmlNodeGetAttribute(v, "posY"),                 -- 9
								xmlNodeGetAttribute(v, "posZ"),                 -- 10
								xmlNodeGetAttribute(v, "rotX"),                 -- 11
								xmlNodeGetAttribute(v, "rotY"),                 -- 12
								xmlNodeGetAttribute(v, "rotZ"),                 -- 13
							};
						end

						if(typ == "removeWorldObject") then
							curTable  =
							{
								xmlNodeGetAttribute(v, "radius"),               -- 1
								xmlNodeGetAttribute(v, "interior"),             -- 2
								xmlNodeGetAttribute(v, "model"),                -- 3
								xmlNodeGetAttribute(v, "lodModel"),             -- 4
								xmlNodeGetAttribute(v, "posX"),                 -- 5
								xmlNodeGetAttribute(v, "posY"),                 -- 6
								xmlNodeGetAttribute(v, "posZ"),                 -- 7
								xmlNodeGetAttribute(v, "rotX"),                 -- 8
								xmlNodeGetAttribute(v, "rotY"),                 -- 9
								xmlNodeGetAttribute(v, "rotZ"),                 -- 10
							}
						end


						if(serverLoad) then
							if(self.tblServerMaps[mapPath][typ]) then
								table.insert(self.tblServerMaps[mapPath][typ], curTable);
							end
						else
							if(self.tblClientMaps[mapPath][typ]) then
								table.insert(self.tblClientMaps[mapPath][typ], curTable);
							end
						end

					end
				else
					outputDebugString("Map not Found: "..':'..resourceName.."/"..mapPath, 0, 255, 255, 255)
				end
				if(loadMap) and (serverLoad) then
					self:loadMap(mapPath);
				end
			end
		end

	end
	outputDebugString("Es wurden "..iMaps.." Maps in "..math.floor(((getTickCount()-startTick)/1000)).." Sekunden gefunden!");
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMapManager:constructor(...)
	-- Klassenvariablen --

	self.tblClientMaps          = {};       -- Das wird warscheinlich der groesste Table aufm ganzen Server sein
	self.tblServerMaps          = {};

	self.tblClientMapSettings   = {};


	self.tblServerMapElements   = {};

	self.mainMapElement         = createElement("mainMapElement");


	self.tblMapLoaded           = {};

	-- Funktionen --
	self:init_maps()

	-- Events --
end

-- EVENT HANDLER --
