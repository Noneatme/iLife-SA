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
-- ## Name: cBusiness.lua		        	##
-- ## Author: Noneatme(Gunvarrel		##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

cBusiness = {};

CorporationBizes    = {}


BusinessBizes       = {}
--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function cBusiness:new(...)
    local obj = setmetatable({}, {__index = self});
    if obj.constructor then
        obj:constructor(...);
    end
    return obj;
end

-- ///////////////////////////////
-- ///// updateElementData	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cBusiness:updateElementData()
    if(self.m_uPickup) then
        self.m_uPickup:setData("Title", self.m_sTitle)
        self.m_uPickup:setData("OwnerName", self.m_sOwner)
        self.m_uPickup:setData("Cost", self.m_iCost)
        self.m_uPickup:setData("Einkommen", self.m_iIncome)
        self.m_uPickup:setData("ID", self.m_iID)
    end
end

-- ///////////////////////////////
-- ///// saveData       	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cBusiness:saveData(sData)
    self:updateSaveValues();
    local value     = self.m_tblSaveValues[sData]
    CDatabase:getInstance():query("UPDATE corporation_business SET "..sData.." = '"..tostring(value).."' WHERE iID = '"..self.m_iID.."';");
    return true;
end

-- ///////////////////////////////
-- ///// updateSaveValues 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cBusiness:updateSaveValues()
    self.m_tblSaveValues    =
    {
        ["MiscSettings"]    = toJSON(self.m_tblMiscSettings),
        ["OwnerID"]         = self.m_iOwnerID,
    }
end


-- ///////////////////////////////
-- ///// setSetting  		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cBusiness:setSetting(sSetting, sValue, bSave)
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

function cBusiness:getSetting(sSetting, sValue)
    return self.m_tblMiscSettings[sSetting];
end

-- ///////////////////////////////
-- ///// getLagerEinheiten	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cBusiness:getLagereinheiten()
    if(tonumber(self.m_iOwnerID) == 0) or not(self.m_iOwnerID) or not(Corporations[self.m_iOwnerID]) then
        return 99999        -- Kein Besitzer, System springt ein
    else
        return self.m_iLagerEinheiten;
    end
end

-- ///////////////////////////////
-- getLagerEinheitenMultiplikator
-- ///// Returns: void		//////
-- ///////////////////////////////

function cBusiness:getLagereinheitenMultiplikator()
    return ((cBusinessManager:getInstance().m_tblMultiplikatoren[self.m_sTitle]) or 1)
end

-- ///////////////////////////////
-- getMaxLagerEinheiten
-- ///// Returns: void		//////
-- ///////////////////////////////

function cBusiness:getMaxLagereinheiten()
    return ((cBusinessManager:getInstance().m_tblMaxLagereinheiten[self.m_sTitle]) or 100)
end

-- ///////////////////////////////
-- ///// removeOneLagereinheit	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cBusiness:removeOneLagereinheit(bDoNotNotify)
    local einheit       = 1*self:getLagereinheitenMultiplikator()
    self:addLagereinheiten(-einheit)

    if(self:getLagereinheiten() < 1) then
        if not(bDoNotNotify) then
            if(self:getCorporation() ~= 0) then
                self:getCorporation():sendRoleMessage("* Dem Business "..self.m_sTitle.." in "..self.m_sStandort.." sind die Lagereinheiten ausgegangen!", 6, 255, 0, 0)
            end
        end

        if(self.m_iEmptySince == 0) then
            self.m_iEmptySince = getRealTime().timestamp;
            self:setSetting("emptysince", self.m_iEmptySince)
        end
    end
    return true;
end

-- ///////////////////////////////
-- ///// addLagerEinheiten	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cBusiness:addLagereinheiten(iEinheiten)
    self.m_iLagerEinheiten = self.m_iLagerEinheiten+iEinheiten
    self:setSetting("lagereinheiten", self.m_iLagerEinheiten, true)

    if(self.m_iLagerEinheiten > 1) then
        self.m_iEmptySince = 0;
        self:setSetting("emptysince", 0)
    end
