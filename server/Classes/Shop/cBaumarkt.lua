--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

Baumarkt = {}

local absperrungen  =
{
	[193] = true,
	[194] = true,
	[195] = true,
	[196] = true,
	[197] = true

}

CBaumarkt = inherit(CShop)

function CBaumarkt:constructor(iDim)
	self.MapRoot = getResourceMapRootElement(getThisResource(), "res/maps/baumarkt.map")

	self.ShopMarker = ItemShops[10].addMarker(ItemShops[10], 0, 0, 2413.2995605469, -1427.255859375, 23.986780166626)
	setElementInterior(self.ShopMarker, 0)

	-- Fraktionsshop
	self.ShopMarker2 = ItemShops[19].addMarker(ItemShops[19], 0, 0, 2404.4548339844, -1413.0732421875, 24.042953491211)
	setElementInterior(self.ShopMarker2, 0)

	CShop.constructor(self, "Baumarkt", 0, 0, 0)

	createBlip(391.76177978516, -1818.3244628906, 7.8410706520081, 63)
	self.ID = iDim-20000

	table.insert(Baumarkt, self)
	CShop.constructor(self, "Baumarkt", self.ID)
end


function CBaumarkt:BuyPlayerItem(uPlayer, iItem, iID)

	local x, y, z 	= getElementPosition(uPlayer);

	local int, dim	= getElementInterior(uPlayer), getElementDimension(uPlayer);
	local object = MoveableObject:New(objectMover.objectModels[iItem], x, y, z, 0, 0, 0, nil, uPlayer:getID(), true, 0, true, int, dim, false, iID).uObject;

	setElementCollisionsEnabled(object, false)
	setElementAlpha(object, 155);
	setTimer(setElementCollisionsEnabled, 5000, 1, object, true);
	setTimer(setElementAlpha, 5000, 1, object, 255);


	logger:OutputPlayerLog(uPlayer, "Platzierte Objekt", objectMover.objectModels[iItem], getZoneName(x, y, z, false)..", "..getZoneName(x, y, z, true));


	if(absperrungen[iItem]) and (absperrungen[iItem] == true) then
		-- Absperrung, loeschen
		local time = 60*60*1000;
		setTimer(function()
			if(isElement(object.uObject)) then
				destroyElement(object.uObject)
			end
		end, time, 1);
	end
end

function CBaumarkt:destructor()

end
