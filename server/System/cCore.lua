--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

-- #######################################
-- ## Project: MTA iLife				##
-- ## Name: cCore.lua					##
-- ## Author: Audifire					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

cCore = inherit(cSingleton)
cCore.tManager = {
	-- // world \\ --
	"cInformationWindowManager",
	-- // Player Specific Managers \\ --
	"CInventoryManager",
	"CFactionManager",
	-- // Item Specific Managers \\ --
	"CItemCategoryManager",
	"CItemManager",
	"CItemShopManager",
	"CCraftingManager",
	"CChainManager",
	-- // Vehicle Specific Managers \\ --
	"CUserVehicleManager",
	"CNoobcarsManager",
	"CVehicleShopManager",
	-- // Other Managers \\ --
	"CInfoPickupManager",
	"CDriveInManager",
	"CInteriorManager",
	"CHouseManager",
	"CAdManager",
	"CBankVendorManager",
	"CPayNSprayManager",
	"CAchievementManager",
	"CTrashcanManager",
	"CSupportTicketManager",
	"CQuestManager",
	"cDrugManager",

}

DEFINE_DEBUG		= false

-- Event Modus, Umstellbar bei der LTR
DEFINE_EVENT_MODUS	= false

function cCore:constructor()
	outputDebugString("[".._Gsettings.serverName.." - Start Sequence] Script starting now!")

	self.iStart = getTickCount()
	self.strIP = ""

	for index, player in pairs(getElementsByType("player")) do
		local tbl = getAllElementData(player)
		for index, key in pairs(tbl) do
			setElementData(player, index, nil)
		end
		setElementDimension(player, 0)
		setElementInterior(player, 0)
	end

	self:checkServerIP()
end

function cCore:destructor()
	outputDebugString("[".._Gsettings.serverName.." - Stop Sequence] Script stopping now!")
end

function cCore:checkServerIP ()
	--callRemote("http://www.ilife-sa.de/serverUtil.php", bind(cCore.returnIP, self))
	self:returnIP("Override")
end

function cCore:returnIP (result)
	if (result and #result >= 7 and #result <= 15) then
		self.strIP = result
	end
	self:loadServer()
end

function cCore:loadServer()
	outputDebugString("[".._Gsettings.serverName.." - Start Sequence] IP recognized: " .. tostring(self.strIP))
	mapManager              = cMapManager:new();
	downloadManager 		= DownloadManager:New();

	-- // Define Server Type with IP \\ --
	for i, v in ipairs(cCore.tServerTypes) do
		if (v["fCheck"](self.strIP)) then
			DEFINE_DEBUG = v["bDebug"]
			CDatabase:new(v["strType"], v["strHost"], v["strUser"], v["strPass"], v["strDB"], v["iPort"])
			CSystemManager:new(v["iDBID"])
			outputDebugString("[".._Gsettings.serverName.." - Start Sequence] Starting ".._Gsettings.serverName.." server now! (" .. v["strName"] .. ")")
			break
		end
	end

	logger = Logger:New();

	-- // Debug Execution \\ --
	if (DEFINE_DEBUG) then
		load_commands_func();
	end

	-- // Loading Managers \\ --
	self:initUtils()
	for i, v in ipairs(cCore.tManager) do
		if (type(_G[v]) == "table") then
			_G[v]:new(--[[unpack(v)]])
		else
			outputServerLog("Could not find Manager: "..v)
			stopResource(getThisResource())
		end
	end

	CUserVehicleManager:getInstance():startThread();
	CInteriorManager:getInstance():createMarkers()


	--NPCManager 			= new(CNPCManager)

	-- // No Managers \\ --


	CObjectCreator.public["create_objects"]()

	outputDebugString("[iLife - Start Sequence] Script started in " .. math.floor((getTickCount() - self.iStart) / 1000) .. " sec")
end

function cCore:initUtils()
	local res = CDatabase:getInstance():query("SELECT ID, Name FROM user")
	for k,v in ipairs(res) do
		PlayerNames[v["ID"]] = v["Name"]
		PlayerIDS[v["Name"]] = v["ID"];
	end
	outputServerLog("Es wurden "..#res.. " Spieler gefunden!")

	local vehicle_preise_result = CDatabase:getInstance():query("SELECT VID, Price FROM shop_vehicle_data ORDER BY Price DESC;")
	if(vehicle_preise_result) then
		for index, data in pairs(vehicle_preise_result) do
			global_vehicle_preise[tonumber(data["VID"])] = tonumber(data["Price"]);
		end
	end
end

-- // Commands \\ --
function cCore.cmd_rm(uPlayer, strCommand, strManager, ...)
	if (uPlayer:getAdminLevel() >= 2) then
		_G[strManager]:new(...)
	end
end
addCommandHandler("rm", cCore.cmd_rm, false, false)


-- EVENT HANDLER --
addEventHandler("onResourceStart", getResourceRootElement(), bind(new,cCore), true, "high+9999")
--addEventHandler("onResourceStop", getResourceRootElement(), function () delete(cCore:getInstance()) end, true, "high+9999")


-- // Server Information Table \\ --
cCore.tServerTypes = {}

-- // Live Server \\ --
-- -----------------------
-- HIER DATEN EINTRAGEN!
local iID = #cCore.tServerTypes + 1
cCore.tServerTypes[iID] = {}
cCore.tServerTypes[iID]["fCheck"] = function (strIP) return true end	-- return true, damit der Server diese Konfiguration erkennt
cCore.tServerTypes[iID]["iDBID"] = 1
cCore.tServerTypes[iID]["strName"] = "normal"
cCore.tServerTypes[iID]["strType"] = "mysql"
cCore.tServerTypes[iID]["strHost"] = "127.0.0.1" -- host
cCore.tServerTypes[iID]["strUser"] = "db_mta" -- username
cCore.tServerTypes[iID]["strPass"] = "" -- password
cCore.tServerTypes[iID]["strDB"] = "db_mta_ilife" -- database
cCore.tServerTypes[iID]["iPort"] = 3306
cCore.tServerTypes[iID]["bDebug"] = false