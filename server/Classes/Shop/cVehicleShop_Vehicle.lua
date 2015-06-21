--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

VehicleShopVehicles = {}

CVehicleShopVehicle = inherit(CVehicle)

function CVehicleShopVehicle:constructor(iID, cShop, iInt, iDim, sColor, sTuning, iType, iStock, iPrice)
	self.ID 		= iID
	self.Shop  		= cShop
	self.Int 		= iInt
	self.Dim 		= iDim
	self.Color 		= sColor
	self.Tuning 	= sTuning
	self.Type 		= iType
	self.Stock 		= iStock
	self.Price 		= iPrice

	VehicleShopVehicles[iID] = self

	setVehicleDamageProof(self, true)

	self.eOnVehicleClick  = bind(CVehicleShopVehicle.onVehicleClick,self)
	addEventHandler("onElementClicked", self, self.eOnVehicleClick)

	self:setLocked(true)
	self:setFrozen(true)
	self:setAlpha(230);

end

function CVehicleShopVehicle:destructor()

end

function CVehicleShopVehicle:getID()
	return self.ID
end

function CVehicleShopVehicle:getPrice()
	return self.Price
end

function CVehicleShopVehicle:getType()
	return self.Type
end

function CVehicleShopVehicle:getColorString()
	return self.Color
end

function CVehicleShopVehicle:getTuning()
	return self.Tuning
end

function CVehicleShopVehicle:getShop()
	return self.Shop;
end

function CVehicleShopVehicle:getBiz()
	return cBusinessManager:getInstance().m_uBusiness[self.Shop.Filliale]		-- Gesundheit
end


function CVehicleShopVehicle:onVehicleClick(mouseButton, buttonState, thePlayer)
	if( (mouseButton == "left") and (buttonState == "down") ) then
		--"CarbuyGuiOpen", getLocalPlayer(), function(ID, Modelname, Cost, Bestand)
		triggerClientEvent(thePlayer, "CarbuyGuiOpen", thePlayer, self.ID, getVehicleName(self), self.Price, self.Stock)
	end
end
