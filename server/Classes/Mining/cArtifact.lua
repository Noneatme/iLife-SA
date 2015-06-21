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
-- ## Name: cArtifact.lua		        	##
-- ## Author: Noneatme(Gunvarrel)		##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- ## Date: March 2015                  ##
-- #######################################

cArtifact = {};

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function cArtifact:new(...)
    local obj = setmetatable({}, {__index = self});
    if obj.constructor then
        obj:constructor(...);
    end
    return obj;
end

-- ///////////////////////////////
-- ///// getPosition 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cArtifact:getPosition()
    return self.m_iX, self.m_iY
end

-- ///////////////////////////////
-- ///// getDistanceToPlayer/////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cArtifact:getDistanceToPlayer(uPlayer)
    local iX, iY        = uPlayer:getPosition()

    if(getDistanceBetweenPoints3D(iX, iY, 0, self.m_iX, self.m_iY) < 5) then
        return true
    else
        return getDistanceBetweenPoints3D(iX, iY, 0, self.m_iX, self.m_iY)
    end
end

-- ///////////////////////////////
-- ///// addLoot    		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cArtifact:addLoot(iID)
    if(iID == 1) then
        -- Waffenloot
        self.m_sName    = "Waffenkiste"
        self.m_tblLoot  =       -- ItemID, Anzahl
                            -- cBasicFunctions:calculateProbability(50) and 5 = 50%ige Warscheinlichkeit das es 5 stck sind
        {
            [262]   = math.random(0, 5),        -- Waffenpaket
            [244]   = math.random(0, 2),        -- 9mm
            [241]   = math.random(0, 2),        -- AK
            [249]   = math.random(0, 2),        -- Gewehr
            [243]   = math.random(0, 2),        -- M4
            [247]   = math.random(0, 3),        -- MP5
            [245]   = math.random(0, 3),        -- Micro SMG
            [18]    = math.random(0, 1),        -- Doominator
        }

        for i = 253, 258, 1 do
            self.m_tblLoot[i] = math.random(0, 5);  -- Munitionspakete
        end

    elseif(iID == 2) then
        -- Geldloot
        self.m_sName    = "Geldartefakt"
        self.m_tblLoot  =
        {
            [265]       = math.random(5, 25);   -- Geldsack
            [228]       = cBasicFunctions:calculateProbability(50) and math.random(1, 2);    -- Geldschachtel
            [31]        = math.random(0, 20);   -- Schokoriegel
        }
    elseif(iID == 3) then
        --
        self.m_sName    = "Schrott"
        self.m_tblLoot  =
        {
            [54]    = cBasicFunctions:calculateProbability(50) and math.random(1, 10),   -- Computer
            [182]   = cBasicFunctions:calculateProbability(50) and math.random(0, 1),    -- Einkaufswagen
            [49]    = cBasicFunctions:calculateProbability(50) and math.random(1, 5),    -- Eisenzaun
            [44]    = cBasicFunctions:calculateProbability(50) and math.random(2, 2),    -- Grill
            [47]    = cBasicFunctions:calculateProbability(50) and math.random(1, 5),    -- Holz
            [50]    = cBasicFunctions:calculateProbability(50) and math.random(1, 2),    -- Huette
            [259]   = cBasicFunctions:calculateProbability(50) and math.random(1, 2),    -- Lagerkiste
            [180]   = cBasicFunctions:calculateProbability(50) and math.random(0, 1),    -- Muelltonne
            [181]   = cBasicFunctions:calculateProbability(50) and math.random(0, 2),    -- Muelltonne 2
            [53]    = cBasicFunctions:calculateProbability(50) and math.random(0, 2),    -- Parkbank
            [43]    = cBasicFunctions:calculateProbability(50) and math.random(0, 3),    -- Sonnenschirm
            [183]   = cBasicFunctions:calculateProbability(50) and math.random(0, 1),    -- Telefonhaus
            [49]    = cBasicFunctions:calculateProbability(50) and math.random(0, 1),    -- Tisch und Stuhl
            [294]   = cBasicFunctions:calculateProbability(50) and math.random(0, 5),    -- Baum
            [303]   = cBasicFunctions:calculateProbability(50) and math.random(0, 5),    -- Artifkataufladung (50)
            [229]   = cBasicFunctions:calculateProbability(50) and math.random(1, 10),    -- Eisen
            [251]   = cBasicFunctions:calculateProbability(50) and math.random(1, 10),    -- Schwarzpulver


        }
    elseif(iID == 4) then
        --
        self.m_sName    = "Drogenpaket"
        self.m_tblLoot  =
        {
            [10]    = cBasicFunctions:calculateProbability(60) and math.random(1, 150), -- Canaabis
            [9]     = cBasicFunctions:calculateProbability(70) and math.random(1, 510), -- Crystal
            [12]    = cBasicFunctions:calculateProbability(70) and math.random(1, 150), -- Ecstasy
            [274]   = cBasicFunctions:calculateProbability(50) and math.random(1, 20), -- Hanfsamen
            [14]    = cBasicFunctions:calculateProbability(50) and math.random(1, 20), -- Kokain
            [30]    = cBasicFunctions:calculateProbability(30) and math.random(1, 20), -- LSD
            [11]    = cBasicFunctions:calculateProbability(20) and math.random(1, 5),   -- Magic Mushrooms
        }
    elseif(iID == 5) then
        --
        self.m_sName    = "Feuerwerkskiste"
        self.m_tblLoot  =
        {
            [266]   = math.random(1, 50),
            [272]   = cBasicFunctions:calculateProbability(50) and math.random(0, 5),
            [269]   = cBasicFunctions:calculateProbability(50) and math.random(0, 5),
            [267]   = cBasicFunctions:calculateProbability(50) and math.random(10, 50),
            [268]   = math.random(2, 10),
            [270]   = math.random(1, 15),
            [271]   = cBasicFunctions:calculateProbability(50) and math.random(0, 5),
        }
    elseif(iID == 6) then
        --
        self.m_sName    = "Scannerartefakt"
        self.m_tblLoot  =
        {
            [300]   = cBasicFunctions:calculateProbability(10) and 1,                       -- Scanner T3
            [304]   = cBasicFunctions:calculateProbability(30) and math.random(1, 3),       -- Scanner T1
            [305]   = cBasicFunctions:calculateProbability(50) and math.random(1, 3),       -- Scanner T2
            [301]   = cBasicFunctions:calculateProbability(50) and math.random(10, 25),       -- Aufladung T1
            [302]   = cBasicFunctions:calculateProbability(50) and math.random(10, 25),       -- Aufladung T2
            [303]   = cBasicFunctions:calculateProbability(50) and math.random(10, 25),       -- Aufladung T3
        }
    elseif(iID == self.m_iMaxVarianten) then
        --
        self.m_sName    = "Rareartefakt"
        self.m_tblLoot  =
        {
            [13]    = cBasicFunctions:calculateProbability(30) and math.random(1, 5),    -- Wundertuete
            [179]   = cBasicFunctions:calculateProbability(10) and math.random(0, 1),    -- Sodaautomat
            [51]    = cBasicFunctions:calculateProbability(30) and math.random(1, 5),    -- Radio
            [287]   = cBasicFunctions:calculateProbability(20) and math.random(0, 1),    -- Baseballcapie
            [288]   = cBasicFunctions:calculateProbability(10) and math.random(0, 1),    -- Businesshut
            [281]   = cBasicFunctions:calculateProbability(20) and math.random(0, 1),    -- Partyhut
            [279]   = cBasicFunctions:calculateProbability(10) and math.random(0, 1),    -- Westernhut
            [287]   = cBasicFunctions:calculateProbability(30) and math.random(0, 1),    -- Bauarbeiterhelm
            [277]   = cBasicFunctions:calculateProbability(10) and math.random(0, 1),    -- Sombrero
        }
    end
