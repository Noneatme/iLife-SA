--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

NPCs = {}
CNPC = {}

 --[[///
	Klasse: CNPC
	Attribute:
		ID : INT(21)
		X : Float()
		Y : Float()
		Z : Float()
		Rot : Float()
		
		Type : INT (21)
			//Definition:
			1= Kauft Drogen (14)
			2= Verkauft Drogen (28)
			3= Kauft Essen (79)
			4= Verkauft Essen (168)
			5= Kauft Waffen (135)
			6= Verkauft Waffen (143)
 ]]-----

SellNPCIDs = {
	[2]=true,
	[4]=true
 }
 
BuyNPCIDs = {
	[1]=true,
	[3]=true
 }
 
DrugTypes = {
	[9]=true,
	[10]=true,
	[11]=true,
	[12]=true,
	[14]=true
}
 
EatTypes = {
	[3]=true,
	[4]=true,
	[5]=true,
	[15]=true,
	[16]=true,
	[17]=true,
}

WeaponTypes = {
 
}
 
function CNPC:constructor(ID,X,Y,Z,Rot,Typ)
	self.ID = ID
	self.X = X
	self.Y = Y
	self.Z = Z 
	self.Rot = Rot
	self.Type = Typ
	
	if (SellNPCIDs[self.Type]) then
	
	else
		if (BuyNPCIDs[self.Type]) then
		
		else
		
		end
	end
	
	self.eOnClick = bind(CNPC.onClick,self)
	addEventHandler("onElementClicked", self, self.eOnClick)
	
	NPCs[self.ID] = self
end

function CNPC:onClick(button,state,player)
	if button == "left" and state == "down" then
		if (self.Type == 1) then
			player:showInfoBox("info","KAUFE DROGEN")
			return true
		end
		if (self.Type == 2) then
			player:showInfoBox("info","VERKAUFE DROGEN")
			return true
		end
		if (self.Type == 3) then
			player:showInfoBox("info","KAUFE ESSEN")
			return true
		end
		if (self.Type == 4) then
			player:showInfoBox("info","VERKAUFE ESSEN")
			return true
		end
		if (self.Type == 5) then
			player:showInfoBox("info","KAUFE WAFFEN")
			return true
		end
		if (self.Type == 6) then
			player:showInfoBox("info","VERKAUFE WAFFEN")
			return true
		end
	end
end