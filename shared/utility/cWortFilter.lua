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
-- ## Name: cWortFilter.lua		       	##
-- ## Author: Noneatme(Gunvarrel)		##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

cWortFilter = inherit(cSingleton);

--[[

]]

-- ///////////////////////////////
-- ///// applyCensoreFilter	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cWortFilter:applyCensoreFilter(sString)
    local newString     = ""
    if(self.m_bBadWordsLoaded) then
        local workingWord   = sString
        for index, sBadWord in pairs(self.m_tblBadWords) do
            sBadWord = tostring(string.lower(sBadWord):sub(0, #sBadWord-1));
            --[[
            local pattern       = workingWord:match(".*"..string.lower(sBadWord).."*.");

            if(pattern) then    -- Gefunden

                for i = 1, #workingWord, 1 do
                    local startPos, endPos  = workingWord:find(pattern, i);
                    if(startPos) and (endPos) then
                        workingWord:
                    end
                end
                ]]
            --[[    workingWord = workingWord:gsub(pattern, string.rep("*", #tostring(pattern)));
            end]]

            if(workingWord:lower():find(sBadWord)) then
                local words = split(workingWord, " ")
                local curChar    = 0;
                for i = 1, #words, 1 do
                    local startPos, endPos  = workingWord:lower():find(sBadWord, curChar);
                    if(startPos) and (endPos) then

                        local sWordBla = ""
                        sWordBla        = sWordBla..workingWord:sub(0, startPos-1)
                        sWordBla        = sWordBla..string.rep("*", #sBadWord)
                        sWordBla        = sWordBla..workingWord:sub(endPos+1, #workingWord)

                        workingWord     = sWordBla;
                    end

                    curChar = curChar+#words[i];
                end
            else

            end
        end

        newString   = workingWord;
    else
        newString = sString;

    end

    return newString;
end

-- ///////////////////////////////
-- ///// hasBadWordIn       //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cWortFilter:hasBadWordIn(sString)
    if(self.m_bBadWordsLoaded) then
        local workingWord   = string.lower(sString):gsub("[_-;:µ|><!^#'%%!§$\\&/()=.,-#+}{ ]", '').."-";
        for index, sBadWord in pairs(self.m_tblBadWords) do
            local pattern       = workingWord:match(".*"..string.lower(sBadWord).."*.");
            if(pattern) then    -- Gefunden
                return sBadWord
            end
        end
    end
    return false;
end

-- ///////////////////////////////
-- ///// loadBadWords 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cWortFilter:loadBadWords()
    if not(self.m_bBadWordsLoaded) then
        self.m_bBadWordsLoaded = true;

        self.m_uFile                    = File("res/txt/badWords.txt");
        self.m_sFileContent             = self.m_uFile:read(self.m_uFile:getSize())

        self.m_tblBadWords              = split(self.m_sFileContent, 10);

        self.m_uFile:close();


    end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cWortFilter:constructor(...)
    -- Klassenvariablen --
    self.m_bBadWordsLoaded  = false;

    -- Funktionen --
    self:loadBadWords()

    -- Events --
end

-- EVENT HANDLER --
