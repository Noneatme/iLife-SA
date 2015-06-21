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


cFunc["create_objects"] = function()
	-- TODO: Remove Static Method Calls

--	mapManager              = cMapManager:new();
	EasterEgg 				= new(CEasterEgg)
    corporationManager		= cCorporationManager:new();

	noDMZonenManager		= NoDMZonenManager:New();
	prestigeManager			= PrestigeManager:New();

	gateLoader				= GateLoader:New();
	serverSettings			= ServerSettings:New();
	serverTrains			= ServerTrains:new();

	radialMenuManager 		= RadialMenuManager:New();
	churchBellManager 		= ChurchBellManager:New();
	carStart 				= CarStart:New();
	vehicleCategoryManager = cVehicleCategoryManager:new()

	aussichtsPunkt 			= AussichtsPunkt:new();

	animationManager		= AnimationManager:New();
	tuningGarageManager 	= TuningGarageManager:New();
	boneAttachManager 		= BoneAttachManager:New();
	objectMover				= ObjectMover:New();

	if not(DEFINE_DEBUG) then
		moveableObjectLoader	= MoveableObjectLoader:new();
	end
	furnitureRemover		= FurnitureRemover:New();
	mainMenuManager			= MainMenuManager:New();
	customSirenManager		= CustomSirenManager:New();
	carWashManager			= CarWashManager:New();
	offlineMSGManager		= OfflineMSGManager:New();

	einkaufszentrum			= Einkaufszentrum:New();

	-- Fraktionen
	-- News
	ofactions				= {};
	ofactions.News			= NewsFaction:New();
	ofactions.Mechanic		= MechanicFaction:New();
	containerJob			= ContainerJob:New();
	sniper					= Sniper:New();
	weatherManager			= WeatherManager:new();

	waffentruckManager      = cWaffentruckManager:new();
	fireworkManager         = cFireworkManager:new();

	gamemodeManager			= cGamemodeManager:new();
	oocChat					= cOOCChat:new();
	marketManager			= cMarketManager:new();



	cWortFilter:new();
	cTruckerJob:new()
	cBusinessManager:new();
	cMapRemovalsManager:new();			-- Singleton

	gamemodeManager:addLobby(1, 11, "Default Lobby 1", 32, -1, 0, "Standart", 30000, true, true)
	gamemodeManager:addLobby(1, 12, "Default Lobby 2", 32, -1, 0, "Standart", 30000, true, true)

	DrugCookJob             = new(CDrugCookJob)

	-- Fahrzeuge --
	for i = 400, 611, 1 do
		downloadManager:AddFile("res/images/vehicles/"..i..".jpg");
    end

    -- Skins

    for i = 1, 312, 1 do
        downloadManager:AddFile("res/images/hud/skins/"..i..".jpg");
    end



	-- FACTIONS --
	cSpecialForce:new();

	cArtifactManager:new();
	cAsservatenkammer:new();
	cServerInfoRenderer:new();
end

CObjectCreator = {}
CObjectCreator.public = {}
CObjectCreator.public["create_objects"] = cFunc["create_objects"]

-- EVENT HANDLER --
