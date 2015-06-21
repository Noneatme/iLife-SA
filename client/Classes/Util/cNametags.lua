--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

--
-- Created by Noneatme
-- User: Noneatme
-- Date: 25.02.2015
-- Time: 12:02
-- Copyright(c) 2015 - iLife Team and Developers
--

cNameTags = {}

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function cNameTags:new(...)
    local obj = setmetatable({}, {__index = self});
    if obj.constructor then
        obj:constructor(...);
    end
    return obj;
end

-- ///////////////////////////////
-- ///// onRender    		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cNameTags:onRender()
    for uPed, index in pairs(self.m_tblElementsToRender) do
        if(uPed) and (isElement(uPed)) and (isElementStreamedIn(uPed)) then
            local dist      = (uPed.position-getCamera().position).length

            if(isLineOfSightClear(getCamera().position, uPed.position, true, false, false, false)) and (self.m_bEnabled) and (uPed ~= localPlayer) then
                local x, y, z   = getPedBonePosition(uPed, 6);

                local addY      = 0.6

                local sx, sy    = getScreenFromWorldPosition(x, y, z+addY)
                local sx2, sy2    = getScreenFromWorldPosition(x, y, z+addY-0.1)

                local sPlayername   = uPed:getName()
                local dScale    = (10/dist);
                local textScale = ((8/2))/dist

                if(dScale > 1.2) then
                    dScale = 1.2
                end
                if(textScale > 0.5) then
                    textScale = 0.5
                end
                if(dScale > 0) then
                    if(sx) and (sy) then

                        if(localPlayer:getData("Adminlevel") > 0) then
                            sPlayername = sPlayername.." (ID: "..uPed:getData("ID")..", $"..uPed:getData("Geld")..")"
                            if(sy2) then

                            end
                        end

                    --    dxDrawText(sPlayername, sx+(dScale*2), sy+(dScale*2), sx, sy, tocolor(0, 0, 0, 255), textScale, self.m_uFont, "center", "center")
                        dxDrawText(sPlayername, sx, sy, sx, sy, tocolor(255, 255, 255, 255), textScale, self.m_uFont, "center", "center")

                    end
                    if(sx2) and (sy2) then
                        local width = 130
                        dxDrawRectangle(sx2-((width/2)*dScale), sy2, width*dScale, 20*dScale, tocolor(255, 255, 255, 50))

                        -- LOSS INCREASE --
                        local health    = uPed:getHealth()
                        local armor     = uPed:getArmor()

                        local minusWert = 0;
                        local minusWert2 = 0;


                        if(self.m_tblLossAmmount[uPed]) then
                            if(armor > 0) then
                                minusWert = minusWert+(self.m_tblLossAmmount[uPed]/10)
                                self.m_tblLastMinusWert[uPed]   = minusWert;
                            else
                                if(self.m_tblLastMinusWert[uPed] > 0) then
                                    self.m_tblLossAmmount[uPed] = (100-health)*10

                                    self.m_tblLastMinusWert[uPed] = 0

                                end

                                minusWert2 = minusWert2+(self.m_tblLossAmmount[uPed]/10)
                            end
                        end
                        if(self.m_tbldoDecreaseLoss[uPed] == true) then
                            self.m_tblLossAmmount[uPed] = self.m_tblLossAmmount[uPed]-20;
                            if(self.m_tblLossAmmount[uPed] < 0) then
                                self.m_tblLossAmmount[uPed]     = 0
                                self.m_tbldoDecreaseLoss[uPed]  = false;
                            end
                        end



                        dxDrawRectangle(sx2-((width/2)*dScale)+(3*dScale), sy2+(3*dScale), ((width*dScale-(6*dScale))/100*health), 20*dScale-(6*dScale), tocolor(255, 0, 0, 150))

                        if(armor > 0) then
                            dxDrawRectangle(sx2-((width/2)*dScale)+(3*dScale)+((width*dScale-(6*dScale))/100*armor), sy2+(3*dScale), ((minusWert))*dScale, 20*dScale-(6*dScale), tocolor(255, 255, 255, 150))
                        else
                            local val = minusWert2

                            dxDrawRectangle(sx2-((width/2)*dScale)+(3*dScale)+((width*dScale-(6*dScale))/100*health), sy2+(3*dScale), val*dScale, 20*dScale-(6*dScale), tocolor(255, 255, 255, 150))

                        end
                        dxDrawRectangle(sx2-((width/2)*dScale)+(3*dScale), sy2+(3*dScale), ((width*dScale-(6*dScale))/100*armor), 20*dScale-(6*dScale), tocolor(50, 50, 50, 200))


                        -- Icon --
                        local url   = false
                        if(getElementData(uPed, "CorporationLogo")) then
                            url = getElementData(uPed, "CorporationLogo")

                            if not(self.m_tblCorporationIcons[uPed]) then
                                -- HIER ZEICHNEN
								self.m_tblCorporationIcons[uPed]	= viewCorpGUI:drawLogo(url)
                            end
                            url = self.m_tblCorporationIcons[uPed]

                            if not(isElement(url)) then
                                url = false;
                            end
                        end

                        if(url)then
                            dxDrawImage(sx2-((width/2)*dScale)+(3*dScale)-25*dScale, sy2+(2*dScale), 16*dScale, 16*dScale, url)
                        end

                        dxDrawText(health+armor.." / 200", sx2-((width/2)*dScale), sy2, sx2-((width/2)*dScale)+width*dScale, sy2+20*dScale, tocolor(255, 255, 255, 155), textScale*0.7, self.m_uFont, "center", "center")

                    end
                end
            end
        else
            self:removeElementIndex(uPed)
        end
    end
