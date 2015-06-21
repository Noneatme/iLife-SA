--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

cPrivateKeyGenerator = {}
cPrivateKeyGenerator.timeLimit = 900000
cPrivateKeyGenerator.length = 32
cPrivateKeyGenerator.validChars = {}

for i=48, 57, 1 do
	table.insert(cPrivateKeyGenerator.validChars, string.char(i))
end

for i=65, 90, 1 do
	table.insert(cPrivateKeyGenerator.validChars, string.char(i))
end
for i=97, 122, 1 do
	table.insert(cPrivateKeyGenerator.validChars, string.char(i))
end


function cPrivateKeyGenerator:constructor ()
	math.randomseed()
	self.key = ""
	self.tick = 0
end

function cPrivateKeyGenerator:getKey()
	self.key = ""
	for i=1, cPrivateKeyGenerator.length, 1 do
		self.key = self.key .. cPrivateKeyGenerator.validChars[math.random(1, #cPrivateKeyGenerator.validChars)]
	end
	self.tick = getTickCount()
	
	return self.key
end

function cPrivateKeyGenerator:isOverTimeLimit()
	return self.tick + cPrivateKeyGenerator.timeLimit < getTickCount()
end

function cPrivateKeyGenerator:getRemainingTimeLimit ()
	local time = {}
	time.minutes = 0
	time.seconds = 0
	if (self.tick + cPrivateKeyGenerator.timeLimit > getTickCount()) then
		local remaining = self.tick + cPrivateKeyGenerator.timeLimit - getTickCount()
		time.minutes = math.floor(remaining / 60000)
		time.seconds = remaining - (time.minutes * 60000)
	end	
	return time
end