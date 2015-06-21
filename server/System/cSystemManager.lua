--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CSystemManager = inherit(cSingleton)
CSystemManager.tCommands = {}

function CSystemManager:constructor(iServerID)
	local time = getRealTime()
	setMinuteDuration(60000)
	setTime(time.hour, time.minute)

	self.iServerID = iServerID or 0

	self:loadSystemVariables()
	self:refreshServerSettings("PW4iLife")
	self.uTimer = setTimer(bind(self.timer_checkServerRestart, self), 60000, 0)

	-- Set Correct Serverpassword after time x
	self.uPasswordTimer = setTimer(
		function()
		--	self:refreshServerSettings()
		end
	, 60000,1)

	CSystemManager.tCommands["sysupdate"] = bind(self.cmd_sysupdate, self)
	addCommandHandler("sysupdate", CSystemManager.tCommands["sysupdate"], false, false)
	CSystemManager.tCommands["sysmanual"] = bind(self.cmd_sysmanual, self)
	addCommandHandler("sysmanual", CSystemManager.tCommands["sysmanual"])
	
	--[[
	addEventHandler("onPlayerJoin", getRootElement(), function()
		local players	= #getElementsByType("player")
		if(players > self.iPlayerRecord) then
			self.iPlayerRecord = players;
			outputChatBox("Neuer Spielerrekord: "..self.iPlayerRecord.." Spieler", 0, 0, 255);
			CDatabase:getInstance():query("UPDATE System SET PlayerRecord = '"..self.iPlayerRecord.."' WHERE iID = '" .. self.iServerID .. "'")
		end
	end)]]
end

function CSystemManager:destructor()
	if (self.uTimer and isTimer(self.uTimer)) then killTimer(self.uTimer) end
	if (self.uPasswordTimer and isTimer(self.uPasswordTimer)) then killTimer(self.uPasswordTimer) end
	removeCommandHandler("sysupdate", CSystemManager.tCommands["sysupdate"])
	removeCommandHandler("sysmanual", CSystemManager.tCommands["sysmanual"])
end

function CSystemManager:loadSystemVariables ()
	local result = CDatabase:getInstance():query("SELECT * FROM System WHERE iID = '" .. self.iServerID .. "'")
	if(result) then
		self.Servername 			= result[1]["Servername"]
		self.Serverpasswort 		= result[1]["Passwort"]
		self.Version 				= result[1]["Version"]
		self.Mapname 				= result[1]["Mapname"]
		self.Slogan 				= result[1]["Slogan"]
		self.MaxPlayers 			= result[1]["MaxPlayers"]
		self.MinAge 				= result[1]["MinAge"]
		self.URL 					= result[1]["URL"]
		self.Mail 					= result[1]["Mail"]
		self.IP 					= result[1]["IP"]
		self.DebugLevel 			= result[1]["DebugLevel"]
		self.iPlayerRecord 			= tonumber(result[1]["PlayerRecord"]) or 40

		outputDebugString("CSystemManager:loadSystemVariables(): Loaded Serverinformation from ID " .. result[1]["iID"])
	else
		outputDebugString("CSystemManager:loadSystemVariables(): Can't get result (MySQL Error)")
	end
end

function CSystemManager:refreshServerSettings (strPasswordOverride)
	setMaxPlayers( self.MaxPlayers )
	setRuleValue( "DebugLevel", self.DebugLevel)
--	setServerPassword(strPasswordOverride or self.Serverpasswort)
end

function CSystemManager:update()
	self:loadSystemVariables()
	self:refreshServerSettings()
end

function CSystemManager:gmx()
--	setServerPassword(md5("serverrestart"))
	restartTheGamemode()
end

-- // Timer \\ --
function CSystemManager:timer_checkServerRestart ()
	local time = getRealTime()
	if(time.hour == 4 and time.minute == 55) then
		outputChatBox("Achtung: Der Server wird in 5 Minuten neu gestartet!", getRootElement(), 255,0,0)
	end

	if(time.hour == 5 and time.minute == 0) then
		self:gmx()
	end
end

-- // Commands \\ --
function CSystemManager:cmd_sysupdate (uPlayer)
	if (uPlayer:getAdminLevel() >= 2) then
		outputChatBox("Systemupdate: starting now ...", uPlayer)
		self:update()
	end
end

function CSystemManager:cmd_sysmanual (uPlayer)
	if (uPlayer:getAdminLevel() >= 2) then
		if (self.uPasswordTimer and isTimer(self.uPasswordTimer)) then
			killTimer(self.uPasswordTimer)
			outputChatBox("Systemmanual: Killed password timer", uPlayer)
		else
			outputChatBox("Systemmanual: Start sequence is no longer running", uPlayer)
		end
	end
end

function restartTheGamemode()
	for index, player in pairs(getElementsByType("player")) do
		if(getElementData(player,"online")) then
			if(player.save) then
				player:save()
			end
		end
	end
	for id, veh in pairs(UserVehicles) do
		veh:save()
	end

	for id, corp in pairs(Corporations) do
		corp:save()
	end

	for id, biz in pairs(BusinessBizes) do
		biz:save()
	end

	outputChatBox("[!!] Gamemoderestart! Bitte Warten! Autos und Objekte werden nach der Zeit geladen!", root, 255, 0, 0);
	restartResource(getThisResource());
end



local EDexpr = {
	["ExtendedRadio"] = true,
	["Type"] 		= true,
	["Engine"] 		= true,
	["DirtLevel"] 	= true,
	["blip"] 		= true,
	["nodmzone"] 	= true,
	["cj:crate"] 	= true,
	["p:InJob"] 	= true,
	["p:InJob"] 	= true,
	["radio:URL"] 	= true,
	["radio:NAME"] 	= true,
	["p:AFK"]			= true,
}

addEventHandler("onElementDataChange", getRootElement(),
	function(dataName, oldValue)
		if (client) and not (EDexpr[dataName]) then
			setElementData(source, dataName, oldValue)
			cheatBan(source, 2)
		end
	end
)

Eventmultiplicator = 100

function getEventMultiplicator()
	return tonumber(Eventmultiplicator)/100
end

addCommandHandler("event",
	function(thePlayer, cmd, mlt)
		if (thePlayer:getAdminLevel() >= 3) then
			if (tonumber(mlt) < 100) or (tonumber(mlt) > 200) then
				mlt = 100
			end
			Eventmultiplicator = tonumber(mlt)
			outputChatBox("Der Eventmultiplikator wurde auf "..tostring(Eventmultiplicator).."% gesetzt.", getRootElement(), 255,0,0)
		end
	end
)

addEventHandler("onPlayerVehicleEnter", getRootElement(), function(uVehicle)
	local uPlayer = source;

	giveWeapon(uPlayer, 0, 0, true) -- Anti Punch Bug Workaround

end)
