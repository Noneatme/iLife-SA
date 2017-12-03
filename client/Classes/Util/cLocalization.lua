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

function cLocalization:getString(sType, ...)
    if not(self.xml) then
        outputChatBox("Fatal Error: Config File not Available!", 255, 0, 0)
        return sType;
    end

    local value = self.xml:Get(self.m_sLocalization, sType)

    local returnVal = value;
    if not(value) or (string.len(value) < 1) then
        if not(self.m_tblSetVars[sType]) then
            outputConsole("[LOC] Localization not Found: "..self.m_sLocalization..", "..sType)
            self.xml:Set(self.m_sLocalization, sType, "");
            self.m_tblSetVars[sType] = true;

            self.xml:Save()
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

function cLocalization:loadLocalization()
    local loc = getLocalization()["code"];

    if not(fileExists("res/localizations/"..loc..".ini")) then
        loc = "en";
    end

    self.m_sLocalization    = loc;
    --[[
    self.xml   = xmlLoadFile("res/localizations/"..loc..".xml");

    if not(self.xml) then
        self.xml    = xmlCreateFile("res/localizations/"..loc..".xml", "localization_"..loc)
    end
    ]]

    self.xml = EasyIni:LoadFile("res/localizations/"..loc..".ini");

    if not(self.xml) then
        outputConsole("Localization file not found! "..loc..".ini");
    end
    localPlayer:setData("cg:loc", loc);
end


-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cLocalization:constructor(...)
    -- Klassenvariablen --

    self.m_tblSetVars   = {}
    self:loadLocalization();

    -- Funktionen --


    -- Events --
end


-- ///////////////////////////////
-- ///// Destructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cLocalization:destructor(...)
    if(self.xml) then
        self.xml:Save()
    end
end

-- EVENT HANDLER --

cLoc        = cLocalization;


getLocalizationString   = function(...)
    return cLoc:getInstance():getString(...)
end
