--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CElement = {}
registerElementClass("element", CElement)

function CElement:constructor()
	
end

function CElement:destructor()
	self:destroy()
end

function CElement:destroy()
	destroyElement(self)
end

function CElement:getData(key)
	return getElementData(self, key)
end

function CElement:setData(key, value)
	setElementData(self, key, value)
end


function CElement:getType()
	assert(isElement(self), "Invaild Element @ CElement:getType")
	return getElementType(self)
end

function CElement:getHealth()
	return getElementHealth(self)
end

function CElement:setHealth(health)
	setElementHealth(self, health)
end

function CElement:getPosition(boolean)
	if(boolean)then
		return Vector3(getElementPosition(self));
	else
		return getElementPosition(self)
	end
end

function CElement:getRotation(boolean)
	if(boolean )then
		return Vector3(getElementRotation(self));
	else
		return getElementRotation(self)
	end
end

function CElement:getDimension()
	return getElementDimension(self)
end

function CElement:getInterior()
	return getElementInterior(self)
end

function CElement:getModel()
	return getElementModel(self)
end

function CElement:getAttachedElements(...)
	return getAttachedElements(self, ...)
end


function CElement:setModel(iModel)
	if(iModel) then
		return setElementModel(self, iModel)
	end
end

function CElement:setDimension(iDimension)
	return setElementDimension(self, iDimension)
end

function CElement:setInterior(iInterior)
	return setElementInterior(self, iInterior)
end

function CElement:setPosition(x,y,z)
	if(type(x) ~= "table") then
		return setElementPosition(self, x, y ,z)
	end
	return setElementPosition(self, x:getX(), x:getY(), x:getZ())
end

function CElement:getVelocity(...)
	return getElementVelocity(self, ...)
end

function CElement:setVelocity(...)
	return setElementVelocity(self, ...)
end

function CElement:setFrozen(state)
	return setElementFrozen(self, state)
end

function CElement:setRotation(x, y, z)
	if(type(x) == "number") then
		return setElementRotation(self, x, y ,z)
	end
	return setElementRotation(self, x:getX(), x:getY(), x:getZ())
end

function CElement:setDoubleSided(...)
	return setElementDoubleSided(self, ...)
end

function CElement:setCollisionsEnabled(...)
	return setElementCollisionsEnabled(self, ...)
end

function CElement:attach(uElement, V1, V2, V3, V4, V5, V6)
	if(type(V1) == "number") then
		return attachElements(self, uElement, V1, V2, V3, V4, V5, V6)
	end
	return attachElements(self, uElement, V1);
end

function CElement:deattach(uElement)
	return dettachElements(self, uElement);
end

function CElement:getDistanceToElement(element)
	local x1, y1, z1 = getElementPosition(element)
	local x2, y2, z2 = self:getPosition()
	
	return getDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2)
end

function CElement:setVelocity(x, y, z)
	setElementVelocity(self, x, y, z)
end

function CElement:getVelocity()
	return getElementVelocity(self)
end

function CElement:getSpeed()
	local vx, vy, vz = self:getVelocity()
	return (vx^2 + vy^2 + vz^2)^0.5 * 180
end

function CElement:setSpeed(speed)
	local dif = speed / self:getSpeed(speedType)
	local x,y,z = self:getVelocity()
	self:setVelocity(x*diff,y*diff,z*diff)
end
