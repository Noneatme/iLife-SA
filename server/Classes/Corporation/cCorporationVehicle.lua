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
-- Time: 17:36
-- To change this template use File | Settings | File Templates.
--

CorporationVehicles = {}

cCorporationVehicle = inherit(CVehicle)

addEvent("onVehicleSwitchLock", true)

function cCorporationVehicle:constructor(iID, iCorpID, iModell, iX, iY, iZ, iRX, iRY, iRZ, sColor, iKM, sColor2, sName, iInventory)
    CVehicle.constructor(self, "CorporationVehicle", false)

    -- Klassenvariablen --
    self.m_iID          = iID
    self.m_iCorpID      = iCorpID;
    self.m_iModell      = iModell
    self.m_iX           = iX
    self.m_iY           = iY
    self.m_iZ           = iZ
    self.m_iRX          = iRX
    self.m_iRY          = iRY
    self.m_iRZ          = iRZ

    self.m_tblColor     = sColor;

    local r, g, b, a    = getColorFromString(sColor2)
    local colorstring   = r.."|"..g.."|"..b.."|"

    for i = 3, 1, -1 do
        if(self.m_tblColor[i]) then
            local r, g, b, a = getColorFromString(self.m_tblColor[i][2])
            if(r) and (g) and (b) then
                colorstring = colorstring..r.."|"..g.."|"..b.."|"
            end
        end
    end

    local color         = {}

    for i = 1, 9, 1 do
        local f = gettok(colorstring, i, "|");
        color[i] = f;
    end

    self:setColor(unpack(color))

    self.openForEveryoneVehicle	= false;

    self.checkPermissionFunc = function(thePlayer, iSeat)
        if(iSeat == 0) or not(iSeat) then
            if(thePlayer:getCorporation() ~= 0) and (thePlayer:getCorporation():getID() == self.m_iCorpID) then
                return true;
            else
                return false;
            end
        end
        return true;
    end

    self.eOnVehicleExplode = bind(cCorporationVehicle.onVehicleExplode,self)
    addEventHandler("onVehicleExplode", self, self.eOnVehicleExplode)

    self.eOnVehicleSwitchLock = bind(cCorporationVehicle.switchLocked, self)
	addEventHandler("onVehicleSwitchLock", self, self.eOnVehicleSwitchLock)

    self:setData("ID", iID)
    self:setData("CorporationVehicle", true)
    self:setData("Type", "Corporationsfahrzeug")
    self:setData("OwnerName", sName)
    self:setData("Plate", sName)

    if not(iInventory) or (tonumber(iInventory) == 0) or not(Inventories[iInventory]) then
        self.iInventory, self.Inventory = CInventory:generateNewInventory();
        self:save();
    else
        self.iInventory = iInventory;
        self.Inventory  = Inventories[self.iInventory];
    end

    self.Inventory:setMaxGewicht(CUserVehicleManager:getInstance().m_tblVehicleTrunks[tonumber(self.m_iModell)] or 250000)

    --self.switchEngineBla = bind(function(self, player, key, state)  carStart:Toggle(player, key, state, self) end, self);

    -- Funktionen --

    -- Events --
    CorporationVehicles[self.m_iID] = self;
end

-- ///////////////////////////////
-- ///// getCorporation()   //////
-- ///// Returns: nil   	//////
-- ///////////////////////////////

function cCorporationVehicle:getCorporation()
    return Corporations[self.m_iCorpID] or false;
end

-- ///////////////////////////////
-- ///// sendInventory           //////
-- ///// Returns: nil   	//////
-- ///////////////////////////////

function cCorporationVehicle:sendInventory(uPlayer)
	if not(self.Inventory) then
		self.Inventory = Inventories[self.iInventory]
	end

	self.Inventory:refreshGewicht();
	triggerClientEvent(uPlayer, "onClientInventoryRecieve", uPlayer, toJSON(self.Inventory));
end

-- ///////////////////////////////
-- ///// getInventory           //////
-- ///// Returns: nil   	//////
-- ///////////////////////////////

function cCorporationVehicle:getInventory()
	return self.Inventory
end


-- ///////////////////////////////
-- ///// save           //////
-- ///// Returns: nil   	//////
-- ///////////////////////////////

function cCorporationVehicle:save()
    local datas     = {["iInventory"] = self.iInventory}

    for index, value in pairs(datas) do
        CDatabase:getInstance():exec("UPDATE corporation_vehicle SET ?? = ? WHERE iID = ?;", tostring(index), tostring(value), self.m_iID)
    end
end

-- ///////////////////////////////
-- ///// park   //////
-- ///// Returns: nil   	//////
-- ///////////////////////////////

function cCorporationVehicle:park()
    local x, y, z = self:getPosition()
    local rx, ry, rz = self:getRotation()

    CDatabase:getInstance():exec("UPDATE corporation_vehicle SET PosX = '?', PosY = '?', PosZ = '?', RotX = '?', RotY = '?', RotZ = '?' WHERE iID = ?;", x, y, z, rx, ry, rz, self.m_iID)
end

-- ///////////////////////////////
-- ///// switchLocked   //////
-- ///// Returns: nil   	//////
-- ///////////////////////////////

function cCorporationVehicle:switchLocked(thePlayer)
    if(self.checkPermissionFunc(thePlayer)) then
        if (self:isLocked()) then
            self:setLocked(false)
            self.Locked = false
            local x,y,z = self:getPosition()
            triggerClientEvent("onServerPlaySound", self, x, y, z, "res/sounds/car_unlock.mp3")
        else
            self:setLocked(true)
            self.Locked = true
            local x,y,z = self:getPosition()
            triggerClientEvent("onServerPlaySound", self, x, y, z, "res/sounds/car_lock.mp3")
        end
        self:setData("Locked", self.Locked)
    else
        thePlayer:showInfoBox("error", "Für dieses Fahrzeug besitzt du keinen Schlüssel!")
    end
end

-- ///////////////////////////////
-- ///// onVehicleExplode   //////
-- ///// Returns: nil   	//////
-- ///////////////////////////////

function cCorporationVehicle:onVehicleExplode()
    setTimer(function() self:respawn() end, 60000, 1)
end
