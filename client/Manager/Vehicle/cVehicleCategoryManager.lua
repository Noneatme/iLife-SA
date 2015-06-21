--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

-- #######################################
-- ## Project: 		 iLife				        ##
-- ## For MTA: San Andreas				      ##
-- ## Name: cVehicleCategoryManager.lua	##
-- ## Author: MasterM       		        ##
-- ## Version: 1.0						          ##
-- ## License: See top Folder			      ##
-- ## Date: June  2015                  ##
-- #######################################

cVehicleCategoryManager = inherit(cSingleton);


local lp = getLocalPlayer()

--[[

]]

-- ///////////////////////////////
-- ///// getVehicleCategory //////
-- ///// Returns: iCat		  //////
-- ///////////////////////////////

function cVehicleCategoryManager:getVehicleCategory(uVeh)
  local iVehID = uVeh
  if type(uVeh) == "userdata" and getElementType(uVeh) == "vehicle" then
    iVehID = getElementModel(uVeh)
  elseif type(uVeh) == "string" then
    iVehID = getVehicleModelFromName(uVeh)
  end
  if tonumber(iVehID) then
    for i,v in pairs(self.tbl_VehicleCategoryData) do
      if v.veh_ids[tostring(iVehID)] then
        return i
      end
    end
  end
  return false
end


-- ////////////////////////////////////
-- ///// getVehiclesFromCategory //////
-- ///// Returns: tblVehs		     //////
-- ////////////////////////////////////

function cVehicleCategoryManager:getVehiclesFromCategory(iID)
  if self.tbl_VehicleCategoryData[iID] then
    return self.tbl_VehicleCategoryData[iID].veh_ids
  else
    return false
  end
end


-- ///////////////////////////////
-- ///// getCategoryName    //////
-- ///// Returns: sName		  //////
-- ///////////////////////////////

function cVehicleCategoryManager:getCategoryName(iID)
  if type(iID) == "userdata" then
    iID = self:getVehicleCategory(iID)
  end

  if self.tbl_VehicleCategoryData[iID] then
    return self.tbl_VehicleCategoryData[iID].name
  else
    return false
  end
end


-- ///////////////////////////////
-- ///// getCategoryMileage //////
-- ///// Returns: iMileage  //////
-- ///////////////////////////////

function cVehicleCategoryManager:getCategoryMileage(iID)
  if type(iID) == "userdata" then
    iID = self:getVehicleCategory(iID)
  end

  if self.tbl_VehicleCategoryData[iID] then
    return self.tbl_VehicleCategoryData[iID].mileage
  else
    return false
  end
end


-- ///////////////////////////////
-- ///// getCategoryTax     //////
-- ///// Returns: iTax		  //////
-- ///////////////////////////////

function cVehicleCategoryManager:getCategoryTax(iID)
  if type(iID) == "userdata" then
    iID = self:getVehicleCategory(iID)
  end

  if self.tbl_VehicleCategoryData[iID] then
    return self.tbl_VehicleCategoryData[iID].tax
  else
    return false
  end
end


-- ///////////////////////////////
-- ///// getCategoryFuelType//////
-- ///// Returns: sFuelType //////
-- ///////////////////////////////

function cVehicleCategoryManager:getCategoryFuelType(iID)
  if type(iID) == "userdata" then
    iID = self:getVehicleCategory(iID)
  end

  if self.tbl_VehicleCategoryData[iID] then
    return self.tbl_VehicleCategoryData[iID].fueltype
  else
    return false
  end
end

-- ///////////////////////////////
-- ///// getCategoryTankSize//////
-- ///// Returns: iTankSize //////
-- ///////////////////////////////

function cVehicleCategoryManager:getCategoryTankSize(iID)
  if type(iID) == "userdata" then
    iID = self:getVehicleCategory(iID)
  end

  if self.tbl_VehicleCategoryData[iID] then
    return self.tbl_VehicleCategoryData[iID].tank
  else
    return false
  end
end


-- ///////////////////////////////
-- ///// isNoFuelVehicleCategory //////
-- ///// Returns: bool //////
-- ///////////////////////////////

function cVehicleCategoryManager:isNoFuelVehicleCategory(iID)
  if type(iID) == "userdata" then
    iID = self:getVehicleCategory(iID)
  end

  if self.tbl_VehicleCategoryData[iID] then
    return self.tbl_VehicleCategoryData[iID].tank == 0 and true or false
  else
    return false
  end
end



-- ///////////////////////////////
-- ///// onDataRecieve 		  //////
-- ///// Returns: void		  //////
-- ///////////////////////////////

function cVehicleCategoryManager:onDataRecieve(tblData)
  self.tbl_VehicleCategoryData = tblData
end


-- ///////////////////////////////
-- ///// Constructor 		    //////
-- ///// Returns: void		  //////
-- ///////////////////////////////

function cVehicleCategoryManager:constructor()
  -- Klassenvariablen --
  self.tbl_VehicleCategoryData = {}

  -- Funktionen --
  self.recieveDataFunc = function(...) self:onDataRecieve(...) end

  -- Events --
  addEvent("cVehicleCategoryManager_OnClientRecieveData", true)
  addEventHandler("cVehicleCategoryManager_OnClientRecieveData", resourceRoot, self.recieveDataFunc)
  triggerServerEvent("cVehicleCategoryManager_OnClientRequestData", resourceRoot)
end

-- EVENT HANDLER --
