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
-- Date: 21.02.2015
-- Time: 17:35
-- Purpose: MTA iLife SA
--

cCorporation = {};

Corporations    = {}

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function cCorporation:new(...)
    local obj = setmetatable({}, {__index = self});
    if obj.constructor then
        obj:constructor(...);
    end
    return obj;
end

-- ///////////////////////////////
-- ///// saveData       	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporation:saveData(sData)
    self:updateSaveValues();
    local value     = self.m_tblSaveValues[sData]
    CDatabase:getInstance():exec("UPDATE corporations SET ?? = ? WHERE iID = ?;", sData, tostring(value), self.m_iID);
    return true;
end

-- ///////////////////////////////
-- ///// updateSaveValues 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporation:updateSaveValues()
    self.m_tblSaveValues    =
    {
        --[[
        ["FullName"]    = self.m_sFullName,
        ["ShortName"]   = self.m_sShortName,
        ["Color"]       = self.m_sColor,
        ["IconID"]      = tonumber(self.m_iIconID),]] -- DIESE SACHEN NICHT! DIE DUERFEN NICHT GEANDERT WERDEN IN DER LAUFZEIT, VON DAHER IST DAS EGAL wobei EGAL ABER EIg. SCHWEIZER KAESE IST
        ["Bio"]             = self.m_sBio,
        ["TaxRate"]         = self.m_iTaxRate,
        ["State"]           = self.m_iState,
        ["MaxMembers"]      = self.m_iMaxMembers,
        ["MaxVehicles"]     = self.m_iMaxVehicles,
        ["MaxHouses"]       = self.m_iMaxHouses,
        ["MaxBizes"]        = self.m_iMaxBizes,
        ["Skins"]           = toJSON(self.m_tblSkins),
        ["MiscSettings"]    = toJSON(self.m_tblMiscSettings),
    }
end


-- ///////////////////////////////
-- ///// save         		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporation:save()
    self:updateSaveValues();

    for index, data in pairs(self.m_tblSaveValues) do
        self:saveData(index);
    end
end

-- ///////////////////////////////
-- ///// removeCorpVehicle   //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporation:removeCorpVehicle(iID)
    if(self.m_tblVehiclesByID[iID]) then
        local result        = CDatabase:getInstance():query("DELETE FROM corporation_vehicle WHERE `CorpID` = ? AND `iID` = ?;", self.m_iID, self.m_tblVehiclesByID[iID].m_iID);
        destroyElement(self.m_tblVehiclesByID[iID]);

        return true;
    end
    return false;
end

-- ///////////////////////////////
-- ///// addCorpVehicle     //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporation:addCorpVehicle(iID, CorpID, ModellID, PosX, PosY, posZ, rotX, rotY, rotZ, color, kmh, ...)
    self.m_iCurCorpVehicle                      = self.m_iCurCorpVehicle+1;
    local fahrzeug                              = Vehicle(ModellID, PosX, PosY, posZ, rotX, rotY, rotZ)
    self.m_tblVehicleElements[fahrzeug]         = fahrzeug;
    self.m_tblVehicles[self.m_iCurCorpVehicle]  = enew(fahrzeug, cCorporationVehicle, iID, CorpID, ModellID, PosX, PosY, posZ, rotX, rotY, rotZ, color, kmh, ...)
    self.m_tblVehiclesByID[iID]                 = self.m_tblVehicles[self.m_iCurCorpVehicle]

end


