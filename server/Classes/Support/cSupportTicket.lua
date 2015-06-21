--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

SupportTickets = {}
SupportTicketsByCreator = {}
OpenSupportTickets = {}

CSupportTicket = {}

function CSupportTicket:constructor(ID, Creator, Subject, Text, Admin, Answer, State, Timestamp)
	self.ID = ID
	self.Creator = Creator
	self.PlayerName = PlayerNames[self.Creator]
	self.Subject = Subject
	self.Text = Text
	self.Admin = Admin
	self.Answer = Answer
	self.State = State
	self.Timestamp = Timestamp
	
	SupportTickets[self.ID] = self
	
	if (type(SupportTicketsByCreator[self.Creator]) ~= "table") then
		SupportTicketsByCreator[self.Creator] = {}
	end
	if (self.State == 0) then
		OpenSupportTickets[self.ID] = self
	end
	table.insert(SupportTicketsByCreator[self.Creator], self)
end

function CSupportTicket:destructor()

end

function CSupportTicket:getID()
	return self.ID
end

function CSupportTicket:getCreator()
	return self.Creator
end

function CSupportTicket:getAdmin()
	return self.Admin
end

function CSupportTicket:getState()
	return self.State
end

function CSupportTicket:changeState(State)
	self.State = State
	if (self.State ~= 0) then
		OpenSupportTickets[self.ID] = nil
	end
	self:save()
end

function CSupportTicket:changeAdmin(Name)
	self.Admin = Name
	self:save()
end

function CSupportTicket:addAnswer(thePlayer, Answer)
	self.Answer[tostring(table.size(self.Answer)+1)] = {["Name"]=getPlayerName(thePlayer), ["Text"]=Answer, ["Timestamp"] = getRealTime()["Timestamp"]}
	if (self.State ~= 0) then
		self.State = 0
	end
	self:save()
end

function CSupportTicket:save()
	if (self.State ~= 0) then
		OpenSupportTickets[self.ID] = nil
	end
	sendReportsToAdmins()
	CDatabase:getInstance():query("UPDATE Support_Tickets SET Admin = ?, Answers = ?, State = ? WHERE ID = ?", self.Admin, toJSON(self.Answer), self.State, self.ID)
end

addEvent("onPlayerCreateTicket", true)
addEventHandler("onPlayerCreateTicket", getRootElement(),
	function(Subject, Text)
		if (getPlayerName(client) == "Malibu") then
			client:showInfoBox("info", "Computer sagt NEEEEIIIINNN!")
			return false
		end
		CDatabase:getInstance():query("INSERT INTO  Support_Tickets(`ID` ,`Creator` ,`Subject` ,`Text` ,`Admin` ,`Answers` ,`State` ,`Timestamp`)VALUES (NULL ,  ?,  ?,  ?,  'Niemand',  '[ [ ] ]',  '0', CURRENT_TIMESTAMP);", client:getID(), Subject, Text)
		local val = CDatabase:getInstance():query("SELECT * FROM Support_Tickets WHERE ID=(SELECT MAX(ID) FROM Support_Tickets)")
		local value=val[1]
		local Ticket = new(CSupportTicket, value["ID"], value["Creator"], value["Subject"], value["Text"], value["Admin"], fromJSON(value["Answers"]), value["State"], value["Timestamp"])
		client:showInfoBox("info", "Dein Ticket wurde erfolgreich eingereicht!")
		client:refreshTickets()
		for k,v in ipairs(getElementsByType("player")) do
			if (getElementData(v, "online")) then
				if ( (v:getAdminLevel()) and (v:getAdminLevel()> 0)) then
					outputChatBox("Neues Support Ticket (#"..tostring(Ticket:getID())..") von "..getPlayerName(client), v, 255,0,0)
				end
			end
		end
		sendReportsToAdmins()
	end
)

