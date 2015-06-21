--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

-- #######################################
-- ## Project: 							##
-- ## Name: Script.lua					##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings


GLOBAL_INSTANCES	= {}


cFunc["disable_events"] = function()
	-- Heli Kill Deaktivieren --
	addEventHandler("onClientPlayerHeliKilled", getLocalPlayer(), cancelEvent)
end

cFunc["create_objects"] = function()
	outputConsole("[CORE] [".._Gsettings.serverName.." Client Files, Source Code (C) Copyright 2013-2015, iLife-SA Team and Developers]")
	outputConsole("[CORE] Loading ".._Gsettings.serverName.." Core...");
	local startTick		= getTickCount()

	cFunc["disable_events"]();

	cSetting["tick"]			= getTickCount();
	config						= cConfiguration:new();

	cConfig_RadioConfig:new();
	cConfig_ModList:new()
	cConfig_Friendlist:new()

	configuration				= config;
	mapManager          		= cMapManager:new();
	fontManager         		= cFontManager:new();
	hud 						= Hud:New()
	customRain 					= CustomRain:New();
	churchBell					= ChurchBell:New();
	nametags					= cNameTags:new();
	userVehicleManager			= UserVehicleManager:New();
	confirmDialog				= ConfirmDialog:new();
	helpDialog					= HelpDialog:New();
	emenu 						= EMenu:New();
	carStart 					= CarStart:New();
	trainCrossManager 			= TrainCrossManager:New();
	aussichtsPunkt				= AussichtsPunkt:New();
	tuningGarage 				= TuningGarage:New();
	vehicleCategoryManager = cVehicleCategoryManager:new()
	downloadManager 			= DownloadManager:New();
	logger 						= Logger:New();
	trafficLightManager 		= TrafficLightsManager:New();
	objectMover					= ObjectMover:New();
	easterEgg					= EasterEgg:New();
	houseNameRenderer			= HouseNameRenderer:New();
	factionNameRenderer			= FactionNameRenderer:New();
	prestigeNameRenderer		= PrestigeNameRenderer:New();
	BusinessNameRenderer:new();

	noDMZonenManager			= NoDMZonenManager:New();
	pedBloodManager				= PedBloodManager:New();
	ego							= Ego:New();
	einkaufszentrum				= Einkaufszentrum:New();
	userTextures				= UserTextures:New();
	customWorldTextures			= CustomWorldTextures:New();
	moveableObjectExtraManager	= MoveableObjectExtraManager:New();
	mainMenu					= MainMenu:new();
	customVehicleDirtManager	= CustomVehicleDirtManager:New();
	carWashManager				= CarWashManager:New();
	containerJob				= ContainerJob:New();
	sniper						= Sniper:New();
	prestigeGUI					= PrestigeGUI:New();
	businessGUI					= BusinessGUI:New();
	loadingSprite               = cLoadingSprite:new();
	waffentruckManager          = cWaffentruckManager:new();
	bloodScreen                 = cBloodScreen:new();
	insanityShader				= Insanity_Shader:New()
	deathManager				= cDeathManager:new();
	helicam 					= cHelicopterCam:new();
	modellImporter				= cModellImporter:new();
	radarFalle					= cRadarfalle:new();
	attacher					= cAttach:new();
	serverTrains				= cServerTrains:new();
	drugManager					= cDrugManager:new();
	gamemodeManager				= cGamemodeManager:new();
	oocChat						= cOOCChat:new();
	airBreak					= cAirBreak:new();
	marketGUI					= cMarketGUI:new();

    -- CORPORATIONS --
	corpGui						= cCorporationGUI:new();
	corpCreateGUI				= cCreateCorporationGUI:new();
    viewCorpGUI                 = cViewCorporationGUI:new()
    curCorpGUI                  = cCorporationManagementGUI:new();
    cCorporationHRManagementGUI:new();  -- SINGLETON
	cCorporationPRManagementGUI:new()
	cCorporationFinanzManagementGUI:new()
	cCorporationStorageManagementGUI:new();
	cCorporationProductionManagementGUI:new();

	cItemManager:new();

	cInventoryGUI:new();			-- Singleton

	cTempomatManager:new();
	cWortFilter:new();
	cPaydayGUI:new();
	c3DRadioManager:new();
	cRadioManager:new();
	cArtifactScannerGUI:new();
	cAFKManager:new();
	cTruckerJob:new()
	cRegisterWindowGUI:new();
	cAsservatenkammerGUI:new();
	cAdManager:new();

	-- CONFIGS --

	--danceGame = DanceGame:New();
	--danceGameCreator = DanceGameCreator:New();

	-- Sound Manager --
	soundManager				= {};
	soundManager.punchSound 	= PunchSoundManager:New();
	soundManager.vehicleSound 	= CustomVehicleSoundManager:New();
	soundManager.weaponSound	= CustomWeaponSoundManager:New();

	-- FACTIONS --
	ofactions					= {};
	ofactions.newsFaction		= NewsFaction:New();
	ofactions.Mechanic			= MechanicFaction:New();

	-- SLOTMACHINE --
	slotmachine_Settings		= Slotmachine_Settings:New();
	Texture_Importer:New();

	colorPicker.constructor(colorPicker.default)

	triggerServerEvent("onClientSlotmachinesGet", localPlayer);

	-- Benutzung: --
	----------------
	--
	-- customRain:Enable(bool Thunder);	-> Mit oder ohne Blitz, true oder false eintragen
	-- -> Ins Wettersystem damit
	-- customRain:Disable();
	--

	-- AFTER DOWNLOAD MANAGERS --
	outputConsole("[CORE] Object Instancing took "..((getTickCount()-startTick)/1000).." seconds")
end


-- EVENT HANDLER --
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), cFunc["create_objects"]);

addEventHandler("onClientDownloadFinnished", localPlayer, function()
	fireworkManager             = cFireworkManager:new()
	highpingManager             = cHighpingManager:new();
	cServerInfoRenderer:new();


	outputConsole("[CORE] Loading took "..((getTickCount()-cSetting["tick"])/1000).." Seconds");
end)
