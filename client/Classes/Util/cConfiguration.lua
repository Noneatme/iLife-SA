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
-- Date: 29.01.2015
-- Time: 13:40
-- To change this template use File | Settings | File Templates.
--

cConfiguration = inherit(cSingleton)

--[[

]]

-- ///////////////////////////////
-- ///// checkFile  		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cConfiguration:checkFile()
    self.xml    = xmlLoadFile(self.m_sFileName);

    if not(self.xml) then
        self.xml    = xmlCreateFile(self.m_sFileName, "config");

        if(self.m_bInsertJustOnNoneExists == true) then
            for index, val in pairs(self.defaultValues2) do
                self:setConfig(index, val)
            end
            if(self.xtraValues) then
                for index, val in pairs(self.xtraValues) do
                    self:setConfig(index, val)
                end
            end
        end
    end

    xmlSaveFile(self.xml);
end


-- ///////////////////////////////
-- ///// setConfig  		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cConfiguration:setConfig(sConfig, sValue)
    if not(self.xml) then
        outputChatBox("Fatal Error: Config File not Available!", 255, 0, 0)
        return false;
    end

    local node      = xmlFindChild(self.xml, sConfig, 0);
    if not(node) then
        node    = xmlCreateChild(self.xml, sConfig);
    end
    local sucess    = xmlNodeSetValue(node, tostring(sValue));
    xmlSaveFile(self.xml)

    if(sucess) then
        return sValue;
    end

    return false;
end

-- ///////////////////////////////
-- ///// getConfig  		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cConfiguration:getConfig(sConfig)
    if not(self.xml) then
        outputChatBox("Fatal Error: Config File not Available!", 255, 0, 0)
        return false;
    end
    local node  = xmlFindChild(self.xml, sConfig, 0);

    if not(node) then
        node    = xmlCreateChild(self.xml, sConfig);
    end
    local value = xmlNodeGetValue(node);

    if not(value) or (string.len(value) < 1) then
        if(self.defaultValues[sConfig]) then
            value = self.defaultValues[sConfig];
            self:setConfig(sConfig, value);
            outputDebugString("[CONFIG] Config "..sConfig.." not found, using default ("..tostring(value)..")");
            return value
        else
            return false;
        end
    else
        return value
    end
    return false;
end

-- ///////////////////////////////
-- ///// removeConfig  		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cConfiguration:removeConfig(sConfig)
    if not(self.xml) then
        outputChatBox("Fatal Error: Config File not Available!", 255, 0, 0)
        return false;
    end
    local node  = xmlFindChild(self.xml, sConfig, 0);

    if(node) then
        local sucess = xmlDestroyNode(node)
        xmlSaveFile(self.xml)
        return sucess
    end
    return false;
end


-- ///////////////////////////////
-- ///// getAllConfig  		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cConfiguration:getAllConfig()
    if not(self.xml) then
        outputChatBox("Fatal Error: Config File not Available!", 255, 0, 0)
        return false;
    end

    local childs = xmlNodeGetChildren(self.xml);

    local tbl       = {}

    for index, _ in ipairs(childs) do
        tbl[xmlNodeGetName(childs[index])] = xmlNodeGetValue(childs[index])
    end

    return tbl
end

