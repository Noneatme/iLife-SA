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
-- Date: 27.01.2015
-- Time: 18:49
-- To change this template use File | Settings | File Templates.
--

cModellImporter = {};

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function cModellImporter:new(...)
    local obj = setmetatable({}, {__index = self});
    if obj.constructor then
        obj:constructor(...);
    end
    return obj;
end

-- ///////////////////////////////
-- ///// Replace     		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cModellImporter:replace()
    for id, tbl in pairs(self.models) do
        if(tbl[5] == true) then
            self:doActivateMod(id);
        end
    end
end

-- ///////////////////////////////
-- ///// getAllMods   		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cModellImporter:getAllMods()
    return self.models;
end

-- ///////////////////////////////
-- ///// isModActivated 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cModellImporter:isModActivated(iID)
    return self.m_bModActivated[iID];
end

-- ///////////////////////////////
-- ///// isModDownloaded     //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cModellImporter:isModDownloaded(iID)
    iID = tonumber(iID)
    local path      = self.models[iID][2]..self.models[iID][1];
    local down      = true
    if(self.models[iID][4][1]) then
        if not(fileExists(path..".dff")) then
            down = false
        end
    end
    if(self.models[iID][4][2]) then
        if not(fileExists(path..".txd")) then
            down = false
        end
    end
    if(self.models[iID][4][3]) then
        if not(fileExists(path..".col")) then
            down = false
        end
    end
    return down;
end

-- ///////////////////////////////
-- ///// downloadMod         //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cModellImporter:downloadMod(iID)
    iID = tonumber(iID)
    local path      = self.models[iID][2]..self.models[iID][1];
    if(self.models[iID][4][1]) then
        downloadManager:addDownloadFile(path..".dff")
        self.m_tblDownloadList[path..".dff"] = true;
    end
    if(self.models[iID][4][2]) then
        downloadManager:addDownloadFile(path..".txd")
        self.m_tblDownloadList[path..".txd"] = true;
    end
    if(self.models[iID][4][3]) then
        downloadManager:addDownloadFile(path..".col")
        self.m_tblDownloadList[path..".col"] = true;
    end

    self.modDownloading[iID] = true;
end

-- ///////////////////////////////
-- ///// doActivateMod     	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cModellImporter:doActivateMod(iID)
    local tbl       = self.models[iID]
    local path      = tbl[2]..""..tbl[1];

    if(fileExists(path..".col")) then
        engineReplaceCOL(engineLoadCOL(path..".col"), iID);
    end
    if(fileExists(path..".txd")) then
        self.m_tblTxds[iID] = engineLoadTXD(path..".txd")
        engineImportTXD(self.m_tblTxds[iID], iID);
    end
    if(fileExists(path..".dff")) then
        engineReplaceModel(engineLoadDFF(path..".dff", iID), iID);
    end

    outputConsole("Mod Activated: "..path)
    downloadManager.downloading = false;
    self.m_bModActivated[iID] = true;
end

-- ///////////////////////////////
-- ///// doDeactivateMod     //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cModellImporter:doDeactivateMod(iID)
    engineRestoreModel(iID);
    engineRestoreCOL(iID);
    if(self.m_tblTxds[iID]) then
        destroyElement(self.m_tblTxds[iID]);
    end
    outputConsole("Mod Deactivated: "..self.models[iID][2]..self.models[iID][1])

    self.m_bModActivated[iID] = false;
end

-- ///////////////////////////////
-- ///// activateMod     	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cModellImporter:activateMod(iID, bSave, bOverrideDownload)
        if not(self:isModActivated(iID)) then
            if not(self:isModDownloaded(iID)) then
                if not(bOverrideDownload) then
                    self:downloadMod(iID)
                    self.modDownloading[iID] = true;
                end
            else
                self:doActivateMod(iID)
            end
            if(bSave) then
                cConfig_ModList:getInstance():setConfig("mod_activated_"..iID, tostring(true))
            end
        end
end

-- ///////////////////////////////
-- ///// deactivateMod     	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cModellImporter:deactivateMod(iID, bSave)
    if (self:isModActivated(iID)) then
        self:doDeactivateMod(iID)

        if(bSave) then
            cConfig_ModList:getInstance():setConfig("mod_activated_"..iID, tostring(false))
        end
    end
end

-- ///////////////////////////////
-- ///// getModIDFromPath	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cModellImporter:getModIDFromPath(sPath)
    for id, tbl in pairs(self.models) do
        local path      = tbl[2]..tbl[1];
        if(path == string.sub(sPath, 0, string.len(sPath)-4)) then
            return id;
        end
    end
    return false;
end

-- ///////////////////////////////
-- ///// canModBeDeactivated//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cModellImporter:canModBeDeactivated(iID)
    if(self.models[iID][6] == false) then
        return true;
    else
        return false;
    end
end

