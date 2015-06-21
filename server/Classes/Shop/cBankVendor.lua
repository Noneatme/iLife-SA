--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

BankVendors = {}
CBankVendor = inherit(CElement)

function CBankVendor:constructor(iID, sKoords)
	self.ID = iID
	self.Koords = sKoords
	if ( (tonumber(gettok(self.Koords,1,"|"))) == 0 and (tonumber(gettok(self.Koords,2,"|")) == 0) ) then
		self.Blip = createBlip(gettok(self.Koords,3,"|"),gettok(self.Koords,4,"|"),gettok(self.Koords,5,"|"), 52, 1, 0, 0, 0, 255,0,150, getRootElement())
	else
		self:setInterior(gettok(self.Koords,1,"|"))
		self:setDimension(gettok(self.Koords,2,"|"))
	end
	
	self.eOnClicked = bind(self.onClicked, self)
	addEventHandler("onElementClicked", self, self.eOnClicked)
	
	BankVendors[self.ID] = self
end

function CBankVendor:destructor()

end

function CBankVendor:onClicked(button, state, thePlayer)
	if (button == "left" and state == "down") then
		local x,y,z = self:getPosition()
		local x2,y2,z2 = thePlayer:getPosition()
		if (getDistanceBetweenPoints3D(x,y,z,x2,y2,z2) <20) then
			triggerClientEvent(thePlayer, "BankGuiOpen", thePlayer)
		end
	end
end