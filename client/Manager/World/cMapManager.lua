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
-- Time: 15:04
-- Project: MTA iLife
--


cMapManager = inherit(cSingleton);

--[[

]]



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
-- ///// loadMap      		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMapManager:loadMap(sPath, iDimension, iInterior, bOutput, bGhost)
	if(self.tblMapLoaded[sPath] ~= true) then

		local tbl                               = self.tblMaps[sPath];
		self.tblMapElements[sPath]              = {};

		for elementType, elementTable in pairs(tbl) do
			self.tblMapElements[sPath][elementType]  = {};

			if(elementType == "object") then
				for index, eleTBL in pairs(elementTable) do
					if(eleTBL[8]) then
						self.tblMapElements[sPath][elementType][index]         = createObject(eleTBL[5], eleTBL[8], eleTBL[9], eleTBL[10], eleTBL[11], eleTBL[12], eleTBL[13])
						local obj                                              = self.tblMapElements[sPath][elementType][index];

						if(obj) then
							local int = iInterior
							if not(int) then
								int = tonumber(eleTBL[1])
							end

							setElementInterior(obj, int)
							if not(bGhost) then
								setElementCollisionsEnabled(obj, self:toBoolean(eleTBL[2]));
								setElementAlpha(obj, tonumber(eleTBL[3]) or 255);
							else
								setElementCollisionsEnabled(obj, false);
								setElementAlpha(obj, 150);
							end
							setElementDoubleSided(obj, (self:toBoolean(eleTBL[4]) or true)) -- Geht nicht, also so halt
							setObjectScale(obj, tonumber(eleTBL[6]) or 1)
							setElementParent(obj, self.mainMapElement)
							local dim = iDimension
							if not(dim) then
								dim = tonumber(eleTBL[7])
							end
							setElementDimension(obj, dim);
						end
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
		if not(bOutput) then
			outputConsole("[cMapManager] Loaded Map: "..sPath)
		end
	else
		outputConsole("[cMapManager] Map Already Loaded: "..sPath)
	end
end

-- ///////////////////////////////
-- ///// unloadMap      	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMapManager:unloadMap(sPath)
	if(self.tblMapLoaded[sPath] == true) then

		for eleType, tbl1 in pairs(self.tblMapElements[sPath]) do
			if(eleType == "object") then
				for index, element in pairs(tbl1) do
					destroyElement(element);
					self.tblMapElements[sPath][eleType][index] = nil;
				end
			end
		end
		for eleType, tbl1 in pairs(self.tblMaps[sPath]) do
			if(eleType == "removeWorldObject") then
				for index, eleTBL in pairs(tbl1) do
					restoreWorldModel(tonumber(eleTBL[3]), tonumber(eleTBL[1]), tonumber(eleTBL[5]), tonumber(eleTBL[6]), tonumber(eleTBL[7]), tonumber(eleTBL[2]))
					-- LOD --
					restoreWorldModel(tonumber(eleTBL[4]), tonumber(eleTBL[1]), tonumber(eleTBL[5]), tonumber(eleTBL[6]), tonumber(eleTBL[7]), tonumber(eleTBL[2]))
				end
			end
		end

		self.tblMapLoaded[sPath]    = false;
		outputConsole("[cMapManager] Unloaded Map: "..sPath)
	end
end

-- ///////////////////////////////
-- ///// loadAllMaps   		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMapManager:loadAllMaps()
	for pfad, elementTable in pairs(self.tblMaps) do

		if(self.tblMapSettings[pfad]) then
			if(self.tblMapSettings[pfad][2] == true) then
				self:loadMap(pfad, false, false, true, self.tblMapSettings[pfad][3]);

				coroutine.yield()
			end
		end
	end
end

-- ///////////////////////////////
-- ///// getMapInfos 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMapManager:getMapInfos(tblMaps, tblSettings)

	self.tblMaps            = tblMaps;
	self.tblMapSettings     = tblSettings;

	outputConsole("[cMapManager] Loading Maps, total: "..table.length(self.tblMapSettings).." Maps, this could take a while");

	self.startTick          = getTickCount()

	coroutine.resume(self.m_co)

	self.loadMapTimer   = setTimer(self.m_loadNextMapFunc, 150, 0)
end

-- ///////////////////////////////
-- ///// loadNextMap 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMapManager:loadNextMap()
	coroutine.resume(self.m_co)

	if not(isPedOnGround(localPlayer)) then
	--
	end

	if(coroutine.status(self.m_co) == "dead") then
		killTimer(self.loadMapTimer);
		outputConsole("[cMapManager] Maploading took "..((getTickCount()-self.startTick)/1000).." seconds");

		loadingSprite:setEnabled(false);

		self.m_bAllMapsLoaded       = true;

	--	setElementFrozen(localPlayer, false)
	end

end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMapManager:constructor(...)
	-- Klassenvariablen --
	self.tblMaps                = {};
	self.tblMapElements         = {};
	self.tblMapSettings         = {};

	self.tblMapLoaded           = {};

	self.m_bAllMapsLoaded       = false;

	self.mainMapElement         = createElement("mainMap")

	-- Funktionen --
	self.m_getMapInfosFunc      = function(...) self:getMapInfos(...) end

	self.m_funcGenerateMaps     = function(...) self:loadAllMaps() end
	self.m_loadNextMapFunc      = function(...) self:loadNextMap() end

	self.m_co                   = coroutine.create(self.m_funcGenerateMaps)

	-- Events --
	addEvent("onMapManagerMapInfoSend", true);

	addEventHandler("onMapManagerMapInfoSend", getLocalPlayer(), self.m_getMapInfosFunc)
end

-- EVENT HANDLER --