-- ///////////////////////////////
-- ///// loadCoreConfig 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cConfiguration:loadCoreConfig()
    -- FPS --

    local fps       = tonumber(self:getConfig("fps"));
    setFPSLimit(fps);

    -- CURSOR --
    local cursor    = self:getConfig("cursorbind");

    local function bindDat(sKey)
        bindKey(sKey, "both", function( key, state)
            if	not (cursorOverride) then
                showCursor(state == "down")
            end
        end)
    end

    bindDat(cursor)
    addCommandHandler("bindcursor", function(cmd, key) bindDat(key) end)


    -- DEV MODE --
    local devmode   = toBoolean(self:getConfig("development"))
    setDevelopmentMode(devmode)

    -- HEAT HAZE --
    local heatHaze  = tonumber(self:getConfig("heathaze"));
    if not(heatHaze) then
        resetHeatHaze()
    else
        setHeatHaze(heatHaze)
    end

    -- INTERIOR SOUNDS --
    local intSound  = toBoolean(self:getConfig("interior_sounds"))
    setInteriorSoundsEnabled(intSound);

    -- Occlusions --

    local occlusions    = toBoolean(self:getConfig("occlusions"))
    setOcclusionsEnabled(occlusions);

    -- Moon size --
    local moon_size     = tonumber(self:getConfig("moon_size"))
    if(moon_size) then
        setMoonSize(moon_size)
    end

    -- Hotsound --
    hitsoundEnabled     = toBoolean(self:getConfig("hitsound_enabled"))

    addCommandHandler("hitsound", function()
        hitsoundEnabled = not(hitsoundEnabled)

        if(hitsoundEnabled) then
            outputChatBox("Der Hitsound wurde angeschaltet!", 0, 255, 0)
        else
            outputChatBox("Der Hitsound wurde ausgeschaltet!", 0, 255, 0)
        end

        self:setConfig("hitsound_enabled", tostring(hitsoundEnabled));
    end)


    addCommandHandler("changelog", function()
        local file      = File("res/txt/changelog.txt")
        local content   = file:read(file:getSize())
        for index, row in ipairs(split(content, "\n")) do
            outputConsole(row);
        end
        file:close()
    end)

    if(toboolean(self:getConfig("load_world_textures")) == false) then
        local _engineApplyShaderToWorldTexture        = engineApplyShaderToWorldTexture

        function engineApplyShaderToWorldTexture(...)
            return false
        end
    end
end

-- ///////////////////////////////
-- ///// loadBasicConfig	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cConfiguration:loadBasicConfig()
    for config, default in pairs(self.defaultValues) do
        local dat = self:getConfig(config);
        setElementData(localPlayer, config, dat);
    end
end

-- ///////////////////////////////
-- ///// loadCommands 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cConfiguration:loadCommands()
    addCommandHandler("scrambleword", function(cmd, ...)
        local s = scrambleWord((table.concat({...}, " ") or "hello"))
        outputConsole("Wort: "..s)
        setClipboard(s)
    end)
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cConfiguration:constructor(sFileName, sDefaultValues, insertOnNonExists)
    -- Klassenvariablen --

    self.defaultValues =
    {
        ["fps"]                     = "60",
        ["cursorbind"]              = "m",
        ["moon_size"]               = "0",
        ["heathaze"]                = "reset",
        ["interior_sounds"]         = "true",
        ["occlusions"]              = "false",
        ["development"]             = "true",
        ["upload_blitzer_images"]   = "true",
        ["log_console"]             = "false",
        ["nametags_enabled"]        = "true",
        ["hud_enabled"]             = "true",
        ["render_infotext"]         = "true",
        ["render_3dtext"]           = "true",
        ["save_password"]           = "false",
        ["saved_password"]          = "-",
        ["hitsound_enabled"]        = "false",
        ["ooc_chat"]                = "true",
        ["popsound"]                = "res/sounds/poke.ogg",
        ["hide_scoreboard_avatar"]  = "false",
        ["lowrammode"]              = "false",
        ["log_actions"]             = "true",
        ["load_world_textures"]     = "true",
        ["log_debug"]               = "false",
        ["disableads"]              = "false",
    }

    if not(sFileName) then
        sFileName = "config.xml";
    end

    if(sDefaultValues) then
        self.defaultValues  = {}
        self.defaultValues2 = sDefaultValues;
    end

    self.m_sFileName                = sFileName;
    self.m_bInsertJustOnNoneExists = insertOnNonExists

    -- Funktionen --
    self:checkFile()

    if(sFileName == "config.xml") then
        self:loadCommands();
        self:loadCoreConfig()
        self:loadBasicConfig();
    end

    addEventHandler("onClientResourceStop", getResourceRootElement(getThisResource()), function()
        if(self.xml) then
            xmlSaveFile(self.xml)
            xmlUnloadFile(self.xml)
        end
    end)
    -- Events --
end

-- EVENT HANDLER --