end

-- ///////////////////////////////
-- ///// setLagerEinheiten	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cBusiness:setLagereinheiten(iEinheiten)
    self.m_iLagerEinheiten = iEinheiten
    self:setSetting("lagereinheiten", self.m_iLagerEinheiten, true)
end

-- ///////////////////////////////
-- ///// loadSettings   	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cBusiness:loadSettings()
    self.m_iLagerEinheiten  = math.floor((tonumber(self:getSetting("lagereinheiten")) or 0))
    self.m_iLocked          = (tonumber(self:getSetting("locked")) or 0)
    self.m_iEmptySince      = (tonumber(self:getSetting("emptysince")) or 0)

    if(self.m_iEmptySince ~= 0) then
        if(self.m_iEmptySince > getRealTime().timestamp-(24*60*60*2)) and (self.m_iOwnerID ~= 0) then
            -- Enteignet
            self.m_iOwnerID = 0;
            outputDebugString("Business "..self.m_iID.." enteignet, Inaktiv");
            self.m_iEmptySince = 0;
            self:setSetting("emptysince", 0)

        end
    end

    self:setOwner(self.m_iOwnerID);

end

-- ///////////////////////////////
-- ///// addMoney          	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cBusiness:addMoney(iMoney)
    if(self:getCorporation() ~= 0) then
        self:getCorporation():addSaldo(iMoney)
    end
end

-- ///////////////////////////////
-- ///// getCorporation   	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cBusiness:getCorporation()
    if(self.m_iOwnerID ~= 0) then
        return Corporations[self.m_iOwnerID] or false
    end
    return 0;
end

-- ///////////////////////////////
-- ///// getCorporationID  	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cBusiness:getCorporationID()
    if(self.m_iOwnerID ~= 0) then
        if(Corporations[self.m_iOwnerID]) then
            return Corporations[self.m_iOwnerID]:getID()
        end
    end
    return 0;
end

-- ///////////////////////////////
-- ///// setOwner     		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cBusiness:setOwner(iID, bSave)
    iID = tonumber(iID) or 0
    if(iID == 0) then
        if(CorporationBizes[self.m_iOwnerID]) and (CorporationBizes[self.m_iOwnerID][self.m_iID]) then
            CorporationBizes[self.m_iOwnerID][self.m_iID] = nil;
        end
    else
        if not(CorporationBizes[iID]) then
            CorporationBizes[iID] = {}
        end

        if(self.m_iID) and (CorporationBizes[self.m_iOwnerID]) and (CorporationBizes[self.m_iOwnerID][self.m_iID]) and (CorporationBizes[self.m_iOwnerID][self.m_iID] == self) then
            CorporationBizes[self.m_iOwnerID][self.m_iID] = nil;
        end

        CorporationBizes[iID][self.m_iID] = self;
    end
    self.m_iOwnerID             = iID;

    if(Corporations[self.m_iOwnerID]) then
        self.m_sOwner           = Corporations[self.m_iOwnerID].m_sFullName.." ("..Corporations[self.m_iOwnerID].m_sShortName..")";
    else
        self.m_sOwner           = "Niemand"
    end

    if(bSave) then
        self:saveData("OwnerID")
    end
    self:updateElementData();
end

-- ///////////////////////////////
-- ///// getOwner     		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cBusiness:getOwnerID()
    return (tonumber(self.m_iOwnerID) or 0)
end


-- ///////////////////////////////
-- ///// save         		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cBusiness:save()
    self:updateSaveValues();

    for index, data in pairs(self.m_tblSaveValues) do
        self:saveData(index);
    end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

local titleDone = {}

