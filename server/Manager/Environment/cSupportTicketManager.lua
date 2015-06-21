--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CSupportTicketManager = inherit(cSingleton)

function CSupportTicketManager:constructor()
	local start = getTickCount()
	--CDatabase:getInstance():query("DELETE * FROM Support_Tickets WHERE State=1 AND Timestamp")
	local result = CDatabase:getInstance():query("SELECT * FROM support_tickets")
	for k,v in ipairs(result) do
		new(CSupportTicket, v["ID"], v["Creator"], v["Subject"], v["Text"], v["Admin"], fromJSON(v["Answers"]), v["State"], v["Timestamp"])
	end
	outputDebugString("Es wurden "..#result.." Support Tickets gefunden! (" .. getTickCount() - start .. "ms)")
end

function CSupportTicketManager:destructor()

end