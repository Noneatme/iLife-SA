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
-- Date: 05.02.2015
-- Time: 13:38
-- To change this template use File | Settings | File Templates.
--

cPaydayGUI = inherit(cSingleton);
local sx,sy = guiGetScreenSize()

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function cPaydayGUI:new(...)
    local obj = setmetatable({}, {__index = self});
    if obj.constructor then
        obj:constructor(...);
    end
    return obj;
end

-- ///////////////////////////////
-- ///// show        		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cPaydayGUI:show(...)
    if not(self.enabled) and not(clientBusy) then
        self:createElements(...)
        self.enabled = true
    end
end

-- ///////////////////////////////
-- ///// hide          		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cPaydayGUI:hide()
    if(self.guiEle["window"]) then
        self.guiEle["window"]:hide();
        delete(self.guiEle["window"])
        self.guiEle["window"] = false;
        self.enabled = false;
    end
end

-- ///////////////////////////////
-- ///// doPayday   		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cPaydayGUI:doPayday(tblValues)
    if(self.guiEle["window"]) then
        self.guiEle["list"]:clearRows()
        self.guiEle["list"]:addRow("Einkommen| ")
        self.guiEle["list"]:addRow("    Grundeinkommen|+$"..tblValues["BasicIncome"])

        if(tblValues["FactionIncome"]) then
          self.guiEle["list"]:addRow("    Fraktionseinkommen|+$"..tblValues["FactionIncome"])
        end

        if(tblValues["CorporationIncome"]) then
            self.guiEle["list"]:addRow("    Corporationslohn|+$"..tblValues["CorporationIncome"])
        end
        if(tblValues["Interest"]) then
          self.guiEle["list"]:addRow("    Zinsen|+$"..tblValues["Interest"])
        end

        self.guiEle["list"]:addRow("Steuern| ")

        if(tblValues["HouseTaxes"]) then
          self.guiEle["list"]:addRow("    Grundstueckssteuer|-$"..math.abs(tblValues["HouseTaxes"]["total"]))
          for house, tax in pairs(tblValues["HouseTaxes"]) do
            if house ~= "total" then
              self.guiEle["list"]:addRow("        Hausnr. "..tostring(house).."|    -$"..math.abs(tax))
            end
          end
        end

        if(tblValues["VehicleTaxes"]) then
          self.guiEle["list"]:addRow("    Fahrzeugsteuer|-$"..math.abs(tblValues["VehicleTaxes"]["total"]))
          for vehname, tax in pairs(tblValues["VehicleTaxes"]) do
            if vehname ~= "total" then
              self.guiEle["list"]:addRow("        "..tostring(vehname).."|    -$"..math.abs(tax))
            end
          end
        end

        if(tblValues["CorporationTaxes"]) then
            self.guiEle["list"]:addRow("    Corporationssteuer|-$"..math.abs(tblValues["CorporationTaxes"]))
        end

        self.guiEle["list"]:addRow(" | ")
        self.guiEle["list"]:addRow("Gesamt|$"..tblValues["Sum"])


        for index, data in pairs(tblValues) do
                outputConsole(tostring(index)..": "..tostring(data))
        end

        if(isTimer(self.m_timer)) then killTimer(self.m_timer) end
	       self.m_timer	= setTimer(function() self:hide() end, 15000, 1);

        playSound("res/sounds/misc/payday.ogg", false)
    end
end

-- ///////////////////////////////
-- ///// createElements		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cPaydayGUI:createElements(tblValues)
    if not(self.guiEle["window"]) then

        local Y = 112
        local X = 300
        for i,v in pairs(tblValues) do
          if type(v) == "table" then
            for ti, tv in pairs(v) do
                Y = Y + 20
                if Y > sy then Y = sy break end
            end
          else
            Y = Y + 20
            if Y > sy then Y = sy break end
          end
        end

        self.guiEle["window"] 	= new(CDxWindow, "Payday", X, Y, false, false, "Left|Middle", 0, 0, {tocolor(125, 125, 155, 255), false, "Zahltag"})
        self.guiEle["list"]     = new(CDxList, 2, 2, X-7, Y-22, tocolor(255, 255, 255, 255), self.guiEle["window"])
        self.guiEle["list"]:addColumn("Attribut")
        self.guiEle["list"]:addColumn("Wert")

        self.guiEle["window"]:setReadOnly(true)
        for index, ele in pairs(self.guiEle) do
            if(index ~= "window") then
                self.guiEle["window"]:add(ele)
            end
        end

        self.guiEle["window"]:show();

    end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cPaydayGUI:constructor(...)
    -- Klassenvariablen --
    self.guiEle         = {}
    self.enabled        = false;

    -- Funktionen --
	self.m_funcShow		= function(...)
        self:show(...)
        self:doPayday(...)
    end

    -- Events --

	addEvent("PaydayShow", true)
	addEventHandler("PaydayShow", getLocalPlayer(), self.m_funcShow)
end

-- EVENT HANDLER --
