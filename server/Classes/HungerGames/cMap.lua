--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

ClientMaps = {
	[1]="[HG]ReWrite v2 - Beginning",
	[2]="[HG]Samy v1 - HungerWars",
	[3]="[HG]PewX v2 - Seven Towers",
	[4]="[HG]Shape v1 - The Village"
	--[5]="[HG]PewX feat. Prime - Forest Island"
}

Maps = {}

CMap = {}

function CMap:constructor(Name)
	self.Name = Name
	
	self.Mapfile = "/res/maps/HungerGames/"..Name.."/map.map"
	
	self.ElementRoot = getResourceMapRootElement ( getThisResource(), self.Mapfile )
	
	self.Spawns = {}
	self.Chests = {}
	self.Objects = {}
	
	self.SpawnElements = getElementsByType( 'spawnpoint', self.ElementRoot )
	self.ChestElements = getElementsByType( 'chest', self.ElementRoot )
	self.ObjectElements = getElementsByType( 'object', self.ElementRoot )
	self.RemoveWorldElements = getElementsByType('removeWorldObject', self.ElementRoot)
	
	for k,v in ipairs(self.RemoveWorldElements) do
		local id = getElementData(v, "model")
		local radius = getElementData(v, "radius")
		local x = getElementData(v, "posX")
		local y = getElementData(v, "posY")
		local z = getElementData(v, "posZ")
		removeWorldModel(id, radius,x,y,z)
		local id = getElementData(v, "lodModel")
		removeWorldModel(id, radius,x,y,z)
	end
	
	for k,v in ipairs(self.SpawnElements) do
		local x,y,z = getElementPosition(v)
		local rx = getElementData(v, "rotX")
		local ry = getElementData(v, "rotY")
		local rz = getElementData(v, "rotZ")
		--false, false, nil
		table.insert(self.Spawns, {["X"]=x,["Y"]=y,["Z"]=z,["RotZ"]=rz})
	end
	
	for k,v in ipairs(self.ChestElements) do
		local x,y,z = getElementPosition(v)
		local rx = getElementData(v, "rotX")
		local ry = getElementData(v, "rotY")
		local rz = getElementData(v, "rotZ")

		table.insert(self.Chests, {["X"]=x,["Y"]=y,["Z"]=z,["RotX"]=rx, ["RotY"]=ry, ["RotZ"]=rz})
	end
	
	for k,v in ipairs(self.ObjectElements) do
		local id = getElementModel(v)
		local scale = getObjectScale(v)
		local x,y,z = getElementPosition(v)
		local rx, ry, rz = getObjectRotation(v)
		local col = getElementCollisionsEnabled(v)
		--local breakeable = isObjectBreakable(v)
		table.insert(self.Objects, {["ID"]=id,["Scale"]=scale,["X"]=x,["Y"]=y,["Z"]=z,["RotX"]=rx, ["RotY"]=ry, ["RotZ"]=rz,["collisions"]=col,["breakable"]=breakable})
	end
	
	self.MaxPlayers = #self.Spawns
	Maps[self.Name] = self
end

function CMap:destructor()
end

function CMap:getMaxSize()
	return self.MaxPlayers
end

function CMap:getPlayerSpawns()
	return self.Spawns
end

function CMap:getChestPositions()
	return self.Chests
end

function CMap:getObjects()
	return self.Objects
end