function cBusiness:constructor(iID, sStandort, iPosX, iPosY, iPosZ, iOwnerID, iLastAttacked, iType, iCost, sTitle, sDesc, sSettings, iInterior)
    -- Klassenvariablen --
    self.m_iID                  = tonumber(iID);
    self.m_sStandort            = sStandort;
    self.m_iPosX                = tonumber(iPosX);
    self.m_iPosY                = tonumber(iPosY);
    self.m_iPosZ                = tonumber(iPosZ);
    self.m_iOwnerID             = tonumber(iOwnerID);
    self.m_iLastAttacked        = tonumber(iLastAttacked);
    self.m_iType                = tonumber(iType);
    self.m_iCost                = tonumber(iCost);
    self.m_iIncome              = math.floor(self.m_iCost*_Gsettings.corporation.businessIncomeMultiplicator);
    self.m_sTitle               = string.gsub(sTitle, "/", "");
    self.m_sBeschreibung        = sDesc;
    self.m_tblMiscSettings      = (fromJSON(sSettings) or {})

    self.m_sOwner               = "-"
    self.m_iInteriorID          = tonumber(iInterior)
    self.m_tblSaveValues        = {}

    if not(titleDone[self.m_sTitle]) and (fileExists("res/images/business/"..self.m_sTitle..".png")) then
        downloadManager:AddFile("res/images/business/"..self.m_sTitle..".png");
        titleDone[self.m_sTitle] = true;
    end

    self:loadSettings()

    if(InteriorShops[self.m_iInteriorID]) then
        InteriorShops[self.m_iInteriorID].m_iBusinessID = self.m_iID
    end

    -- Funktionen --
    self.m_bOverrideInteriors   = false;        -- Automatische suche nach dem ItemShop

    self.m_uPickup              = Pickup(self.m_iPosX, self.m_iPosY, self.m_iPosZ, 3, 1274, 100)

    local iSize                 = 20;
    if(self.m_bOverrideInteriors) then
        iSize = 40;
    end
    self.m_uCol                 = ColShape.Sphere(self.m_iPosX, self.m_iPosY, self.m_iPosZ, iSize)

    if(self.m_bOverrideInteriors) then
        for index, m in pairs(getElementsWithinColShape(self.m_uCol, "marker")) do
            if(m:getData("intmarkerid")) then
                CDatabase:getInstance():query("UPDATE corporation_business SET InteriorID = '"..m:getData("intmarkerid").."' WHERE iID = '"..self.m_iID.."' LIMIT 1;")
                break;
            end
        end
    end

    self:updateElementData()

    addEventHandler("onPickupHit", self.m_uPickup, function(uElement)
		if(uElement) and (getElementType(uElement) == "player") then
			triggerClientEvent(uElement, "onClientBusinessOpen", uElement, self.m_iID, self.m_iCost, self.m_sOwner, self.m_sTitle, self.m_sBeschreibung, self.m_iIncome)
		end
	end)

    addEventHandler("onColShapeHit", self.m_uCol, function(uElement)
		if(uElement) and (getElementType(uElement) == "player") then
			triggerClientEvent(uElement, "onBusinessColToggle", uElement, self.m_uPickup, true)
            if(uElement:getCorporation() ~= 0) and (uElement:getOccupiedVehicle()) and (uElement:getOccupiedVehicle():getOccupant() == uElement) and (self.m_iOwnerID ~= 0) then
                local truck = uElement:getOccupiedVehicle()

                local trailer = truck:getTowedByVehicle()

                if(truck) and (trailer) and (trailer.Lagereinheiten) then
                    setElementRealSpeed(truck, 0)
                    setElementRealSpeed(trailer, 0)
                    triggerClientEvent(uElement, "onCorporationMarketLadeGUIBusinessAbgebeOpen", uElement, self)
                end
            end
		end
	end)

	addEventHandler("onColShapeLeave", self.m_uCol, function(uElement)
		if(uElement) and (getElementType(uElement) == "player") then
			triggerClientEvent(uElement, "onBusinessColToggle", uElement, self.m_uPickup, false)
		end
	end)
    -- Events --
    self:updateElementData()


    BusinessBizes[self.m_iID] = self;
end

-- EVENT HANDLER --