-- ///////////////////////////////
-- ///// loadDefaultSettings//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cModellImporter:loadDefaultSettings()
    for id, mod in pairs(self.models) do
        if not(cConfig_ModList:getInstance():getConfig("mod_activated_"..id)) then
            local default = mod[5];
            cConfig_ModList:getInstance():setConfig("mod_activated_"..id, tostring(default))
            if(toboolean(default)) then
                self:activateMod(id);
            end
        else
            local en = toboolean(cConfig_ModList:getInstance():getConfig("mod_activated_"..id));

            if(en) then
                self:activateMod(id);
            end
        end
    end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cModellImporter:constructor(...)
    -- Klassenvariablen --
    addEvent("onClientFileDownloadFinnished", true)

    self.models =
    {

        -- ModellName, Pfad, Name, {dff, txd, col}
        [1772]  = {"blitzer", "res/models/blitzer/", "Objekt: Blitzer", {true, true, true}, true, false},
        [541]   = {"bullet", "res/models/cars/", "Auto: Bullet", {true, true, false}, true, false},
        [559]   = {"jester", "res/models/cars/", "Auto: Jester", {true, true, false}, true, false},
        [3409]  = {"drug", "res/models/drug/", "Objekt: Drogen", {false, false, false}, false, false},
        [2054]  = {"hdw201", "res/models/", "HOG: HDW", {true, true, false}, true, true},
        [1337]  = {"firework", "res/models/", "Objekt: Rakete", {true, true, true}, true, true},
        [1239]  = {"info_v2", "res/models/", "Infopickup", {true, true, false}, true, false},
        [1]     = {"dexter", "res/mods/", "Skin: Dexter", {true, true, false}, true, false},
        [347]   = {"tazer", "res/mods/", "Waffe: Taser", {true, true, false}, true, false},
        [10]    = {"bear", "res/mods/", "Skin: Baer", {true, true, false}, true, false},
        [2]     = {"enton", "res/mods/", "Skin: Enton", {true, true, false}, true, true},
        [358]   = {"sniper", "res/models/weapons/", "Waffe: Sniper", {true, true, false}, true, false},
        [2252]  = {"shisha", "res/mods/", "Objekt: Shisha", {true, true, false}, true, false},
        [334]   = {"holz", "res/models/weapons/", "Waffe: Holz", {true, true, false}, false, false},
        [285]   = {"oni", "res/models/skins/", "Skin: SWAT", {true, true, false}, false, false},
        [356]   = {"m4", "res/models/weapons/", "Waffe: M4", {true, true, false}, false, false},
        [349]   = {"chromegun", "res/models/weapons/", "Waffe: Schrotflinte", {true, true, false}, false, false},
        [357]   = {"cuntgun", "res/models/weapons/", "Waffe: Coutry Rifle", {true, true, false}, false, false},
        [348]   = {"desert_eagle", "res/models/weapons/", "Waffe: Desert Eagle", {true, true, false}, false, false},
        [335]   = {"knifecur", "res/models/weapons/", "Waffe: Messer", {true, true, false}, false, false},
        [351]   = {"shotgspa", "res/models/weapons/", "Waffe: SPAZ-12", {true, true, false}, false, false},
        [355]   = {"ak47", "res/models/weapons/", "Waffe: AK-47", {true, true, false}, false, false},
        [3082]  = {"sombrero", "res/models/huete/", "Hut: Sombrero", {true, true, false}, true, true},
        [2797]  = {"baseballcap", "res/models/huete/", "Hut: Baseballcappie", {true, true, false}, true, true},
        [2751]  = {"fedora", "res/models/huete/", "Hut: Fedora", {true, true, false}, true, true},
        [2750]  = {"bauarbeiterhelm", "res/models/huete/", "Hut: Bauarbeiterhelm", {true, true, false}, true, true},
        [2792]  = {"business", "res/models/huete/", "Hut: Business", {true, true, false}, true, true},
        [2798]  = {"partyhut", "res/models/huete/", "Hut: Partyhut", {true, true, false}, true, true},
        [3898]  = {"cowboyhut", "res/models/huete/", "Hut: Cowboyhut", {true, true, false}, true, true},
        [3897]  = {"ilifecap", "res/models/huete/", "Hut: ".._Gsettings.serverName.." Cap", {true, true, false}, true, true},
        [1238]  = {"kegel", "res/models/huete/", "Hut: Kegel", {true, true, false}, true, true},
        [1274]  = {"business", "res/models/objects/", "Pickup: Business", {true, true, false}, true, true},
        -- 3897, 3895, 3894, 3893. 3892, 3891, 3890, 3923
    }


    self.modelAuthors   =
    {
        [1772]      = "Gunvarrel, for ".._Gsettings.serverName,
        [3409]      = "Gunvarrel for ".._Gsettings.serverName,
        [2054]      = "NCSoft",
        [1337]      = "[GER]PLASMA for ".._Gsettings.serverName,
        [1239]      = "[GER]PLASMA for ".._Gsettings.serverName,
        [2252]      = "To edit by Samy",
        [285]       = "Rockstar Games, Bungie, Gunvarrel, Sam@ke",
        [356]       = "ReyZ",
        [349]       = "ReyZ",
        [348]       = "ReyZ",
        [335]       = "ReyZ",
        [351]       = "ReyZ",
        [355]       = "YIbnuN",
        [1274]      = "Gunvarrel for ".._Gsettings.serverName,
    }

    self.m_bModActivated    = {}
    self.m_tblTxds          = {}
    self.m_tblDownloadList  = {}
    self.modDownloading     = {}


    self:loadDefaultSettings()

    -- Funktionen --

    self.m_funcReplaceFunc              = function(...) self.done = true; self:loadDefaultSettings() end

    addEventHandler("onClientDownloadFinnished", getRootElement(), self.m_funcReplaceFunc)
    addEventHandler("onClientFileDownloadFinnished", getRootElement(), function(sPath)
        if(self.done) then
            for p, _ in pairs(self.m_tblDownloadList) do
                if(p) then
                    if(p == sPath) then
                        self.m_tblDownloadList[p] = nil;
                        local id = self:getModIDFromPath(sPath)
                        if(self:isModDownloaded(id)) then
                            self:activateMod(id, false, true)
                        end
                    end
                end
            end
        end
    end)

    -- Events --
end

-- EVENT HANDLER --
