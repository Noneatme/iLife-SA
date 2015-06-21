--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

--
-- Created by IntelliJ IDEA.
-- User: Noneatme
-- Date: 07.02.2015
-- Time: 23:30
-- To change this template use File | Settings | File Templates.
--

-- Wozu diese Datei?
-- Diese Einstellungsdatei existiert Client und Serverseitig. Sie wurde von mir (Gunvarrel, Noneatme, Multivan was auch immer)
-- erstellt um Leuten, welche sich nicht mit dem Script auskennen, die Moeglichkeit zu geben, Einstellungen einfach zu aendern.
-- Diese Datei wurde jedoch erst spaeter erzeugt (Mit dem Lobbysystem) und viele Einstellungen wurden statisch in das Script integriert.


-- BITTE NUR DIE EINSTELLUNGEN AENDERN FALLS DIE PERSON AHNUNG HAT, WAS SIE TUT! --

_Gsettings          = {}

_Gsettings.serverName       = "iLife";                      -- Globaler Name (Wird im Script verwendet)
_Gsettings.scriptVersion    = "1.2.9";                   -- Script Version, unten Links
_Gsettings.mapName          = "iLife 2015";                 -- Map Name, in MTA Serverliste
_Gsettings.gameName         = "German Roleplay";            -- Gamemode Name, in MTA Liste
_Gsettings.iCurRevision     = 166                            -- Zurzeitige Revision
_Gsettings.iFPS             = 60;                           -- FPS

setFPSLimit(_Gsettings.iFPS);

_Gsettings.boardURL         = "www.ilife-sa.de"             -- Board URL

if(setMapName) then
    setMapName(_Gsettings.mapName);
    setGameType(_Gsettings.scriptVersion)
    _Gsettings.server       = true;
end

_Gsettings.hallOfGames              = {}                    -- Hall of Games
_Gsettings.hallOfGames.musicURL     = ""                    -- Music URL (Unbenutzt )

_Gsettings.gmaxOfflineTime  = (     (4*31)   	*24*60*60)  -- Maximale Offlinezeit (4 Monate)

_Gsettings.gameModeMaps =                                   -- Gamemode Maps
{
    [1] =
    {
        [11] = {"BloodBowl", 11},
        [12] = {"Field", 12},
        [13] = {"Farm 1", 13},
    },
    [2] =
    {
        [21] = {"Sample Race", 21},
        [22] = {"Sample Race 2", 22},
    },
    [3] =
    {
        [31] = {"Sample DM", 31},
        [32] = {"Sample DM Map 2", 32},

    },

    [4] =
    {
        [41] = {"Sample CTF", 41},
        [42] = {"Sample CTF Map 2", 42},
    }
}

_Gsettings.gameModes =                                  -- Gamemode Types
{
    "Derby",
    "Race",
    "Deathmatch",
    "Capture the Flag",
}


_Gsettings.keys             = {}                        -- BINDS
_Gsettings.keys.HelpMenu    = "F1"                      -- Helpmenu auf F1
_Gsettings.keys.HudDesigner = "F2"                      -- Und so Weiter
_Gsettings.keys.Adminpanel  = "F3"
_Gsettings.keys.WantedCP    = "F4"
_Gsettings.keys.Fraktion    = "F5"
_Gsettings.keys.Handy       = "F6"
_Gsettings.keys.Vehicles    = "F7"
_Gsettings.keys.Console     = "F8"                      -- Unbenutzt, Hardcoded von MTA
_Gsettings.keys.Market      = "F9"
_Gsettings.keys.Corps       = "F10"

_Gsettings.keys.Inventory   = "i"


_Gsettings.corporation      = {}                        -- CORPORATIONS STUFF
_Gsettings.corporation.iMaxIcons            = 187;      -- Maximale Icons zum Auswaehlen
_Gsettings.corporation.iMaxBackgrounds      = 23;       -- Maximale Backgrounds zum auswaehlen
_Gsettings.corporation.iPriceToCreate       = 250000;   -- Preis wieviel eine Corporation kosten soll

