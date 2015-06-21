--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

cSingleton = {}
cSingleton.__singletonObjects = {}

function cSingleton:derived_constructor()
	self:init()
end

function cSingleton:init() end

function cSingleton:getInstance(...)
	if not(self.__singletonObjects[self]) then
		outputConsole("Singleton not availabe, creating "..tostring(self))
		return self:new(...)
	end
	return self.__singletonObjects[self]
end

function cSingleton:isInitialized()
	return self.__singletonObjects[self] ~= nil
end

function cSingleton:new(...)
	if (self.__singletonObjects[self]) then
		self.__singletonObjects[self] = delete(self)
		self.__singletonObjects[self] = nil
	end
	local obj = {...}
	self.__singletonObjects[self] = new(self, ...)
	return self.__singletonObjects[self]
end
