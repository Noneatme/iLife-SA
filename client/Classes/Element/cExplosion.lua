--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

-- #######################################
-- ## Project:MTA:The Walking Death		##
-- ## Name: Script						##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {}		-- Local Functions 
local cSetting = {}		-- Local Settings

Explosion = {}
Explosion.__index = Explosion


-- ///////////////////////////////
-- ///// New 				//////
-- ///////////////////////////////

function Explosion:New(...)
	local obj = setmetatable({}, {__index = self})
	if obj.Constructor then
		obj:Constructor(...)
	end
	return obj
end

-- ///////////////////////////////
-- ///// CreateParticle		//////
-- ///////////////////////////////

function Explosion:CreateParticle()
	-- SCHWARZER RAUCH --
	self.objects.rauch = createObject(2054, self.x, self.y, self.z)
	for i2 = 1, 1, 1 do
		if(isElement(self.objects.rauch)) then
			setTimer(destroyElement, 3000, 1, self.objects.rauch)
			setElementCollisionsEnabled(self.objects.rauch, false)
			setElementDimension(self.objects.rauch, self.dim)
			setElementAlpha(self.objects.rauch, 0)
		end
	end

	-- EXPLOSION --

	for i = 0, 5, 0.5 do
	
		local x, y, z = self.x, self.y, self.z
		self.objects.explo = {
			createObject(2013, x+i, y, z),
			createObject(2013, x-i, y, z),
			createObject(2013, x, y+i, z),
			createObject(2013, x, y-i, z),
			createObject(2013, x, y, z),
			createObject(2013, x-i, y+i, z),
			createObject(2013, x+i, y-i, z),
			createObject(2013, x+i, y+i, z),
			createObject(2013, x-i, y-i, z),
				
			createObject(2013, x+i, y, z+2),
			createObject(2013, x-i, y, z+2),
			createObject(2013, x, y+i, z+2),
			createObject(2013, x, y-i, z+2),
			
			createObject(2013, x, y, z+4),

		}
	
		for index, object in pairs (self.objects.explo) do
			if(isElement(object)) then
				setTimer(destroyElement, 1005, 1, object)
				setElementCollisionsEnabled(object, false)
				setElementDimension(object, self.dim)
				setElementAlpha(object, 0)
			end
		end
			
		-- RAUCH --
	
		setTimer(function()
			for i = 0, 5, 0.5 do
			
				local x, y, z = self.x, self.y, self.z;
				local id = 2011
				z = z+0.1
				
				self.objects.rauch2 = {
					createObject(id, x+i, y, z),
					createObject(id, x-i, y, z),
					createObject(id, x, y+i, z),
					createObject(id, x, y-i, z),
			
				}
				
	
				for index, objekt in pairs(self.objects.rauch2) do
					if(isElement(objekt)) then
						setTimer(destroyElement, 1004, 1, objekt)
						setElementCollisionsEnabled(objekt, false)
						setElementDimension(objekt, self.dim)
						setElementAlpha(objekt, 0)
					end
				end

			end

		end, 200, 1)
		
		-- FUNKTEN --
		setTimer(function()
			local x, y, z = self.x, self.y, self.z;
			local id = 2059
			z = z+0.1
			
			self.objects.funken = {
				createObject(id, x-2, y+4, z),
				createObject(id, x+2, y-4, z),
				createObject(id, x+4, y-2, z),
				createObject(id, x-4, y+2, z),
			}
			for index, objekt in pairs(self.objects.funken) do
				if(isElement(objekt)) then
					setTimer(destroyElement, 1003, 1, objekt)
					setElementCollisionsEnabled(objekt, false)
					setElementDimension(objekt, self.dim)
					setElementAlpha(objekt, 0)
				end
			end
		end, 50, 1)
		
		-- RAUCHBETT --
		local x, y, z = self.x, self.y, self.z;
		
		
		local id = 2075

		
		self.objects.rauchbett = {
			createObject(id, x, y-1, z),
			createObject(id, x, y-2, z),
			createObject(id, x, y+1, z),
			createObject(id, x, y+2, z),
		}

		for index, object in pairs(self.objects.rauchbett) do
			if(isElement(objekt)) then
				setTimer(destroyElement, 5000, 1, objekt)
				setElementCollisionsEnabled(objekt, false)
				setElementDimension(objekt, self.dim)
				setElementAlpha(objekt, 0)
			end
		end
	end
