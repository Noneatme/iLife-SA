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
-- Date: 01.02.2015
-- Time: 01:33
-- To change this template use File | Settings | File Templates.
--

cDrugManager = inherit(cSingleton)

DrugObjects 	= {}


function cDrugManager:constructor()
    self.loadFunc	    = function() self:load() end
    self.thread			= cThread:new("DrugLoading_Thread", self.loadFunc)

    self.thread:start(50);
end


function cDrugManager:load()
    local result 	= CDatabase:getInstance():query("SELECT * FROM drugs;")
    local index		= 0;
    local start		= getTickCount();

    if(result) then
        local maxCount  = 25;
        local count     = 0;

        for index2, tbl in pairs(result) do
            index = index+1;

            DrugObjects[index]  = cDrug:new(tbl["DrugID"], tbl["OwnerID"], tbl["iX"], tbl["iY"], tbl["iZ"], tbl["iType"], tbl["iTimestamp"]);

            count = count+1;
            if(count > maxCount) then
                count = 0;
                coroutine.yield();
            end
        end
    end

    outputDebugString(index.." Drogenpflanzen gefunden");
end