addEvent("onPlayerAnswerTicket", true)
addEventHandler("onPlayerAnswerTicket", getRootElement(),
	function(ID, Text)
		if (getPlayerName(client) == "Malibu") then
			client:showInfoBox("info", "Computer sagt NEEEEIIIINNN!")
			return false
		end
		if SupportTickets[tonumber(ID)] then
			if ( (client:getAdminLevel() > 0) or ((client:getID() == SupportTickets[tonumber(ID)]:getCreator()))) then
				if (SupportTickets[tonumber(ID)]:getState() == 0) then
					if ((client:getID() == SupportTickets[tonumber(ID)]:getCreator()) or (getPlayerName(client) == SupportTickets[tonumber(ID)]:getAdmin()) or (SupportTickets[tonumber(ID)]:getAdmin() == "Niemand")) then
						SupportTickets[tonumber(ID)]:addAnswer(client, Text)
						if (client:getID() == SupportTickets[tonumber(ID)]:getCreator()) then
							for k,v in ipairs(getElementsByType("player")) do
								if (getElementData(v, "online")) then
									if ( (v:getAdminLevel()) and (v:getAdminLevel()> 0)) then
										outputChatBox("Neue Antwort auf ein Support Ticket (#"..tostring(ID)..")", v, 255,255,255)
									end
								end
							end
							client:refreshTickets()
						else
							SupportTickets[tonumber(ID)]:changeAdmin(client:getName())
						end
						if (getPlayerName(client) == SupportTickets[tonumber(ID)]:getAdmin()) then
							if (isElement(Players[SupportTickets[tonumber(ID)]:getCreator()])) then
								Players[SupportTickets[tonumber(ID)]:getCreator()]:showInfoBox("info", "Du hast eine neue Antwort auf ein Ticket erhalten!")
								outputChatBox("Neue Antwort auf Ticket #"..ID..": "..Text, Players[SupportTickets[tonumber(ID)]:getCreator()], 255,255,255)
								Players[SupportTickets[tonumber(ID)]:getCreator()]:refreshTickets()
							end
							client:showInfoBox("info", "Du hast eine Antwort geschrieben!")
						end	
						sendReportsToAdmins()
					else
						client:showInfoBox("info", "Du bist nicht an diesem Ticket beteiligt!")
					end
				else
					client:showInfoBox("error", "Dieses Ticket ist geschlossen!")
				end
			else
				client:showInfoBox("error", "Dazu besitzt du keine Rechte!")
			end
		else
			client:showInfoBox("error", "Dieses Ticket existiert nicht!")
		end
	end
)

addEvent("onPlayerCloseTicket", true)
addEventHandler("onPlayerCloseTicket", getRootElement(),
	function(ID, State)
		if SupportTickets[tonumber(ID)] then
			if (client:getAdminLevel() > 0) then
				if ((client:getID() == SupportTickets[tonumber(ID)]:getCreator()) or (getPlayerName(client) == SupportTickets[tonumber(ID)]:getAdmin()) or (SupportTickets[tonumber(ID)]:getAdmin() ~= "Niemand")) then
					SupportTickets[tonumber(ID)]:changeAdmin(client:getName())
					SupportTickets[tonumber(ID)]:changeState(tonumber(State))
					if (isElement(Players[SupportTickets[tonumber(ID)]:getCreator()])) then
						Players[SupportTickets[tonumber(ID)]:getCreator()]:showInfoBox("info", "Der Status eines Tickets wurde geändert!")
						Players[SupportTickets[tonumber(ID)]:getCreator()]:refreshTickets()
					end
					sendReportsToAdmins()
				else
					client:showInfoBox("info", "Du bist nicht an diesem Ticket beteiligt!")
				end
			else
				client:showInfoBox("error", "Dazu besitzt du keine Rechte!")
			end
		else
			client:showInfoBox("error", "Dieses Ticket existiert nicht!")
		end
	end
)

addEvent("onPlayerReferTicket", true)
addEventHandler("onPlayerReferTicket", getRootElement(),
	function(ID, Admin)
		if SupportTickets[tonumber(ID)] then
			if (client:getAdminLevel() > 0) then
				SupportTickets[tonumber(ID)]:changeAdmin(Admin)
				if (isElement(Players[SupportTickets[tonumber(ID)]:getCreator()])) then
					Players[SupportTickets[tonumber(ID)]:getCreator()]:showInfoBox("info", "Der Supporter eines Tickets wurde geändert!")
					Players[SupportTickets[tonumber(ID)]:getCreator()]:refreshTickets()
				end
				sendReportsToAdmins()
			else
				client:showInfoBox("error", "Dazu besitzt du keine Rechte!")
			end
		else
			client:showInfoBox("error", "Dieses Ticket existiert nicht!")
		end
	end
)

function sendReportsToAdmins()
	for k,v in ipairs(getElementsByType("player")) do
		triggerClientEvent(v, "onClientRecieveClientTickets", getRootElement(), OpenSupportTickets)
	end
end