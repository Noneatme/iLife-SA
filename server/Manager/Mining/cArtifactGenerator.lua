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

    for index, tbl in pairs(self.m_tblArtifacts) do
        local dist = getDistanceBetweenPoints3D(tbl[1], tbl[2], randX, randY)
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
    
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cArtifactManager:constructor(...)
    -- Klassenvariablen --
    self.m_iMaxArtifactsAtOnce      = 50;
    self.m_iMinArtifactDistance     = 500;


    self.m_iMinDistanceX, self.m_iMinDistanceY  = -3000, -3000
    self.m_iMaxDistanceX, self.m_iMaxDistanceY  = 3000, 3000

    -- ItemID, MaxAnzahl
    self.m_tblRandomItems           =
    {

    }

    self.m_tblArtifacts             = {}

    -- Funktionen --

    for i = 1, self.m_iMaxArtifactsAtOnce, 1 do
        self:generateArtifact()
    end


    -- Events --
end

-- EVENT HANDLER --
