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
-- Date: 08.02.2015
-- Time: 13:23
-- To change this template use File | Settings | File Templates.
--

cGamemodeMap = {};

--[[

]]


-- ///////////////////////////////
-- ///// getName     		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemodeMap:getName()
    return (_Gsettings.gameModeMaps[self.m_iGamemode][self.m_iID][1]);
end

-- ///////////////////////////////
-- ///// getID       		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemodeMap:getID()
    return self.m_iID;
end

-- ///////////////////////////////
-- ///// getFreeSpawnpoint  //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemodeMap:getFreeSpawnpoint()
    for index, spawnpoint in pairs(self:getSpawnpoints()) do
        if not(self.m_iUsedSpawnPositions[index]) then
            return index;
        end
    end
    return false;
end

-- ///////////////////////////////
-- ///// setSpawnpointUsed  //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemodeMap:setSpawnpointUsed(iSpawnpoint, uPlayer)
    self.m_iUsedSpawnPositions[iSpawnpoint] = true;
    self.m_tblSpawnPointByPlayer[uPlayer]   = iSpawnpoint;
    return true;
end

-- ///////////////////////////////
-- ///// setSpawnpointFree  //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemodeMap:setSpawnpointFree(iSpawnpoint, uPlayer)
    if(iSpawnpoint) then
        self.m_iUsedSpawnPositions[iSpawnpoint] = false;
        self.m_tblSpawnPointByPlayer[uPlayer]   = nil;
        return true;
    end
end

-- ///////////////////////////////
-- ///// getMaxPlayers       //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemodeMap:getMaxPlayers()
    if(self.m_tblSpawnPositions) then
        local anzahl = table.length(self.m_tblSpawnPositions)
        return anzahl;
    end
    return 9999;
end

-- ///////////////////////////////
-- ///// getSpawnpoints       //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemodeMap:getSpawnpoints()
    if(self.m_tblSpawnPositions) then
        return self.m_tblSpawnPositions;
    end
    return {};
end

-- ///////////////////////////////
-- ///// getPlayerSpawnpoint//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemodeMap:getPlayerSpawnpoint(uPlayer)
    return (self.m_tblSpawnPointByPlayer[uPlayer]);
end

-- ///////////////////////////////
-- ///// setElementInMap     //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemodeMap:setElementInMap(uElement)
    setElementDimension(uElement, self.m_iDimension);
    setElementInterior(uElement, self.m_iInterior or 0);
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemodeMap:constructor(iGamemode, iID)
    -- Klassenvariablen --

    self.m_iGamemode    = iGamemode;
    self.m_iID          = iID;
    self.m_iDimension   = getEmptyDimension()+1000+iID;
    self.m_iInterior    = self.m_iInterior or 0;
    self.m_iUsedSpawnPositions = {}

    self.m_tblSpawnPointByPlayer = {}
    -- Funktionen --


    -- Events --
end

-- EVENT HANDLER --

