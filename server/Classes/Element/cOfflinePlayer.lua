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
-- Date: 14.02.2015
-- Time: 16:59
-- To change this template use File | Settings | File Templates.
--

cOfflinePlayer = {};

OfflinePlayers  = {}

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function cOfflinePlayer:new(...)
    local obj = setmetatable({}, {__index = self});
    if obj.constructor then
        obj:constructor(...);
    end
    return obj;
end

-- ///////////////////////////////
-- ///// LoadPlayer 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cOfflinePlayer:load()
    if(self.m_iID) then
        --local result        = CDatabase:getInstance():query("SELECT * FROM user WHERE ;");

        local userResult        = CDatabase:getInstance():query("SELECT * FROM user WHERE ID = '"..self.m_iID.."';");

        local result;
        if(userResult) then
            local uPlayerName   = userResult[1]['Name'];

            if not(isPlayerOnline(self.m_iID)) then
                for tabelle, tbl in pairs(self.m_tblDatas) do
                    if(tabelle == "user") then
                        result = userResult;
                    else
                        result = CDatabase:getInstance():query("SELECT * FROM "..tabelle.." WHERE Name = '"..uPlayerName.."';");
                    end

                    for index, data in pairs(tbl) do
                        self[data]  = result[1][tostring(data)];
                    end
                end
                self.m_bLoaded      = true;
                outputDebugString("Loaded Offline Player: "..uPlayerName)

                OfflinePlayers[self.m_iID] = self;
            else
                outputDebugString("Error: Player is Online: "..self.m_iID)
            end
        else
            outputDebugString("Error: Player not Found: "..self.m_iID)
        end
    end
end

-- ///////////////////////////////
-- ///// save      	    	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cOfflinePlayer:save()
    if(self.m_bLoaded) then
        for tabelle, tbl in pairs(self.m_tblDatas) do
            for index, data in pairs(tbl) do
                local d = self:getData(data);
                if(d ~= nil) then
                    CDatabase:getInstance():query("UPDATE "..tabelle.." SET "..data.." = '"..d.."' WHERE Name = '"..self:getData("Name").."';");
                end
            end
        end
        outputDebugString("Unloaded Offline Player: "..self:getData("Name"))
        self.m_bLoaded  = false;

        self:destructor();
    end
end

-- ///////////////////////////////
-- ///// unload      	    //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cOfflinePlayer:unload(...)
    return self:save(...)
end

-- ///////////////////////////////
-- ///// getData     		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cOfflinePlayer:getData(sString)
    return self[sString];
end

-- ///////////////////////////////
-- ///// setData     		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cOfflinePlayer:setData(sString, sValue)
   self[sString] = sValue;
end

-- ///////////////////////////////
-- ///// addBankMoney     	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cOfflinePlayer:addBankMoney(iValue)
    self["Bankgeld"]    = tonumber(self["Bankgeld"]+tonumber(iValue))
end

-- ///////////////////////////////
-- ///// addMoney     	    //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cOfflinePlayer:addkMoney(iValue)
    self["Geld"]    = tonumber(self["Geld"]+tonumber(iValue))
end

-- ///////////////////////////////
-- ///// setCorporation     //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cOfflinePlayer:setCorporation(iValue)
    self["Corporation"]    = tonumber(iValue);
end

-- ///////////////////////////////
-- ///// getCorporation     //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cOfflinePlayer:getCorporation()
    return (Corporations[tonumber(self:getData("CorporationID"))] or false)
end

-- ///////////////////////////////
-- ///// isCEO     //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cOfflinePlayer:isCorporationCEO()
    if(self:hasCorpRole(0) == true) or (self:hasCorpRole(1) == true) then
        return true
    end
    return false
end
-- ///////////////////////////////
-- ///// addCorporationRole //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cOfflinePlayer:addCorpRole(iValue)
    local roles = fromJSON(self:getData("CorporationRoles"))
    roles[iValue] = true;
    self:setData("CorporationRoles", toJSON(roles))
end

-- ///////////////////////////////
-- ///removeCorporationRole //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cOfflinePlayer:removeCorpRole(iValue)
    local roles = fromJSON(self:getData("CorporationRoles"))
    roles[iValue] = nil;
    self:setData("CorporationRoles", toJSON(roles))
end

-- ///////////////////////////////
-- ///resetCorporationRole //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cOfflinePlayer:resetCorpRoles()
    self:setData("CorporationRoles", toJSON({}))
end

-- ///////////////////////////////
-- ///hasCorpRole //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cOfflinePlayer:hasCorpRole(sRoleID)

    if(type(sRoleID) == "string") then
        sRoleID = tonumber(_Gsettings.corporation.findRolesFunction(sRoleID))
    end

    local roles = fromJSON(self:getData("CorporationRoles"))
    local newTBL = {}
    for index, role in pairs(roles) do
        newTBL[tonumber(index)] = toboolean(role);
    end
    roles = newTBL;

    if(roles[0] == true) or (roles[1] == true) then
        return true
    else
        return (roles[sRoleID] or false);
    end
end

-- ///////////////////////////////
-- ///hasDistinctCorpRole //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cOfflinePlayer:hasDistinctCorpRole(iRole)
    local roles = fromJSON(self:getData("CorporationRoles"))
    local newTBL = {}
    for index, role in pairs(roles) do
        newTBL[tonumber(index)] = toboolean(role);
    end

    if(newTBL[iRole] == true)  then
        return true
    else
        return false
    end
end
-- ///////////////////////////////
-- ///// showInfoBox  	    //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cOfflinePlayer:showInfoBox()

end

-- ///////////////////////////////
-- ///// getInventory  	    //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cOfflinePlayer:getInventory()
    return Inventories[self.Inventory];
end

-- ///////////////////////////////
-- ///// getName      	    //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cOfflinePlayer:getName()
    return self:getData("Name");
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cOfflinePlayer:constructor(iID)
    -- Klassenvariablen --
    assert(OfflinePlayers[iID] == nil);

    self.m_iID          = iID;
    self.m_bLoaded      = false;

    -- Funktionen --

    self.m_tblDatas  = {
        ["user"]  =
            {"Name"},
        ["userdata"]    =
            {"Inventory", "Geld", "Bankgeld", "Fraktion", "CorporationID", "CorporationRoles"},
    }

    self:load();
    -- Events --
end

-- EVENT HANDLER --

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cOfflinePlayer:destructor()
    -- Klassenvariablen --
    OfflinePlayers[self.m_iID] = nil;
    self    = nil;

    -- Events --
end


function getOfflinePlayer(iID)
    if(tonumber(iID) ~= nil) and (type(tonumber(iID)) == "number") then
    else
        local result = CDatabase:getInstance():query("SELECT ID FROM user WHERE Name = ?", iID);
        if(result) and (#result > 0) then
            iID = tonumber(result[1]['ID']);
        else
            iID = false;
        end
    end
    if(iID) then
        if(isPlayerOnline(iID)) then
            return Players[iID]
        else
            if(OfflinePlayers[iID]) then
                return OfflinePlayers[iID];
            else
                return cOfflinePlayer:new(iID);
            end
        end
    else
        outputDebugString("OfflinePlayer: User not Found.");
        return false;
    end
end
