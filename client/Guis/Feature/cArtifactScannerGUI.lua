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
-- Date: 05.02.2015
-- Time: 13:38
-- To change this template use File | Settings | File Templates.
--

cArtifactScannerGUI = inherit(cSingleton)

--[[

]]

-- ///////////////////////////////
-- ///// show        		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cArtifactScannerGUI:show()
    if not(self.enabled) then
        self:createElements()
        self.enabled = true
    end
end

-- ///////////////////////////////
-- ///// hide          		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cArtifactScannerGUI:hide()
    if(self.guiEle["window"]) then
        self.guiEle["window"]:hide();
        delete(self.guiEle["window"])
        self.guiEle["window"] = false;
        self.enabled = false;
    end
end

-- ///////////////////////////////
-- ///// createElements		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cArtifactScannerGUI:createElements()
    if not(self.guiEle["window"]) then

        local X, Y = 350, 150
        self.guiEle["window"] 	= new(CDxWindow, "Artefaktscanner", X, Y, true, true, "Center|Top", 0, 0, {tocolor(125, 125, 255, 255), false, "Artefakte"})
        self.guiEle["window"]:setReadOnly(true)
        self.guiEle["list1"]    = new(CDxList, 1, 1, X-4, Y-20, tocolor(255, 255, 255, 255), self.guiEle["window"])
        self.guiEle["list1"]:addColumn("Name")
        self.guiEle["list1"]:addColumn("Distanz")
        self.guiEle["list1"]:addColumn("Status", true)

        for index, ele in pairs(self.guiEle) do
            if(index ~= "window") then
                self.guiEle["window"]:add(ele)
            end
        end

        self.guiEle["window"]:show();
    end
end

-- ///////////////////////////////
-- ///// onResultsGet 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cArtifactScannerGUI:onResultsGet(tblResult)
    self:hide()
    self:show()
    self.guiEle["list1"]:clearRows();

    local bGefunden  = false;

    for artifact, distance in pairs(tblResult) do
        local icon = "res/images/mining/artifacts/new.png"
        if(self.lastResult[artifact.m_iID]) then
            if(self.lastResult[artifact.m_iID] > distance) then
                icon = "res/images/mining/artifacts/down.png"
            else
                icon = "res/images/mining/artifacts/up.png"
            end
        end
        local sdistance = distance.."m"

        if(distance < 15) then
            icon            = "res/images/mining/artifacts/discovered.png"
            sdistance       = "Artefakt entdeckt!"
            bGefunden        = true;
        end

        self.guiEle["list1"]:addRow(artifact.m_sName.."|"..sdistance.."|"..icon, 1)
        self.lastResult[artifact.m_iID] = distance;

        local pos       = localPlayer:getPosition()

        local newZ     = getGroundPosition(artifact.m_iX, artifact.m_iY, pos.z+500);

        if not(artifact.m_iZ) then
            if(newZ and newZ < pos.z+500) then

                if(newZ-pos.z < -5) then
                    newZ = pos-getElementDistanceFromCentreOfMassToBaseOfModel(localPlayer)
                end

                triggerServerEvent("onArtifactZPositionUpdate", localPlayer, artifact.m_iID, newZ+0.1)
            end
        end
    end

    if(bGefunden) then
        playSound("res/sounds/mining/artifact/art_done.ogg", false)
    else
        playSound("res/sounds/mining/artifact/art_use.ogg", false)
    end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cArtifactScannerGUI:constructor(...)
    addEvent("onClientPlayerArtifactScannerResultsGet", true)
    addEvent("onClientPlayerArtifactGUIClose", true)
    -- Klassenvariablen --

    self.guiEle         = {}
    self.enabled        = false;

    self.lastResult     = {}

    -- Funktionen --
    self.m_funcOnArtifactsResultGet                 = function(...) self:onResultsGet(...) end
    self.m_funcOnHide                               = function(...) self:hide(...) end
    -- Events --
    addEventHandler("onClientPlayerArtifactScannerResultsGet", getLocalPlayer(), self.m_funcOnArtifactsResultGet)
    addEventHandler("onClientPlayerArtifactGUIClose", getLocalPlayer(), self.m_funcOnHide)
end

-- EVENT HANDLER --
