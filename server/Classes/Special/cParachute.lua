--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CParachute = {}
Parachutes = {}

function CParachute:constructor(id,x,y,z)
	self.ID = id
	self.X = x
	self.Y = y
	self.Z = z
	
	Parachutes[self.ID] = self

	self.eOnHit = bind(CParachute.onHit, self)
	addEventHandler("onMarkerHit", self, self.eOnHit)
	
end

function CParachute:onHit(element, matching)
	if (matching) and (getElementType(element) == "player") then
		self.AbsprungHeli = {}
		self.Pilot = {}
		self.AbsprungHeli[getPlayerName(element)] = createVehicle(487,self.X,self.Y,self.Z+1300)
		setElementFrozen(self.AbsprungHeli[getPlayerName(element)],true)
		self.Pilot[getPlayerName(element)] = createPed(0,self.X,self.Y,self.Z+1250)
		warpPedIntoVehicle(self.Pilot[getPlayerName(element)],self.AbsprungHeli[getPlayerName(element)])
		warpPedIntoVehicle(element,self.AbsprungHeli[getPlayerName(element)],1)
		local dim = math.random(1,65535)
		setElementDimension(self.Pilot[getPlayerName(element)],dim)
		setElementDimension(self.AbsprungHeli[getPlayerName(element)],dim)
		setElementDimension(element,dim)
		setControlState(element,"enter_exit",true)
		giveWeapon(element,46,1,true)
		
		setTimer(
			function(name)
				destroyElement(self.AbsprungHeli[name])
				destroyElement(self.Pilot[name])
				setElementDimension(getPlayerFromName(name),0)
				end,3000,1, getPlayerName(element)
			)
	end
end

