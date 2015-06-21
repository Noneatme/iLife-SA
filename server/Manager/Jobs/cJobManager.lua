--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CJobManager = {}

function CJobManager:constructor()
	result = CDatabase:getInstance():query("SELECT * FROM Jobs")
	if(#result > 0) then
		for key, value in pairs(result) do
			new(CJob, value["ID"], value["Name"], value["Koords"])
		end
		--outputServerLog("Es wurden "..tostring(#result).." Jobs gefunden!")
	else
		outputServerLog("Es wurden keine Jobs gefunden!")
	end
end

function CJobManager:destructor()

end