end

-- ///////////////////////////////
-- ///// CreateExplosion	//////
-- ///////////////////////////////

function Explosion:CreateExplosion()
	local x, y, z = self.x, self.y, self.z;
	self.explosion = createExplosion(x, y, z, 5, true, -5.0, false);
	createExplosion(x, y, z, 5, true, -5.0, false);
	createExplosion(x, y, z, 5, true, -5.0, false);
end

-- ///////////////////////////////
-- ///// CreateSound		//////
-- ///////////////////////////////

function Explosion:CreateSound()

end

-- ///////////////////////////////
-- ///// LODDistance		//////
-- ///////////////////////////////


function Explosion:LODDistance()
	engineSetModelLODDistance(2011, 10000)
	engineSetModelLODDistance(2059, 10000)
	engineSetModelLODDistance(2013, 10000)
	engineSetModelLODDistance(2054, 10000)
	engineSetModelLODDistance(2075, 10000)
end


-- ///////////////////////////////
-- ///// CreateTruemmer		//////
-- ///////////////////////////////

function Explosion:CreateTruemmer()
	local x, y, z = self.x, self.y, self.z;
	self.ped = createVehicle(594, x, y, z)
	setElementAlpha(self.ped, 0)
	setTimer(destroyElement, 5000, 1, self.ped)
	
	for i = 1, 8 do
		local x2 = x
		local y2 = y
			
		local randIds = {1252, 1265, 1218, 1230}
			
		local randRockIds = {3930, 3929, 3931};
		local id = randIds[4];
			
	--	if(math.random(0, 5) == 3) then
	--		id = randIds[math.random(1, #randIds)];
	--	end
			
		local objekt = createObject(id, x2, y2, z+1)
		setElementAlpha(objekt, 0)
		setObjectBreakable(objekt, false)
		local rock 	 = createObject(randRockIds[math.random(1, #randRockIds)], x, y, z);
		setElementCollisionsEnabled(rock, false)
		attachElements(rock, objekt);
		
		setElementRotation(objekt, math.random(0, 360), math.random(0, 360), math.random(0, 360))
		setTimer(destroyElement, 15000, 1, objekt)
		setTimer(destroyElement, 15000, 1, rock)
		
			
		--	setElementAlpha(objekt, 150)
		setObjectScale(objekt, 0.75)
			
			
		local newX, newY = getPointFromDistanceRotation(x2, y2, 2.5, 360 * (i/8))
				
		for i = 1, 5, 1 do
			setTimer(function()
				setElementVelocity(objekt, (newX-x2)/(math.random(8, 12)), (newY-y2)/math.random(8, 12), math.random(25, 50)/100)
						
				--	createExplosion(x2, y2, z, 5, false, 0, false)
			end, i*50, 1)
		end
		setElementVelocity(objekt, (newX-x2)/8, (newY-y2)/8, 10)
	end
end


-- ///////////////////////////////
-- ///// CreateFunken 		//////
-- ///////////////////////////////


function Explosion:CreateFunken()
	local x, y, z = self.x, self.y, self.z;

	fxAddSparks(x, y, z, 0, 0, 3, 3, 500, 0, 0, 3, false, 2, 5)
--	createFire(x, y, z);
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///////////////////////////////

function Explosion:Constructor(x, y, z, typ)
	self.x = x;
	self.y = y;
	self.z = z;
	
	self.dim = 0;
	
	self.objects = {};
	
	-- Methoden
	
	self:LODDistance();
		
	self:CreateTruemmer();
	
	--self:CreateSound();
	--self:CreateParticle();
	self:CreateExplosion();

	self:CreateFunken();
	
	
	--logger:OutputInfo("[CALLING] Explosion Constructor");
	
end

-- EVENT HANDLER --z


function getPointFromDistanceRotation(x, y, dist, angle)
 
    local a = math.rad(90 - angle);
 
    local dx = math.cos(a) * dist;
    local dy = math.sin(a) * dist;
 
    return x+dx, y+dy;
 
end