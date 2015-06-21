--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

Maps = {}

addEvent("onServerSendMaps", true)
addEventHandler("onServerSendMaps", getRootElement(),
	function(input)
		Maps = input
	end
)

CCreateLobby = {}

function CCreateLobby:constructor()
	self.Gui ={
		["Window"] = false,
		["Image"] = {},
		["Edit"] = {},
		["Button"] = {},
		["Label"] = {},
		["List"] = {}
	}
	
	self.Gui["Window"] = new(CDxWindow, "Erstelle eine Lobby", 602, 427, true, true, "Center|Middle")
	
	self.Gui["Image"][1] = new(CDxImage, 0, 0, 600, 397, "/res/images/guibg.png",tocolor(255,255,255,255), self.Gui["Window"])
	
	self.Gui["Label"][1] = new(CDxLabel, "Maps:", 10, 5, 155, 35, tocolor(255,255,255,255), 1, "default", "left", "top", self.Gui["Window"])
	
	self.Gui["List"][1] = new(CDxList, 10, 30, 300, 350, tocolor(125,125,125,200), self.Gui["Window"])
	
	self.Gui["Label"][2] = new(CDxLabel, "Name:", 330, 5, 200, 35, tocolor(255,255,255,255), 1, "default", "left", "center", self.Gui["Window"])
	self.Gui["Edit"][1] = new(CDxEdit, "", 330, 45, 220, 50, "default", tocolor(0,0,0,255), self.Gui["Window"])
	
	self.Gui["Label"][3] = new(CDxLabel, "Max. Players (>2):", 330, 110, 200, 35, tocolor(255,255,255,255), 1, "default", "left", "center", self.Gui["Window"])
	self.Gui["Edit"][2] = new(CDxEdit, "0", 330, 160, 220, 50, "Number", tocolor(0,0,0,255), self.Gui["Window"])
	
	self.Gui["Label"][4] = new(CDxLabel, "Achtung:\nWenn eine zu große Anzahl gewählt wird, wird die Anzahl auf die Anzahl der verfügbaren Spawnpoints reduziert!", 330, 220, 220, 90, tocolor(255,255,255,255), 1, "default", "left", "center", self.Gui["Window"])
	
	self.Gui["Button"][1] = new(CDxButton, "Create", 380, 320, 160, 35, tocolor(255,255,255,255), self.Gui["Window"])
	self.Gui["Button"][2] = new(CDxButton, "Cancel", 380, 360, 160, 35, tocolor(255,255,255,255), self.Gui["Window"])
	
	self.Gui["List"][1]:addColumn("Name")
	
	self.Gui["List"][1]:clearRows()
	for k,v in pairs(Maps) do
		self.Gui["List"][1]:addRow(v)
	end
	
	self.Gui["Button"][1]:addClickFunction(
		function ()
			if (self.Gui["Edit"][1]:getText() ~= "") then
				if ( not (string.len(self.Gui["Edit"][1]:getText()) >= 15) ) then
					if (tonumber(self.Gui["Edit"][2]:getText()) > 2) then
						if (self.Gui["List"][1]:getRowData(1) ~= "none") then
							self.Gui["Window"]:hide()
							triggerServerEvent("onPlayerStartLobby", getLocalPlayer(), self.Gui["Edit"][1]:getText(), tonumber(self.Gui["Edit"][2]:getText()), self.Gui["List"][1]:getRowData(1))
						else
							showInfoBox("error", "Wähle eine Map aus!")
						end
					else
						showInfoBox("error", "Die Lobby wäre zu klein!")
					end
				else
					showInfoBox("error", "Der Name ist zu lang!")
				end
			else
				showInfoBox("error", "Wählen einen Namen!")
			end
		end
	)
	
	self.Gui["Button"][2]:addClickFunction(
		function ()
			self.Gui["Window"]:hide()
			triggerEvent("onOpenLobbyBrowser", getRootElement())
		end
	)
	
	self.Gui["Window"]:add(self.Gui["Image"][1])
	self.Gui["Window"]:add(self.Gui["Label"][1])
	self.Gui["Window"]:add(self.Gui["Label"][2])
	self.Gui["Window"]:add(self.Gui["Label"][3])
	self.Gui["Window"]:add(self.Gui["Label"][4])
	self.Gui["Window"]:add(self.Gui["Edit"][1])
	self.Gui["Window"]:add(self.Gui["Edit"][2])
	self.Gui["Window"]:add(self.Gui["List"][1])
	self.Gui["Window"]:add(self.Gui["Button"][1])
	self.Gui["Window"]:add(self.Gui["Button"][2])
	
	self.Gui["Window"]:show()
end

function CCreateLobby:getGui()
	return self.Gui
end

function CCreateLobby:destructor()

end

addEvent("onOpenCreateLobby", false)
addEventHandler("onOpenCreateLobby", getRootElement(), 
function()
	if (CreateLobby) then 
		CreateLobby:getGui()["Window"]:show()
	else 
		CreateLobby=new(CCreateLobby) 
	end
end
)

CreateLobby = false