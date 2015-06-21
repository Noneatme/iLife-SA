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
-- ## Name: cBusinessManager.lua		        	##
-- ## Author: Noneatme(Gunvarrel		##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

cBusinessManager = inherit(cSingleton);

--[[

]]


-- ///////////////////////////////
-- ///// loadBusines 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cBusinessManager:loadBusiness(row)
    local biz        = cBusiness:new(row['iID'], row['Standort'], row['PosX'], row['PosY'], row['PosZ'], row['OwnerID'], row['LastAttacked'], row['Type'], row['Cost'], row['Title'], string.removeInvalidSonderzeichen(row['Beschreibung']), row['MiscSettings'], row['InteriorID'])

    self.m_uBusiness[tonumber(row['iID'])] = biz;
end

-- ///////////////////////////////
-- ///// loadAllBusines 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cBusinessManager:loadAllBusiness()
    self.m_uBusiness = {}

--    local query = CDatabase:getInstance():query("SELECT b.*, stripSpeciaChars(b.Beschreibung, 1, 1, 1, 1) AS Beschreibung_Converted FROM corporation_business b;")
    local query = CDatabase:getInstance():query("SELECT b.* FROM corporation_business b;")
    for index, row in pairs(query) do
        self:loadBusiness(row)
        coroutine.yield()
    end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cBusinessManager:constructor(...)
    -- Klassenvariablen --
    self.m_tblMultiplikatoren =   -- WIEVIELE LAGEREINHEITEN PRO KAUF IN DEN BIZES VERBRAUCHT WERDEN
    {
        ["Aircraftshop"]                = 0.5,
        ["Burgershot"]                  = 0.1,
        ["Strip-Club"]                  = 1,
        ["Ammu-Nation"]                 = 1,
        ["Cluckin Bell"]                = 0.1,
        ["Donutladen"]                  = 0.1,
        ["Sexshop"]                     = 0.5,
        ["Casino"]                      = 1,
        ["The Well Stacked Pizza"]      = 0.1,
        ["24/7"]                        = 1,
        ["Skinshop"]                    = 0.5,
        ["Wettbuero"]                   = 1,
        ["Disco"]                       = 1,
        ["Bar"]                         = 1,
        ["Restaurant"]                  = 1,
        ["Pay N Spray"]                 = 1,
        ["Fitnessstudio"]               = 1,
        ["Fahrzeugshop"]                = 0,5,
        ["Tankstelle"]                  = 0.01,
        ["Einkaufszentrum"]             = 1,
    }

    self.m_tblMaxLagereinheiten           =
    {
        ["Aircraftshop"]                = 3000,
        ["Burgershot"]                  = 100,
        ["Strip-Club"]                  = 500,
        ["Ammu-Nation"]                 = 1000,
        ["Cluckin Bell"]                = 100,
        ["Donutladen"]                  = 100,
        ["Sexshop"]                     = 200,
        ["Casino"]                      = 500,
        ["The Well Stacked Pizza"]      = 100,
        ["24/7"]                        = 250,
        ["Skinshop"]                    = 250,
        ["Wettbuero"]                   = 250,
        ["Disco"]                       = 250,
        ["Bar"]                         = 250,
        ["Restaurant"]                  = 250,
        ["Pay N Spray"]                 = 650,
        ["Fitnessstudio"]               = 350,
        ["Tankstelle"]                  = 300,
        ["Einkaufszentrum"]             = 1000,
    }

    -- Funktionen --
    self.m_funcOnLoad   = function(...) self:loadAllBusiness(...) end

    -- Events --
    self.m_uThread      = cThread:new("Business Loading Thread", self.m_funcOnLoad, 2)

    self.m_uThread:start(50)
end

-- EVENT HANDLER --