end

-- ///////////////////////////////
-- ///// generateLoot		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cArtifact:generateLoot()
    local rand = math.random(1, self.m_iMaxVarianten)
    if(math.random(1, 10) == 1) then
        self:addLoot(math.random(1, self.m_iMaxVarianten-1))

        self.m_tblLoot  = "Bomb"
    else
        if(rand == self.m_iMaxVarianten) then
            if(math.random(1, self.m_iMaxVarianten) == math.floor(self.m_iMaxVarianten/2)) then
                self:addLoot(self.m_iMaxVarianten)
            else
                self:addLoot(math.random(1, self.m_iMaxVarianten-1))
            end
        else
            self:addLoot(rand)
        end
    end
end

-- ///////////////////////////////
-- ///// giveLootToPlayer	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cArtifact:giveLootToPlayer(uPlayer)
    if(type(self.m_tblLoot) == "string") and (self.m_tblLoot == "Bomb") then
        local x, y, z = uPlayer:getPosition()
        createExplosion(x, y, z)
        uPlayer:showInfoBox("info", "Du bist auf eine Bombe gestossen!")
    else
        for id, amount in pairs(self.m_tblLoot) do
            if(id) and (amount) then
                if(Items[id]) and (amount > 0) then
                    outputConsole("Artefakt, Gegenstand Erhalten: "..Items[id]:getName().." ("..amount..")", uPlayer)
                    uPlayer:getInventory():addItem(Items[id], amount)
                end
            end
        end
    end
end

-- ///////////////////////////////
-- //generateArtifactCrate	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cArtifact:generateArtifactCrate()
    if not(self.m_uCrate) then
        self.m_uCrate       = Object(2969, self.m_iX, self.m_iY, self.m_iZ, 0, 0, math.random(0, 360));
        addEventHandler("onElementClicked", self.m_uCrate, function(sBtn, sState, uPlayer)
            if(uPlayer) and (isElement(uPlayer)) and not(self.m_bDone) and (sBtn == "left") and (sState == "down") then
                local x, y, z       = uPlayer:getPosition()
                local x2, y2, z2    = self.m_uCrate:getPosition()

                if(getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) < 5) then
                    logger:OutputPlayerLog(uPlayer, "Sammelte Artefakt ein", self.m_sName)
                    self:giveLootToPlayer(uPlayer)
                    self:destructor()
                    uPlayer:showInfoBox("sucess", "Du hast das Artefakt: "..self.m_sName.." eingesammelt und Gegenstande erhalten!")
                    uPlayer:incrementStatistics("Artefakte", "Gesammelt", 1)
                    triggerClientEvent(uPlayer, "onClientPlayerArtifactGUIClose", uPlayer)
                else
                    uPlayer:showInfoBox("error", "Du musst naeher dran!")
                end
            end
        end)
    end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cArtifact:constructor(iID, iX, iY)
    -- Klassenvariablen --
    self.m_iMaxVarianten    = 7;
    self.m_iID              = iID;

    self.m_iX               = iX;
    self.m_iY               = iY;
    self.m_iZ               = false;

    if(DEFINE_DEBUG) then
    --    createBlip(self.m_iX, self.m_iY, 0)
    end
    -- Funktionen --
    self:generateLoot();

    -- Events --
end

-- ///////////////////////////////
-- ///// destructor   		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cArtifact:destructor()
    if(self.m_uCrate) then
        self.m_uCrate:destroy()
    end
    self.m_bDone    = true;
    self            = nil;
end


-- EVENT HANDLER --
