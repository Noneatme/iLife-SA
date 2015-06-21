--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

Jobs = {}

CJob = {}

function CJob:constructor(iID, sName, sKoords)
	self.ID = iID
	self.Name = sName
	self.Koords = sKoords
	
	Jobs[self.ID] = self
end

function CJob:destructor()

end

addEvent("onClientRequestJobs", true)
addEventHandler("onClientRequestJobs", getRootElement(), 
	function()
		triggerClientEvent(client, "onClientRecieveJobs", getRootElement(), Jobs)
	end
)