-- ///////////////////////////////
-- ///// loadFactionVehicles //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporation:loadCorpVehicles()
    if not(self.m_bCorpVehiclesLoaded) then
        self.m_tblVehicleElements   = {}
        self.m_tblVehiclesByID      = {}
        local result        = CDatabase:getInstance():query("SELECT * FROM corporation_vehicle WHERE `CorpID` = ?;", self.m_iID);
        if(result) and (#result > 0) then
            for index, row in pairs(result) do
                self:addCorpVehicle(row['iID'], row['CorpID'], row['ModellID'], row['PosX'], row['PosY'], row['PosZ'], row['RotX'],row['RotY'],row['RotZ'], self.m_tblIcons, row['iKM'], self.m_sColor, self.m_sFullName, row['iInventory']);
            end
        end
        self.m_bCorpVehiclesLoaded = true;
    end
end

-- ///////////////////////////////
-- convertUserVehicleToCorpVehicle
-- ///// Returns: strings	////// (Errorausgabe)
-- ///////////////////////////////

function cCorporation:convertUserVehicleToCorpVehicle(uVehicle)
    local sClass    = "cCorporation: "

    if(uVehicle) then

        local modell        = uVehicle:getModel()
        local pos           = Vector3(uVehicle:getPosition())
        local rot           = Vector3(uVehicle:getRotation())
        local inv           = uVehicle.iInventory;
        CDatabase:getInstance():query("DELETE FROM Vehicles WHERE ID = ?", uVehicle.ID)
        uVehicle:removeFromUserVehiclesByPlayer();
        uVehicle.tDestroy(true)

        CDatabase:getInstance():query("INSERT INTO corporation_vehicle (CorpID, ModellID, PosX, PosY, PosZ, RotX, RotY, RotZ, iInventory) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);", self.m_iID, modell, pos.x, pos.y, pos.z, rot.x, rot.y, rot.z, inv or 0)

        local result        = CDatabase:getInstance():query("SELECT LAST_INSERT_ID() AS id FROM corporation_vehicle LIMIT 1;")
        local id            = result[1]["id"];

        self:addCorpVehicle(tonumber(id), self.m_iID, modell, pos.x, pos.y, pos.z, rot.x, rot.y, rot.z, self.m_tblIcons, 0, self.m_sColor, self:getName(), inv)

        return true;
    else
        return sClass.."UserVehicle not found"
    end
end

-- ///////////////////////////////
-- ///// addStatus      	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporation:addStatus(iStatus)
    self.m_iState = self.m_iState+iStatus;


    if(self.m_iState <= 0) then
        self.m_iState = 0
    end
    if(self.m_iState >= 200) then
        self.m_iState = 200;
    end
    return self.m_iState;
end

-- ///////////////////////////////
-- ///// getStatus      	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporation:getStatus()
    return self.m_iState;
end
-- ///////////////////////////////
-- ///// getVehicles    	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporation:getVehicles()
    return self.m_tblVehicleElements;
end

-- ///////////////////////////////
-- ///// setSetting  		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporation:setSetting(sSetting, sValue, bSave)
    self.m_tblMiscSettings[sSetting] = sValue;
    if(bSave) then
        self:saveData("MiscSettings");
    end
    return sValue;
end

-- ///////////////////////////////
-- ///// getSetting  		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporation:getSetting(sSetting, sValue)
    return self.m_tblMiscSettings[sSetting];
end

-- ///////////////////////////////
-- ///// setData      		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporation:setData(sSetting, sValue, bSave)
    self.m_tblSaveValues[sSetting] = sValue;

    if(bSave) then
        return self:saveData(sSetting);
    end
    return sValue;
end

-- ///////////////////////////////
-- ///// getData  		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporation:getData(sSetting, sValue)
    return self.m_tblMiscSettings[sSetting];
end


-- ///////////////////////////////
-- ///// getID               //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporation:getID()
    return self.m_iID;
end

-- ///////////////////////////////
-- ///// getFullName        //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporation:getFullName()
    return self.m_sFullName;
end

-- ///////////////////////////////
-- ///// get    Name        //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporation:getName()
    return self:getFullName()
end

-- ///////////////////////////////
-- ///// getMembers        //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporation:getMembers()
    return self.m_tblMembers;
end

-- ///////////////////////////////
-- ///// getMemberCount      //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporation:getMemberCount()
    return self.m_iMembers;
end

-- ///////////////////////////////
-- ///// setMOTD            //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporation:setMOTD(sMotd)
    return self:setSetting("MOTD", sMotd, true);
end

-- ///////////////////////////////
-- ///// getMOTD            //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporation:getMOTD(sMotd)
    self.m_sMotd    = (self:getSetting("MOTD") or "-")
    return self:getSetting("MOTD");
end


-- ///////////////////////////////
-- ///// setLagereinheiten  //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporation:setLagereinheiten(iVal)
    self.m_iLagerEinheiten = iVal
    self:setSetting("lagereinheiten", iVal, true)
end

-- ///////////////////////////////
-- /////getLagereinheiten   //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporation:addLagereinheiten(iVal)
    self.m_iLagerEinheiten = self.m_iLagerEinheiten+iVal
    self:setSetting("lagereinheiten", self.m_iLagerEinheiten, true)
end


-- ///////////////////////////////
-- /////getLagereinheiten   //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporation:getLagereinheiten()
    return self.m_iLagerEinheiten;
end

-- ///////////////////////////////
-- ///// getBio             //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporation:getBio()
    return self.m_sBio;
end

-- ///////////////////////////////
-- ///// setBio             //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporation:setBio(sBio)
    self.m_sBio = sBio;
end

-- ///////////////////////////////
-- ///// getTaxRate           //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporation:getRaxRate()
    return self.m_iTaxRate;
end

-- ///////////////////////////////
-- ///// setBio             //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporation:setTaxRate(iRate)
    self.m_iTaxRate = iRate;
end


-- ///////////////////////////////
-- ///// getCEO             //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporation:getCEO()
    for index, members in pairs(self.m_tblMembers) do
        if(self.m_tblMemberRoles[members]) then
            for index, role in pairs(self.m_tblMemberRoles[members]) do
                if(tonumber(index) == 0) and (toboolean(role) == true) then
                    return members
                end
            end
        end
    end
    return false;
end

-- ///////////////////////////////
-- ///// refreshOnlineMembers     //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporation:refreshOnlineMembers()
    self.m_tblOnlineMembers = {}
    for member, _ in pairs(self.m_tblMembers) do
        if(getPlayerFromName(member)) then
            self.m_tblOnlineMembers[getPlayerFromName(member)] = true
        end
    end
end

-- ///////////////////////////////
-- ///// refreshMembers     //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporation:refreshMembers()
    self.m_tblMembers       = {}
    self.m_iMembers         = 0;
    self.m_tblOnlineMembers = {}
    local result = CDatabase:getInstance():query("SELECT * FROM userdata WHERE CorporationID = ?", self.m_iID)
    if(result) and (#result > 0) then
        for index, row in pairs(result) do
            self.m_tblMembers[row['Name']] = row['Name'];
            self.m_tblMemberRoles[row['Name']] = fromJSON(row['CorporationRoles']);

            self.m_iMembers = self.m_iMembers+1;

            if(getPlayerFromName(row['Name'])) then
                self.m_tblOnlineMembers[getPlayerFromName(row['Name'])] = true
            end
        end
    end
    self:getMOTD()
    return self:getMembers();
end

-- ///////////////////////////////
-- ///// sendFactionMessage   //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporation:sendFactionMessage(sMessage, r, g, b)
    for index, bool in pairs(self.m_tblOnlineMembers) do
        if(isElement(index)) then
            outputChatBox(sMessage, index, r, g, b);
        else
            self:refreshOnlineMembers()
        end
    end
end

-- ///////////////////////////////
-- ///// sendRoleMessage   //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporation:sendRoleMessage(sMessage, iRole, r, g, b)
    for index, bool in pairs(self.m_tblOnlineMembers) do
        if(isElement(index)) then
            if(index:hasCorpRole(iRole)) then
                outputChatBox(sMessage, index, r, g, b)
            end
        else
            self:refreshOnlineMembers()
        end
    end
end

--[[
-- ///////////////////////////////
-- ///// refreshConnections //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporation:refreshConnections()
    self.m_tblConnections       = {}
    self.m_tblConnectionNames   = {}

    local lastIndex         = 1;
    local result            = CDatabase:getInstance():query("SELECT * FROM corporation_connections WHERE ID1 = ? OR ID2 = ?;", self.m_iID, self.m_iID)
    for index, row in pairs(result) do
        self.m_tblConnections[lastIndex] = row;

        local differentID;
        if(tonumber(row['ID1']) == self.m_iID) then
            differentID = tonumber(row['ID2'])
        else
            differentID = tonumber(row['ID1'])
        end

        self.m_tblConnectionNames[lastIndex] = Corporations[differentID].m_sFullName;
        lastIndex = lastIndex+1;
    end
    return self.m_tblConnections;
end]]

-- ///////////////////////////////
-- ///// refreshConnections //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporation:getConnections()
    local result        = CDatabase:getInstance():query("SELECT * FROM corporation_connections WHERE ID1 = ? OR ID2 = ?;", self.m_iID, self.m_iID);

    local tbl                   = {}
    local index                 = 0;
    self.m_tblConnectionNames   = {}

    if(result) then
        for index2, row in pairs(result) do
            index = index+1;

            local differentID;
            if(tonumber(row['ID1']) == self.m_iID) then
                differentID = tonumber(row['ID2'])
            else
                differentID = tonumber(row['ID1'])
            end
            tbl[index] = {Corporations[differentID], tonumber(row["iState"])}

            self.m_tblConnectionNames[index] = Corporations[differentID]
        end
    end

    self.m_tblConnections   = tbl;
    return self.m_tblConnections, self.m_tblConnectionNames;
end

-- ///////////////////////////////
-- ///// loadDefaultDatas 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporation:loadDefaultDatas()
    if not(self.m_bDefaultDatasLoaded) then
        self.m_iSaldo           = (tonumber(self:getData("saldo")) or 0)
        self.m_iInventory       = (tonumber(self:getSetting("inventory")) or 0)
        self.m_iLagerEinheiten  = (tonumber(self:getSetting("lagereinheiten")) or 0)
        self.m_tblSkins         = table.rewriteIntegerIndexes(self.m_tblSkins)


        if not(self.m_iInventory) or (self.m_iInventory == 0) then
            CDatabase:getInstance():query("INSERT INTO  inventory (`Type` ,`Categories` ,`Items` ,`Slots`) VALUES ('2',  ' [ { \"7\": true, \"1\": true, \"2\": true, \"4\": true, \"8\": true, \"9\":  true, \"5\": true, \"3\": true, \"6\": true } ]',  '[ {\"17\": 2 } ]',  '250');")
            local val = CDatabase:getInstance():query("SELECT * FROM inventory WHERE ID=(LAST_INSERT_ID()) LIMIT 1;")
            local value = val[1]
            self.m_iInventory = tonumber(value["ID"])
            new(CInventory, value["ID"], value["Type"], value["Categories"], value["Items"], value["Slots"])
            outputConsole("Die Corporation "..self:getName().." besitzt nun das Inventar mit der Nummer "..value["ID"])

            self:setSetting("inventory", self.m_iInventory, true)
        end

        self:getLohn();
        self:updateBizes();
        self.m_bDefaultDatasLoaded = true;
    end
end



-- ///////////////////////////////
-- ///// getInventory    	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporation:getInventory()
    return (Inventories[self.m_iInventory] or false)
end

-- ///////////////////////////////
-- ///// setSaldo        	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporation:setSaldo(iSaldo)
    self.m_iSaldo = iSaldo;
    self:setSetting("saldo", iSaldo, true)
end

-- ///////////////////////////////
-- ///// addSaldo        	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporation:addSaldo(iSaldo)
    self.m_iSaldo = self.m_iSaldo+iSaldo;
    self:setSetting("saldo", self.m_iSaldo, true)
end

-- ///////////////////////////////
-- ///// hasSaldo        	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporation:hasSaldo(iSaldo)
    if(self.m_iSaldo >= iSaldo) then
        return true
    end
    return false;
end

-- ///////////////////////////////
-- ///// getSaldo        	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporation:getSaldo()
    return self.m_iSaldo;
end

-- ///////////////////////////////
-- ///// getSkins        	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporation:getSkins()
    return self.m_tblSkins;
end

-- ///////////////////////////////
-- ///// getRoleFromSkin   	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporation:getRoleFromSkin(iSkin)
    for id, skin in pairs(self.m_tblSkins) do
        if(tonumber(skin) == tonumber(iSkin)) then
            return (tonumber(id))
        end
    end
end

-- ///////////////////////////////
-- ///// setSkin        	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporation:setSkin(iRolle, iID)
    self.m_tblSkins[iRolle] = iID;
    return iID
end


-- ///////////////////////////////
-- ///// updateHouses      	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporation:updateHouses()
    self.m_tblHouses    = {};
    self.m_iCurHouses   = 0;

    local houses    = CorporationHouses[self.m_iID]
    if(houses) then
        for ID, house in pairs(houses) do
            self.m_tblHouses[ID] = house;
            self.m_iCurHouses = self.m_iCurHouses+1;
        end
    end
end

-- ///////////////////////////////
-- ///// updateBizes      	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporation:updateBizes()
    self.m_tblBizes         = {};
    self.m_iCurBizes        = 0;

    local bizes    = CorporationBizes[self.m_iID]
    if(bizes) then
        for ID, biz in pairs(bizes) do
            self.m_tblBizes[ID] = biz;
            self.m_iCurBizes = self.m_iCurBizes+1;
        end
    end
end


-- ///////////////////////////////
-- ///// getBusinesses     	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporation:getBizes()
    self:updateBizes();
    return self.m_tblBizes;
end

-- ///////////////////////////////
-- ///// getBizIncome     	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporation:refreshBizIncome()
    local bizes     = self:getBizes()

    local income        = 0
    for index, biz in pairs(bizes) do
        income = income+biz.m_iIncome;
    end

    self.m_iBizIncome   = income;
    return income;
end

-- ///////////////////////////////
-- ///// getBizIncome     	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporation:getBizIncome()
    self:refreshBizIncome()
    return (self.m_iBizIncome or 0)
end


-- ///////////////////////////////
-- ///// getHouses      	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporation:getHouses()
    self:updateHouses();
    return self.m_tblHouses;
end

-- ///////////////////////////////
-- ///// getOnlinePlayers  	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporation:getOnlinePlayers()
    local players   = getElementsByType("player")   -- Hmm

    local count     = 0;
    for index, player in pairs(players) do
        if(player.CorporationID) and (player:getCorporation() ~= 0) and (player:getCorporation():getID() == self.m_iID) then
            count = count+1;
        end
    end
    return count;
end

-- ///////////////////////////////
-- ///// getLohn          	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporation:getLohn()
    self.m_iLohn = (tonumber(self:getSetting("lohn")) or 0)
    return self.m_iLohn
end

-- ///////////////////////////////
-- ///// setLohn          	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporation:setLohn(iLohn)
    return (tonumber(self:setSetting("lohn", iLohn, true)) or false)
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporation:constructor(iID, sFullName, sShortName, sColor, iIconID, sFounderName, sFounderDate, sBio, iTaxRate, iState, iMaxMembers, iMaxVehicles, iMaxHouses, iMaxSkins, iMaxBizes, sSkins, sMiscSettings)
    -- Klassenvariablen --

    self.m_iID              = tonumber(iID);
    self.m_sFullName        = (sFullName or "-")
    self.m_sShortName       = (sShortName or "-");
    self.m_sColor           = (sColor or "#FFFFFF");
    self.m_tblIcons         = (fromJSON(iIconID) or {});
    self.m_sFounderName     = (sFounderName or "-");
    self.m_sFounderDate     = (sFounderDate or "-");
    self.m_sBio             = (sBio or "-");
    self.m_iTaxRate         = (tonumber(iTaxRate) or 1);
    self.m_iState           = (tonumber(iState) or 100);
    self.m_iMaxMembers      = (tonumber(iMaxMembers) or 2);
    self.m_iMaxVehicles     = (tonumber(iMaxVehicles) or 2);
    self.m_iMaxSkins        = (tonumber(iMaxSkins) or 3);
    self.m_iMaxHouses       = (tonumber(iMaxHouses) or 1);
    self.m_iMaxBizes        = (tonumber(iMaxBizes) or 2);

    self.m_iMembers         = 0;

    self.m_tblSkins         = (fromJSON(sSkins) or {})
    self.m_tblMiscSettings  = (fromJSON(sMiscSettings) or {})

    -- Funktionen --

    self.m_tblMembers               = {}
    self.m_tblMemberRoles           = {}
    self.m_tblOnlineMembers         = {}

    self.m_bCorpVehiclesLoaded      = false;
    self.m_tblVehicles              = {}
    self.m_iCurCorpVehicle          = 0;

    self.m_iCurHouses               = 0;
    self.m_tblHouses                = {}


    self.m_iCurOnlinePlayers        = 0;

    -- Events --
    self:refreshMembers();
    self:loadCorpVehicles();
    self:loadDefaultDatas()

    Corporations[iID] = self;
end

-- ///////////////////////////////
-- ///// destructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporation:destructor()
    for _, v in pairs(self.m_tblVehicles) do
        if(isElement(v)) then
            destroyElement(v)
        end
    end

    CDatabase:getInstance():query("DELETE FROM corporation_vehicle WHERE CorpID = ?", self.m_iID)
    CDatabase:getInstance():query("DELETE FROM corporations WHERE iID = ?", self.m_iID)

    outputDebugString("Corporation: "..self.m_iID.." deleted.")
end

-- EVENT HANDLER --
