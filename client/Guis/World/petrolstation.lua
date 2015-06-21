--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

local Petrolstation = {
["window"] = false,
}

local Petrol_Costs = {
	["petrol"] 				= 3,
	["diesel"] 				= 2,
	["super-petrol"] 	= 4,
	["jet_fuel"] 			= 6,
}


local lp = getLocalPlayer()


local function closePetrolstationGui()
	if (Petrolstation["window"] ~= false) then
		Petrolstation["window"]:hide()
		delete(Petrolstation["window"])
		Petrolstation["window"] = false
	end
end

addEvent("PetrolstationGuiOpen",true)
addEventHandler("PetrolstationGuiOpen", lp, function()
	if (not clientBusy) then
		closePetrolstationGui()
		local uVeh = getPedOccupiedVehicle(lp)
		local iVehCat 				= vehicleCategoryManager:getVehicleCategory(uVeh)
		local sVehFuelType 		= vehicleCategoryManager:getCategoryFuelType(iVehCat)
		local iVehTankSize		= vehicleCategoryManager:getCategoryTankSize(iVehCat)
		local cost 						= Petrol_Costs[sVehFuelType] or 0
		local loc 						= "GUI_world_petrolstation_"

		local fuel 						= math.round(getElementData(getPedOccupiedVehicle(localPlayer), "Fuel"))
		local fueldiff 				= math.max(fuel, 0)/iVehTankSize


		Petrolstation["window"] = new(CDxWindow, getLocalizationString(loc.."window_header"), 303, 350, true, true, "Center|Middle", 0, 0, {tocolor(0, 0, 125, 255), false, getLocalizationString(loc.."window_title")}, getLocalizationString(loc.."window_infotext"))
		Petrolstation["label_info"] = new(CDxLabel, getLocalizationString(loc.."label_refill"), 5, 0, 290, 70, tocolor(255,255,255,255), 1.2, "default", "center", "center", Petrolstation["window"])
		Petrolstation["label_price"] = new(CDxLabel, (getLocalizationString(loc.."label_price")):format(getLocalizationString(loc.."label_price_"..sVehFuelType), formNumberToMoneyString(cost)), 5, 70, 290, 20, tocolor(255,255,255,255), 1.2, "default", "left", "center", Petrolstation["window"])

		Petrolstation["progress_fillstate"] = new(CDxProgressbar, fueldiff, 5, 100, 285, 30, tocolor(0, 255, 0, 255), Petrolstation["window"], (getLocalizationString(loc.."label_fuel_state")):format(fuel, iVehTankSize))

	  Petrolstation["label_amount"] = new(CDxLabel, getLocalizationString(loc.."label_amount"), 5, 140, 285, 20, tocolor(255,255,255,255), 1.2, "default", "left", "center", Petrolstation["window"])
		Petrolstation["Edit1"] = new(CDxEdit, "0", 5, 160, 285, 50, "Number", tocolor(0,0,0,255), Petrolstation["window"])
		Petrolstation["Button1"] = new(CDxButton, getLocalizationString(loc.."button_refill_amount"), 5, 220, 285, 50, tocolor(255,255,255,255), Petrolstation["window"])
		Petrolstation["Button2"] = new(CDxButton, getLocalizationString(loc.."button_refill_full"), 5, 280, 285, 50, tocolor(255,255,255,255), Petrolstation["window"])

		Petrolstation["Button1"]:addClickFunction(
		function ()
			if (tonumber(Petrolstation["Edit1"]:getText())>0) and tonumber(Petrolstation["Edit1"]:getText())<= iVehTankSize-math.round(getElementData(getPedOccupiedVehicle(localPlayer), "Fuel")) then
				triggerServerEvent("onClientFillVehicle", getRootElement(),tonumber(Petrolstation["Edit1"]:getText()))
				closePetrolstationGui()
			else
				showInfoBox("error", getLocalizationString(loc.."confirm_wrong_amount"))
			end
		end
		)

		Petrolstation["Button2"]:addClickFunction(
		function ()
			triggerServerEvent("onClientFillVehicle", getRootElement(), iVehTankSize-math.round(getElementData(getPedOccupiedVehicle(localPlayer), "Fuel")))
			closePetrolstationGui()
		end
		)

		for index, ele in pairs(Petrolstation) do
				if(index ~= "window") then
						Petrolstation["window"]:add(ele)
				end
		end

		Petrolstation["window"]:setHideFunction(function() closePetrolstationGui() end)

		Petrolstation["window"]:show()
	end
end
)
