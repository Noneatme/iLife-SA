--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CNoobcars = inherit(CVehicle)
Noobcars = {}
 
function CNoobcars:constructor(id,model,x,y,z,rx,ry,rz)
	self.ID = id
	self.Model = model
	self.X = x
	self.Y = y
	self.Z = z
	self.RX = rx
	self.RY = ry
	self.RZ = rz
	self.Noobcar = true
	Noobcars[self.ID] = self
	
	setElementData(self, "noobcar", true)

	self.openForEveryoneVehicle	= true;
	
	self.eOnExplode = bind(CNoobcars.onExplode, self)
	addEventHandler("onVehicleExplode", self, self.eOnExplode)
	
	self.eOnVehicleEnter = bind(CNoobcars.onVehicleEnter,self)
	addEventHandler("onVehicleEnter", self, self.eOnVehicleEnter)
	
	self.eOnVehicleExit  = bind(CNoobcars.onVehicleExit,self)
	addEventHandler("onVehicleExit", self, self.eOnVehicleExit)
	addEventHandler("onVehicleStartExit", self, self.eOnVehicleExit)
	
	self.bSwitchEngine = bind(CNoobcars.switchEngine, self)

	self.switchEngineBla = bind(function(self, player, key, state)  carStart:Toggle(player, key, state, self) end, self);
	
	CVehicle.constructor(self, "Spawn", false)
end

function CNoobcars:onExplode()
	setTimer(respawnVehicle, 60000, 1, source)
end

function CNoobcars:isNoobCar()
	if self.Noobcar then
		return true
	else
		return false
	end
end

function CNoobcars:onVehicleExit(thePlayer, seat, jacked)
	if(seat == 0) then

	end
end

function CNoobcars:onVehicleEnter(thePlayer, seat, jacked)
	if(seat == 0) then

	end
end

function CNoobcars:switchEngine()
	if (self:getEngineState()) then
		self:setEngineState(false)
	else
		self:setEngineState(true)
	end
	self:setData("Engine", self:getEngineState())
end

function CNoobcars:getEngine()
	return self.EngineState
end

setTimer(function()
	for i,v in ipairs(Noobcars) do
			if isVehicleEmpty(v) then
				respawnVehicle(v)
			end
	end
end,60000*30,0)


