--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

cWebRadioManager = inherit(cSingleton)
cWebRadioManager.tInstances = {}

function cWebRadioManager:constructor()
	local start = getTickCount()
	
	local result = CDatabase:getInstance():query("SELECT * FROM webradios;")
	for k,v in ipairs(result) do
		table.insert(self.tInstances, new(cWebRadio, v["iID"], v["strName"], v["strURL"]))
	end
	outputServerLog("Es wurden "..tostring(#result).." Webradios gefunden!(Ende: " .. getTickCount() - start .. "ms)")
end

function cWebRadioManager:destructor()

end