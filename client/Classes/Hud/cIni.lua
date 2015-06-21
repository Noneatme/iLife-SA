--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

--[[

#############################
##   (c) Soner		       ##
##   EasyIni			   ##
#############################

]]--


EasyIni = {}
EasyIni.__index = EasyIni

function EasyIni:LoadFile(filename, ignoreExists)
	--	traceback()
	local self = setmetatable({},EasyIni)
	if not(ignoreExists) then
		if not fileExists(filename) then
			file = fileCreate(filename)
			fileClose(file)
		end
	end
	local file = fileOpen(filename)
	if not(file) then
		return false;
	end
	local size = fileGetSize(file)
	if(size < 1) then
		size = 10;
	end
	local read = fileRead(file, size);
	fileClose(file)
	local data = {}
	local filedata = split(read,"\n")
	local lastzone = ""
	for _,row in ipairs(filedata) do
		if string.find(row, "[", 1, true) and string.find(row, "]", 1, true) then
			local b,e = string.find(row,"]",1,true)
			lastzone = string.sub(row,2,e-1)
			if not data[lastzone] then
				data[lastzone]={}
			end
		elseif string.find(string.sub(row,1,1),";",1,true) then --Ignorieren von INI Kommentierungen
		else
			local tempsplit = split(row,"=")
			data[lastzone][tempsplit[1]] = tempsplit[2]
		end
	end
	self.data = data
	self.filename = filename
	return self
end

function EasyIni:NewFile(filename)
	local self = setmetatable({},EasyIni)
	self.data = {}
	self.filename = filename
	return self
end


function EasyIni:Get(selection,name)
	if self.data[selection] then
		if self.data[selection][name] then
			return self.data[selection][name]
		else
			return false
		end
	else
		return false
	end
end

function EasyIni:GetNamesFromSelection(selection)
	if self.data[selection] then
		return self.data[selection];
	else
		return false
	end
end


function EasyIni:Set(selection,name,value)
	if not self.data[selection] then
		self.data[selection] = {}
	end
	self.data[selection][name] = value
	return true
end


function EasyIni:Save()
	local string = ""
	for selection,selectiontable in pairs(self.data) do
		string = string.."["..selection.."]\n"
		local iTable	= {}
		local iIndex	= 1;
		for k,v in pairs(selectiontable) do
			if(k and v) then
				iTable[iIndex] = {k, v};
				iIndex = iIndex+1
			end
		end

		table.sort(iTable, function(a, b) return tostring(b[1]) < tostring(a[1]) end)

		for index, val in ipairs(iTable) do
			string = string..val[1].."="..tostring(val[2]).."\n"
		end
	end
	if(fileExists(self.filename)) then
		fileDelete(self.filename)
	end
	local file = fileCreate(self.filename)
	fileWrite(file,string)
	fileFlush(file)			-- KLOSPUELUNG!!
	fileClose(file)
	return true
end

function traceback ()
	local level = 1
	while true do
		local info = debug.getinfo(level, "Sl")
		if not info then break end
		if info.what == "C" then   -- is a C function?
			outputDebugString(level, "C function")
		else   -- a Lua function
			outputDebugString(string.format("[%s]:%d",
			info.short_src, info.currentline))
		end
		level = level + 1
	end
end
