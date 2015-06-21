--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

DriveIns = {}
CDriveIn = {}

 --[[///
	Klasse: CDriveIn
	Attribute:
		ID : INT(21)
		Type : INT (21)
			//Definition:
			= 1 // Burgershot
			= 2 // CluckinBell
			= 3 // Donuts
			= 4 // Well Stacked Pizza
			= 5 // Petrol Station
		X : Float()
		Y : Float()
		Z : Float
 ]]-----

function CDriveIn:constructor(ID, Type,X,Y,Z, iFiliale)
	self.ID = ID
	self.Type = Type
	self.X = X
	self.Y = Y
	self.Z = Z
    self.Filiale = (tonumber(iFiliale))

	DriveIns[self.ID] = self

	self.eOnHit = bind(CDriveIn.onHit, self)
	addEventHandler("onMarkerHit", self, self.eOnHit)
end

function CDriveIn:onHit(vehicle, matching)
	if (matching) then
        if getElementType(vehicle) == "vehicle" then

			setElementVelocity(vehicle, 0, 0, 0)

			local driver = getVehicleOccupant(vehicle)
			if(driver) then
	            driver.TankstellenID = self.Filiale

				if (self.Type == 1) then
					triggerClientEvent(driver, "onItemShopOpen", driver, 4)
					return true
				end
				if (self.Type == 2) then
					triggerClientEvent(driver, "onItemShopOpen", driver, 5)
					return true
				end
				if (self.Type == 3) then
					triggerClientEvent(driver, "onItemShopOpen", driver, 6)
					return true
				end
				if (self.Type == 4) then
					triggerClientEvent(driver, "onItemShopOpen", driver, 7)
					return true
				end
				if (self.Type == 5) then
          local cat = vehicleCategoryManager:getVehicleCategory(vehicle)
        	if vehicle:getFuel() > (vehicleCategoryManager:getCategoryTankSize(cat) or 100) then
            vehicle:setFuel(vehicleCategoryManager:getCategoryTankSize(cat))
        	end
          if not vehicleCategoryManager:isNoFuelVehicleCategory(cat) then
					     triggerClientEvent(driver, "PetrolstationGuiOpen", driver)
          end
					return true
				end
			end
        end
	end
end


addEvent("onClientFillVehicle", true)
addEventHandler("onClientFillVehicle", getRootElement(),
	function(amount)
  local uVeh = getPedOccupiedVehicle(client)
		if (uVeh) then
      if not amount or amount < 1 then return false end

		local canBuy            = true;
		local bizPurchase       = false;
		local biz;
		local einheitenCost     = 0;

		local fil               = client.TankstellenID

		if(fil) and (fil ~= 0) then
			if(cBusinessManager:getInstance().m_uBusiness[fil]) then
			biz = cBusinessManager:getInstance().m_uBusiness[fil];

			einheitenCost	= math.floor((amount*biz:getLagereinheitenMultiplikator()))

				if(biz:getLagereinheiten() >= einheitenCost) then
						canBuy 			= true;
						bizPurchase 	= true;
				else
					canBuy = false;
					client:showInfoBox("error", "Diese Tankstelle ist leer! Sie muss erst wieder aufgefuellt werden.")
				end
			end
		end

    local iVehCat 			= vehicleCategoryManager:getVehicleCategory(uVeh)
		local sVehFuelType  = vehicleCategoryManager:getCategoryFuelType(iVehCat)
		local Petrol_Costs  = {
			["petrol"] 			  = 3,
			["diesel"] 			  = 2,
			["super-petrol"] 	= 4,
			["jet_fuel"] 		  = 6,
		}

		if(canBuy) then
			local money = amount*(Petrol_Costs[sVehFuelType] or 0)

			if (getElementData(getPedOccupiedVehicle(client), "Fraktion") or client:payMoney(money)) then
        uVeh:setFuel(uVeh:getFuel()+amount)
				client:showInfoBox("info", "Du hast ein Fahrzeug betankt (-"..money.."$)!")


				if(bizPurchase) and not(getElementData(uVeh, "Fraktion")) then
					local businessGeld = money
					biz:addLagereinheiten(-einheitenCost)

					if(biz:getCorporation() ~= 0) then
						biz:getCorporation():addSaldo(businessGeld);
					end
				end
			end
		end
		else
			client:showInfoBox("error", "Welches Fahrzeug willst du betanken?")
		end
	end
)