_Gsettings.corporation.roles                =
{
    [0]         = "CEO",                                -- Die Rollen, hier Rollennamen
    [1]         = "Deputy CEO",                         -- Koennen hier geaendert werden (Ich empfehle sie so zu lassen)
    [2]         = "HR manager",
    [3]         = "PR manager",
    [4]         = "Financial officier",
    [5]         = "Storage operator",
    [6]         = "Production manager",
}

_Gsettings.corporation.rolesShort  =                    -- Short names der Corporationen
{
    [0]         = "CEO",
    [1]         = "DCEO",
    [2]         = "HRM",
    [3]         = "PR",
    [4]         = "FIN",
    [5]         = "STR",
    [6]         = "PRM",
}

_Gsettings.corporation.playerSlotCost               = {}
_Gsettings.corporation.playerSlotCostIncrement      = 750;      -- Kosten Pro CORP Spielerslot
_Gsettings.corporation.vehicleSlotCost              = {}
_Gsettings.corporation.vehicleSlotCostIncrement     = 2500;     -- Kosten Pro CORP Fahrzeugslot
_Gsettings.corporation.houseSlotCost                = {}
_Gsettings.corporation.houseSlotCostIncrement       = 55000;    -- Kosten Pro CORP Hausslot
_Gsettings.corporation.businessSlotCost             = {}
_Gsettings.corporation.businessSlotCostIncrement    = 15000;    -- Kosten Pro CORP Businessslot

for i = 1, 100, 1 do
    _Gsettings.corporation.playerSlotCost[i]    = _Gsettings.corporation.playerSlotCostIncrement*i;
    _Gsettings.corporation.vehicleSlotCost[i]   = _Gsettings.corporation.vehicleSlotCostIncrement*i;
    _Gsettings.corporation.houseSlotCost[i]     = _Gsettings.corporation.houseSlotCostIncrement*i;
    _Gsettings.corporation.businessSlotCost[i]  = _Gsettings.corporation.businessSlotCostIncrement*i;
end

_Gsettings.corporation.businessIncomeMultiplicator  = 0.0005;       -- Business Income Multiplikator, wieviel Einkommen man pro Biz die Stunde macht


_Gsettings.corporation.findRolesFunction    = function(sRole)
    for id, role in pairs(_Gsettings.corporation.roles) do
        if(role == sRole) then
            return id;
        end
    end
    return false;
end

--[[
--Members
Next to the corporation's members, you can see their roles. Roles in a corporation are:

CEO - The founder of the corporation will become the only CEO of the corporation. He or she cannot be demoted by anyone, only the CEO can transfer the right to another member. The CEO also possesses each of the roles listed below.

Deputy CEO - Can only be promoted by the CEO, and like him/her the deputy has the same (below listed) privileges. Not even the Deputy can demote the CEO. There is no limit on the number of Deputy CEOs.

HR (human resource) manager - Manages the corporation's manpower. The HR manager can invite other Agents, accept incoming applications, edit the recruitment form, or sack current members.

PR (public relations) manager - He or she creates the image of the corporation. The PR manager can edit the corporation's logo, public description, the recruitment form, and the corporation bulletins

Financial officer - Responsible for the corporation's financial status. The accountant can edit the tax rate, transfer money to a member, extend the corporation containers' lease period, and pay from the corporation's account when buying items on the market. Also handles corporation insurances.

Production manager - Entitled to use the corporation's account when using a terminal/outpost service (e.g. manufacturing cost in factory)

Delegate - When an Agent opens the corporation profile, the delegates are displayed there. The official way to contact a corporation is to contact a delegate personally.

Storage operator - Each corporation can lease storages on each terminal/outpost where the corporation members can store and share items. The operator can edit a storage's name, access level, and logging. He or she can also create folders in them.

 ]]


