--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

Players = {}

PlayerNames = {}
PlayerIDS	= {}
Phonenumbers = {}

global_vehicle_preise = {};

local randNMR           = math.random(1, 10000);	-- Best Key Security 2015
local tblLoginSounds    =
{
	teaEncode("http://rewrite.ga/iLife/login.mp3", randNMR),								                -- Default
	teaEncode("http://noneat.me/sound/hero.mp3", randNMR),						                        -- Hero
	--teaEncode("http://rewrite.ga/iLife/intro.mp3", randNMR),					                            -- Epic von Johnny
	--teaEncode("http://www.vio-race.de/servermusic/mapmusic/realsteel-ft-banana_dark-time.mp3", randNMR),  -- Register Music
	teaEncode("http://noneat.me/sound/safehouse_part2.mp3", randNMR),										-- Safehouse, Copyright EA Games
	teaEncode("http://noneat.me/sound/pr0nGroove.mp3", randNMR),											-- Soundcloud, "pr0n Groove", Copyleft
	--teaEncode("http://noneatme.de/sound/mus_amasian1.mp3", randNMR),										-- Amnasian, Copyright Rockstar Games
	teaEncode("http://noneat.me/sound/tsfw.ogg", randNMR),												-- Sound von Samy, eventuell Copyright
	teaEncode("http://noneat.me/sound/iLife/3d_ambience_loginscreen.ogg", randNMR),						-- Perpeetum, Hammer	(Copyright)
	teaEncode("http://noneat.me/sound/JUNLAJUBALAM%20-%20Adobe%20CS5activator.ogg", randNMR),				-- Adobe CS5 Activator Keygen (Copyleft!)

}

--Provisorisch
mainTeam = createTeam("Server")

CPlayer = inherit(CElement)

--Allgemeine Events
addEvent("onPlayerRegister",true)
addEvent("onPlayerLoginS",true)
--Util
addEvent("onPlayerExecuteServerCommand", true)
--Adminsystem
addEvent("onAdminFreezePlayer",true)
addEvent("onAdminGetHerePlayer",true)
addEvent("onAdminGoToPlayer",true)
addEvent("onAdminSpectatePlayer",true)
addEvent("onAdminKillPlayer",true)
addEvent("onAdminKickPlayer",true)
addEvent("onAdminWarnPlayer",true)
addEvent("onAdminBanPlayer",true)
addEvent("onAdminShutdown",true)
addEvent("onAdminGMX",true)
--PD Funktionen
addEvent("onCopLocatePlayer", true)
addEvent("onCopDeleteWanted", true)
addEvent("onCopGiveWanted", true)
addEvent("onCopGiveSTVO", true)
addEvent("onCopExaminePlayer", true)
addEvent("onCopTakeIllegalThings", true)
--Banksystem
addEvent("onPlayerBankDeposit", true)
addEvent("onPlayerBankWithdraw", true)
addEvent("onPlayerBankTransfer", true)
addEvent("onPlayerPayInFactionBank", true)
addEvent("onPlayerPayOutFactionBank", true)
--Haussystem
addEvent("onPlayerHouseEnter", true)
addEvent("onPlayerHouseToggleLocked", true)
addEvent("onPlayerHouseBuySell", true)
addEvent("onPlayerHouseGiveKey", true)
addEvent("onPlayerHouseRevokeKey", true)
--Fraktionsgui
addEvent("onPlayerTakeFactionSkin", true)
addEvent("onPlayerLeaveFaction", true)
addEvent("onPlayerOpenLeaderGui", true)
--Vehiclesystem
addEvent("onPlayerVehicleBuy", true)
addEvent("onPlayerVehicleKeyGive", true)
addEvent("onPlayerVehicleKeyRemove", true)
addEvent("onPlayerVehicleAttach", true)
--AmmuNation
addEvent("onPlayerBuyWeapon", true)
addEvent("onPlayerBuyAmmo", true)
--Sexshop
addEvent("onPlayerBuySexWeapon", true)
--Inventar/Items
addEvent("onPlayerUseItem", true)
addEvent("onPlayerDeleteItem", true)
--Selfmenu
addEvent("onPlayerChooseStatus", true)
addEvent("onPlayerChangeSpawn", true)
addEvent("onPlayerChangeName", true)
addEvent("onPlayerChangePassword", true);

--Private Key System
addEvent("onPlayerRequestNewKey", true)
addEvent("onPlayerRequestKey", true)
-- Inventrar
addEvent("onPlayerRefreshInventory", true);
addEvent("onPlayerKickHighPing", true);
addEvent("onPlayerDrugPlace", true);

addEvent("onPlayerPasswortVergessen", true)

function CPlayer:constructor()
	self.LoggedIn = false

	self.eOnPlayerLoginS = bind(CPlayer.login,self)
	addEventHandler("onPlayerLoginS",self, self.eOnPlayerLoginS)
	self.eOnPlayerRegister = bind(CPlayer.register,self)
	addEventHandler("onPlayerRegister", self, self.eOnPlayerRegister)
	self.eOnNickChange = bind(CPlayer.onNickChange, self)
	addEventHandler( "onPlayerChangeNick", self, self.eOnNickChange)
end

function CPlayer:destructor()
	if(isTimer(self.mTimer)) then
		killTimer(self.mTimer)
	end
	if(isElement(Players[self.ID])) then
		Players[self.ID] = nil
	end
	self.LoggedIn = false
end