end

-- ///////////////////////////////
-- ///// removeElementIndex	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cNameTags:removeElementIndex(uIndex)
    self.m_tblElementsToRender[uIndex] = nil;
    if(self.m_tblCorporationIcons[uIndex]) and (isElement(self.m_tblCorporationIcons[uIndex])) then
        destroyElement(self.m_tblCorporationIcons[uIndex])
        self.m_tblCorporationIcons[uIndex]  = nil;
    end
end

-- ///////////////////////////////
-- ///// onElementStreamIn	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cNameTags:onElementStreamIn()
    local uElement = source;
    if(uElement:getType() == self.m_sElementType) then
        self.m_tblElementsToRender[uElement] 	= true;
		self.m_tblLastMinusWert[uElement]		= 0;
		self.m_tblLossAmmount[uElement]     	= 0
		self.m_tbldoDecreaseLoss[uElement]  	= false;
        setPlayerNametagShowing(uElement, false)

	--	outputDebugString("Loaded Nametag Player: "..uElement:getName())
    end
end

-- ///////////////////////////////
-- ///// onElementStreamOut	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cNameTags:onElementStreamOut()
    local uElement = source;
    if(uElement:getType() == self.m_sElementType) then
        self:removeElementIndex(uElement)
	--	outputDebugString("Unloaded Nametag Player: "..uElement:getName())
    end
end

-- ///////////////////////////////
-- ///// onPedDamage 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cNameTags:onPedDamage(uAttacker, iWeapon, iBodypart, iLoss)
    local uPlayer = source;
    if not(self.m_tblLossAmmount[uPlayer]) then
        self.m_tblLossAmmount[uPlayer] = 0;
    end
    self.m_tblLossAmmount[uPlayer] = self.m_tblLossAmmount[uPlayer]+(iLoss*12.5)

    if(isTimer(self.m_tblLossDecreaseTimer[uPlayer])) then
        killTimer(self.m_tblLossDecreaseTimer[uPlayer])
    end
    self.m_tbldoDecreaseLoss[uPlayer]       = false;
    self.m_tblLossDecreaseTimer[uPlayer]    = setTimer(function()
        self.m_tbldoDecreaseLoss[uPlayer]   = true;
    end, 500, 1)
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cNameTags:constructor(...)
    -- Klassenvariablen --
    self.m_tblElementsToRender  = {}
    self.m_sElementType         = "player"
	self.m_uFont                = dxCreateFont("res/fonts/oswald.ttf", 32)

    self.m_tblLossAmmount       = {}
    self.m_tblLossDecreaseTimer = {}
    self.m_tbldoDecreaseLoss    = {}
    self.m_tblLastMinusWert     = {}
    self.m_tblCorporationIcons  = {}
	self.m_bEnabled				= true;

    -- Funktionen --
    self.m_funcOnElementStreamIn        = function(...) self:onElementStreamIn(...) end;
    self.m_funcOnElementStreamOut       = function(...) self:onElementStreamOut(...) end;
    self.m_funcOnRender                 = function(...) self:onRender(...) end;
    self.m_funcOnPedDamage              = function(...) self:onPedDamage(...) end;


    -- Events --

    addEventHandler("onClientElementStreamIn", getRootElement(), self.m_funcOnElementStreamIn);
    addEventHandler("onClientElementStreamOut", getRootElement(), self.m_funcOnElementStreamOut);
    addEventHandler("onClientRender", getRootElement(), self.m_funcOnRender)
    addEventHandler("onClientPlayerDamage", getRootElement(), self.m_funcOnPedDamage);

	addCommandHandler("hidenametags", function()
		self.m_bEnabled	= not(self.m_bEnabled)
	end)

end

-- EVENT HANDLER --