_Gsettings.userWerbenUserBelohnunugen   =
{
    [1] = "Sodaautomat",                                -- Die Belohnungen pro Geworbenen User
    [2] = "Sozialer Status: Der Hammer!",
    [3] = "Westernhut & Partyhut",
    [4] = "Werbeicon neben dem Namen",
    [5] = "Eigene Corporation nach Wahl",
    [6] = "Hausmarker nach Wahl",
    [7] = "10000 EP",
    [8] = "Fahrzeug: Turismo",
    [9] = "Fahrzeug aus Liste nach Wahl",
    [10] = "Doppelter Payday",
}

_Gsettings.huete_models      =                          -- HUETE MODELLE
{
    [282]       = {2320, 0, 0, 0, 0, 0, 180},               -- Hut: Glotze
    [277]       = {3082, 0, 0, 0.2, 0, 0, 0},               -- Hut: Sombrero
    [287]       = {2797, 0, -0.010, 0.08, 0, 0, 0},         -- Baseballcap
    [276]       = {2751, 0, 0.05, 0.04, 0, 0, 180},         -- Fedora
    [278]       = {2750, 0, 0.05, 0.04, 0, 0, 180},         -- Bauarbeiterhelm
    [288]       = {2792, 0, 0.035, 0.08, 0, 0, 180},        -- Business
    [281]       = {2798, 0, 0.035, 0.13, 0, 0, 180},        -- Partyhut
    [284]       = {2149, 0, 0, 0.05, 0, 0, 180},            -- Mikrowelle
    [279]       = {3898, 0, 0.025, 0.16, 0, 0, 0},          -- Cowboyhut
  --  [289]       = {3897, 0.005, 0.070, 0.08, 0, 0, 180},  -- iLife Cap
    [289]       = {3897, 0, -0.010, 0.08, 0, 0, 0},         -- iLife cap
    [283]       = {1238, 0, 0, 0.15, 0, 0, 0},              -- Kegel
    [285]       = {2738, 0, 0, 0.7, 0, 0, 180},               -- Toilette

}
_Gsettings.huete_models_find_func   = function(iModell)
    iModell = tonumber(iModell)
    for id, tbl in pairs(_Gsettings.huete_models) do
        if(tbl[1] == iModell) then
            return id;
        end
    end
    return 0;
end
_Gsettings.persistentMarketCategories   =               -- Persistente Marketkategorien
{
    ["- Neuwagen"]        = {[1] = 1337},
    ["- Gebrauchtwagen"]  = {[1] = 1338},
    ["- Immobilien"]      = {[1] = 1339},
}

for i = 400, 611, 1 do
    _Gsettings.persistentMarketCategories["- Neuwagen"][i] = getVehicleNameFromModel(i);
    _Gsettings.persistentMarketCategories["- Gebrauchtwagen"][i] = getVehicleNameFromModel(i);
end

_Gsettings.hallOfGamesSpawn = {1803.5140380859, -1306.9649658203, 120.25859832764}  -- Der Hall of Games Spawn

if(triggerServerEvent) then
    addEventHandler("onClientPreRender", getRootElement(), function()
        local x, y = guiGetScreenSize()
        dxDrawText("* ".._Gsettings.serverName.." ".._Gsettings.scriptVersion.." (rev. ".._Gsettings.iCurRevision..")", 1, y-15, 1, y, tocolor(255, 255, 255, 150))
    end)

    addEvent("onClientPlayerReceiveServerInfos", true)
    addEventHandler("onClientPlayerReceiveServerInfos", getLocalPlayer(), function(bDebug)
        if(bDebug) then
            _Gsettings.scriptVersion = _Gsettings.scriptVersion.."_Development"
            DEFINE_DEBUG = true
        else
            _Gsettings.scriptVersion = _Gsettings.scriptVersion.."_Live"
        end
    end)

    triggerServerEvent("onPlayerRequestServerInfos", localPlayer)
else
    addEvent("onPlayerRequestServerInfos", true)
    addEventHandler("onPlayerRequestServerInfos", getRootElement(), function()
    	local uPlayer = client;

    	triggerClientEvent(client, "onClientPlayerReceiveServerInfos", client, DEFINE_DEBUG)
    end)
end
