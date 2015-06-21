--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

-- TODO: Managerklasse Schreiben!

InfoPickups = {}
CInfoPickup = {}

function CInfoPickup:constructor(ID,X,Y,Z,Int,Dim,Text)
	self.ID = ID
	self.X = X
	self.Y = Y
	self.Z = Z
	self.Int = Int
	self.Dim = Dim
	self.Text = Text

	self.eHit = bind(CInfoPickup.onHit, self)
	addEventHandler("onPickupHit", self, self.eHit)

	InfoPickups[self.ID] = self
end

function CInfoPickup:onHit(thePlayer)
    if(thePlayer) and (isElement(thePlayer)) and (getElementType(thePlayer) == "player") then
        thePlayer:showInfoBox("question", self.Text)
    end
end
