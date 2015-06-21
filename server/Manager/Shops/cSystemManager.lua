--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CSystemManager = {}

-- atest

function CSystemManager:constructor()
	result = CDatabase:getInstance():query("SELECT * FROM system")
	
	self.Servername = result[1]["Servername"]
	self.Serverpasswort =result[1]["Passwort"]
	self.Version = result[1]["Version"]
	self.Mapname = result[1]["Mapname"]
	self.Slogan = result[1]["Slogan"]
	self.MaxPlayers = result[1]["MaxPlayers"]
	self.MinAge = result[1]["MinAge"]
	self.URL = result[1]["URL"]
	self.Mail = result[1]["Mail"]
	self.IP = result[1]["IP"]
	self.DebugLevel = result[1]["DebugLevel"]
	
	if(getServerName() ~= self.Servername.." v"..self.Version.." - "..self.Slogan) then
		outputServerLog("---------------------------------------")
		outputServerLog("Bitte Servernamen anpassen!")
		outputServerLog("Alter Name: "..getServerName())
		outputServerLog("Neuer Name: "..self.Servername.." v"..self.Version.." - "..self.Slogan)
		outputServerLog("---------------------------------------")
		stopResource(getThisResource())
	else
		outputServerLog("------------------------------------------------")
		outputServerLog("Server name is '"..self.Servername.." v"..self.Version.." - "..self.Slogan.."'")
		setServerConfigSetting("password",self.Serverpasswort, true)
		outputServerLog("Serverinformationen wurden geladen!")
		outputServerLog("------------------------------------------------")
		
		self.tUpdate = bind(self.update, self)
		self.Timer = setTimer(self.tUpdate, 60000, 0)
	end
	
end

function CSystemManager:destructor()

end

function CSystemManager:update() 
	result = CDatabase:getInstance():query("SELECT * FROM system")
	
	self.Servername = result[1]["Servername"]
	self.Serverpasswort =result[1]["Passwort"]
	self.Version = result[1]["Version"]
	self.Mapname = result[1]["Mapname"]
	self.Slogan = result[1]["Slogan"]
	self.MaxPlayers = result[1]["MaxPlayers"]
	self.MinAge = result[1]["MinAge"]
	self.URL = result[1]["URL"]
	self.Mail = result[1]["Mail"]
	self.IP = result[1]["IP"]
	self.DebugLevel = result[1]["DebugLevel"]

	setMaxPlayers( self.MaxPlayers )
	
	setRuleValue( "DebugLevel", self.DebugLevel )
	setMapName( self.Mapname )
	setGameType ( self.Servername )
	
	if (getServerPassword() ~= self.Serverpasswort) then
		outputServerLog("------------------------------------------------")
		setServerConfigSetting("password",self.Serverpasswort, true)
		outputServerLog("Serverinformationen wurden nachgeladen!")
		outputServerLog("------------------------------------------------")
	end
	
	local time = getRealTime()
	setMinuteDuration(60000)
	setTime(time.hour, time.minute)
	
	if(time.hour == 4 and time.minute == 55) then
		outputChatBox("Achtung: Der Server wird in 5 Minuten neu gestartet!", getRootElement(), 255,0,0)
	end
	
	if(time.hour == 5 and time.minute == 0) then
		self:gmx()
	end
end

function CSystemManager:gmx()
	setServerPassword(md5("serverrestart"))
	for k,v in ipairs(getElementsByType("player")) do
		kickPlayer(v, "Serverneustart")
	end
	restartResource(getThisResource())
end

SystemManager = new(CSystemManager)