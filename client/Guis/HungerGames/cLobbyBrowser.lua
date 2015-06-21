--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

Lobbies = {}

CLobbyBrowser = {}

function CLobbyBrowser:constructor()
	triggerServerEvent("onClientRequestLobbies", getRootElement(), getLocalPlayer())
	self.Gui ={
		["Window"] = false,
		["Image"] = {},
		["Button"] = {},
		["Label"] = {},
		["List"] = {}
	}
	
	self.Gui["Window"] = new(CDxWindow, "Lobbybrowser", 602, 427, true, true, "Center|Middle")
	
	self.Gui["Image"][1] = new(CDxImage, 0, 0, 600, 397, "/res/images/guibg.png",tocolor(255,255,255,255), self.Gui["Window"])
	
	self.Gui["List"][1] = new(CDxList, 10, 10, 580, 300, tocolor(125,125,125,200), self.Gui["Window"])
	
	self.Gui["Button"][1] = new(CDxButton, "Aktualisieren", 10, 340, 180, 35, tocolor(255,255,255,255), self.Gui["Window"])
	self.Gui["Button"][2] = new(CDxButton, "Beitreten", 210, 340, 180, 35, tocolor(255,255,255,255), self.Gui["Window"])
	self.Gui["Button"][3] = new(CDxButton, "Erstellen", 410, 340, 180, 35, tocolor(255,255,255,255), self.Gui["Window"])
	
	self.Gui["List"][1]:addColumn("ID")
	self.Gui["List"][1]:addColumn("Name")
	self.Gui["List"][1]:addColumn("Spieler")
	self.Gui["List"][1]:addColumn("Map")
	self.Gui["List"][1]:addColumn("Status")
	
	self:refresh()
	
	self.Gui["Button"][1]:addClickFunction(
		function ()
			triggerServerEvent("onClientRequestLobbies", getLocalPlayer())
		end
	)
	
	self.Gui["Button"][2]:addClickFunction(
		function ()
			triggerServerEvent("onPlayerJoinLobby", getLocalPlayer(), self.Gui["List"][1]:getRowData(1))
			self.Gui["Window"]:hide()
		end
	)
	
	self.Gui["Button"][3]:addClickFunction(
		function ()
			self.Gui["Window"]:hide()
			triggerEvent("onOpenCreateLobby", getRootElement())
		end
	)
	
	self.Gui["Window"]:add(self.Gui["Image"][1])
	self.Gui["Window"]:add(self.Gui["List"][1])
	self.Gui["Window"]:add(self.Gui["Button"][1])
	self.Gui["Window"]:add(self.Gui["Button"][2])
	self.Gui["Window"]:add(self.Gui["Button"][3])
	
	self.Gui["Window"]:show()
end

function CLobbyBrowser:getGui()
	return self.Gui
end

function CLobbyBrowser:destructor()

end

function CLobbyBrowser:refresh()
	self.Gui["List"][1]:clearRows()
	for k,v in pairs(Lobbies) do
		self.Gui["List"][1]:addRow(v["ID"].."|"..v["Name"].."|"..v["Size"].."|"..v["Mapname"].."|"..v["Status"])
	end
end

addEvent("onOpenLobbyBrowser", true)
addEventHandler("onOpenLobbyBrowser", getRootElement(), 
function()
	if (LobbyBrowser) then 
		triggerServerEvent("onClientRequestLobbies", getLocalPlayer())
		LobbyBrowser:getGui()["Window"]:show()
	else 
		LobbyBrowser=new(CLobbyBrowser) 
	end
end
)

LobbyBrowser = false

function updateLobbys(recievedLobbies)
	Lobbies = recievedLobbies
	if (LobbyBrowser) then
		LobbyBrowser:refresh()
	end
end
addEvent("onServerSendLobbies", true)
addEventHandler("onServerSendLobbies", getRootElement(), updateLobbys)