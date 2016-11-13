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
-- Date: 22.02.2015
-- Time: 19:53
-- To change this template use File | Settings | File Templates.
--

cBasicFunctions = {};


--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function cBasicFunctions:new(...)
    local obj = setmetatable({}, {__index = self});
    if obj.constructor then
        obj:constructor(...);
    end
    return obj;
end

-- ///////////////////////////////
-- /doArchiveRowIntoDatabaseTable/
-- ///// Returns: Object	//////
-- ///////////////////////////////

function cBasicFunctions:doArchiveRowIntoDatabaseTable(iID, result)
    CDatabase:getInstance():query("INSERT INTO archive (ArchiveType, Daten) VALUES (?, ?);", iID, toJSON(result));
end

-- ///////////////////////////////
-- /////Wahrscheinlichkeit  /////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function cBasicFunctions:calculateProbability(chance)
    assert(chance >= 0 and chance <= 100, "Bad Chance (Range 0-100)")
    return (math.random(0, 100) <= chance)
end

-- ///////////////////////////////
-- /isOwnerInTheLastMonthsActive/
-- ///// Returns: Object	//////
-- ///////////////////////////////

local last_logins	= {}

function cBasicFunctions:isOwnerInTheLastMonthsActive(iID)
    iID = tonumber(iID);
    if(iID) then
        if not(last_logins[iID]) then
            local result	= CDatabase:getInstance():query("SELECT Last_Login FROM user WHERE ID = ?;", iID);
            if(result) and (#result > 0) then
                last_logins[iID]		= tonumber(result[1]["Last_Login"]);
            else
                last_logins[iID] = 0;
            end
        end
        -- 1424213329
        local time				= getRealTime().timestamp
        if(last_logins[iID]) and (time-last_logins[iID] > _Gsettings.gmaxOfflineTime) then
		-- OVERRIDE
            return true;
        else
            return true;
        end
    end
    return true;
end
isOwnerInTheLastMonthsActive = cBasicFunctions.isOwnerInTheLastMonthsActive;


-- EVENT HANDLER --
