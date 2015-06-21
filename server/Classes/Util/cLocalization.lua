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
-- ## Name: cLocalization.lua		        	##
-- ## Author: Noneatme(Gunvarrel)		##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- ## Date: March 2015                  ##
-- #######################################

cLocalization = inherit(cSingleton);

--[[

]]

-- ///////////////////////////////
-- ///// getString   		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cLocalization:getString(sLanguage, sType, ...)
    if not(self.xml[sLanguage]) then
        self:loadLocalization(sLanguage);
    end

    if not(self.xml[sLanguage]) then
        -- Config not Found --
        return sType;
    end

    local value = self.xml[sLanguage]:Get(self.m_sLocalization, sType)

    local returnVal = value;
    if not(value) or (string.len(value) < 1) then
        if not(self.m_tblSetVars[sType]) then
        --    outputConsole("[LOC] Localization not Found: "..self.m_sLocalization..", "..sType)
            self.xml[sLanguage]:Set(self.m_sLocalization, sType, "");
            self.m_tblSetVars[sLanguage][sType] = true;

            self.xml[sLanguage]:Save()
        end
        returnVal = sType;
    else
        if(#{...} > 0) then
            returnVal = value:format(...);
        else
            returnVal = value
        end
    end

    return returnVal;
end

-- ///////////////////////////////
-- ///// loadLocalization	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cLocalization:loadLocalization(sLanguage)
    local loc = sLanguage;

    if not(fileExists("res/serverlocalizations/"..loc..".ini")) then
        loc = "en_US";
    end

    --[[
    self.xml   = xmlLoadFile("res/localizations/"..loc..".xml");

    if not(self.xml) then
        self.xml    = xmlCreateFile("res/localizations/"..loc..".xml", "localization_"..loc)
    end
    ]]
    if not(self.xml[sLanguage]) then
        self.xml[sLanguage] = EasyIni:LoadFile("res/localizations/"..loc..".ini");
        if not(self.xml[sLanguage]) then
            return false;
        end
    end

    return false;
end

-- ///////////////////////////////
-- ///// isLanguageLoaded	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cLocalization:isLanguageLoaded(sLanguage)
    local loc = sLanguage;
    if(self.xml[sLanguage]) then
        return true;
    end

    return false;
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cLocalization:constructor(...)
    -- Klassenvariablen -
    self.xml            = {};
    self.m_tblSetVars   = {};

    -- Funktionen --
    self:loadLocalization("en_US");

    -- Events --
end

-- ///////////////////////////////
-- ///// Destructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cLocalization:destructor(...)

    -- Save XML's --
    for language, xml in pairs(self.xml) do
        if(self.xml[language]) then
            self.xml[language]:Save()
        end
    end

    self.xml = nil;
end

-- EVENT HANDLER --

cLoc        = cLocalization;

getLocalizationString   = function(...)
    return cLoc:getInstance():getString(...)
end
