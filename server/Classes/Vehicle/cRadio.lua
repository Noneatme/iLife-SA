--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CRadio = {}

function CRadio:updateRadioChannels()
	channels = {}
	result = CDatabase:getInstance():query("SELECT * FROM Radio_Streams")
	if(#result > 0) then
		for res,value in pairs(result) do
			table.insert(channels, {["URL"]=value["URL"],["NAME"]=value["Name"]})
		end
	end
	triggerClientEvent(getRootElement(),"onRadioChannelsRecieve", getRootElement(), channels)
end
addCommandHandler("refreshRadio", CRadio.updateRadioChannels)

function CRadio:requestedRadioChannels()
	channels = {}
	result = CDatabase:getInstance():query("SELECT * FROM Radio_Streams")
	if(#result > 0) then
		for res,value in pairs(result) do
			table.insert(channels, {["URL"]=value["URL"],["NAME"]=value["Name"]})
		end
	end
	triggerClientEvent(client,"onRadioChannelsRecieve", client, channels)
end
addEvent("requestRadioChannels", true)
addEventHandler("requestRadioChannels", getRootElement(), CRadio.requestedRadioChannels)