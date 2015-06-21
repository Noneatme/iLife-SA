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
-- Time: 01:28
-- To change this template use File | Settings | File Templates.
--

cDrug   = {};
Drugs   = {};

iDrugPlantTime  = 30000;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function cDrug:new(...)
    local obj = setmetatable({}, {__index = self});
    if obj.constructor then
        obj:constructor(...);
    end
    return obj;
end

-- ///////////////////////////////
-- ///// save        		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cDrug:saveNewEntry(uPlayer)
    local iX, iY, iZ = self.m_tblPos:getX(), self.m_tblPos:getY(), self.m_tblPos:getZ()

    local result = CDatabase:getInstance():query("INSERT INTO drugs (OwnerID, iX, iY, iZ, iType, iTimestamp) VALUES ('"..self.m_iOwner.."', '"..iX.."', '"..iY.."', '"..iZ.."', '"..self.m_iType.."', '"..self.m_iTimestamp.."');");
    if(result) then
        local res   = CDatabase:getInstance():query("SELECT LAST_INSERT_ID() as ID FROM drugs;");
        self.m_iID  = tonumber(res[1]['ID']);

        Drugs[self.m_iID] = self;
    end

    setElementPosition(self.m_uObject, iX, iY, iZ-2);
    moveObject(self.m_uObject, iDrugPlantTime, iX, iY, iZ, 0, 0, 0, "InOutQuad");

    logger:OutputPlayerLog(uPlayer, "Pflanze Droge (Typ: "..self.m_iType..")", getZoneName(iX, iY, iZ, false)..", "..getZoneName(iX, iY, iZ, true));
end

-- ///////////////////////////////
-- ///// getCurrentGramm	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cDrug:getCurrentGramm()
    local timestamp = getRealTime().timestamp;

    local gramm     = 0;
    local time     = (timestamp-self.m_iTimestamp)*1000;



    if(self.m_iType == 1) then
        gramm = time/(self.m_iTYPE1_ZEIT*60*60*1000)
        gramm = math.floor(gramm*self.m_iMAX_TYPE1_GRAMM)

        if(gramm > self.m_iMAX_TYPE1_GRAMM) then
            gramm = self.m_iMAX_TYPE1_GRAMM
        end
    else
        gramm = time/(self.m_iTYPE2_ZEIT*60*60*1000)
        gramm = math.floor(gramm*self.m_iMAX_TYPE2_GRAMM)

        if(gramm > self.m_iMAX_TYPE2_GRAMM) then
            gramm = self.m_iMAX_TYPE2_GRAMM
        end
    end


    if(time > self.m_iVERFALLZEIT*60*60*1000) then
        -- Verfallen
        return 5
    end

    return gramm;
end

-- ///////////////////////////////
-- ///// ernte       		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cDrug:ernte(uPlayer)
    local gramm         = self:getCurrentGramm()
    local iX, iY, iZ    = uPlayer:getPosition();
    if(getDistanceBetweenPoints3D(iX, iY, iZ, self.m_tblPos:getX(), self.m_tblPos:getY(), self.m_tblPos:getZ()) < 3) then
        logger:OutputPlayerLog(uPlayer, "Erntete Droge (Typ: "..self.m_iType..")", getZoneName(iX, iY, iZ, false)..", "..getZoneName(iX, iY, iZ, true), gramm.."g");

        if(gramm > 0) then
            if(self.m_iType == 1) then
                uPlayer:getInventory():addItem(Items[14], gramm);
            else
                uPlayer:getInventory():addItem(Items[10], gramm);
            end
            uPlayer:showInfoBox("sucess", "Du hast "..gramm.." Gramm Drogen geerntet!")
            uPlayer:incrementStatistics("Drogen", "Gramm geerntet", gramm)
        else
            uPlayer:showInfoBox("sucess", "Du hast die Wurzel weggeworfen!")
            uPlayer:incrementStatistics("Drogen", "Wurzeln weggeworfen", 1)
        end

        self:destructor();
    else
        uPlayer:showInfoBox("error", "Du musst naeher dran!")
    end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cDrug:constructor(iID, iOwner, iX, iY, iZ, iType, iTimestamp)
    -- Klassenvariablen --
    self.m_iID          = tonumber(iID) or 0;
    self.m_iOwner       = tonumber(iOwner) or 0;

    self.m_iType        = (tonumber(iType)) or 1;
    self.m_tblPos       = Vector3(iX, iY, iZ);
    self.m_iTimestamp   = tonumber(iTimestamp);


    self.m_iMAX_TYPE1_GRAMM     = 15;   -- Max Gramm
    self.m_iMAX_TYPE2_GRAMM     = 35;
    self.m_iTYPE1_ZEIT          = 16;    -- Max Ziehzeit
    self.m_iTYPE2_ZEIT          = 32;


    self.m_iVERFALLZEIT         = 45;   -- 55 Stunden

    -- Funktionen --

    self.m_uObject      = createObject(3409, self.m_tblPos:getX(), self.m_tblPos:getY(), self.m_tblPos:getZ());
    self.m_uClickOB     = createObject(4638, self.m_tblPos:getX(), self.m_tblPos:getY(), self.m_tblPos:getZ());

    setElementAlpha(self.m_uClickOB, 0);
    setObjectScale(self.m_uClickOB, 0);
    attachElements(self.m_uClickOB, self.m_uObject, 0, 0, -0.1, 90, 0, 0);
    -- Events --

    if(self.m_iID) then
        Drugs[self.m_iID] = self;
    end

    addEventHandler("onElementClicked", self.m_uClickOB, function(button, state, uPlayer)
        if(button == "left") and (state == "down") then
            local iGramm    = self:getCurrentGramm()
            triggerClientEvent(uPlayer, "onDrugPlantClick", uPlayer, self.m_iID, iGramm);
        end
    end)
end

-- ///////////////////////////////
-- ///// destructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cDrug:destructor()
    if(isElement(self.m_uObject)) then
        destroyElement(self.m_uObject)
        destroyElement(self.m_uClickOB);
    end

    CDatabase:getInstance():query("DELETE FROM drugs WHERE DrugID = '"..self.m_iID.."';");

    Drugs[self] = nil;
    self        = nil;
end
-- EVENT HANDLER --


addEvent("onDrugErnte", true)
addEventHandler("onDrugErnte", getRootElement(), function(iID)
    if(Drugs[iID]) then
        Drugs[iID]:ernte(client);
    else
        client:showInfoBox("error", "Diese Drogenpflanze existiert nicht!");
    end
end)