function CPlayer:loadData()
	result = CDatabase:getInstance():query("SELECT * FROM user WHERE Name=?",self:getName())
	if(result) and (#result > 0) then
		local row = result[1]
		if (not isElement(Players[row["ID"]])) then
			self.eOnWasted = bind(CPlayer.onWasted, self)
			addEventHandler("onPlayerWasted", self, self.eOnWasted)

			--Util
			self.eOnPlayerChat = bind(CPlayer.onChat,self)
			addEventHandler("onPlayerChat", self, self.eOnPlayerChat)
			self.eOnExecuteServerCommand = bind(CPlayer.onExecuteCommandHandler, self)
			addEventHandler("onPlayerExecuteServerCommand", self, self.eOnExecuteServerCommand)

			--Addmin Events
			self.eOnAdminFreezePlayer = bind(CPlayer.onAdminFreezePlayer, self)
			addEventHandler("onAdminFreezePlayer", self, self.eOnAdminFreezePlayer)
			self.eOnAdminGetHerePlayer = bind(CPlayer.onAdminGetHerePlayer, self)
			addEventHandler("onAdminGetHerePlayer", self, self.eOnAdminGetHerePlayer)
			self.eOnAdminGoToPlayer = bind(CPlayer.onAdminGoToPlayer, self)
			addEventHandler("onAdminGoToPlayer", self, self.eOnAdminGoToPlayer)
			self.eOnAdminSpectatePlayer = bind(CPlayer.onAdminSpectatePlayer, self)
			addEventHandler("onAdminSpectatePlayer", self, self.eOnAdminSpectatePlayer)
			self.eOnAdminKillPlayer = bind(CPlayer.onAdminKillPlayer, self)
			addEventHandler("onAdminKillPlayer", self, self.eOnAdminKillPlayer)
			self.eOnAdminKickPlayer = bind(CPlayer.onAdminKickPlayer, self)
			addEventHandler("onAdminKickPlayer", self, self.eOnAdminKickPlayer)
			self.eOnAdminWarnPlayer = bind(CPlayer.onAdminWarnPlayer, self)
			addEventHandler("onAdminWarnPlayer", self, self.eOnAdminWarnPlayer)
			self.eOnAdminBanPlayer = bind(CPlayer.onAdminBanPlayer, self)
			addEventHandler("onAdminBanPlayer", self, self.eOnAdminBanPlayer)

			self.eOnAdminShutdown = bind(CPlayer.onAdminShutdown, self)
			addEventHandler("onAdminShutdown", self, self.eOnAdminShutdown)
			self.eOnAdminGMX = bind(CPlayer.onAdminGMX, self)
			addEventHandler("onAdminGMX", self, self.eOnAdminGMX)

			self.eOnPrivatMSG = bind(CPlayer.onPrivatMSG, self)
			addEventHandler("onPlayerPrivateMessage", self, self.eOnPrivatMSG)

			self.eOnInventoryRefresh = bind(CPlayer.refreshInventory, self)
			addEventHandler("onPlayerRefreshInventory", self, self.eOnInventoryRefresh)

			--Minute Timer
			self.tMinuteTimer = bind(CPlayer.minuteTimer, self)

			--Triggerable Events

			--Banksystem
			self.eOnBankDeposit = bind(CPlayer.onBankDeposit, self)
			addEventHandler( "onPlayerBankDeposit", self, self.eOnBankDeposit)
			self.eOnBankWithdraw = bind(CPlayer.onBankWithdraw, self)
			addEventHandler( "onPlayerBankWithdraw", self, self.eOnBankWithdraw)
			self.eOnBankTransfer = bind(CPlayer.onBankTransfer, self)
			addEventHandler( "onPlayerBankTransfer", self, self.eOnBankTransfer)

			self.eOnPlayerPayInFactionBank = bind(CPlayer.onPlayerPayInFactionBank, self)
			addEventHandler( "onPlayerPayInFactionBank", self, self.eOnPlayerPayInFactionBank)
			self.eOnPlayerPayOutFactionBank = bind(CPlayer.onPlayerPayOutFactionBank, self)
			addEventHandler( "onPlayerPayOutFactionBank", self, self.eOnPlayerPayOutFactionBank)

			--Haussystem
			self.eOnHouseEnter = bind(CPlayer.OnHouseEnter, self)
			addEventHandler("onPlayerHouseEnter", self, self.eOnHouseEnter)
			self.eOnHouseToggleLocked = bind(CPlayer.OnHouseToggleLocked, self)
			addEventHandler("onPlayerHouseToggleLocked", self, self.eOnHouseToggleLocked)
			self.eOnHouseBuySell = bind(CPlayer.OnHouseBuySell, self)
			addEventHandler("onPlayerHouseBuySell", self, self.eOnHouseBuySell)
			self.eOnHouseGiveKey = bind(CPlayer.OnHouseGiveKey, self)
			addEventHandler("onPlayerHouseGiveKey", self, self.eOnHouseGiveKey)
			self.eOnHouseRevokeKey = bind(CPlayer.OnHouseRevokeKey, self)
			addEventHandler("onPlayerHouseRevokeKey", self, self.eOnHouseRevokeKey)

			--Fraktionsgui
			self.eOnTakeFactionSkin = bind(CPlayer.OnTakeFactionSkin, self)
			addEventHandler("onPlayerTakeFactionSkin", self, self.eOnTakeFactionSkin)
			self.eOnOpenLeaderGui = bind(CPlayer.OnOpenLeaderGui, self)
			addEventHandler("onPlayerOpenLeaderGui", self, self.eOnOpenLeaderGui)
			self.eOnLeaveFaction = bind(CPlayer.OnLeaveFaction, self)
			addEventHandler("onPlayerLeaveFaction", self, self.eOnLeaveFaction)

			--Vehiclesystem
			self.eOnVehicleBuy = bind(CPlayer.OnVehicleBuy, self)
			addEventHandler("onPlayerVehicleBuy", self, self.eOnVehicleBuy)
			self.eOnVehicleKeyGive = bind(CPlayer.OnVehicleKeyGive, self)
			addEventHandler("onPlayerVehicleKeyGive", self, self.eOnVehicleKeyGive)
			self.eOnVehicleKeyRemove = bind(CPlayer.OnVehicleKeyRemove, self)
			addEventHandler("onPlayerVehicleKeyRemove", self, self.eOnVehicleKeyRemove)


			self.eOnVehicleAttach	= bind(CPlayer.OnVehicleAttach, self)
			addEventHandler("onPlayerVehicleAttach", self, self.eOnVehicleAttach);

			--Copfunctions
			self.eOnCopLocatePlayer = bind(CPlayer.OnCopLocatePlayer, self)
			addEventHandler("onCopLocatePlayer", self, self.eOnCopLocatePlayer)
			self.eOnCopDeleteWanted = bind(CPlayer.OnCopDeleteWanted, self)
			addEventHandler("onCopDeleteWanted", self, self.eOnCopDeleteWanted)
			self.eOnCopGiveWanted = bind(CPlayer.OnCopGiveWanted, self)
			addEventHandler("onCopGiveWanted", self, self.eOnCopGiveWanted)
			self.eOnCopGiveSTVO = bind(CPlayer.OnCopGiveSTVO, self)
			addEventHandler("onCopGiveSTVO", self, self.eOnCopGiveSTVO)
			self.eOnCopExaminePlayer = bind(CPlayer.OnCopExaminePlayer, self)
			addEventHandler("onCopExaminePlayer", self, self.eOnCopExaminePlayer)
			self.eOnCopTakeIllegalThings = bind(CPlayer.OnCopTakeIllegalThings, self)
			addEventHandler("onCopTakeIllegalThings", self, self.eOnCopTakeIllegalThings)

			--Ammunation
			self.eOnPlayerBuyWeapon = bind(CPlayer.OnPlayerBuyWeapon, self)
			addEventHandler("onPlayerBuyWeapon", self, self.eOnPlayerBuyWeapon)
			self.eOnPlayerBuyAmmo = bind(CPlayer.OnPlayerBuyAmmo, self)
			addEventHandler("onPlayerBuyAmmo", self, self.eOnPlayerBuyAmmo)

			--Sexshop
			self.eOnPlayerBuySexWeapon = bind(CPlayer.OnPlayerBuySexWeapon, self)
			addEventHandler("onPlayerBuySexWeapon", self, self.eOnPlayerBuySexWeapon)

			--Items/inventar
			self.eOnPlayerUseItem = bind(CPlayer.onUseItem, self)
			addEventHandler("onPlayerUseItem", self, self.eOnPlayerUseItem)
			self.eOnPlayerDeleteItem = bind(CPlayer.onDeleteItem, self)
			addEventHandler("onPlayerDeleteItem", self, self.eOnPlayerDeleteItem)

			--Self Menu
			self.eOnPlayerChooseStatus = bind(CPlayer.onChooseStatus, self)
			addEventHandler("onPlayerChooseStatus", self, self.eOnPlayerChooseStatus)
			self.eOnPlayerChangeSpawn = bind(CPlayer.onChangeSpawn, self)
			addEventHandler("onPlayerChangeSpawn", self, self.eOnPlayerChangeSpawn)

			--Settings etc pp
			self.eOnPlayerChangeName = bind(CPlayer.onChangeName, self)
			addEventHandler("onPlayerChangeName", self, self.eOnPlayerChangeName)

			self.eOnPlayerChangePassword = bind(CPlayer.onPlayerChangePassword, self)
			addEventHandler("onPlayerChangePassword", self, self.eOnPlayerChangePassword)

			--Private Key System
			self.tPKGenerator = new(cPrivateKeyGenerator)
			self.eOnPlayerRequestNewKey = bind(CPlayer.onRequestNewKey, self)
			addEventHandler("onPlayerRequestNewKey", self, self.eOnPlayerRequestNewKey)
			self.eOnPlayerRequestKey = bind(CPlayer.onRequestKey, self)
			addEventHandler("onPlayerRequestKey", self, self.eOnPlayerRequestKey)
			-- Damage

			addEventHandler("onPlayerDamage", self, function(...) self:onPlayerDamageEvent(...) end)
			-- Drug
			self.eOnPlayerDrugPlace				= bind(CPlayer.onDrugPlace, self);
			addEventHandler("onPlayerDrugPlace", self, self.eOnPlayerDrugPlace);


            self.m_funcOnCorporationGuiOpen = function(...)
                if (self:getCorporation() ~= 0) then
                    triggerClientEvent(self, "onCorporationsMenuMangementOpen", self, self:getCorporation(), self:getCorpRoles())
                end
            end

			self.savedDatas =
			{ "ID", "Name", "E-Mail", "Status", "Geld", "Fraktion", "Fraktionsname", "Rank","Achievements", "All_Status", "Bonuspoints" , "Statistics", "SupportTickets", "Skin"};

			self.ID=row["ID"]

			self.Name=row["Name"]
			PlayerNames[self.ID] = self.Name
			PlayerIDS[self.Name] = self.ID;

			self.EMail                  	=row["E-Mail"]
			self.Password                   =row["Password"]
			self.Salt						=row["Salt"]
			self.Serial						=row["Serial"]
			self.Played_Time				=row["Played_Time"]
			self.Totaly_Played				=row["Today_Played"]
			self.Last_IP					=row["Last_IP"]
			self.Last_Login					=row["Last_Login"]
			self.Last_Logout				=row["Last_Logout"]
			self.Register_Date				=row["Register_Date"]
			self.Geburtsdatum				=row["Geburtsdatum"]
			self.Verifikation				= tonumber(row["Verifikation"])
			self.AdminLevel 				= tonumber(row["Adminlevel"])
			self.Status 					= row["Status"]
			self.All_Status 				= fromJSON(row["Available_Status"])
			self.Bonuspoints 				= row["Bonuspoints"]
			self.Achievements 				= fromJSON(row["Achievements"])
			self.Statistics 				= fromJSON(row["Statistics"])
			self.PrivateKey 				= row["PrivateKey"]
			self.m_iNextReward			= row["NextReward"];
			self.m_iRewardLevel			= row['RewardLevel'];

			self:setData("ID", self.ID);
			self:setData("Playtime", row["Played_Time"])
			self:setData("Status", self.Status)
			self:setData("RegisterDate", self.Register_Date)
			self:setData("Birthday", self.Geburtsdatum)
			self:setData("Adminlevel", self.AdminLevel)
			self:setData("Serial", self.Serial);
			self:setData("Bonuspoints", self.Bonuspoints)


			if (self.AdminLevel > 0) then
				sendReportsToAdmins()
				bindKey(self, _Gsettings.keys.Adminpanel, "down",
				function()
					triggerClientEvent(self, "toggleAdminGui", self)
				end
				)
				outputChatBox("Press F3 to open Adminpanel!", self)
			end

			local result2 = CDatabase:getInstance():query("SELECT * FROM userdata WHERE Name=?",self:getName())
			if not(result2) then
				kickPlayer(self, "Userdata konnten nicht geladen werden!")
				return;
			end
			local row2 = result2[1]
			--Userdata
			self.Inventory = Inventories[row2["Inventory"]]
			triggerClientEvent(self, "onClientInventoryRecieve", self ,toJSON(self.Inventory))

			self.Phonenumber = tostring(row2["Phonenumber"])
			self:setData("Phonenumber", self.Phonenumber)
			self.InTelephoneCall = false
			self.TelephoneCallName = false
			Phonenumbers[self.Phonenumber] = self

			self.Geld=tonumber(row2["Geld"])
			self:setData("Geld", self.Geld)

			self.Bankgeld=tonumber(row2["Bankgeld"])
			self:setData("Bankgeld", self.Bankgeld)

			self.Fraktion=Factions[tonumber(row2["Fraktion"])]
			self:setData("Fraktion", tonumber(row2["Fraktion"]))
			self:setData("Fraktionsname", self.Fraktion:getName())
            self.JailedFaction =  tonumber(row2["JailedFaction"]) or 1
            self:setData("JailedFaction",self.JailedFaction)
            self.HutItem = tonumber(row2["HutItem"]) or 0
            self:setData("HutItem", self.HutItem)
            self.CorporationID      = tonumber(row2["CorporationID"])
            self.CorporationRoles   = (fromJSON(row2["CorporationRoles"]) or {});
            self:setCorporation(self.CorporationID)

			if(self.CorporationID ~= 0) then
				local motd	= self:getCorporation():getMOTD()
				if(motd) and (string.len(motd) > 2) then
					outputChatBox("#FFFFFFMotD: #FFFF00"..motd, self, 255, 255, 255, true)
				end
			end

			triggerClientEvent(self,"onServerSendsFactionInfo", self, self.Fraktion:getData())

			self.Rank=tonumber(row2["Rank"])

			if (self.Fraktion:getID() ~= 0) then
				bindKey(self, _Gsettings.keys.Fraktion, "down",
				function()
					if (self.Fraktion:getID() ~= 0) then
						local tFactionData = self.Fraktion:getData()
						local bIsLeader = (self.Rank == 5)
						local tFactionMembers = self.Fraktion:getMembers()
						local iRank = self.Rank
						triggerClientEvent(self, "toggleFactionGui", self, tFactionData ,bIsLeader, tFactionMembers, iRank)
					end
				end
				)
				outputChatBox("Drücke ".._Gsettings.keys.Fraktion.." um das Fraktionspanel zu öffnen!", self)
            end


			self.Spawntype      = row2["Spawntype"]
			self.Spawnkoords    = row2["Spawnkoords"]
			self.Skin           = row2["Skin"]
			self.Geschlecht     = row2["Geschlecht"]
			self.Jailtime       = tonumber(row2["Jailtime"])
			self:setData("Jailtime", self.Jailtime)
			self:setWanteds(tonumber(row2["Wanteds"]))
			self.STVO   = tonumber(row2["STVO"])
			self:setData("STVO", self.STVO)


			self.Muted = 0

			if  ( ( gettok(self.Spawntype, 1, "|") == "Dynamic") or (self.Last_Logout+900 > getRealTime()["timestamp"]) ) then
				self.int = tonumber(gettok(row2["Spawnkoords"], 1, "|"))
				self.dim = tonumber(gettok(row2["Spawnkoords"], 2, "|"))
				self.x = tonumber(gettok(row2["Spawnkoords"], 3, "|"))
				self.y = tonumber(gettok(row2["Spawnkoords"], 4, "|"))
				self.z = tonumber(gettok(row2["Spawnkoords"], 5, "|"))
				self.rz = tonumber(gettok(row2["Spawnkoords"], 6, "|"))
			else
				self.int = tonumber(gettok(self.Spawntype, 2, "|"))
				self.dim = tonumber(gettok(self.Spawntype, 3, "|"))
				self.x = tonumber(gettok(self.Spawntype, 4, "|"))
				self.y = tonumber(gettok(self.Spawntype, 5, "|"))
				self.z = tonumber(gettok(self.Spawntype, 6, "|"))
				self.rz = tonumber(gettok(self.Spawntype, 7, "|"))
			end

			self.Weapons = {}

			for i=1, 12, 1 do
				local slot = gettok(row2["Weapons"],i,"|")
				self.Weapons[i] = {
					["Weapon"] = gettok( slot,1,","),
					["Ammo"] = gettok(slot,2,",")
				}
			end

			--Quests
			self.ActiveQuests = fromJSON(row2["ActiveQuests"])

			for k,v in pairs(self.ActiveQuests) do
				Quests[tonumber(k)]:playerResume(self)
			end

			self.FinishedQuests = fromJSON(row2["FinishedQuests"])

			self:refreshClientQuests()

			--Vehicle_Keys
			self.vehicleKeys = {}
			local result3 = CDatabase:getInstance():query("SELECT * FROM vehicle_keys WHERE UID="..self.ID)
			if(result3 and #result3 > 0) then
				for key, value in pairs(result3) do
					self.vehicleKeys[value["VID"]] = true
				end
			else
			--Keine Schlüssel vorhanden!
			end

			setPlayerTeam ( self, mainTeam )
			Players[self.ID] = self

			if (isTimer(self.mTimer)) then
			else
				self.mTimer = setTimer(self.tMinuteTimer, 60000, 0)
			end

			self:setHunger(row2["Hunger"])
			self.iHealth = row2["Health"]
			self:setDuty(false)
			self:setData("loggedIn", true)
			--SupportTickets
			self:refreshTickets()
			self:RefreshDatas()

			self:checkForLoginRewards();


			CDatabase:getInstance():query("UPDATE User SET Last_Login=? WHERE ID= ?", getRealTime()["timestamp"], self.ID)
		end
	else
		kickPlayer(self, "Bitte erneut einloggen")
	end
end

function CPlayer:checkForLoginRewards()

	local function giveReward(iLevel)
		-- Reward Generieren
		local reward = cPlayer_RewardGenerator:getInstance():generateReward(iLevel);

		if(reward[1] == "geld") then
			self:addMoney(reward[2]);
		elseif(reward[1] == "item") then
			self:getInventory():addItem(CItemManager:getInstance():getItemFromID(reward[2]), reward[3]);
		end

		logger:OutputPlayerLog(self, "Erhielt Loginreward", reward[1], reward[2], reward[3]);
		triggerClientEvent(self, "onLoginRewardGet", self, reward);
	end

	if not(self.m_bLoginRewardGot) then
		self.m_bLoginRewardGot = true;


		local iLevel		= self.m_iRewardLevel;				-- Der Zurzeitige Login loginTag
		local iCurTime		= getRealTime().timestamp;			-- Zurzeitige Timestamp

		local iNextTime	= self.m_iNextReward;				-- Wann der naechste Tag kommt

		local dayLenght 	= 86400;									-- Zeit in Sekunden (Fur den Timestamp)

		-- Kein Level Definiert?
		if not(iLevel) or (iLevel < 1) then
			iLevel = 0;	-- 1. Level
		end

		if not(iNextTime) or (iNextTime < 100000) then		--- Keine Zeit?
			iNextTime = iCurTime-1500;	-- Jetzt
		end

		if(iCurTime >= iNextTime) then	-- Zeit > NaechesteRewardZeit?
			-- Leve Incrementieren
			if(iCurTime <= iNextTime+(dayLenght*1.5)) then	-- Innerhalb von 1,5 Tagen?
				iLevel = iLevel+1;
				giveReward(iLevel);
			else						-- Wieder bei 1 Anfangen
				iNextTime = iCurTime+dayLenght;
				iLevel = 1;
				giveReward(iLevel);
			end
		end

		-- Counter erhoehen
		iNextTime = iNextTime+dayLenght;

		-- Aktualisieren
		CDatabase:getInstance():query("UPDATE User SET NextReward = ?, RewardLevel = ? WHERE ID = ?", iNextTime, iLevel, self.ID)


	end
end

function CPlayer:enableLoading(bBool)
	return triggerClientEvent(self, "onLoadingSpriteToggle", self, bBool)
end

function CPlayer:setLoading(...)

	return self:enableLoading(...)
end

function CPlayer:spawn()
	--self:loadData()
	triggerClientEvent(self, "hideLoginWindow", self)
	self:setLoading(false);
	self.Crack			= false;
	self.CrackCounter 	= 0;
	self:setSWAT(false);

	local cells = self:getJailPosition(self.JailedFaction)

	if (self.iHealth <= 0) then
		if (math.random(1,2) == 1) then
			self.x = 2031.5595703125
			self.y = -1405.455078125
			self.z =17.233493804932
			self.rz = 160
			self.int = 0
			self.dim = 0
		else
			self.x = 1178.5380859375
			self.y = -1323.599609375
			self.z =14.125015258789
			self.rz = 275
			self.int = 0
			self.dim = 0
		end
		self.iHealth = 100
	end

	if (self.inSpecial == "HungerGames") then
		self.x =  1800.9729003906
		self.y = -1303.8123779297
		self.z = 120.25536346436
		self.rz = 270
		self.int = 0
		self.dim = 2
		self:setInSpecial(nil)
	end

	if (self.Jailtime > 0) then
		local cell = math.random(1,#cells)
		self.int = tonumber(gettok(cells[cell], 1, "|"))
		self.dim = tonumber(gettok(cells[cell], 2, "|"))
		self.x = tonumber(gettok(cells[cell], 3, "|"))
		self.y = tonumber(gettok(cells[cell], 4, "|"))
		self.z = tonumber(gettok(cells[cell], 5, "|"))
		self.rz = tonumber(gettok(cells[cell], 6, "|"))

		self:setData("jailed", true);
	end

	spawnPlayer (self, self.x, self.y, self.z+0.5, 0, self.Skin, tonumber(self.int) or 0, tonumber(self.dim) or 0)
	self:setFrozen(true)
	setElementDimension(self, self.dim)
	setElementInterior(self, self.int, self.x, self.y, self.z+0.5)

	setPlayerMoney (self, tonumber ( self.Geld ) )
	setPlayerName(self, self.Name)
	setPlayerWantedLevel(self, self.Wanteds)

	self.LoggedIn = true
	self:setData("online", true)

	if (self.iHealth <= 0) then
		setTimer(
		function()
			setCameraTarget(self)
			fadeCamera(self, true, 2.0)
			self:setHealth(self.iHealth)
			self:setFrozen(false)
		end, 4000, 1
		)
	else

		setTimer(function()
			if(self) then
				setCameraTarget(self)
				fadeCamera(self, true, 1.0)
				self:setFrozen(false)
			end
		end, 2000, 1)
		self:setHealth(self.iHealth)

		if (self:getFaction():getType() == 2) then
			setPedArmor(self, 100)
		end

		for k,v in ipairs(self.Weapons) do
			if (v["Weapon"] ~= 0) then
				self:addWeapon(v["Weapon"], v["Ammo"], false)
			end
		end
	end

	toggleAllControls(self, true)

	local time = getRealTime()
	if ( time["timestamp"] <  1393700399) then
		setTimer(function() Achievements[15]:playerAchieved(self) end, 5000,1)
	end
	if ( time["timestamp"] >  1393700399) and  ( time["timestamp"] <  1393797651) then
		setTimer(function() Achievements[2]:playerAchieved(self) end, 5000,1)
	end

	triggerClientEvent(self, "onClientItemsReceive", self, toJSON(CItemManager:getInstance():getItems()))
	triggerEvent("onInformationWindowRequestItems", self, self)

    self:refreshInventory()
	self:GiveFactionWeapons();


	if(self.HutItem ~= 0) then
		local ItemID = _Gsettings.huete_models_find_func(self.HutItem);
		if(ItemID ~= 0) then
			self:setHeadObject(unpack(_Gsettings.huete_models[ItemID]));
		end
	else
		if(getRealTime().monthday == 1) and (getRealTime().month+1 == 4) then
			self:setHeadObject(2320, 0, 0, 0, 0.1, 0, 180);
		end
	end

-- Faction Weapons
end

function CPlayer:GiveFactionWeapons()
	local iFactionID 	= tonumber(self:getFaction():getID())
	local iRank			= tonumber(self:getRank());
	local iFactionType	= tonumber(self:getFaction():getType());

	if(iFactionType == 3) then	-- Neutrale Fraktionen
		if(iFactionID == 6) then
			-- SAT
			self:addWeapon(43, 99999, true) -- Kameraw
		end
	elseif(iFactionType == 2) then -- Boese Fraktionen
		self:addWeapon(4, 1, true); -- Messer

	elseif(iFactionType == 1) then	-- Gute Fraktionen
		self:addWeapon(3, 1, true); -- Night Stick
		-- Barrikaden --
		self:getInventory():addItem(Items[193], 150);
		self:getInventory():addItem(Items[194], 150);
		self:getInventory():addItem(Items[195], 150);
		self:getInventory():addItem(Items[196], 150);
		self:getInventory():addItem(Items[197], 150);
	end


	if(self:getCorporation() ~= 0) then
		if(self:getCorporation():getStatus() < 30) then
			self:setArmor(100)
			self:addWeapon(4, 1, true); -- Messer
		end
	end
end

function CPlayer:meCMD(sMSG)
	if(#sMSG > 1) then
		local x, y, z = getElementPosition(self)
		local col = createColSphere(x, y, z, 15)
		for index, player in pairs(getElementsWithinColShape(col, "player")) do
			if(getElementDimension(player) == getElementDimension(self)) then
				outputChatBox("* "..getPlayerName(self).." "..sMSG, player, 135, 0, 255)
			end
		end
		destroyElement(col);
	end
end
function CPlayer:isLoggedIn()
	return self.LoggedIn
end

function CPlayer:onExecuteCommandHandler(cmd, args)
	if not(clientcheck(self, client)) then return end
	executeCommandHandler(cmd, self, args)
end

function CPlayer:getName()
	return string.gsub(getPlayerName(self), '#%x%x%x%x%x%x', '')
end

function CPlayer:IsInFactionRange()
	for ID, Faction in pairs(Factions) do
		if(Faction.Distanz > 0) then
			local x1, y1, z1 = getElementPosition(self);
			local x2, y2, z2 = getElementPosition(Faction.FactionColshape);

			if(getDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2) <= Faction.Distanz) then
				return ID;
			end
		end
	end

	-- Häuser
	for ID, Haus in pairs(Houses) do
		if(Haus.FactionID ~= 0) then
			local x1, y1, z1 = getElementPosition(self);
			local x2, y2, z2 = getElementPosition(Haus.colShape);
			if(getDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2) <= 60) then
				return Haus.FactionID;
			end
		end
	end
	return false;
end

function CPlayer:RefreshDatas()
	for index, data in pairs(self.savedDatas) do
		local value = self[data];

		if(data == "Fraktion") then
			value = self.Fraktion:getID();
		end

		if(value ~= nil) then
			if (getElementData(self, data) ~= value) then
				setElementData(self, data, value)
			end
			if (getElementData(self, "p:"..data) ~= value) then
				setElementData(self, "p:"..data, value)
			end
		end
	end
end

function CPlayer:getRank()
	return self.Rank
end

function CPlayer:setRank(iRank)
	self.Rank = iRank
	if (self.Rank == 5) then
		Achievements[79]:playerAchieved(self)
	end
	self:RefreshDatas()
end

function CPlayer:getMoney()
	return self.Geld
end

function CPlayer:addMoney(iAmount)
	if(self.Geld) and (iAmount) then
		self.Geld = self.Geld+iAmount
		self:setData("Geld", self.Geld)
		self:RefreshDatas()
		self:incrementStatistics("Account", "Geld erhalten", iAmount)
		return true
	end
	return false;
end

function CPlayer:heal(iAmount)
	if (self:getHealth()+iAmount >= 100) then
		self:setHealth(100)
	else
		self:setHealth(self:getHealth()+iAmount)
		self:incrementStatistics("Account", "Leben erhalten", iAmount)
	end

	self:RefreshDatas()
end

function CPlayer:getWanteds()
	return self.Wanteds
end

function CPlayer:setHeadObject(iObject, iX, iY, iZ, rX, rY, rZ)
    self.HutItem   = iObject

	boneAttachManager:AttachToPlayerBone(self, (tonumber(iObject) or 1337), -1, 1, (tonumber(iX) or 0), (tonumber(iY) or 0), (tonumber(iZ) or 0), (tonumber(rX) or 0), (tonumber(rY) or 0), (tonumber(rZ) or 0))
end

function CPlayer:addSTVO(count,Reason)
	if ( (self:getInventory():hasItem(Items[20],1) ) or (self:getInventory():hasItem(Items[19],1) ) )  then
		if (self.STVO+count >= 8 ) then
			self:getInventory():removeItem(Items[20],1)
			self:getInventory():removeItem(Items[19],1)
			self:refreshInventory()
			self.STVO = 0
			self:showInfoBox("warning", "Dein Führerschein wurde entzogen! Grund: "..Reason)
			self:refreshInventory()
		else
			self.STVO = self.STVO+count
			self:showInfoBox("warning", "Du hast einen STVO-Punkt erhalten. Grund: "..Reason)
		end
		self:setData("STVO", self.STVO)
	else
		return false
	end
	return true
end

function CPlayer:setWanteds(iValue)
	if (iValue > 6) then iValue = 6 end
	if (iValue < 0) then iValue = 0 end
	self.Wanteds = iValue
	setPlayerWantedLevel(self, iValue)
	if (self.Wanteds>0) then
		Achievements[58]:playerAchieved(self)
	end
	if (self.Wanteds == 6) then
		Achievements[60]:playerAchieved(self)
	end
	self:setData("Wanteds", iValue)
	self:RefreshDatas()
end
function jailFunction(hitElement, matching, iFaction)
	if (getElementType(hitElement) == "vehicle") then
		local theCop = getVehicleOccupant(hitElement, 0)
		local theOccupants = getVehicleOccupants(hitElement)
		for k, v in pairs(theOccupants) do
			if(theCop) and (theCop:getFaction():getType() == 1) and (theCop:isDuty()) and (k ~= theCop) then
				if(v:getWanteds() > 0) then
					removePedFromVehicle(v)
					for k2,v2 in ipairs( getElementsByType("player")) do
						if (getElementData(v2, "online")) and (v2:getFaction():getType() == 1) then
							if (v:getFaction():getType() == 2) then
								outputChatBox("Der Spieler "..v:getName().." wurde von "..theCop:getName().." für "..tostring(v:getWanteds()*5).." Minuten eingesperrt.", v2, 0, 255, 0)
							else
								outputChatBox("Der Spieler "..v:getName().." wurde von "..theCop:getName().." für "..tostring(v:getWanteds()*10).." Minuten eingesperrt.", v2, 0, 255, 0)
							end
						end
					end
					Factions[iFaction]:addDepotMoney(v:getWanteds()*100)
					v:jail(v:getWanteds()*10, true, iFaction or 1)
					Achievements[81]:playerAchieved(theCop)
				end
			end
		end
	end
end

function CPlayer:getJailPosition(iFaction)
	local cells1 = {
		[1] = "1|0|3764.439453125|-1615.12890625|120.96875|0|0|0",
		[2] = "1|0|3754.5830078125|-1615.12890625|120.96875|0|0|0",
		[3] = "1|0|3745.8427734375|-1615.12890625|120.96875|0|0|0",
		[4] = "1|0|3736.5283203125|-1615.12890625|120.96875|0|0|0"
	}
	local cells2 = {
		[1] = "0|0|1842.5045166016|-1593.1131591797|13.604301452637|0|0|0",
		[2] = "0|0|1852.2640380859|-1596.9366455078|13.585055351257|0|0|0",
		[3] = "0|0|1864.7650146484|-1589.0623779297|13.578476905823|0|0|0",
		[4] = "0|0|1853.9664306641|-1578.4615478516|13.622136116028|0|0|0"
	}

	local usedCell = cells1

	if(iFaction == 2) then
		usedCell = cells2
	end

	return usedCell
end

function CPlayer:jail(iTime, ovrr, iFaction)
	self:setJailtime(math.round(iTime),  ovrr)

	if not(iFaction) then
		iFaction = tonumber(self:getData("JailedFaction"))
	else
		self:setData("JailedFaction", iFaction)
	end

	Achievements[59]:playerAchieved(self)


	self:getInventory():removeIllegalItems()
	self:refreshInventory()

	local usedCell = self:getJailPosition(iFaction)

	local cell = math.random(1,#usedCell)

	self.int = tonumber(gettok(usedCell[cell], 1, "|"))
	self.dim = tonumber(gettok(usedCell[cell], 2, "|"))
	self.x = tonumber(gettok(usedCell[cell], 3, "|"))
	self.y = tonumber(gettok(usedCell[cell], 4, "|"))
	self.z = tonumber(gettok(usedCell[cell], 5, "|"))
	self.rz = tonumber(gettok(usedCell[cell], 6, "|"))

	spawnPlayer (self, self.x, self.y, self.z+0.5, 0, self.Skin, 0, 0)
	setElementDimension(self, self.dim)
	setElementInterior(self, self.int, self.x, self.y, self.z+0.5)

	self:setWanteds(0)

	self:setData("jailed", true)
end

function CPlayer:setInSpecial(sType)
	self:setData("inSpecial", sType)
	self.inSpecial = sType
end

function CPlayer:getInSpecial()
	return self.inSpecial
end

function CPlayer:getHunger()
	return tonumber(self.Hunger)
end

function CPlayer:getJailtime()
	return self.Jailtime
end

function CPlayer:setJailtime(iTime, nabsolut)
	if (self.Fraktion:getType() == 2) and nabsolut then
		iTime = math.round(iTime/2)
	end

	self.Jailtime = iTime
	self:setData("Jailtime", iTime)
end

function CPlayer:setJailedFaction(iFaction)
    self.JailedFaction = iFaction;
	return self:setData("JailedFaction", iFaction)
end

function CPlayer:setHunger(iAmount)
	self.Hunger = iAmount
	self:setData("Hunger", self.Hunger)
end

function CPlayer:eat(iAmount)
	if (self.Hunger+iAmount >= 100 ) then
		self:setHunger(100)
	else
		self:setHunger(self.Hunger+iAmount)
	end
end

function CPlayer:payMoney(iAmount)
	if (self.Geld >= iAmount) then
		self.Geld = self.Geld-iAmount
		self:setData("Geld", self.Geld)
		self:incrementStatistics("Account", "Geld ausgegeben", iAmount)
		return true
	else
		self:showInfoBox("error", "Dafür hast du zu wenig Geld! Du benötigst "..iAmount.." $!")
		return false
	end
end

function CPlayer:payBonuspoints(iAmount)
	if (self.Bonuspoints >= iAmount) then
		self.Bonuspoints = self.Bonuspoints-iAmount
		self:incrementStatistics("Bonuspunkte", "Bonuspunkte_ausgegeben", iAmount)
		self:RefreshDatas()
		return true
	else
		self:showInfoBox("error", "Dafür hast du zu wenig Bonuspunkte! Du benötigst "..iAmount.." Punkte!")
		return false
	end
end

function CPlayer:setMoney(iAmount)
	self.Geld = iAmount
	self:setData("Geld", self.Geld)
end

function CPlayer:getBankMoney()
	return self.Bankgeld
end

function CPlayer:hasLicense(sType)
	return true
	--[[
	if (sType == "Car") then
	return self.License[1]
	end
	if (sType == "Bike") then
	return self.License[2]
	end
	if (sType == "Helicopter") then
	return self.License[3]
	end
	if (sType == "Plane") then
	return self.License[4]
	end
	if (sType == "Fun") then
	return self.License[5]
	end
	if (sType == "Weapon") then
	return self.License[6]
	end
	]]
end

function CPlayer:incrementStatistics(sCategory, sName, incValue)
	local count = incValue
	if not count then
		count = 1
	end

	if not (self.Statistics[sCategory]) then
		self.Statistics[sCategory] = {}
	end

	if not( self.Statistics[sCategory][sName] ) then
		self.Statistics[sCategory][sName] = count
	else
		self.Statistics[sCategory][sName] = self.Statistics[sCategory][sName] + count
	end
	self:RefreshDatas()
end

function CPlayer:getStatistics(sCategory, sName)
	if (self.Statistics[sCategory]) and (self.Statistics[sCategory][sName]) then
		return self.Statistics[sCategory][sName]
	else
		return 0
	end
end

function CPlayer:addStatus(Status)
	self.All_Status[Status] = true
	self:RefreshDatas()
end

function CPlayer:onChooseStatus(sStatus)
	if not(clientcheck(self, client)) then return end
	if (self.All_Status) then
		self.Status = sStatus
		self:showInfoBox("info", "Du trägst nun den Status: "..self.Status)
		self:RefreshDatas()
	else
		self:showInfoBox("error", "Ungültiger Status ausgewählt!")
	end
end

function CPlayer:onChangeSpawn(sSpawn)
	if not(clientcheck(self, client)) then return end
	local typ, int, dim, x, y, z, rz
	if (sSpawn == "Dynamische Position") then
		typ = "Dynamic"
		int = 0
		dim = 0
		x,y,z = 0,0,0
		rz = 0
	end
	if (sSpawn == "Aktuelle Position") then
		typ = "Custom"
		x,y,z = getElementPosition(self)
		rz = getElementRotation(self)
		int = getElementInterior(self)
		dim = getElementDimension(self)
	end
	if (sSpawn == "Stadthalle LS") then
		typ = "CityHall LS"
		x,y,z = 1481.1896972656, -1740.1169433594, 13.546875
		rz = 0
		int = 0
		dim = 0
	end
	if (sSpawn == "Pier LS") then
		typ = "Pier LS"
		x,y,z = 394.1350402832, -1801.7465820313, 7.828125
		rz = 0
		int = 0
		dim = 0
	end
	if (sSpawn == "Hafen LS") then
		typ = "Docks LS"
		x,y,z = 2676.2248535156, -2419.5144042969, 13.6328125
		rz = 270
		int = 0
		dim = 0
	end
	self.Spawntype = typ.."|"..int.."|"..dim.."|"..x.."|"..y.."|"..z.."|"..rz
	self:showInfoBox("info", "Du hast deine Spawnposition geändert!")
end

function CPlayer:onChangeName(sNick)
	if not(clientcheck(self, client)) then return end

	if (self:getInventory():removeItem(Items[263], 1)) then
	else
		self:showInfoBox("error", "Du besitzt keine Lizenz!")
		return false
	end

	self.SecureNickChange = true

	if (#CDatabase:getInstance():query("SELECT * FROM user WHERE Name=?", sNick) > 0 ) then
		self:showInfoBox("error", "Dieser Name ist bereits vergeben!")
		self:getInventory():addItem(Items[263], 1)
		self:refreshInventory()
		return false
	end

	local suc = CDatabase:getInstance():query("UPDATE userdata AS a JOIN user AS b ON a.Name = b.Name SET a.Name=?, b.Name=? WHERE a.Name=?", sNick, sNick, self.Name)

	if (suc) then
		logger:OutputPlayerLog(self, "Änderte Namen", sNick)
		self.Fraktion:updateMemberName(self, sNick)

		PlayerIDS[self.Name] = nil

		self.Name = sNick
		PlayerNames[self.ID] = self.Name
		PlayerIDS[self.Name] = self.ID

		kickPlayer(self, self, "Du hast deinen Namen erfolgreich geaendert!")
	else
		self:showInfoBox("error", "Bei der Verarbeitung ist ein Fehler aufgetreten!")
		self:getInventory():addItem(Items[263], 1)
		self:refreshInventory()
	end
end


function CPlayer:onRequestNewKey()
	if (self.tPKGenerator:isOverTimeLimit()) then
		self.PrivateKey = self.tPKGenerator:getKey()
		triggerClientEvent(self, "onReceiveKey", self, self.PrivateKey)
		local res, num, err = CDatabase:getInstance():query("UPDATE user SET PrivateKey = ? WHERE Name=?", self.PrivateKey, self.Name)
	else
		local time = self.tPKGenerator:getRemainingTimeLimit()
		self:showInfoBox("warning", "Generierung erst wieder möglich in:\n" .. tostring(time.minutes) .. " Minuten und " .. tostring(math.floor(time.seconds/1000)) .. " Sekunden")
	end
end

function CPlayer:onRequestKey()
	triggerClientEvent(self, "onReceiveKey", self, self.PrivateKey)
end


function CPlayer:hasAchievement(Achievement)
	if not (getElementData(self, "online")) then
		return true
	end
	if type(self.Achievements[tostring(Achievement:getID())]) == "number" then
		return true
	else
		return false
	end
end

function CPlayer:addAchievement(Achievement)
	if (self:hasAchievement(Achievement)) then
		return false
	else
		self.Achievements[tostring(Achievement:getID())] = getRealTime()["timestamp"]
		if (Achievement:getID() == 41) then
			triggerClientEvent(getRootElement(), "onPlayerGetMedal", getRootElement(), getPlayerName(self))
		end
		triggerClientEvent(self, "onClientAchievementRecieve", self, Achievement:getID(), Achievement:getName(), Achievement:getReward():getPoints())
		self:RefreshDatas()
		return true
	end
end

function CPlayer:getAchievements()
	return self.Achievements
end

function CPlayer:setAchievements(tblAchievements)
	self.Achievements = tblAchievements
	self:RefreshDatas()
end

function CPlayer:getBonuspoints()
	return self.Bonuspoints
end

function CPlayer:addBonuspoints(iBonuspoints)
	self.Bonuspoints = self.Bonuspoints+iBonuspoints
	self:RefreshDatas()
end

function CPlayer:removeBonuspoints(iBonuspoints)
	if (self.Bonuspoints-iBonuspoints < 0) then
		self:showInfoBox("error", "Dazu besitzt du zu wenig Bonuspunkte!")
	else
		self.Bonuspoints = self.Bonuspoints-iBonuspoints
	end
	self:RefreshDatas()
end

function CPlayer:checkJobAchievements()
	if (self:getStatistics("Job", "Geld_erarbeitet") >= 30000 ) then
		Achievements[33]:playerAchieved(self)
		if (self:getStatistics("Job", "Geld_erarbeitet") >= 100000 ) then
			Achievements[34]:playerAchieved(self)
			if (self:getStatistics("Job", "Geld_erarbeitet") >= 250000 ) then
				Achievements[35]:playerAchieved(self)
				if (self:getStatistics("Job", "Geld_erarbeitet") >= 1000000 ) then
					Achievements[36]:playerAchieved(self)
				end
			end
		end
	end
end

function CPlayer:setBankMoney(iAmount)
	self.Bankgeld = iAmount
	self:setData("Bankgeld", self.Bankgeld)
end

function CPlayer:addBankMoney(iAmount)
	self.Bankgeld = self.Bankgeld+iAmount
	self:setData("Bankgeld", self.Bankgeld)
end


function CPlayer:onBankTransfer(sName, iAmount)
	if not(clientcheck(self, client)) then return end
	if (self:getBankMoney()>= iAmount) then
		local target = getPlayerFromPartialName(sName)
		if (isElement(target) and target:isLoggedIn()) then
			if (target ~= self) then
				self:setBankMoney(self:getBankMoney()-iAmount)
				target:setBankMoney(target:getBankMoney()+iAmount)
				triggerClientEvent(self, "BankGuiRefresh", self)
				triggerClientEvent(target, "BankGuiRefresh", self)
				self:showInfoBox("info", "Du hast "..target:getName().." "..iAmount.."$ überwiesen!")
				target:showInfoBox("info", "Dir wurden "..iAmount.."$ von "..self:getName().." überwiesen!")
				Achievements[75]:playerAchieved(self)

				logger:OutputPlayerLog(self, "Ueberwies Geld", target:getName(), iAmount);

			else
				self:showInfoBox("error", "Du kannst dir kein Geld überweisen!")
			end
		else
			self:showInfoBox("error", "Dieser Spieler existiert nicht oder ist offline!")
		end
	else
		self:showInfoBox("error", "Du hast zu wenig Geld auf deinem Konto!")
	end
end

function CPlayer:onBankWithdraw(iAmount)
	if not(clientcheck(self, client)) then return end
	if (self:getBankMoney()>= iAmount) then
		self:setBankMoney(self:getBankMoney()-iAmount)
		self:setMoney(self:getMoney()+iAmount)
		triggerClientEvent(self, "BankGuiRefresh", self)
		self:showInfoBox("info", "Du hast erfolgreich "..iAmount.."$ ausgezahlt!")
		logger:OutputPlayerLog(self, "Zahlte aus", iAmount);

	else
		self:showInfoBox("error", "Du hast zu wenig Geld auf deinem Konto!")
	end
end

function CPlayer:onPrivatMSG(sMessage, uTarget)
	logger:OutputPlayerLog(self, "Schrieb Privatnachricht", sMessage, getPlayerName(uTarget))
end

function CPlayer:onBankDeposit(iAmount)
	if not(clientcheck(self, client)) then return end
	if (self:getMoney()>= iAmount) then
		self:setMoney(self:getMoney()-iAmount)
		self:setBankMoney(self:getBankMoney()+iAmount)
		triggerClientEvent(self, "BankGuiRefresh", self)
		self:showInfoBox("info", "Du hast erfolgreich "..iAmount.."$ eingezahlt!")
		logger:OutputPlayerLog(self, "Zahlte ein", iAmount);

	else
		self:showInfoBox("error", "Du hast zu wenig Geld auf der Hand!")
	end
end


function CPlayer:onPlayerPayInFactionBank(iAmount)
	if (self.Fraktion:getID() ~= 0) then
		if (self:getBankMoney()-iAmount >= 0) then
			self:setBankMoney(self:getBankMoney()-iAmount)
			self.Fraktion:addDepotMoney(iAmount)
			self:showInfoBox("info", "Du hast Geld in die Fraktionskasse eingezahlt!")
			logger:OutputPlayerLog(self, "Zahlte in Fraktion  ein", iAmount);
			triggerClientEvent(self, "BankGuiRefresh", self)
		else
			self:showInfoBox("error", "So viel Geld besitzt du nicht!")
		end
	end
end

function CPlayer:onPlayerPayOutFactionBank(iAmount)
	if (self.Fraktion:getID() ~= 0) then
		if (self.Rank >= 4) then
			if (self.Fraktion:removeDepotMoney(iAmount)) then
				self:setBankMoney(self:getBankMoney()+iAmount)
				self:showInfoBox("info", "Du hast Geld aus der Fraktionskasse ausgezahlt!")
				logger:OutputPlayerLog(self, "Zahlte aus Fraktion  aus", iAmount);
				triggerClientEvent(self, "BankGuiRefresh", self)
			else
				self:showInfoBox("error", "So viel Geld besitzt deine Fraktion nicht!")
			end
		else
			self:showInfoBox("error", "Dazu bist du nicht autorisiert!")
		end
	end
end

function CPlayer:onPlayerDamageEvent(uAttacker, iWeapon, iBodypart, iLoss)
	if(uAttacker) and (getElementType(uAttacker) == "player") then
		outputConsole("Du hast "..getPlayerName(self).." mit Waffe "..(getWeaponNameFromID(iWeapon) or "unbekannt").." "..iLoss.." schaden zugefuegt.", uAttacker);
		outputConsole("Du hast "..iLoss.." Schaden durch Waffe "..(getWeaponNameFromID(iWeapon) or "unbekannt").." erhalten.", self);
		triggerClientEvent(uAttacker, "onClientPlayerHitsoundPlay", uAttacker, self, iLoss);
		triggerClientEvent(self, "onClientPlayerDamageGet", self);
	end
	damageCalcServer_func(uAttacker, iWeapon, iBodypart, iLoss, self)
end

function CPlayer:setPlayerCurrentHouseVisited(sHouse)
	self.currentHouse       = sHouse;
end

function CPlayer:OnHouseEnter(ID)
	local House = Houses[ID]

	self:setPlayerCurrentHouseVisited(House);

	if (House:getFactionID() ~= 0) then
		if (self:getFaction():getID() == House:getFactionID()) then
			self:setFrozen(true)
			local data = House:getInteriorData()
			self:setPosition(data[1], data[2], data[3])
			self:setInterior(data[4])
			self:setDimension(10000+House:getID())
			self:setFrozen(false)
			triggerClientEvent(self,"hideHouseGui", self)
			self:showInfoBox("info", "Du hast ein Haus betreten!")

		else
			self:showInfoBox("error", "Du solltest hier verschwinden!")
		end
	elseif (House:getCorporation() ~= 0) then
		if (self:getCorporation() ~= 0) and (self:getCorporation():getID() == House:getCorporation():getID()) then
			self:setFrozen(true)
			local data = House:getInteriorData()
			self:setPosition(data[1], data[2], data[3])
			self:setInterior(data[4])
			self:setDimension(10000+House:getID())
			self:setFrozen(false)
			triggerClientEvent(self,"hideHouseGui", self)
			self:showInfoBox("info", "Du hast ein Haus betreten!")

		else
			self:showInfoBox("error", "Du hast kein Schluessel fuer dieses Haus!")
		end
	else
		if ( (House:isLocked()) and (House:getOwnerID() ~= self.ID) and (not House:hasPlayerKey(self.Name)) ) then
			self:showInfoBox("error", "Dieses Haus ist abgeschlossen!")
		else
			self:setFrozen(true)
			local data = House:getInteriorData()
			self:setPosition(data[1], data[2], data[3])
			self:setInterior(data[4])
			self:setDimension(10000+House:getID())
			self:setFrozen(false)
			triggerClientEvent(self,"hideHouseGui", self)
			self:showInfoBox("info", "Du hast ein Haus betreten!")
		end
	end
end

function CPlayer:getOccupiedVehicle()
	return getPedOccupiedVehicle(self)
end

function CPlayer:OnHouseToggleLocked(ID)
	if not(clientcheck(self, client)) then return end
	local House = Houses[ID]
	if ((House:getOwnerID() == self.ID) or (House:hasPlayerKey(self.Name))) then
		House:toggleLocked()
		if (House:isLocked()) then
			self:showInfoBox("info", "Du hast dieses Haus abgeschlossen!")
		else
			self:showInfoBox("info", "Du hast dieses Haus aufgeschlossen!")
		end
		triggerEvent("onPickupHit", House, self)
	else
		self:showInfoBox("error", "Du besitzt keinen Schlüssel für dieses Haus!")
	end
end

function CPlayer:OnHouseBuySell(ID)
	if not(clientcheck(self, client)) then return end
	local House = Houses[ID]
	if ( House:getOwnerID() == 0 ) and (House:getFactionID() == 0) and (House:getCorporation() == 0) then
		local Price = House:getCost()
		if (self:getBankMoney() > Price) then
			self:setBankMoney(self:getBankMoney()-Price)
			House:setNewOwner(self.ID)
			self:incrementStatistics("Eigenheim", "H\aeuser_im_Besitz", 1)
			if (self:getStatistics("Eigenheim", "H\aeuser_im_Besitz") > 1) then
				Achievements[40]:playerAchieved(self)
			end
			if (House:getCost() >= 900000 ) then
				Achievements[37]:playerAchieved(self)
			end
			Achievements[6]:playerAchieved(self)
			self:showInfoBox("sucess", "Du hast ein Haus gekauft! -$"..Price)
			logger:OutputPlayerLog(self, "Kaufe Haus", House.ID, Price)
		else
			self:showInfoBox("error", "Du hast zu wenig Geld auf dem Konto!")
		end
	else
		if (House:getOwnerID() == self.ID) and (House:getFactionID() == 0) and (House:getCorporation() == 0) then
			local Price 		= House:getCost()
			local iKosten		= tonumber((Price*8)/10);

			self:setBankMoney(self:getBankMoney()+iKosten);
			House:reset()
			self:incrementStatistics("Eigenheim", "H\aeuser_im_Besitz", -1)
			self:showInfoBox("sucess", "Du hast ein Haus verkauft! +$"..iKosten)
			logger:OutputPlayerLog(self, "Verkaufe Haus", House.ID, iKosten)
		else
			self:showInfoBox("error", "Dieses Haus gerhoert dir nicht!")
		end
	end
	triggerEvent("onPickupHit", House, self)
end

function CPlayer:OnHouseGiveKey(ID, sName)
	if not(clientcheck(self, client)) then return end
	local House = Houses[ID]
	if (House:getOwnerID() == self.ID) then
		local result = CDatabase:getInstance():query("SELECT ID FROM user WHERE Name=?", sName)
		if (#result>0) then
			if (not(House:hasPlayerKey(sName)) and (self.Name ~= sName)) then
				result2 = CDatabase:getInstance():query("INSERT INTO house_keys(`UID` ,`HID`) VALUES (?, ?);", result[1]["ID"], House:getID())
				House:addKey(result["ID"], sName)
				self:showInfoBox("info", "Du hast einen Schlüssel an "..sName.." vergeben!")
				if (isElement(Players[result[1]["ID"]])) then
					Players[result[1]["ID"]]:showInfoBox("info", self.Name.." hat dir einen Schlüssel gegeben!")
				end
			else
				self:showInfoBox("error", "Dieser Spieler besitzt bereits einen Schlüssel!")
			end
		else
			self:showInfoBox("error", "Dieser Spieler existiert nicht!")
		end
	else
		self:showInfoBox("error", "Dieses Haus gerhört dir nicht!")
	end
	triggerEvent("onPickupHit", House, self)
end

function CPlayer:OnHouseRevokeKey(ID, Name)
	if not(clientcheck(self, client)) then return end
	local House = Houses[ID]
	if (House:getOwnerID() == self.ID) then
		local result = CDatabase:getInstance():query("SELECT ID FROM user WHERE Name=?", Name)
		if (#result>0) then
			result2 = CDatabase:getInstance():query("DELETE FROM house_keys WHERE HID=? AND UID=?", House:getID(), result[1]["ID"])
			House:removeKey(Name)
			self:showInfoBox("info", "Du hast "..Name.." den Schlüssel entzogen!")
			if (isElement(Players[result[1]["ID"]])) then
				Players[result[1]["ID"]]:showInfoBox("warning", "Dir wurde ein Schlüssel von "..self.Name.." entzogen!")
			end
		else
			self:showInfoBox("error", "Dieser Spieler existiert nicht!")
		end
	else
		self:showInfoBox("error", "Dieses Haus gerhört dir nicht!")
	end
	triggerEvent("onPickupHit", House, self)
end

function CPlayer:OnVehicleKeyGive(uVehicle, sName)
	local id = tonumber(uVehicle)
	if(UserVehicles[id]) and (UserVehicles[id].OwnerID == client:getID()) then
		local res = UserVehicles[id]:addUserKey(self, sName);
		if(res) then
			triggerClientEvent(self, "onClientReceivUserVehicles", self, UserVehiclesByPlayer[self:getID()], global_vehicle_preise, nil)
		end
	else
		self:showInfoBox("error", "Das ist nicht dein Auto! Das solltest du eigentlich nicht sehen lol");
	end
end

function CPlayer:hasArtifactScanner(iItem)
	if(iItem == 301 or iItem == 302 or iItem == 303) and (self.Inventory:hasItem(Items[300], 1)) then	-- Tier 3
		return true;
	end
	if(iItem == 301 or iItem == 302) and (self.Inventory:hasItem(Items[305], 1)) then		-- Tier 2
		return true;
	end
	if(iItem == 301) and (self.Inventory:hasItem(Items[304], 1)) then						-- Tier 1
		return true;
	end
	return false;
end

function CPlayer:OnVehicleAttach(uVehicle)
	if(uVehicle ~= false) then
		self:showInfoBox("info", "Benutze X oder Leertaste um dich zu detachen!");

		-- Habe ich nicht von Vio Kopiert, laallalal --
		local px, py, pz = self:getPosition()
		local vx, vy, vz = getElementPosition(uVehicle)

		local sx = px - vx
		local sy = py - vy
		local sz = pz - vz

		local rotpX = 0
		local rotpY = 0
		local _, _, rotpZ = getElementRotation(self)

		local rotvX,rotvY,rotvZ = getElementRotation(uVehicle)

		local t = math.rad(rotvX)
		local p = math.rad(rotvY)
		local f = math.rad(rotvZ)

		local ct = math.cos(t)
		local st = math.sin(t)
		local cp = math.cos(p)
		local sp = math.sin(p)
		local cf = math.cos(f)
		local sf = math.sin(f)

		local z = ct*cp*sz + (sf*st*cp + cf*sp)*sx + (-cf*st*cp + sf*sp)*sy
		local x = -ct*sp*sz + (-sf*st*sp + cf*cp)*sx + (cf*st*sp + sf*cp)*sy
		local y = st*sz - sf*ct*sx + cf*ct*sy

		local rotX = rotpX - rotvX
		local rotY = rotpY - rotvY
		local rotZ = rotpZ - rotvZ

		attachElements(self, uVehicle, x, y, z, rotX, rotY, rotZ);
	else
		detachElements(self)
	end
end

function CPlayer:OnVehicleKeyRemove(uVehicle, sName)
	local id = tonumber(uVehicle)
	if(UserVehicles[id]) and (UserVehicles[id].OwnerID == client:getID()) then
		local res = UserVehicles[id]:removeUserKey(self, sName);
		if(res) then
			triggerClientEvent(self, "onClientReceivUserVehicles", self, UserVehiclesByPlayer[self:getID()], global_vehicle_preise, nil)
		end
	else
		self:showInfoBox("error", "Das ist nicht dein Auto! Das solltest du eigentlich nicht sehen lol");
	end
end

function CPlayer:OnVehicleBuy(VID)
	if not(clientcheck(self, client)) then return end
	local theVehicle 	= VehicleShopVehicles[VID]
	local biz			= theVehicle:getBiz()
	local theShop 		= theVehicle:getShop()

	local canBuy 		= true;
	local bizPurchase	= false;
	local price			= theVehicle:getPrice()

	local einheitenCost;
	if(biz) then
		einheitenCost	= math.floor((price/1000)*biz:getLagereinheitenMultiplikator())

		if(biz:getLagereinheiten() >= einheitenCost) then
			canBuy 			= true;
			bizPurchase 	= true;
		else
			canBuy = false;
			self:showInfoBox("error", "Dieser Laden ist leer! Er muss erst wieder aufgefuellt werden. ("..einheitenCost..", "..biz:getLagereinheiten()..")")
		end
	end

	if(canBuy) then
		if (self:getMoney() >= theVehicle:getPrice()) then
			self:setMoney(self:getMoney()-theVehicle:getPrice())
		else
			if (self:getBankMoney() >= theVehicle:getPrice()) then
				self:setBankMoney(self:getBankMoney()-theVehicle:getPrice())
			else
				self:showInfoBox("error", "Du kannst dir dieses Fahrzeug nicht leisten!")
				return false
			end
		end

		local SpawnKoords = theShop:getSpawnCoords()
		local int = gettok(SpawnKoords, 1, "|")
		local dim = gettok(SpawnKoords, 2, "|")
		local koords = gettok(SpawnKoords, 3, "|").."|"..gettok(SpawnKoords, 4, "|").."|"..gettok(SpawnKoords, 5, "|").."|"..gettok(SpawnKoords, 6, "|").."|"..gettok(SpawnKoords, 7, "|").."|"..gettok(SpawnKoords, 8, "|")
		local insert = CDatabase:getInstance():query("INSERT INTO `vehicles` (`ID`, `VID`, `OwnerID`, `Int`, `Dim`, `Koords`, `Color`, `Tuning`, `Plate`, `Fuel`, `KM`, `Health`, `KaufDatum`) VALUES (NULL, ?, ?, ?, ?, ?, ?, ?, ?, '?', '0', '1000', NOW());", theVehicle:getElementModel(), self.ID, int, dim, koords, theVehicle:getColorString(), theVehicle:getTuning(), self.Name, vehicleCategoryManager:getCategoryTankSize(vehicleCategoryManager:getVehicleCategory(theVehicle)))
		if (insert) then
			local ID = CDatabase:getInstance():query("SELECT LAST_INSERT_ID() AS ID FROM vehicles;")
			local result = CDatabase:getInstance():query("SELECT * FROM vehicles WHERE ID=?", ID[1]["ID"])
			value = result[1]
			local theUserVehicle = createVehicle(value["VID"], gettok(value["Koords"],1,"|"), gettok(value["Koords"],2,"|"), gettok(value["Koords"],3,"|"), gettok(value["Koords"],4,"|"), gettok(value["Koords"],5,"|"), gettok(value["Koords"],6,"|"), value["Plate"])
			enew(theUserVehicle, CUserVehicle, value["ID"], value["OwnerID"], value["Int"], value["Dim"], value["VID"], value["Koords"], value["Color"], value["Tuning"], value["Plate"], value["Fuel"],value["KM"], value["Health"])
			warpPedIntoVehicle(self, theUserVehicle)
			triggerClientEvent(self,"hideCarbuyGui",self)
			self:showInfoBox("info", "Du hast ein Fahrzeug erworben! Achte darauf das du es rechtzeitig Parkst, ansonsten wird es geloescht!")
			Achievements[10]:playerAchieved(self)
			self:incrementStatistics("Fahrzeuge", "Fahrzeuge_gekauft", 1)


			if(bizPurchase) then
				local businessGeld = math.floor(theVehicle:getPrice()/100*15);

				biz:addLagereinheiten(-einheitenCost)
				if(biz:getCorporation() ~= 0) then
					biz:getCorporation():addSaldo(businessGeld);
				end
			end
			logger:OutputPlayerLog(self, "Autokauf", getVehicleNameFromModel(getElementModel(theVehicle)), "$"..theVehicle:getPrice())

		else
			self:showInfoBox("error", "Es ist ein Fehler bei der Verarbeitung aufgetreten!")
			self:addMoney(theVehicle:getPrice());
		end
	end
	--[[
	local theVehicle = VehicleShopVehicles[VID]
	local theShop = theVehicle:getShop()
	local theChain = theShop:getChain()

	if (theVehicle:getStock()> 0) then
		if (self:getMoney() >= theVehicle:getPrice()) then
			self:setMoney(self:getMoney()-theVehicle:getPrice())
		else
			if (self:getBankMoney() >= theVehicle:getPrice()) then
				self:setBankMoney(self:getBankMoney()-theVehicle:getPrice())
			else
				self:showInfoBox("error", "Du kannst dir dieses Fahrzeug nicht leisten!")
				return false
			end
		end
		local SpawnKoords = theShop:getSpawnCoords()
		local int = gettok(SpawnKoords, 1, "|")
		local dim = gettok(SpawnKoords, 2, "|")
		local koords = gettok(SpawnKoords, 3, "|").."|"..gettok(SpawnKoords, 4, "|").."|"..gettok(SpawnKoords, 5, "|").."|"..gettok(SpawnKoords, 6, "|").."|"..gettok(SpawnKoords, 7, "|").."|"..gettok(SpawnKoords, 8, "|")
		insert = CDatabase:getInstance():query("INSERT INTO `vehicles` (`ID`, `VID`, `OwnerID`, `Int`, `Dim`, `Koords`, `Color`, `Tuning`, `Plate`, `Fuel`, `KM`, `Health`, `KaufDatum`) VALUES (NULL, ?, ?, ?, ?, ?, ?, ?, ?, '100', '0', '1000', NOW());", theVehicle:getElementModel(), self.ID, int, dim, koords, theVehicle:getColorString(), theVehicle:getTuning(), self.Name)
		if (insert) then
			local ID = CDatabase:getInstance():query("SELECT MAX(ID) FROM vehicles")
			local result = CDatabase:getInstance():query("SELECT * FROM vehicles WHERE ID=?", ID[1]["MAX(ID)"])
			value = result[1]
			local theUserVehicle = createVehicle(value["VID"], gettok(value["Koords"],1,"|"), gettok(value["Koords"],2,"|"), gettok(value["Koords"],3,"|"), gettok(value["Koords"],4,"|"), gettok(value["Koords"],5,"|"), gettok(value["Koords"],6,"|"), value["Plate"])
			enew(theUserVehicle, CUserVehicle, value["ID"], value["OwnerID"], value["Int"], value["Dim"], value["VID"], value["Koords"], value["Color"], value["Tuning"], value["Plate"], value["Fuel"],value["KM"], value["Health"])
			warpPedIntoVehicle(self, theUserVehicle)
			triggerClientEvent(self,"hideCarbuyGui",self)
			theVehicle:setStock(theVehicle:getStock()-1)
			self:showInfoBox("info", "Glückwunsch!\nDu hast ein Fahrzeug erworben")
			Achievements[10]:playerAchieved(self)
			self:incrementStatistics("Fahrzeuge", "Fahrzeuge_gekauft", 1)

			local businessGeld = math.floor(theVehicle:getPrice()/100*7);

			if(BusinessChains[theChain:getID()]) and (BusinessChains[theChain:getID()][theShop.Filliale]) then
				BusinessChains[theChain:getID()][theShop.Filliale]:DepotMoney(businessGeld, "Fahrzeug gekauft");
			end
			logger:OutputPlayerLog(self, "Autokauf", getVehicleNameFromModel(getElementModel(theVehicle)), "$"..theVehicle:getPrice())

		else
			self:showInfoBox("error", "Es ist ein Fehler bei der Verarbeitung aufgetreten!")
			self:addMoney(theVehicle:getPrice());
		end
	else
		self:showInfoBox("error", "Dieses Fahrzeug ist nicht mehr auf Lager!")
	end
	--outputChatBox("ID: "..theVehicle:getID().."| Stock:"..theVehicle:getStock().."| Price:"..theVehicle:getPrice().."| Type:"..theVehicle:getType())

	--]]
end

function CPlayer:fadeInPosition(iX, iY, iZ, iDim, iInt, fRot)
	local Rot = fRot or 0.0
	if not(isTimer(self.fadeTimer)) and not(isTimer(self.preFadeTimer)) and not(isPedInVehicle(self)) then
		fadeCamera(self, false, 0.5);
		setElementFrozen(self, true)
		self.preFadeTimer = setTimer(
			function()
				setElementPosition(self, iX, iY, iZ)
				setElementDimension(self, (iDim or 0))
				setElementInterior(self, (iInt or 0))
				setElementRotation(self, 0, 0, Rot)
				fadeCamera(self, true, 0.5);
				setElementFrozen(self, false)

			end
		, 500, 1)
	end
end

function CPlayer:save()

	local x,y,z = self:getPosition()
	local rx,ry,rz = self:getRotation()
	local int = self:getInterior()
	local dim = self:getDimension()
	local resDims = {
		[60000] = true
	}
	if ( ((self:getDimension() > 0) and (self:getDimension() < 10000)) or (resDims[self:getDimension()])) or (getElementData(self, "p:InJob") == true) then
		self.Koords = tostring(self.int).."|"..tostring(self.dim).."|"..tostring(self.x).."|"..tostring(self.y).."|"..tostring(self.z).."|"..tostring(self.rz)
	else
		self.Koords = tostring(int).."|"..tostring(dim).."|"..tostring(x).."|"..tostring(y).."|"..tostring(z).."|"..tostring(rz)
	end

	local weapons = ""

	if ((not (self:isDuty())) and (not(self.inSpecial))) then
		for i=1, 12, 1 do
			if (i > 1) then
				weapons = weapons.."|"
			end
			weapons = weapons..getPedWeapon(self, i)..","..getPedTotalAmmo ( self, i)
		end
	else
		weapons = "0,0|0,0|0,0|0,0|0,0|0,0|0,0|0,0|0,0|0,0|0,0|0,0"
	end
	if(self.Fraktion) then
		local res, num, err = CDatabase:getInstance():query("UPDATE userdata AS a JOIN user AS b ON a.Name = b.Name SET a.Geld =?, a.Health=?, a.Hunger=?, a.Bankgeld=?, a.Fraktion=?, a.Rank=?, a.Spawntype=?, a.Spawnkoords=?, a.Skin=?, a.Jailtime =?, a.Wanteds =?, a.STVO =?, a.Weapons =?, a.ActiveQuests=?, a.FinishedQuests=?, b.Played_Time=?, b.Status=?, b.Available_Status=?, b.Bonuspoints=?, b.Achievements=?, b.Statistics=?, b.Last_Logout=?, a.JailedFaction=?, a.HutItem=?, a.CorporationID=?, a.CorporationRoles=? WHERE a.Name=?", self.Geld, self:getHealth(), self.Hunger, self.Bankgeld, self.Fraktion:getID(), self.Rank, self.Spawntype ,self.Koords, (self.Skin or 0), self.Jailtime, self.Wanteds, self.STVO, weapons, toJSON(self.ActiveQuests), toJSON(self.FinishedQuests), self.Played_Time, self.Status, toJSON(self.All_Status), self.Bonuspoints, toJSON(self.Achievements), toJSON(self.Statistics), getRealTime()["timestamp"], self.JailedFaction, self.HutItem, self.CorporationID, toJSON((self.CorporationRoles or {})), self.Name)
		if (res) then

		else
			outputServerLog("Daten fuer Spieler "..getPlayerName(self).." konnte nicht richtig gespeichert werden!")
			outputDebugString("CPlayer:Save: "..tostring(err))
		end
	end
end

function CPlayer:setDuty(bState)
	if(self.LoggedIn) then
		self.Duty = bState
	end
end

function CPlayer:setSWAT(bState)
	if(self.LoggedIn) then
		self.m_bLSPD_SWAT = bState
	end
end

function CPlayer:isSWAT(bState)
	return self.m_bLSPD_SWAT;
end

function CPlayer:onWasted(totalAmmo, theKiller, theWeapon, bodyPart, bStealth)
	-- Autos --
	if(isPedInVehicle(self)) then
		local veh = getPedOccupiedVehicle(self)
		unbindKey(self, "x", "both", veh.switchEngineBla)
	end
	if (self.inSpecial) then
		if(self.inSpecial == "hallofgames") or (self.inSpecial == "hallofgames2") then
			self:setInSpecial(nil)
		else
			return false
		end
	end
	if (self:getWanteds() > 0) then
		if ( theKiller ~= false) then
			if ( (theKiller:getFaction():getType() == 1) and ( theKiller:isDuty()) ) then
				self:setJailtime(self:getWanteds()*12, true)
				local faction = theKiller:getFaction():getID()
				Factions[faction]:addDepotMoney(self:getWanteds()*75)
				self:setJailedFaction(faction);
				self:showInfoBox("info", "Du wurdest für "..tostring(self:getWanteds()*12).." Minuten eingesperrt!")
				self:getInventory():removeIllegalItems()
				self:refreshInventory()
				Achievements[81]:playerAchieved(theKiller)
				Achievements[83]:playerAchieved(theKiller)
				for k2,v2 in pairs( getElementsByType("player")) do
					if (v2) and (v2.showInfoBox) and (getElementData(v2, "online") and v2:getFaction():getType() == 1) then
						if (self:getFaction():getType() == 2) then
							outputChatBox("Der Spieler "..self:getName().." wurde von "..theKiller:getName().." verletzt und für "..tostring(self:getWanteds()*6).." Minuten eingesperrt.", v2, 0, 255, 0)
						else
							outputChatBox("Der Spieler "..self:getName().." wurde von "..theKiller:getName().." verletzt und für "..tostring(self:getWanteds()*12).." Minuten eingesperrt.", v2, 0, 255, 0)
						end
					end
				end
			end

			if(theKiller:getCorporation() ~= 0) then
				theKiller:getCorporation():addStatus(-1);
			end
		end


	end

	local kname = "-"
	if(theKiller) then
		if(getElementType(theKiller) == "player") then
			kname = getPlayerName(theKiller);
		elseif(getElementType(theKiller) == "vehicle") then
			if(getVehicleOccupant(theKiller)) and (getElementType(theKiller) == "player") then
				kname = getPlayerName(getVehicleOccupant(theKiller)).."(Fahrzeug)";
			else
				kname = "Fahrzeug"
			end
		end
	end

	logger:OutputPlayerLog(self, "Starb", "Killer: "..kname);


	if (self:getJailtime() <= 0) then
		local x,y,z,r = 0, 0, 0, 0
		if (math.random(1,2) == 1) then
			x = 2031.5595703125
			y = -1405.455078125
			z =17.233493804932
			r = 160
		else
			x = 1178.5380859375
			y = -1323.599609375
			z =14.125015258789
			r = 275
		end
		if (self.iHealth > 0) then
			setTimer(
			function()
				if (isElement(self)) then
					spawnPlayer(self, x, y, z, 160, self.Skin, 0, 0, mainTeam)
					setPedHeadless(self, false)
					self:setDuty(false)

					if (self:getFaction():getType() == 2) then
						setPedArmor(self, 100)
					end

					if(self:getData("inlobby") == true) then
						gamemodeManager:exitPlayer(self)
					end
				end
			end, 11000, 1
			)
		end
	else
		if (self.iHealth > 0) then
			setTimer(
			function()
				self:jail(self.Jailtime, false, self:getData("JailedFaction"))
				self:setDuty(false)
				setPedHeadless(self, false)
			end, 11000, 1
			)
		end
	end

	self:incrementStatistics("Spieler", "Gestorben", 1)

	if (self:getStatistics("Spieler", "Gestorben") >= 100) then
		Achievements[8]:playerAchieved(self)
	end

	if (theKiller) and (isElement(theKiller)) and (getElementType(theKiller) == "player") and (theKiller ~= self) then
		theKiller:incrementStatistics("Spieler", "Spieler_Get\oetet", 1)
		Achievements[7]:playerAchieved(theKiller)
	else
		Achievements[86]:playerAchieved(self)
	end

	if(self.m_deathPickup) and (isElement(self.m_deathPickup)) then
		self.m_deathPickup:destroy()
	end
	local x, y, z			= self:getPosition()
	self.m_deathPickup 		= Pickup(x, y, z, 3, 1212, 1000)
	local droppedMoney		= math.floor((self:getMoney()/100)*1)
	self:addMoney(-droppedMoney)

	addEventHandler("onPickupHit", self.m_deathPickup, function(uElement)
		if(uElement) and (getElementType(uElement) == "player") and not(isPedDead(uElement)) then
			source:destroy()
			uElement:addMoney(droppedMoney)
			uElement:showInfoBox("info", "Du hast $"..droppedMoney.." aufgehoben!")
		end
	end)
end

function CPlayer:getFaction()
	return self.Fraktion
end

function CPlayer:getPlaytimeHours()
	return (math.floor(getElementData(self,"Playtime")/60))
end

function CPlayer:setCorporation(iID)
    if(Corporations[iID]) then
        self.Corporation = Corporations[iID]
    else
		if not(DEFINE_DEBUG) then
        	iID = 0;
		end
        self.Corporation = iID;
    end
    self.CorporationID = iID;

    unbindKey(self, _Gsettings.keys.Fraktion, "down");
    if(self.CorporationID ~= 0) then
        bindKey(self, _Gsettings.keys.Fraktion, "down", self.m_funcOnCorporationGuiOpen)
        outputChatBox("Drücke ".._Gsettings.keys.Fraktion.." um das Corporationsmenu zu öffnen!", self)
        self:setData("CorporationName", self.Corporation.m_sShortName)
		self:setData("CorporationNameFull", self.Corporation.m_sFullName)
        self:setData("CorporationLogo", self.Corporation.m_tblIcons)
        self:setData("CorporationColor", self.Corporation.m_sColor)

		self:getCorporation():refreshOnlineMembers();
	else
		self:setData("CorporationNameFull", false)
		self:setData("CorporationName", false)
		self:setData("CorporationLogo", false)
		self:setData("CorporationColor", false)
    end

    return (self.Corporation or 0)
end

function CPlayer:getCorporation()
    if(Corporations[self.CorporationID]) then
        self.Corporation = Corporations[self.CorporationID]
    end
	return (self.Corporation or 0)
end

function CPlayer:getCorpRoles()
	return (self.CorporationRoles or {})
end

function CPlayer:addCorpRole(iRoleID)
	self.CorporationRoles[iRoleID] = true;

    self:save();
end

function CPlayer:removeCorpRole(iRoleID)
	self.CorporationRoles[iRoleID] = nil;
	table.remove(self.CorporationRoles, iRoleID)
end

function CPlayer:resetCorpRoles()
    self.CorporationRoles = {}
end

function CPlayer:isCorporationCEO()
    if(self:hasCorpRole(0) == true) or (self:hasCorpRole(1) == true) then
        return true
    end
    return false
end

function CPlayer:hasDistinctCorpRole(iRole)
    self:refreshCorpRoles();
    if(self.CorporationRoles[iRole] == true)  then
        return true
    else
        return false
    end
end

function CPlayer:refreshCorpRoles()
    local newTBL = {}
    for index, role in pairs(self.CorporationRoles) do
        newTBL[tonumber(index)] = toboolean(role);
    end
    self.CorporationRoles = newTBL;
end

function CPlayer:hasCorpRole(sRoleID)
    self:refreshCorpRoles();
	if(type(sRoleID) == "string") then
		sRoleID = tonumber(_Gsettings.corporation.findRolesFunction(sRoleID))
    end
    if(self.CorporationRoles[0] == true) or (self.CorporationRoles[1] == true) then
        return true
    else
	    return (self.CorporationRoles[sRoleID] or false);
    end
end

function CPlayer:isDuty()
	return self.Duty
end

function CPlayer:takeWeapons()
	takeAllWeapons(self)
end

function CPlayer:getSkin()
	return self.Skin
end

function CPlayer:setSkin(iSkin, ignoreSave)
	if (not (ignoreSave)) then
		self.Skin = iSkin
		Achievements[68]:playerAchieved(self)
	end
	self:setModel(iSkin)
	self:RefreshDatas()
end

function CPlayer:setFaction(Faction)
	if(Faction:getID() ~= 0) then
		if(self:getCorporation() ~= 0) then
			return
		end
	end
	self.Fraktion = Faction
	self:setData("Fraktion", self.Fraktion:getID())
	self:setData("Fraktionsname", self.Fraktion:getName())

	if (self.Fraktion:getID() ~= 0) then
		Achievements[65]:playerAchieved(self)
		unbindKey(self, _Gsettings.keys.Fraktion, "down")
		bindKey(self, _Gsettings.keys.Fraktion, "down",
		function()
			if (self.Fraktion:getID() ~= 0) then
				local tFactionData = self.Fraktion:getData()
				local bIsLeader = (self.Rank == 5)
				local tFactionMembers = self.Fraktion:getMembers()
				local iRank = self.Rank
				triggerClientEvent(self, "toggleFactionGui", self, tFactionData ,bIsLeader, tFactionMembers, iRank)
			end
		end
		)
		outputChatBox("Drücke F5 um das Fraktionspanel zu öffnen!", self)
	else
		Achievements[80]:playerAchieved(self)
		unbindKey(self, _Gsettings.keys.Fraktion, "down")
	end
	self:RefreshDatas()
end

function CPlayer:getPing()
	return getPlayerPing(self)
end

function CPlayer:getWeapon(iSlot)
	if(type(tonumber(iSlot)) == "number") then
		return getPedWeapon(self, iSlot)
	else
		return false;
	end
end

function CPlayer:hasWeapon(iWeapon)
	if(type(tonumber(iWeapon)) == "number") then
		if(self:getWeapon(getSlotFromWeapon(iWeapon)) == iWeapon) then
			return true
		end
	end
	return false;
end

function CPlayer:addWeapon(iWeapon, iAmmo, bCurrent)
	giveWeapon(self, iWeapon, iAmmo, bCurrent)
	Achievements[69]:playerAchieved(self)
end

function CPlayer:addAmmu(iWeapon, iAmmo)
	setWeaponAmmo(self, iWeapon, self:getAmmuInSlot(getSlotFromWeapon(iWeapon))+iAmmo)
end

function CPlayer:getAmmuInSlot(iSlot)
	return getPedTotalAmmo ( self, iSlot)
end

function CPlayer:resetWeapons()
	takeAllWeapons(self)
end


function CPlayer:getVehicle()
	return getPedOccupiedVehicle(self)
end

function CPlayer:getAdminLevel()
	return self.AdminLevel
end

function CPlayer:getAdminlevel()
    return self:getAdminLevel()
end

function CPlayer:getSerial()
	return getPlayerSerial(self)
end

function CPlayer:getIP()
	return getPlayerIP(self)
end

function CPlayer:getID()
	return self.ID
end

--QuestThings

function CPlayer:startQuest(theQuest)
	theQuest:playerAccept(self)
end

function CPlayer:finishQuest(theQuest)
	theQuest:playerFinish(self)
end

function CPlayer:progressQuest(theQuest)
	theQuest:playerProgress(self)
end

function CPlayer:abortQuest(theQuest)
	theQuest:playerAbort(self)
end

function CPlayer:refreshClientQuests()
	triggerClientEvent(self, "onClientRecievePlayerQuestData", self, self.ActiveQuests, self.FinishedQuests)
end

function CPlayer:isQuestActive(theQuest)
	local QuestID = theQuest:getID()

	--Status or nil
	return self.ActiveQuests[tostring(QuestID)]
end

function CPlayer:isQuestFinished(theQuest)
	local QuestID = theQuest:getID()

	--Timestamp or nil
	return self.FinishedQuests[tostring(QuestID)]
end

function CPlayer:isQuestAcceptable(theQuest)
	local QuestID = theQuest:getID()

	if (self:isQuestActive(theQuest)) then
		return false
	end

	local finished = self:isQuestFinished(theQuest)

	if (finished) then
		if (theQuest.Type == 1) then
			return false
		end
		if (theQuest.Type == 3) then
			if (finished + 79200 > getRealTime()["timestamp"] ) then
				return false
			end
		end
	end

	if (theQuest.playerReachedRequirements(self, false)) then
		return true
	else
		return false
	end
end


function CPlayer:addQuestToLog(theQuest)
	local QuestID = theQuest:getID()

	if (self:isQuestActive(theQuest)) then
		return false
	end

	if (table.length(self.ActiveQuests) >= 15) then
		self:showInfoBox("error", "Du kannst maximal 15 Quests gleichzeitig erfüllen.")
		return false
	end

	self:setQuestState(theQuest, "Accepted")

	outputChatBox("Quest angenommen: "..theQuest:getName(),self, 0,125,0)

	logger:OutputPlayerLog(self, "Startete Quest", theQuest:getID())

	return true
end

function CPlayer:setQuestState(theQuest, State)
	local QuestID = theQuest:getID()

	self.ActiveQuests[tostring(QuestID)] = State

	self:refreshClientQuests()

	theQuest:triggerClientScript(self, State, false)

	if (theQuest.Texts[State]) then
		self:showInfoBox("info", theQuest.Texts[State])
	end

	return true
end

function CPlayer:removeQuestFromLog(theQuest, success)
	local QuestID = theQuest:getID()

	local Progress = self:isQuestActive(theQuest)

	if (success and not (Progress == "Finished")) then
		self:showInfoBox("error", "Du musst die Quest erst erfüllen!")
		return false
	end

	if not (Progress) then
		return false
	end

	if (success) then
		self:showInfoBox("info", "Du hast die Quest abgegeben!")
		self.FinishedQuests[tostring(QuestID)] = getRealTime()["timestamp"]
		theQuest:getReward():execute(self)
		self:incrementStatistics("Quests", "Abgeschlossen", 1)

		theQuest.onTurnIn(self)

		triggerClientEvent(self, "onServerPlaySavedSound", self, "/res/sounds/wow/quest_finished.mp3", "quest_finish", false)

		if (theQuest:getType() == 1) then
			self:incrementStatistics("Quests", "Normale", 1)
			if (self:getStatistics("Quests", "Normale") <= 251) then
				Achievements[114]:playerAchieved(self)
				if (self:getStatistics("Quests", "Normale") >= 25) then
					Achievements[117]:playerAchieved(self)
					if (self:getStatistics("Quests", "Normale") >= 50) then
						Achievements[118]:playerAchieved(self)
						if (self:getStatistics("Quests", "Normale") >= 100) then
							Achievements[119]:playerAchieved(self)
							if (self:getStatistics("Quests", "Normale") >= 250) then
								Achievements[120]:playerAchieved(self)
							end
						end
					end
				end
			end
		end
		if (theQuest:getType() == 2) then
			self:incrementStatistics("Quests", "Wiederholbare", 1)
			if (self:getStatistics("Quests", "Wiederholbare") <= 251) then
				Achievements[116]:playerAchieved(self)
				if (self:getStatistics("Quests", "Wiederholbare") >= 25) then
					Achievements[125]:playerAchieved(self)
					if (self:getStatistics("Quests", "Wiederholbare") >= 50) then
						Achievements[126]:playerAchieved(self)
						if (self:getStatistics("Quests", "Wiederholbare") >= 100) then
							Achievements[127]:playerAchieved(self)
							if (self:getStatistics("Quests", "Wiederholbare") >= 250) then
								Achievements[128]:playerAchieved(self)
							end
						end
					end
				end
			end
		end
		if (theQuest:getType() == 3) then
			self:incrementStatistics("Quests", "T\aegliche", 1)
			if (self:getStatistics("Quests", "T\aegliche") <= 251) then
				Achievements[115]:playerAchieved(self)
				if (self:getStatistics("Quests", "T\aegliche") >= 25) then
					Achievements[121]:playerAchieved(self)
					if (self:getStatistics("Quests", "T\aegliche") >= 50) then
						Achievements[122]:playerAchieved(self)
						if (self:getStatistics("Quests", "T\aegliche") >= 100) then
							Achievements[123]:playerAchieved(self)
							if (self:getStatistics("Quests", "T\aegliche") >= 250) then
								Achievements[124]:playerAchieved(self)
							end
						end
					end
				end
			end
		end
	else
		self:showInfoBox("error", "Du hast die Quest abgebrochen!")
		self:abortQuest(theQuest)
		self:incrementStatistics("Quests", "Abgebrochen", 1)
		triggerClientEvent(self, "onServerPlaySavedSound", self, "/res/sounds/wow/quest_abort.ogg", "quest_abort", false)
	end

	self.ActiveQuests[tostring(QuestID)] = nil

	self:refreshClientQuests()

	logger:OutputPlayerLog(self, "Beendete Quest", theQuest:getID(), tostring(sucess))
end

function CPlayer:hasKeyForVehicle(theVehicle)
	if(theVehicle:getOwnerID() == self.ID) then
		return true
	else
		local keys = theVehicle.keys;
		if(keys) then
			for id, name in pairs(keys) do
				if(tonumber(id) == self.ID) then
					return true;
				end
			end
		end
		return false;
	end
	return false;
end

function CPlayer:showInfoBox(action, text)
	if(isElement(self)) then triggerClientEvent(self, "infoBoxShow", self, action, parseString(text)) end
end

function CPlayer:onNickChange()
	if (self.SecureNickChange) then
		self.SecureNickChange = nil
		return true
	end
	cancelEvent()
end

function CPlayer:onChat(message, messageType)
	message = cWortFilter:getInstance():applyCensoreFilter(message);

	if (not self.Messages) then
		self.Messages = {}
	end

	cancelEvent()
	local str = self.Name..": "..message

	if (self.InTelephoneCall) then
		str = self.Name.."(Handy) : "..message
	end

	self.Messages[getTickCount()] = true

	for k,v in pairs(self.Messages) do
		if getTickCount()-k > 5000 then
			self.Messages[k] = nil
		end
	end

	if (table.size(self.Messages) >= 4) then
		self.Muted = getTickCount()
	end

	if (getTickCount()-self.Muted > 30000) then
		self.Muted = 0
	end

	if (self.Muted > 0) then
		self:showInfoBox("error", "Du wurdest wegen Spamming gemutet!\nNoch "..tostring(math.round((30000- (getTickCount()-self.Muted))/1000)).." Sekunden!")
		return false
	end

	if(messageType == 0) then
		if(ofactions.News.isLive[self] == true) then
			ofactions.News:OutputChat(self, message);
		elseif(ofactions.News.doingNews[self] == true) then
			ofactions.News:DoNews(self, message);
		else
			local x,y,z = self:getPosition()
			local sphere = createColSphere(x, y,z, 35)

			for k,v in ipairs(getElementsWithinColShape(sphere, "player")) do
				if ((getElementDimension(v) == getElementDimension(self)) and (getElementInterior(v) == getElementInterior(self))) then
					if (self.InTelephoneCall and getPlayerName(v) == self.TelephoneCallName) then
					else
						outputChatBox(str, v, 255, 255, 255)
					end
				end
			end
			destroyElement(sphere)
		end

		logger:OutputPlayerLog(self, "Schrieb Chatnachricht", message);

		if (self.InTelephoneCall) then
			str = self.Name.."(Handy) : "..message
			if (getPlayerFromName(self.TelephoneCallName)) then
				outputChatBox(str, getPlayerFromName(self.TelephoneCallName), 255, 255, 255)
			end
		end

	else
		if(messageType == 2) then
			if ( self:getFaction():getID() ~= 0 ) then
				for k,v in ipairs(getElementsByType("player")) do
					if getElementData(v, "online") then
						if ( self:getFaction() == v:getFaction() ) then
							local r,g,b = v:getFaction():getColors()
							outputChatBox("["..v:getFaction():getRankName(self.Rank).."] "..self.Name..": "..message, v, r, g, b)
						end
					end
				end
			end

			if(self:getCorporation() ~= 0) then
				local corp	= self:getCorporation();

				corp:sendFactionMessage("["..self:getName()..": "..message.."]", getColorFromString(corp.m_sColor))
			end
		end

		logger:OutputPlayerLog(self, "Schrieb Fraktionsnachricht", message);

	end

end

addEventHandler("onPlayerChat", getRootElement(), function()
	if not(getElementData(source, "online")) then
		cancelEvent()
	end
end)

function CPlayer:minuteTimer(bPayday)
	if (self:getHunger() > 0) then
		if ( self.Jailtime == 0 ) then
			self:setHunger(self:getHunger()-0.25)
		else
			self:setHunger(75)
		end
		if (self:getHunger() > 25) then
			if (getElementDimension(self) ~= 60000) then
				self:heal(5)
			end
		end
	else
		if not(DEFINE_DEBUG) then
			if (self:getHealth()-10 > 0) then
				self:setHealth(self:getHealth()-10)
				self:showInfoBox("warning", "Du hungerst.\nIss etwas um zu überleben!")
			else
				self:setHealth(0)
			end
		end
	end
	if ( self.Jailtime > 0 ) then
		self:setJailtime(self.Jailtime - 1)
		if (self.Jailtime <= 0) then
			self:showInfoBox("info", "Du wurdest aus dem Gefängnis entlassen!")
			self:setInterior(0)
			self:setPosition(1544.5, -1675.80005, 13.6)
			self:setDimension(0)
			self:setRotation(0,0,90)

			self:setData("jailed", false)
			triggerClientEvent(self, "onClientPlayerJailControlsActivate", self)
		end
	end
	if (self:getData("p:AFK") ~= true and self.Jailtime <= 0) or ((bPayday and DEFINE_DEBUG)) then
		self.Played_Time = self.Played_Time+1
		self:setData("Playtime", self.Played_Time)
		--Payday
		if (self.Played_Time%60 == 0) or ((bPayday and DEFINE_DEBUG)) then
			if (self.Played_Time/60 >= 10) then
				Achievements[17]:playerAchieved(self)
				if (self.Played_Time/60 >= 50) then
					Achievements[18]:playerAchieved(self)
					if (self.Played_Time/60 >= 100) then
						Achievements[19]:playerAchieved(self)
						if (self.Played_Time/60 >= 250) then
							Achievements[20]:playerAchieved(self)
							if (self.Played_Time/60 >= 500) then
								Achievements[21]:playerAchieved(self)
								if (self.Played_Time/60 >= 1000) then
									Achievements[22]:playerAchieved(self)
								end
							end
						end
					end
				end
			end

			local trigtab = {}

			local HouseCost 	= -100
			--local CarCost 		= -50

			local BasicIncome 	= math.random(450, 550);

			trigtab["BasicIncome"] = BasicIncome
			local FactionIncome = 200*self.Rank

			if(self:getFaction():getID() == 0) then
				FactionIncome = 0;	-- Businesseinkommen
			end
			trigtab["FactionIncome"] = FactionIncome > 0 and FactionIncome or nil

			local Interest = self.Bankgeld/100
			if (Interest >= 1000) then
				Interest = 1000
			end
			trigtab["Interest"] = Interest > 0 and Interest or nil
			--[[
			result = CDatabase:getInstance():query("SELECT count(*) FROM houses WHERE Owner=?", self.ID)
			local HousTaxes = result[1]["count(*)"]*HouseCost
			trigtab["HouseTaxes"] = HousTaxes]]

			--result = CDatabase:getInstance():query("SELECT count(*) FROM vehicles WHERE OwnerID=?", self.ID)
			local CarTaxes = {["total"] = 0}
			-- car taxes
			for i,veh in pairs(UserVehiclesByPlayer[self:getID()]) do
				CarTaxes["total"] = CarTaxes["total"]-vehicleCategoryManager:getCategoryTax(veh["Vehicle"])
				CarTaxes[getVehicleName(veh["Vehicle"])] = vehicleCategoryManager:getCategoryTax(veh["Vehicle"]) > 0 and -vehicleCategoryManager:getCategoryTax(veh["Vehicle"]) or nil
			end
			trigtab["VehicleTaxes"] = CarTaxes["total"] < 0 and CarTaxes or nil

			-- house taxes
			local HouseTaxes = {["total"] = 0}
			for houseid,price in pairs(CHouseManager:getInstance():getHousesByOwnerID(self:getID())) do
				HouseTaxes["total"] = HouseTaxes["total"]-math.floor(price/1000)
				HouseTaxes[tostring(houseid)] = -math.floor(price/1000)
			end
			trigtab["HouseTaxes"] = HouseTaxes["total"] < 0 and HouseTaxes or nil

			local PayDay = 0

			if (getEventMultiplicator() > 1) then
				PayDay= math.round( (BasicIncome+FactionIncome+Interest+HouseTaxes["total"]+CarTaxes["total"])*(getEventMultiplicator()*2) )
			else
				PayDay= math.round( (BasicIncome+FactionIncome+Interest+HouseTaxes["total"]+CarTaxes["total"]))
			end

			local CorpTaxes		= 0;

			local corporationIncome = 0;
			if(self:getCorporation() ~= 0) then
				local corporationTaxRate	= self:getCorporation():getRaxRate()
				local lohn					= math.floor(tonumber(self:getCorporation():getLohn()))

				if(lohn) and (lohn >= 0) then
					corporationIncome = lohn;

					if(self:getCorporation():getSaldo() >= lohn) then
						PayDay = PayDay+corporationIncome;
						self:getCorporation():addSaldo(-lohn)
					else
						corporationIncome = 0;
					end
				end
				trigtab["CorporationIncome"] = corporationIncome > 0 and corporationIncome or nil

				-- BIZ INCOME --
				--[[
				local bizIncome	= self:getCorporation():getBizIncome();

				trigtab["CorporationIncome"] = trigtab["CorporationIncome"]+bizIncome;
				]]
				trigtab["CorporationTaxes"] = math.floor(PayDay/100*corporationTaxRate)
				PayDay = PayDay-trigtab["CorporationTaxes"];

				self:getCorporation():addSaldo(trigtab["CorporationTaxes"]);


			end



			trigtab["Sum"] = math.floor(PayDay)
			local ReichenSteuer	= 0;

			self:setBankMoney(self:getBankMoney()+PayDay)

			logger:OutputPlayerLog(self, "Erhielt Payday", "$"..PayDay);


			triggerClientEvent(self, "PaydayShow", self, trigtab)

			playSoundFrontEnd(self, 43)

			if ((self:getWanteds() > 0) and (((self.Played_Time%60)%2 == 0))) then
				self:setWanteds(self:getWanteds()-1)
			end

			if ((self.STVO > 0) and (((self.Played_Time%60)%5 == 0))) then
				self.STVO = self.STVO-1
			end

			if (self:getFaction():getType() == 3) then
				self:getFaction():addDepotMoney(500)
			end
		end
	end
end


function CPlayer:onDrugPlace(iType)
	self.Crack			= true;
	setElementData(self, "drugplacing", true);
	local x, y, z	= self:getPosition();
	local type = 1;
	if(iType == 274) then
		type = 1
	else
		type = 2
	end
	local timestamp	= getRealTime().timestamp;
	local drug 		= cDrug:new(false, self:getID(), x, y, z-1.6, type, timestamp);
	drug:saveNewEntry(self)

	setPedAnimation(self, "BOMBER","BOM_Plant_Loop", -1, true, false, false)
--	setElementFrozen(self, true)
	toggleAllControls(self, false);
	setTimer(function()
		setElementData(self, "drugplacing", false);
		self.Crack			= false;
		setPedAnimation(self)
	--	setElementFrozen(self, false)
		toggleAllControls(self, true)
	end, iDrugPlantTime, 1)
end

function CPlayer:removeFromVehicle()
	removePedFromVehicle(self)
end

function CPlayer:removeFromVehicleOptic()
	if not(self.m_bEjecting) then
		self.m_bEjecting = true

		setControlState(self, "enter_exit", true)
		setTimer(function()
			removePedFromVehicle(self)
			setControlState(self, "enter_exit", false)
			self.m_bEjecting = false;
		end, 1000, 1)
	end
end

--Global

function CPlayer:generateSalt(password)
	local randWert	= math.random(1, 5);
	return string.sub(hash("sha512", getRealTime().timestamp.."|"..password.."|"..self:getName()), randWert, randWert+10);
end

function CPlayer:onPlayerChangePassword(curPW, newPW)
	if(string.len(newPW) > 5) then
		local result = CDatabase:getInstance():query("SELECT * FROM user WHERE Name=?",self:getName())
		local row = result[1]
		if(hash("sha512", curPW..row["Salt"]) == row["Password"]) then
			-- Update Hash Alogitm --
			local salt		= self:generateSalt(newPW);
			local res = CDatabase:getInstance():query("UPDATE user SET Password = '"..hash("sha512", newPW..salt).."', Salt = '"..salt.."' WHERE Name=?",self:getName())
			if(res) then
				outputDebugString("Updated Hashed Password for User: "..self:getName());
				self:showInfoBox("sucess", "Dein Passwort wurde mit einer SHA512+Salt Verschlüsselung sicher erneuert!");
				self:incrementStatistics("Account", "Passwort geanedert", 1)
			end
		else
			self:showInfoBox("error", "Dein zurzeitiges Passwort ist nicht Korrekt!")
		end
	else
		self:showInfoBox("error", "Dein Passwort muss länger als 5 Zeichen sein!");
	end
end



function CPlayer:login(password, bOverridePassword)
    if(cCorporationManager) then
        if not(cCorporationManager:getInstance().m_bEverythingLoaded) then
            self:showInfoBox("error", "Server ist noch nicht bereit! Bitte Warten!")
            triggerClientEvent(self, "enableLoginAgain", self)
       --     return
        end
    end
	local result = CDatabase:getInstance():query("SELECT * FROM user WHERE Name=?",self:getName())

	if(result) then
		row = result[1]

		local sucess = false;
		if(DEFINE_DEBUG) then
			sucess = true;
		else
			if (md5(password) == row["Password"]) then
				sucess	= true;

				local salt		= self:generateSalt(password);

				-- Update Hash Alogitm --
				CDatabase:getInstance():query("UPDATE user SET Password = '"..hash("sha512", password..salt).."', Salt = '"..salt.."' WHERE Name=?",self:getName())
				outputDebugString("Updated Hashed Password for User: "..self:getName());

            else
				if(hash("sha512", password..row["Salt"]) == row["Password"]) then
					sucess = true;
				end
			end
		end
		if(sucess) then
			resendPlayerModInfo(self);
			self:loadData()
			self:spawn()
			self:incrementStatistics("Account", "Logins", 1)
			self:setLoading(false);
			self.Online = true;

			logger:OutputPlayerLog(self, "Loggte sich ein", getPlayerIP(self), getPlayerSerial(self))

			mapManager:sendMapInfotoPlayer(self);
		else
			self:showInfoBox("error", "Ung\\ueltiger Benutzername oder falsches Passwort angegeben!")
			triggerClientEvent(self, "enableLoginAgain", self)
			return
		end
	else
		triggerClientEvent(self, "enableLoginAgain", self)
		self:showInfoBox("error", "MySQL Fehler!\nBitte erneut versuchen, oder reconnecten.\nEventuell Admin bescheid sagen.");
	end
end


function CPlayer:register(name, email, password, geburtsdatum, geschlecht)
	thePlayer = self;
	local result = CDatabase:getInstance():query("SELECT * FROM user WHERE Name=?",name)
	self:setLoading(false);

	if(#result  >= 1 ) then
		self:showInfoBox("error", "Dieser Account existiert bereits!")
		triggerClientEvent(self, "onClientRegisterWindowGUIOpenAgain", self);
		return
	else
		local salt		= self:generateSalt(password);
		local insert1 = "INSERT INTO user (`id`, `Name`, `E-Mail`, `Password`, `Salt`, `Serial`, `Played_Time`, `Last_IP`, `Last_Logout`, `Last_Login`, `Register_Date`, `Geburtsdatum`, `Verifikation`, `Adminlevel`, `Status`, `Available_Status`, `Bonuspoints`, `Achievements`, `Statistics`) VALUES (NULL, ?, ?, ?, ?, ?, '0', ?, '0', '0', CURDATE(), ?, '0', '0', 'Obdachloser', '[ { \"Obdachloser\": true } ]', '0', '[ [ ] ]', '[ [ ] ]');"
		local insert2 = "INSERT INTO userdata (`Name`, `Inventory`, `Phonenumber`, `Geld`, `Bankgeld`, `Fraktion`, `Rank`, `Spawnkoords`, `Skin`, `Geschlecht`, `Jailtime`, `Wanteds`, `ActiveQuests`, `FinishedQuests`) VALUES (?,  (SELECT MAX(ID) FROM `Inventory`), ?, '100', '250', '0', '0', '0|0|1338.2893066406|-1773.7534179688|13.552166938782|0', '137', ?, '0', '0', '"..toJSON({}).."', '"..toJSON({}).."');"

		local phoneNumber = math.random(1, 299).."-"..math.random(1, 99).."-"..math.random(1, 1299)

		--[[
		local phoneNumber = false
		while not phoneNumber do
			local tel = math.random(100000, 99999999)
			local exists = CDatabase:getInstance():query("Select * From userdata WHERE Phonenumber=?", tel)
			if not(exists) or (#exists == 0) then
				phoneNumber = tel
			end
		end
		]]

		CDatabase:getInstance():query("INSERT INTO `Inventory` (`ID` ,`Type` ,`Categories` ,`Items` ,`Slots`)VALUES (NULL ,  '1',  ' [ { \"7\": true, \"1\": true, \"2\": true, \"4\": true, \"8\": true, \"9\":  true, \"5\": true, \"3\": true, \"6\": true } ]',  '[ {\"17\": 2 } ]',  '250');")

		--Inserten (Join?)
		CDatabase:getInstance():query(insert1, name, email, hash("sha512", password..salt), salt, getPlayerSerial(self),getPlayerIP(self),geburtsdatum)
		CDatabase:getInstance():query(insert2, name, phoneNumber, geschlecht)

		local val = CDatabase:getInstance():query("SELECT * FROM `inventory` WHERE ID=(SELECT MAX(ID) FROM `Inventory`)")
		local value=val[1]
		new (CInventory, value["ID"], value["Type"], value["Categories"], value["Items"], value["Slots"])

		-- Provisorisch - Nach Eingabe in das Interface
		triggerClientEvent (self, "hideLoginWindow", self, true )

		self:setName(name);
		self:login(password)

		logger:OutputPlayerLog(self, "Registrierte sich", getPlayerIP(self), getPlayerSerial(self))
	end

end


function CPlayer:quit()
	if(source.LoggedIn) then
		if (source:getWanteds() > 0) then
			local x,y,z = getElementPosition(source)
			local shape = createColSphere(x,y,z, 30)

			for k,v in ipairs(getElementsWithinColShape(shape, "player")) do
				if (v.LoggedIn) and (v:getFaction():getType() == 1) and (v:isDuty()) then
					local faction = v:getFaction():getID()
					Factions[faction]:addDepotMoney(source:getWanteds()*100)
					source:jail(source:getWanteds()*15, true)
					for k2,v2 in ipairs( getElementsByType("player")) do
						if(v2.LoggedIn) then
							if (getElementData(v2, "online")) and (v2:getFaction():getType() == 1) then
								outputChatBox("Der Spieler "..source:getName().." wurde wegen Offlineflucht eingesperrt.", v2, 0, 255, 0)
								source:incrementStatistics("Account", "Offlinefluechte", 1)
							end
						end
					end
					break;
				end
			end

			destroyElement(shape)
		end
		CDatabase:getInstance():savePlayer(source)

		logger:OutputPlayerLog(source, "Loggte sich aus", getPlayerIP(source), getPlayerSerial(source));

		cTruckerJob:getInstance():clearPlayerElement(source)
	end
end
addEventHandler ( "onPlayerQuit", getRootElement(), CPlayer.quit )

--Adminsystem

function CPlayer:refreshTickets()
	if (type(SupportTicketsByCreator[self.ID]) == "table") then
		self.SupportTickets = SupportTicketsByCreator[self.ID]
	else
		self.SupportTickets = {}
	end
	self:RefreshDatas()
end

function CPlayer:onAdminFreezePlayer(tPlayer)
	if not(clientcheck(self, client)) then return end
	local neededAdminLevel = 2
	if (self:getAdminLevel() >= neededAdminLevel) then
		if (isElement(tPlayer)) then
			if (isElementFrozen(tPlayer)) then
				tPlayer:setFrozen(false)
				self:showInfoBox("info", "Der Spieler "..tPlayer:getName().." wurde aufgetaut!")
				tPlayer:showInfoBox("info", "Du wurdest von einem Adminstrator aufgetaut!")
			else
				tPlayer:setFrozen(true)
				self:showInfoBox("info", "Der Spieler "..tPlayer:getName().." wurde eingefroren!")
				tPlayer:showInfoBox("warning", "Du wurdest von einem Adminstrator eingefroren!")
			end
		else
			self:showInfoBox("error", "Dieser Spieler existiert nicht!")
		end
	else
		self:showInfoBox("error", "Dazu fehlt dir die Berechtigung!")
	end
end

function CPlayer:onAdminGetHerePlayer(tPlayer)
	if not(clientcheck(self, client)) then return end
	local neededAdminLevel = 1
	if (self:getAdminLevel() >= neededAdminLevel) then
		if (isElement(tPlayer)) then
			local x, y, z = self:getPosition()
			local interior = self:getInterior()
			local dim = self:getDimension()

			tPlayer:setPosition(x+0.5, y+0.5, z)
			tPlayer:setInterior(interior)
			tPlayer:setDimension(dim)

			if(isPedInVehicle(tPlayer)) then
				tPlayer = getPedOccupiedVehicle(tPlayer)
				setElementPosition(tPlayer, x+0.5, y+0.5, z)
				setElementInterior(tPlayer, interior)
				setElementDimension(tPlayer, dim);
			end
		else
			self:showInfoBox("error", "Dieser Spieler existiert nicht!")
		end
	else
		self:showInfoBox("error", "Dazu fehlt dir die Berechtigung!")
	end
end

function CPlayer:onAdminGoToPlayer(tPlayer)
	if not(clientcheck(self, client)) then return end
	local neededAdminLevel = 1
	if (self:getAdminLevel() >= neededAdminLevel) then
		if (isElement(tPlayer)) then
			local x, y, z = tPlayer:getPosition()
			local interior = tPlayer:getInterior()
			local dim = tPlayer:getDimension()

			self.ox, self.oy, self.oz = getElementPosition(self)
			self.odim = getElementDimension(self)
			self.oint = getElementInterior(self)

			self:setPosition(x+0.5, y+0.5, z)
			self:setInterior(interior)
			self:setDimension(dim)

			if(isPedInVehicle(self)) then
				tPlayer = getPedOccupiedVehicle(self)
				setElementPosition(tPlayer, x+0.5, y+0.5, z)
				setElementInterior(tPlayer, interior)
				setElementDimension(tPlayer, dim);
			end
		else
			self:showInfoBox("error", "Dieser Spieler existiert nicht!")
		end
	else
		self:showInfoBox("error", "Dazu fehlt dir die Berechtigung!")
	end
end

addCommandHandler("goback",
	function(pl, cmd)
		if (pl.ox and pl.oy and pl.oz and pl.odim and pl.oint) then

			if(isPedInVehicle(pl)) then
				tPlayer = getPedOccupiedVehicle(pl)
				setElementPosition(tPlayer, pl.ox, pl.oy, pl.oz)
				setElementInterior(tPlayer, pl.oint)
				setElementDimension(tPlayer, pl.odim);
			else
				setElementInterior(pl, pl.oint)
				setElementDimension(pl, pl.odim)
				setElementPosition(pl, pl.ox, pl.oy, pl.oz)
			end

			pl.ox, pl.oy, pl.oz = false, false, false
			pl.odim = false
			pl.oint = false

			pl:showInfoBox("info", "Home, sweet Home!")
		else
			pl:showInfoBox("error", "Du kannst dich nicht zurückporten!")
		end
	end
)

function CPlayer:onAdminSpectatePlayer(tPlayer)
	if not(clientcheck(self, client)) then return end
	local neededAdminLevel = 1
	if (self:getAdminLevel() >= neededAdminLevel) then
		if (isElement(tPlayer)) then
			setCameraTarget(self, tPlayer)
			setCameraInterior(self, tPlayer:getInterior())
			self:showInfoBox("info", "Du beobachtest nun "..tPlayer:getName().."!")
			logger:OutputPlayerLog(self, "Spectate", tPlayer:getName(), tostring(getRealTime()["timestamp"]))
		else
			self:showInfoBox("error", "Dieser Spieler existiert nicht!")
		end
	else
		self:showInfoBox("error", "Dazu fehlt dir die Berechtigung!")
	end
end

function CPlayer:onAdminKillPlayer(tPlayer)
	if not(clientcheck(self, client)) then return end
	local neededAdminLevel = 2
	if (self:getAdminLevel() >= neededAdminLevel) then
		if (isElement(tPlayer)) then
			tPlayer:setHealth(0)
			tPlayer:showInfoBox("warning", "Du wurdest aus administrativen Gründen getötet!")
			self:showInfoBox("info", "Du hast einen Spieler getötet!")
		else
			self:showInfoBox("error", "Dieser Spieler existiert nicht!")
		end
	else
		self:showInfoBox("error", "Dazu fehlt dir die Berechtigung!")
	end
end

function CPlayer:onAdminKickPlayer(tPlayer, Reason)
	if not(clientcheck(self, client)) then return end
	local neededAdminLevel = 1
	if (self:getAdminLevel() >= neededAdminLevel) then
		if (isElement(tPlayer)) then
			self:showInfoBox("info", "Du hast den Spieler gekickt!")
			outputChatBox("Der Spieler "..tPlayer:getName().." wurde von "..self:getName().." gekickt! Grund: "..Reason, getRootElement(), 255, 0, 0)
			kickPlayer(tPlayer, self, Reason)
		else
			self:showInfoBox("error", "Dieser Spieler existiert nicht!")
		end
	else
		self:showInfoBox("error", "Dazu fehlt dir die Berechtigung!")
	end
end

function CPlayer:onAdminWarnPlayer(tPlayer)
	if not(clientcheck(self, client)) then return end
	local neededAdminLevel = 2
	if (self:getAdminLevel() >= neededAdminLevel) then
		if (isElement(tPlayer)) then
			self:showInfoBox("error", "Verwarnen ist momentan nicht möglich!")
		else
			self:showInfoBox("error", "Dieser Spieler existiert nicht!")
		end
	else
		self:showInfoBox("error", "Dazu fehlt dir die Berechtigung!")
	end
end

function CPlayer:onAdminBanPlayer(tPlayer, Reason, Length, LengthString)
	if not(clientcheck(self, client)) then return end
	local neededAdminLevel = 2
	if (self:getAdminLevel() >= neededAdminLevel) then
		if (isElement(tPlayer)) then

			local time = getRealTime()

			local Expire = time["timestamp"]+Length

			local query = "INSERT INTO  `bans` (`id` ,`Name` ,`Serial` ,`IP` ,`Date` ,`banned_by` ,`Grund` ,`expire_timestamp`)VALUES (NULL ,  ?,  ?,  ?,  NOW(),  ?,  ?,  ?);"
			CDatabase:getInstance():query(query, tPlayer:getName(), tPlayer:getSerial(), tPlayer:getIP(), self:getName(), Reason, Expire)
			self:showInfoBox("info", "Du hast einen Spieler gebannt!")

			outputChatBox("Der Spieler "..tPlayer:getName().." wurde von "..self:getName().." gebannt. ("..LengthString..") Grund: "..Reason, getRootElement(), 255, 0, 0)
			kickPlayer(tPlayer, self, "Du wurdest gebannt. Grund: "..Reason)

		else
			self:showInfoBox("error", "Dieser Spieler existiert nicht!")
		end
	else
		self:showInfoBox("error", "Dazu fehlt dir die Berechtigung!")
	end
end

function CPlayer:onAdminShutdown()

	--[[
	if not(clientcheck(self, client)) then return end
	local neededAdminLevel = 1
	if (self:getAdminLevel() >= neededAdminLevel) then
		shutdown("Admin "..self.Name.." hat den Server notabgeschaltet!")
	else
		self:showInfoBox("error", "Dazu fehlt dir die Berechtigung!")
	end
	]]
end

function CPlayer:getLocalization()
	if(self:getData("cg:loc")) then
		return self:getData("cg:loc");
	else
		return "en_US";
	end
end

function CPlayer:getLocalizationString(...)
	return getLocalizationString(self:getLocalization(), ...);
end

function CPlayer:onAdminGMX(iTime)
	local neededAdminLevel = 3
	if (self:getAdminLevel() >= neededAdminLevel) then
		if (iTime > 0.05) then
			outputChatBox("Der Server wird in "..math.round(iTime,2).." Minute(n) neu gestartet!", getRootElement(), 255,0,0, false)
			setTimer(
			function()
				CSystemManager:getInstance():gmx()
			end, iTime*60000, 1
			)
		else
			self:showInfoBox("error", "Bitte eine Zeit > 0.05 eingeben!")
		end
	else
		self:showInfoBox("error", "Dazu fehlt dir die Berechtigung!")
	end
end

--PD Funktionen

function CPlayer:OnCopLocatePlayer(tPlayerName)
	if not(clientcheck(self, client)) then return end
	if ( (self:getFaction():getType() == 1) and (self:isDuty()) ) then
		if (not (tPlayerName == "nil")) then
			local tPlayer = getPlayerFromPartialName(tPlayerName)
			if isElement(tPlayer) then
				local tx, ty, tz = tPlayer:getPosition()
				self:showInfoBox("info", "Dieser Spieler befindet sich in: "..getZoneName(tx, ty, tz).."!")
			else
				self:showInfoBox("error", "Dieser Spieler ist offline!")
			end
		else
			self:showInfoBox("error", "Bitte wähle einen Spieler aus!")
		end
	else
		self:showInfoBox("error", "Du bist kein Beamter im Dienst!")
	end
end

function CPlayer:OnCopDeleteWanted(tPlayerName, sReason)
	if not(clientcheck(self, client)) then return end
	if ( (self:getFaction():getType() == 1) and (self:isDuty()) ) then
		if (not (tPlayerName == "nil")) then
			local tPlayer = getPlayerFromPartialName(tPlayerName)
			if isElement(tPlayer) then
				if (tPlayer:getWanteds() > 0) then
					tPlayer:setWanteds(0)
					self:showInfoBox("info", "Du hast die Akte von "..tPlayerName.." geleert!")
					tPlayer:showInfoBox("warning", "Deine Akte wurde geleert. Grund: "..sReason..".")
					triggerClientEvent(self, "refreshPDComputerGui", self)

					CFaction:sendTypeMessage(1, getPlayerName(self).." leerte die Akte von "..getPlayerName(tPlayer)..".", 0,120,0)
					logger:OutputPlayerLog(self, "Leerte Akte", tPlayerName, sReason)

				else
					self:showInfoBox("error", "Dieser Spieler besitzt keine Wanteds!")
				end
			else
				self:showInfoBox("error", "Dieser Spieler ist offline!")
			end
		else
			self:showInfoBox("error", "Bitte wähle einen Spieler aus!")
		end
	else
		self:showInfoBox("error", "Du bist kein Beamter im Dienst!")
	end
end

addCommandHandler("clear",
	function(thePlayer, cmd, sName, swReason)
		if (isPedInVehicle(thePlayer) and getElementData(getPedOccupiedVehicle(thePlayer), "Fraktion") == 1) then
			thePlayer:OnCopDeleteWanted(sName, sReason)
		end
	end
)

function CPlayer:OnCopGiveWanted(tPlayerName, iCount, sReason)
	if not(clientcheck(self, client)) then return end
	if ( (self:getFaction():getType() == 1) and (self:isDuty()) ) then
		if (not (tPlayerName == "nil")) then
			local tPlayer = getPlayerFromPartialName(tPlayerName)
			if isElement(tPlayer) then
				if (tPlayer:getWanteds() < iCount) then
					tPlayer:setWanteds(iCount)
					self:showInfoBox("info", "Du hast "..tPlayerName.." "..tostring(iCount).." Wanted(s) gegeben!")
					tPlayer:showInfoBox("warning", "Du hast "..tostring(iCount).." Wanted(s) erhalten. Grund: "..sReason..".")
					triggerClientEvent(self, "refreshPDComputerGui", self)
					outputChatBox ( "Du hast "..tostring(iCount).." Wanted(s) von "..getPlayerName(self).." erhalten. Grund: "..sReason..".", tPlayer, 180, 0, 0 )

					CFaction:sendTypeMessage(1, getPlayerName(self).." gab "..getPlayerName(tPlayer).." "..tostring(iCount).." Wanted(s). Grund: ".. sReason, 0,120,0)
					logger:OutputPlayerLog(self, "Gab Wanteds an ", tPlayerName, sReason)
					tPlayer:incrementStatistics("Account", "Wanteds erhalten", iCount)
				else
					self:showInfoBox("error", "Dieser Spieler besitzt bereits angemessene Wanteds!")
				end
			else
				self:showInfoBox("error", "Dieser Spieler ist offline!")
			end
		else
			self:showInfoBox("error", "Bitte wähle einen Spieler aus!")
		end
	else
		self:showInfoBox("error", "Du bist kein Beamter im Dienst!")
	end
end

function CPlayer:OnCopGiveSTVO(tPlayerName, sReason)
	if not(clientcheck(self, client)) then return end
	if ( (self:getFaction():getType() == 1) and (self:isDuty()) ) then
		if (not (tPlayerName == "nil")) then
			local tPlayer = getPlayerFromPartialName(tPlayerName)
			if isElement(tPlayer) then
				if (tPlayer:addSTVO(1, sReason)) then
					self:showInfoBox("info", "Du hast einen STVO Punkt vergeben!")
					tPlayer:incrementStatistics("Account", "STVOs erhalten", 1)
				else
					self:showInfoBox("info", "Dieser Spieler besitzt keinen Führerschein!")
				end
			else
				self:showInfoBox("error", "Dieser Spieler ist offline!")
			end
		else
			self:showInfoBox("error", "Bitte wähle einen Spieler aus!")
		end
	else
		self:showInfoBox("error", "Du bist kein Beamter im Dienst!")
	end
end

addCommandHandler("stvo",
	function(thePlayer, cmd, sName, sReason)
		if (isPedInVehicle(thePlayer) and thePlayer:getFaction():getType() == 1) then
			thePlayer:OnCopGiveSTVO(sName, sReason)
		end
	end
)

function CPlayer:OnCopExaminePlayer(tPlayer)
	if not(clientcheck(self, client)) then return end
	if ( (self:getFaction():getType() == 1) and (self:isDuty()) ) then
		if (tPlayer.Handsup or tPlayer.Crack) then
			if (getDistanceBetweenElements3D(self,tPlayer) < 3) then
				if (table.size(tPlayer:getInventory():getIllegalItems()) >= 1) then
					self:showInfoBox("info", "Der Spieler besitzt illegale Gegenstände!")
				else
					self:showInfoBox("info", "Der Spieler besitzt keine illegale Gegenstände!")
				end
				tPlayer:showInfoBox("info", "Du wurdest durchsucht!")
			else
				self:showInfoBox("error", "Du bist zu weit entfernt!")
			end
		else
			self:showInfoBox("error", "Der Spieler lässt sich nicht durchsuchen!")
		end
	else
		self:showInfoBox("error", "Du bist nicht im Dienst!")
	end
end

function CPlayer:OnCopTakeIllegalThings(tPlayer)
	if not(clientcheck(self, client)) then return end
	if ( (self:getFaction():getType() == 1) and (self:isDuty()) ) then
		if (tPlayer.Handsup or tPlayer.Crack) then
			if (getDistanceBetweenElements3D(self,tPlayer) < 3) then
				if (table.size(tPlayer:getInventory():getIllegalItems()) >= 1) then
					tPlayer:getInventory():removeIllegalItems(true)
					self:showInfoBox("info", "Du hast dem Spieler alle illegale Gegenstände abgenommen!")
					tPlayer:showInfoBox("info", "Dir wurden alle illegale Gegenstände abgenommen!")
					tPlayer:refreshInventory()
					if (tPlayer:getWanteds() > 0) then
						takeAllWeapons(tPlayer)
					end
				else
					self:showInfoBox("info", "Der Spieler besitzt keine illegale Gegenstände!")
				end
			else
				self:showInfoBox("error", "Du bist zu weit entfernt!")
			end
		else
			self:showInfoBox("error", "Der Spieler lässt sich nichts abnehmen!")
		end
	else
		self:showInfoBox("error", "Du bist nicht im Dienst!")
	end
end


function CPlayer:OnPlayerBuyWeapon(sWeapon, iFilliale, iChain)
	if not(clientcheck(self, client)) then return end
	local WeaponIDs = {
		["9mm"] = 22,
		["Desert Eagle"] = 24,
		["Shotgun"] = 25,
		["Uzi"] = 28,
		["MP5"] = 29,
		["Country Rifle"] = 33,
		["AK-47"] = 30,
		["M4"] = 31,
		["Armor"] = 22,
	}

	local Weaponprices = {
		["Weapon"] = {
			["9mm"] = 450,
			["Desert Eagle"] = 1100,
			["Shotgun"] = 950,
			["Uzi"] = 1250,
			["MP5"] = 1750,
			["Country Rifle"] = 2150,
			["AK-47"] = 3450,
			["M4"] = 5500,
			["Armor"] = 450,
		}
	}

	if (getSlotFromWeapon(WeaponIDs[sWeapon]) and self:getWeapon(getSlotFromWeapon(WeaponIDs[sWeapon])) ~= WeaponIDs[sWeapon] ) or (sWeapon == "Armor") then
		local cost 		= Weaponprices["Weapon"][sWeapon];
		local canPay 	= true;
		if(self:getMoney() >= cost) then
			local intID = self.m_iCurIntID;
			local biz;
			if(intID ~= 0) and (InteriorShops[intID]) and (InteriorShops[intID].m_iBusinessID) then
				biz = cBusinessManager:getInstance().m_uBusiness[tonumber(InteriorShops[intID].m_iBusinessID)];
				if(biz) then
					canPay = (biz:getLagereinheiten() >= 0)
				end
			end
			if(canPay) then
				if (self:payMoney(cost)) then
					validPayed = true
					if(biz) then
						biz:removeOneLagereinheit()
						if(biz:getCorporation() ~= 0) then
							biz:getCorporation():addSaldo(math.floor(cost*0.50));
						end
					end
					if(sWeapon ~= "Armor") then
						self:addWeapon(WeaponIDs[sWeapon], getWeaponProperty ( WeaponIDs[sWeapon], "poor", "maximum_clip_ammo"), true)
					else
						self:setArmor(100)
					end
				end
			else
				self:showInfoBox("error", "Dieser Gegenstand ist nicht mehr Vorraetig! Die Corporation muss diesen Laden erst wieder auffuellen.")
			end
		else
			self:showInfoBox("error", "Du hast nicht genug Geld fuer diese Waffe!")
		end

		--[[
		if (self:payMoney(Weaponprices["Weapon"][sWeapon])) then
			self:addWeapon(WeaponIDs[sWeapon], getWeaponProperty ( WeaponIDs[sWeapon], "poor", "maximum_clip_ammo"), true)
			self:showInfoBox("info", "Du hast dir eine Waffe gekauft!")

			local geld 		= Weaponprices["Weapon"][sWeapon];
			local bekommen 	= math.floor(geld/100*50);

			if(BusinessChains[iChain]) and (BusinessChains[iChain][iFilliale]) then
				BusinessChains[iChain][iFilliale]:DepotMoney(bekommen, "Waffe gekauft");
			end
		end
		]]

	else
		self:showInfoBox("error", "Du besitzt diese Waffe bereits!")
	end
end

function CPlayer:OnPlayerBuyAmmo(sWeapon, iFilliale, iChain)
	if not(clientcheck(self, client)) then return end
	local WeaponIDs = {
		["9mm"] = 22,
		["Desert Eagle"] = 24,
		["Shotgun"] = 25,
		["Uzi"] = 28,
		["MP5"] = 29,
		["Country Rifle"] = 33,
		["AK-47"] = 30,
		["M4"] = 31
	}
	local Weaponprices = {
		["Ammu"] = {
			["9mm"] = 110,
			["Desert Eagle"] = 240,
			["Shotgun"] = 10,
			["Uzi"] = 270,
			["MP5"] = 320,
			["Country Rifle"] = 15,
			["AK-47"] = 450,
			["M4"] = 625
		}
	}
	if (self:getWeapon(getSlotFromWeapon(WeaponIDs[sWeapon])) == WeaponIDs[sWeapon] ) then
		--[[
		if (self:payMoney(Weaponprices["Ammu"][sWeapon])) then
			self:addAmmu(WeaponIDs[sWeapon], getWeaponProperty ( WeaponIDs[sWeapon], "poor", "maximum_clip_ammo"))

			local geld 		= Weaponprices["Ammu"][sWeapon];
			local bekommen 	= math.floor(geld/100*50);

			if(BusinessChains[iChain]) and (BusinessChains[iChain][iFilliale]) then
				BusinessChains[iChain][iFilliale]:DepotMoney(bekommen, "Waffe gekauft");
			end

			self:showInfoBox("info", "Du hast dir Munition gekauft!")
		end

		]]

		local cost 		= Weaponprices["Ammu"][sWeapon];
		local canPay 	= true;
		if(self:getMoney() >= cost) then
			local intID = self.m_iCurIntID;
			local biz;
			if(intID ~= 0) and (InteriorShops[intID]) and (InteriorShops[intID].m_iBusinessID) then
				biz = cBusinessManager:getInstance().m_uBusiness[tonumber(InteriorShops[intID].m_iBusinessID)];
				if(biz) then
					canPay = (biz:getLagereinheiten() >= 0)
				end
			end
			if(canPay) then
				if (self:payMoney(cost)) then
					validPayed = true
					if(biz) then
						biz:removeOneLagereinheit()
						if(biz:getCorporation() ~= 0) then
							biz:getCorporation():addSaldo(math.floor(cost*0.50));
						end
					end

					self:addAmmu(WeaponIDs[sWeapon], getWeaponProperty ( WeaponIDs[sWeapon], "poor", "maximum_clip_ammo"))
				end
			else
				self:showInfoBox("error", "Dieser Gegenstand ist nicht mehr Vorraetig! Die Corporation muss diesen Laden erst wieder auffuellen.")
			end
		else
			self:showInfoBox("error", "Du hast nicht genug Geld fuer diese Waffe!")
		end
	else
		self:showInfoBox("error", "Du besitzt diese Waffe nicht!")
	end
end

function CPlayer:OnPlayerBuySexWeapon(sSexWeapon)
	if not(clientcheck(self, client)) then return end
	local WeaponIDs = {
		["Blumen"] = 14,
		["Vibrator"] = 12,
		["Lilaner Dildo"] = 10,
		["Kurzer Dildo"] = 11
	}
	local Weaponprices = {
		["Weapon"] = {
			["Blumen"] = 25,
			["Vibrator"] = 175,
			["Lilaner Dildo"] = 150,
			["Kurzer Dildo"] = 150
		}
	}
	if (self:getWeapon(getSlotFromWeapon(WeaponIDs[sSexWeapon])) ~= WeaponIDs[sSexWeapon] ) then
		--[[
		if (self:payMoney(Weaponprices["Weapon"][sSexWeapon])) then
			self:addWeapon(WeaponIDs[sSexWeapon], 1, true)
			self:showInfoBox("info", "Du hast dir etwas gekauft!")
		end

		]]

		local cost 		= Weaponprices["Weapon"][sSexWeapon];
		local canPay 	= true;
		if(self:getMoney() >= cost) then
			local intID = self.m_iCurIntID;
			local biz;
			if(intID ~= 0) and (InteriorShops[intID]) and (InteriorShops[intID].m_iBusinessID) then
				biz = cBusinessManager:getInstance().m_uBusiness[tonumber(InteriorShops[intID].m_iBusinessID)];
				if(biz) then
					canPay = (biz:getLagereinheiten() >= 0)
				end
			end
			if(canPay) then
				if (self:payMoney(cost)) then
					validPayed = true
					if(biz) then
						biz:removeOneLagereinheit()
						if(biz:getCorporation() ~= 0) then
							biz:getCorporation():addSaldo(math.floor(cost*0.50));
						end
					end

					self:addWeapon(WeaponIDs[sSexWeapon], 1, true)
					self:showInfoBox("info", "Du hast dir etwas gekauft!")
				end
			else
				self:showInfoBox("error", "Dieser Gegenstand ist nicht mehr Vorraetig! Die Corporation muss diesen Laden erst wieder auffuellen.")
			end
		else
			self:showInfoBox("error", "Du hast nicht genug Geld fuer diese Waffe!")
		end
	else
		self:showInfoBox("error", "Du besitzt dieses Produkt bereits!")
	end
end

function CPlayer:OnTakeFactionSkin()
	if not(clientcheck(self, client)) then return end
	if (self.Fraktion:getType() ~= 1) then
		self:setSkin(self.Fraktion:getRankSkin(self.Rank))
		self:showInfoBox("info", "Skin gewechselt!")
	end
end

function CPlayer:OnOpenLeaderGui()
	if not(clientcheck(self, client)) then return end
	if (self:getRank() == 5) then
		local tFactionData = self.Fraktion:getData()
		local tFactionMembers = self.Fraktion:getMembers()
		triggerClientEvent(self, "showFactionLeaderGui", self, tFactionData, tFactionMembers)
	end
end

function CPlayer:OnLeaveFaction()
	if not(clientcheck(self, client)) then return end
	self:getFaction():removeMember(self:getName())
	self:showInfoBox("info","Du hast die Fraktion verlassen!")
end

function CPlayer:getInventory()
	return self.Inventory
end

function CPlayer:onUseItem(ItemID)
	if not(clientcheck(self, client)) then return end
	local Item = Items[ItemID]
	Item:use(self)
end



function CPlayer:onDeleteItem(ItemID, Amount)
	if not(clientcheck(self, client)) then return end
	local Item = Items[ItemID]
	Item:delete(self, Amount)
	local x,y,z = getElementPosition(self)
	self:meCMD("wirft einen schwarzen Muellbeutel weg...");
	self:showInfoBox("sucess", "Du hast "..Amount.." "..Item:getName().." weggeworfen!");
end

function CPlayer:refreshInventory()
	self:getInventory():refreshGewicht();
	triggerClientEvent(self, "onClientInventoryRecieve", self, toJSON(self:getInventory()), Items, ItemCategories)
end


function CPlayer:callNumber(Number)
	if (Phonenumbers[Number] and isElement(Phonenumbers[Number])) then
		if (Phonenumbers[Number] == self) then
			self:showInfoBox("error", "Man ruft sich nicht selber an!")
			return false
		end
		if (not Phonenumbers[Number].InTelephoneCall) and (not self.InTelephoneCall) then
			self.TelephoneCallName = getPlayerName(Phonenumbers[Number])
			Phonenumbers[Number].TelephoneCallName = getPlayerName(self)
			outputChatBox("Anruf von "..getPlayerName(self).." ("..self.Phonenumber.."). /accept zum Abnehmen!", Phonenumbers[Number], 255,140,0)
			outputChatBox("Warte auf Annahme!", self, 255,140,0)
			triggerClientEvent(Phonenumbers[Number], "onServerPlaySavedSound", getRootElement(), "/res/sounds/handy/ringtone.mp3", "Ringtone", false)
			triggerClientEvent(self, "onServerPlaySavedSound", self, "/res/sounds/handy/wartezeichen.mp3", "Wartezeichen", false)
			self.Called = true
			Phonenumbers[Number].Called = false
		else
			self:showInfoBox("info", "Besetzt!")
			triggerClientEvent(self, "onServerPlaySavedSound", self, "/res/sounds/handy/besetzt.mp3", "Besetzt", false)
		end
	else
		self:showInfoBox("error", "Kein Anschluss unter dieser Nummer!")
		triggerClientEvent(self, "onServerPlaySavedSound", self, "/res/sounds/handy/keinanschluss.mp3", "KeinAnschluss", false)
	end
end
addCommandHandler("call", function(thePlayer, cmd, Number) if(getElementData(thePlayer, "online")) then thePlayer:callNumber(tostring(Number)) end end)

function CPlayer:callAccept()
	if (self.TelephoneCallName) and (getPlayerFromName(self.TelephoneCallName)) then
		if (not getPlayerFromName(self.TelephoneCallName).InTelephoneCall) and (not self.InTelephoneCall) and (not self.Called) then
			getPlayerFromName(self.TelephoneCallName).InTelephoneCall = true
			self.InTelephoneCall = true
			setElementData(self, "CallingWith", self.TelephoneCallName)
			setElementData(self, "InCall", self.InTelephoneCall)
			setElementData(getPlayerFromName(self.TelephoneCallName), "CallingWith", getPlayerFromName(self.TelephoneCallName).TelephoneCallName)
			setElementData(getPlayerFromName(self.TelephoneCallName), "InCall", getPlayerFromName(self.TelephoneCallName).InTelephoneCall)
			triggerClientEvent(self, "onServerStopSavedSound", self,"Ringtone")
			outputChatBox("Abgehoben.", getPlayerFromName(self.TelephoneCallName), 255,140,0)
			outputChatBox("Angenommen.", self, 255,140,0)
		end
	end
end
addCommandHandler("accept", function(thePlayer, cmd) if(getElementData(thePlayer, "online")) then thePlayer:callAccept() end end)

function CPlayer:stopCall()
	if (self.InTelephoneCall) then
		if (getPlayerFromName(self.TelephoneCallName)) then
			getPlayerFromName(self.TelephoneCallName).InTelephoneCall = false
			getPlayerFromName(self.TelephoneCallName).TelephoneCallName = false
			setElementData(getPlayerFromName(self.TelephoneCallName), "CallingWith", getPlayerFromName(self.TelephoneCallName).TelephoneCallName)
			setElementData(getPlayerFromName(self.TelephoneCallName), "InCall", getPlayerFromName(self.TelephoneCallName).InTelephoneCall)
			outputChatBox("Aufgelegt.", getPlayerFromName(self.TelephoneCallName), 255,140,0)
		end
		self.InTelephoneCall = false
		self.TelephoneCallName = false
		setElementData(self, "CallingWith", self.TelephoneCallName)
		setElementData(self, "InCall", self.InTelephoneCall)
		outputChatBox("Aufgelegt.", self, 255,140,0)
	else
	end
end
addCommandHandler("hangup", function(thePlayer, cmd) if(getElementData(thePlayer, "online")) then thePlayer:stopCall() end end)

function CPlayer:sendSMS(Number, ...)

	local parametersTable = {...}
	local stringWithAllParameters = table.concat( parametersTable, " " )
	if stringWithAllParameters == nil then
		self:showInfoBox("error", "Du kannst keinen leeren Text senden!")
		return false
	elseif stringWithAllParameters == "" or stringWithAllParameters == " " or stringWithAllParameters == "  " then
		self:showInfoBox("error", "Du kannst keinen leeren Text senden!")
		return false
	end

	local text = stringWithAllParameters

	if (Phonenumbers[Number] and isElement(Phonenumbers[Number])) then
		if (Phonenumbers[Number] == self) then
			self:showInfoBox("error", "Das wäre dumm!")
			return false
		end
		if (self:payMoney(10)) then
			outputChatBox("SMS von "..getPlayerName(self).." ("..self.Phonenumber.."):", Phonenumbers[Number],255,140,0)
			outputChatBox(text, Phonenumbers[Number],255,140,0)
			self:showInfoBox("info", "SMS gesendet!")
			triggerClientEvent(Phonenumbers[Number], "onServerPlaySavedSound", self, "/res/sounds/handy/sms.mp3", "SMS", false)
		else
			self:showInfoBox("error", "Eine SMS kostet 10$!")
		end
	else
		self:showInfoBox("error", "Die SMS konnte nicht zugestellt werden!")
		triggerClientEvent(self, "onServerPlaySavedSound", getRootElement(), "/res/sounds/handy/keinanschluss.mp3", "KeinAnschluss", false)
	end
end
addCommandHandler("sms", function(thePlayer, cmd, Number, ...) if(getElementData(thePlayer, "online")) then thePlayer:sendSMS(Number, ...) end end)

addCommandHandler("number",
	function(thePlayer, cmd, Name)
		if (getPlayerFromPartialName(Name) and getElementData(getPlayerFromPartialName(Name), "online")) then
			outputChatBox("Der Spieler "..getPlayerName(getPlayerFromPartialName(Name)).." hat die Telefonnummer "..getPlayerFromPartialName(Name).Phonenumber..".", thePlayer, 255, 140, 0)
		else
			outputChatBox("Der Spieler existiert nicht!", thePlayer, 255,140,0)
		end
	end
)

-- Priorität

function onClientJoin()
	if not(clientcheck(source, client)) then return end
	setElementData(source, "online", false)
	local accs = CDatabase:getInstance():query("SELECT * FROM user WHERE Serial = ?", getPlayerSerial(source))
	if(accs) and ((#accs >= 1)) then
		setPlayerName(source, accs[1]["Name"])
	end

	setElementDimension ( source, 5 )
	fadeCamera( source, true)
	setCameraTarget( source, source )

	setCameraMatrix ( source, 1500.6999511719, -1580.9000244141, 1517.5, -1625, -1625, 42.900001525879, 0,0 )

	username = string.gsub(getPlayerName(source), '#%x%x%x%x%x%x', '')
	username = string.gsub(getPlayerName(source), '|', '')

	setPlayerName(source, username)

	enew(source, CPlayer)

	local result = CDatabase:getInstance():query("SELECT * FROM user WHERE Name=?",username)
	if(result) and (#result > 0) then
		if(DEFINE_DEBUG) then
			source:login()
		else
			triggerClientEvent(source, "onClientPlayerJoinBack", source, 1, 1, tblLoginSounds, randNMR)
		end
	else
		triggerClientEvent(source, "onClientPlayerJoinBack", source, 0, 0, tblLoginSounds, randNMR)
	end

end
addEvent("onClientJoin", true)
addEventHandler("onClientJoin", getRootElement(), onClientJoin)

addEventHandler("onPlayerConnect", getRootElement(), function(username, IP, playerUsername, Serial, playerVersionNumber, playerVersionString)
	local rtime = getRealTime()
	local result =CDatabase:getInstance():query("SELECT * FROM bans WHERE (Name=? OR Serial=? OR IP=?) AND expire_timestamp > ?", username, Serial, IP, rtime["timestamp"])
	if ((result and #result>0)) then
		local btime = getRealTime(result[1]["expire_timestamp"]) or 9999999999999999999

		if(tonumber(result[1]["Permanent"]) == 1) then
			cancelEvent( true, "Du wurdest von "..result[1]["banned_by"].." Permanent vom Spielen ausgeschlossen. Grund: "..result[1]["Grund"])
		else
			cancelEvent( true, "Du wurdest von "..result[1]["banned_by"].." bis zum "..tostring(btime.monthday).."."..tostring(btime.month+1).."."..tostring(btime.year+1900).." "..tostring(btime.hour)..":"..tostring(btime.minute)..":"..tostring(btime.second).." gebannt. Grund: "..result[1]["Grund"])
		end
	end

end
)

addEventHandler("onPlayerJoin", getRootElement(), function()
	setCameraMatrix(source, 1495.1999511719,-1636.8000488281,16.89999961853,1525.0999755859,-1661.5999755859,14.199999809265)


	-- Join Datas
	local function getFormatDate()
		local time = getRealTime()
		local day = time.monthday
		local month = time.month+1
		local year = time.year+1900
		local hour = time.hour
		local minute = time.minute
		if(day < 10) then
			day = "0"..day;
		end
		if(month < 10) then
			month = "0"..month;
		end
		if(hour < 10) then
			hour = "0"..hour;
		end
		if(minute < 10) then
			minute = "0"..minute;
		end

		return day.."."..month.."."..year.." "..hour..":"..minute;
	end

	local name = string.gsub(getPlayerName(source), '#%x%x%x%x%x%x', '')

	name = string.gsub(name, "'", '')

	-- MySQL --

	local serial = getPlayerSerial(source);

	local result = CDatabase:getInstance():query("SELECT * FROM joindata WHERE Serial = ?", serial);

	if not(result) or (#result < 1) then
		local herkunft = exports.admin:getPlayerCountry(source);
		if not(herkunft) then
			herkunft = "N/A"
		end
		local ip = getPlayerIP(source)
		local version = getPlayerVersion(source)
		local date = getFormatDate()

		CDatabase:getInstance():query("INSERT INTO joindata(Username, Herkunft, IP, Serial, Version, Lastseen, Timesjoined) VALUES ('"..name.."', '" ..herkunft.. "', '" ..ip.. "', '" ..serial.. "', '" ..version.. "', '" ..date.. "', '0');");
	else
		local serial = getPlayerSerial(source);
		local version = getPlayerVersion(source)
		local date = getFormatDate()
		local joins = tonumber(result[1]['Timesjoined'])+1
		CDatabase:getInstance():query("UPDATE joindata SET Version = '"..version.."', Lastseen = '"..date.."', Timesjoined = '"..joins.."' WHERE Serial = '"..serial.."';");
	end
end)

addEvent("getPlayerCheckInformation",true)

addEventHandler("getPlayerCheckInformation",getRootElement(),
function(name)
	if not(clientcheck(source, client)) then return end

	local result1 = CDatabase:getInstance():query("SELECT * FROM user WHERE Name=?",name)
	if ( (result1 and #result1 > 0) ) then
		triggerClientEvent(source,"givePlayerCheckInformation1",source,result1)
	else
		source:showInfoBox("error", "Spieler nicht gefunden!")
	end
	local result2 = CDatabase:getInstance():query("SELECT * FROM userdata WHERE Name=?",name)
	if ( (result2 and #result2 > 0) ) then
		triggerClientEvent(source,"givePlayerCheckInformation2",source,result2)
	end
	local result3 = CDatabase:getInstance():query("SELECT * FROM bans WHERE (Name=?) AND expire_timestamp > ?",name, getRealTime()["timestamp"])
	if ( (result3 and #result3 > 0) ) then
		triggerClientEvent(source,"givePlayerCheckInformation3",source,"Ja")
	else
		triggerClientEvent(source,"givePlayerCheckInformation3",source,"Nein")
	end
end
)

addEventHandler("onPlayerPasswortVergessen", getRootElement(), function(sEmail)
	local uPlayer = client;
	if(string.len(sEmail) > 2) and (isEmailCorrect(sEmail)) then
		local result = CDatabase:getInstance():query("SELECT * FROM user WHERE `E-Mail` = ?;", sEmail);
		if(result and #result > 0) then
			CDatabase:getInstance():query("UPDATE user SET Password = 'email', Salt = 'email' WHERE `E-Mail` = ?;", sEmail);

			fetchRemote("http://zaxon.istga.ga/php/passwort_vergessen.php", function(sData) uPlayer:showInfoBox("info", sData) end, sEmail, false)

			uPlayer:showInfoBox("sucess", "Du wirst innerhalb von 5 Minuten eine E-Mail erhalten!");
		else
			client:showInfoBox("error", "E-Mail wurde nicht in der Datenbank gefunden.")
		end
	else
		client:showInfoBox("error", "Ungueltige E-Mail Adresse!")
	end
end)


function antimsg(cmd)
	if(cmd == "msg") then
		cancelEvent()
	end
end
addEventHandler("onPlayerCommand",getRootElement(),antimsg)


weaponDamages = {}
weaponDamages[8] = 30
weaponDamages[22] = 9
weaponDamages[23] = 0
weaponDamages[24] = 22.5
weaponDamages[25] = 18
weaponDamages[26] = 9
weaponDamages[27] = 7.2
weaponDamages[28] = 13.5
weaponDamages[29] = 9
weaponDamages[32] = 13.5
weaponDamages[30] = 7.2
weaponDamages[31] = 5.4
weaponDamages[33] = 18
weaponDamages[34] = 45
weaponDamages[35] = 45
weaponDamages[36] = 40.5
weaponDamages[51] = 9

function damageCalcServer_func ( attacker, weapon, bodypart, loss, player )
	if attacker and weapon and bodypart and loss then
		if getElementType ( player ) == "player" then
			if weapon == 34 and bodypart == 9 then
				setPedHeadless(player, true)
				killPed ( player, attacker, weapon, bodypart )
				return false
			end
			if (weapon == 23)  then
				if (not isPedInVehicle(player)) and (not isPedInVehicle(attacker)) then
					player:showInfoBox("warning","Du wurdest getazert!")
					toggleAllControls(player, false)
					setPedAnimation(player, "CRACK", "crckdeth2", -1, true, false, false, true)
					player.Crack = true
					player:setData("crack", true)
					if(isTimer(player.crackTimer)) then killTimer(player.crackTimer) end
					player.crackTimer = setTimer(function() toggleAllControls(player, true) setPedAnimation(player) player.Crack = false player:setData("crack", false) player.CrackCounter = player.CrackCounter+1 end, 25000, 1)
					Achievements[82]:playerAchieved(attacker)
				end
				return false
			else
			--[[
				local basicDMG = weaponDamages[weapon]
				local dontDealDamage = false

				if not dontDealDamage then

					if weapon == 0 then
						if getPedFightingStyle ( attacker ) == 7 or getPedFightingStyle ( attacker ) == 15 or getPedFightingStyle ( attacker ) == 16 then
							loss = loss / 2
						end
					end

					local multiply = 1
					if bodypart == 3 or bodypart == 4 then
						multiply = 1.5
					elseif bodypart == 5 or bodypart == 6 then
						multiply = 0.8
					elseif bodypart == 7 or bodypart == 8 then
						multiply = 1.2
					elseif bodypart == 9 then
						multiply = 2
					end
					if ( (isElement(attacker)) and (getElementType(attacker) == "player") and (attacker:getFaction():getType() == 1) and ( attacker:isDuty() ) ) then
						multiply = multiply*1.2
					end
					if ( weaponDamages[weapon] ) then
						damagePlayer ( player, basicDMG * multiply, attacker, weapon, bodypart)
					else
						damagePlayer ( player, loss, attacker, weapon, bodypart)
					end
				end]]
			end
		end
	end
end
addEvent ( "qwertz", true )
addEventHandler ( "qwertz", getRootElement(), damageCalcServer_func )

local anti_kick_serials	= {
	["66266F5649C6BAF009245B3282E68D03"] = true,
	["68B1E35F4C22B078FFF78CC251333133"] = true,
}

addEventHandler("onPlayerKickHighPing", getRootElement(), function(iPing, iLimit)
	local kick = true;

	if(DEFINE_DEBUG) then
		kick = false;
	end

	if(DEFINE_EVENT_MODUS) then
		kick = false;
	end

	if(anti_kick_serials[getPlayerSerial(client)]) then
		kick = false
	end

	if(client) and (client.Rank) and (client:getAdminLevel() > 5) then
		kick = false; -- Anti Gunvarrel Kick, mein Internet ist scheisse ._.
	end
	if(kick) then
		kickPlayer(client, "Du wurdest wegen Highping gekickt! Ping: "..iPing..", limit: "..iLimit)
	end
end)

--[[
function damagePlayer ( player, amount, damager, weapon, bodypart)
	if isElement ( player ) then
		local armor = getPedArmor ( player )
		local health = getElementHealth ( player )
		if armor > 0 then
			if armor >= amount then
				setPedArmor ( player, armor - amount )
				--triggerEvent("onPlayerDamage", player, weapon, bodypart, amount )
			else
				setPedArmor ( player, 0 )
				amount = math.abs ( armor - amount )
				setElementHealth ( player, health - amount )
				--triggerEvent("onPlayerDamage", player, weapon, bodypart, amount )
				if getElementHealth ( player ) - amount <= 0 then
					killPed ( player, damager, weapon, 3, false )
				end
			end
		else
			if getElementHealth ( player ) - amount <= 0 then
				killPed ( player, damager, weapon, 3, false )
			end
			setElementHealth ( player, health - amount )
			--triggerEvent("onPlayerDamage", player, weapon, bodypart, amount )
		end
	end
end
]]
local spammingcommands = {
	["sms"] 	= 3000,
	["call"] 	= 3000,
	["geige"] 	= 10000,
	["o"] 		= 3000,
	["respawn"] = 5000,
	["pay"] 	= 1000,
	["s"]		= 3000,
	["meCMD"]	= 3000,

}

addEventHandler("onPlayerCommand", getRootElement(),
	function(cmd)
		if(source) and (source.Rank) and (source:getAdminLevel() < 4) then
			if (spammingcommands[cmd]) then
				if (not source.lastCommand) then
					source.lastCommand = getTickCount()-5000
				end

				if (getTickCount() - source.lastCommand > 2000) then
					source.lastCommand = getTickCount()
				else
					cancelEvent()
					source.lastCommand = getTickCount()
					source:showInfoBox("error", "Dafür musst du mindestens 2 Sekunden warten.")
				end
			end
		end
	end
)
