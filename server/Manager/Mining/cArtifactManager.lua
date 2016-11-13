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
-- ## Name: cArtifactManager.lua		        	##
-- ## Author: Noneatme(Gunvarrel)		##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- ## Date: March 2015                  ##
-- #######################################

cArtifactManager = inherit(cSingleton);

--[[

]]

-- ///////////////////////////////
-- //getRandomArtifactPosition////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cArtifactManager:getRandomArtifactPosition()
    local randX, randY      = math.random(self.m_iMinDistanceX, self.m_iMaxDistanceX), math.random(self.m_iMinDistanceY, self.m_iMaxDistanceY)

    for index, art in pairs(self.m_tblArtifacts) do
        local x, y = art:getPosition()
        local dist = getDistanceBetweenPoints2D(x, y, randX, randY)
        if(dist < self.m_iMinArtifactDistance) then
            return self:getRandomArtifactPosition();
        end
    end
    return randX, randY
end

-- ///////////////////////////////
-- ///// generateArtifact	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cArtifactManager:generateArtifact()
    local x, y = self:getRandomArtifactPosition();
    self.m_tblArtifacts[self.m_iCurrentArtifact] = cArtifact:new(self.m_iCurrentArtifact, x, y)
    self.m_iCurrentArtifact = self.m_iCurrentArtifact+1;
end

-- ///////////////////////////////
-- ///// getArtifactsNearPlayer//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cArtifactManager:getArtifactsNearPlayer(uPlayer, iDistance)
    local x, y, z = uPlayer:getPosition()

    local arts      = {}
    for _, artifact in pairs(self.m_tblArtifacts) do
        if(artifact) and not(artifact.m_bDone) then
            local x2, y2 = artifact:getPosition()
            if(getDistanceBetweenPoints2D(x, y, x2, y2) <= iDistance) then
                arts[artifact] = getDistanceBetweenPoints2D(x, y, x2, y2)
            end
        end
    end
    return arts;
end

-- ///////////////////////////////
-- ///// doEntdeckeArtifact ////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cArtifactManager:doEntdeckeArtifact(uPlayer, iID)
    local artifact  = self.m_tblArtifacts[iID];
    if not(artifact.m_bDone) then
        artifact:generateArtifactCrate();
        self:generateArtifact();
    end
end

-- ///////////////////////////////
-- ///// scanForPlayerArtifact////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cArtifactManager:scanForPlayerArtifacts(uPlayer, iID)
    local distance  = 10;

    if(iID == 302) then
        distance = 25;
    elseif(iID == 303) then
        distance = 50;
    end

    distance = distance*10
    local arts  = self:getArtifactsNearPlayer(uPlayer, distance)

    triggerClientEvent(uPlayer, "onClientPlayerArtifactScannerResultsGet", uPlayer, arts)

    for artifact, distance in pairs(arts) do
        if(artifact.m_iZ) then
            if(distance < self.m_iMinDistanceToDiscover) then
                self:doEntdeckeArtifact(uPlayer, artifact.m_iID)
            end
        end
    end
    uPlayer.m_bArtifactScanned      = true;
end

-- ///////////////////////////////
-- ///// updateZPosition	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cArtifactManager:updateZPosition(uPlayer, iArtifact, iZ)
    if(self.m_tblArtifacts[iArtifact]) and (uPlayer.m_bArtifactScanned) then
        self.m_tblArtifacts[iArtifact].m_iZ = iZ or false;

        if(self.m_tblArtifacts[iArtifact].m_iZ) then
            local x, y = self.m_tblArtifacts[iArtifact]:getPosition()
            local x2, y2 = uPlayer:getPosition()

            if(getDistanceBetweenPoints2D(x, y, x2, y2) <= self.m_iMinDistanceToDiscover) then
                self:doEntdeckeArtifact(uPlayer, iArtifact)
            end
        end
    end
end

-- ///////////////////////////////
-- ///// generateNewArtifacts/////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cArtifactManager:generateNewArtifacts(iAtOnce)
    if(tonumber(iAtOnce)) then
        self.m_iMaxArtifactsAtOnce = iAtOnce:tonumber();
    end

    for id, art in pairs(self.m_tblArtifacts) do
        if(art) then
            delete(art)
        end
        art = nil
    end

    self.m_tblArtifacts = {}

    local sTick = getTickCount()
    for i = 1, self.m_iMaxArtifactsAtOnce, 1 do
        self:generateArtifact()
    end

    outputDebugString("Generated "..self.m_iMaxArtifactsAtOnce.." Artifacts in "..((getTickCount()-sTick)/1000).."s")

end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cArtifactManager:constructor(...)
    -- Klassenvariablen --
    addEvent("onArtifactZPositionUpdate", true)

    self.m_iMaxArtifactsAtOnce      = 500;
    self.m_iMinArtifactDistance     = 50;

    self.m_iCurrentArtifact         = 1

    self.m_iMinDistanceToDiscover   = 15;


    self.m_iMinDistanceX, self.m_iMinDistanceY  = -3000, -3000
    self.m_iMaxDistanceX, self.m_iMaxDistanceY  = 3000, 3000

    self.m_tblArtifacts             = {}

    -- Funktionen --

    self:generateNewArtifacts();

    self.m_funcOnZPositionReceive       = function(...) self:updateZPosition(client, ...) end

    -- Events --
    addEventHandler("onArtifactZPositionUpdate", getRootElement(), self.m_funcOnZPositionReceive)
end

-- EVENT HANDLER --
