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
-- Date: 23.12.2014
-- Time: 20:24
-- Project: MTA iLife
--
--
cLoadingSprite = inherit(cSingleton);

--[[

]]

-- ///////////////////////////////
-- ///// disableFinal 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cLoadingSprite:disableFinal()
	if(self.m_bFinal == false) then
		removeEventHandler("onClientRender", getRootElement(), self.m_func_render)
		self.m_bEnabled = false;
		self.m_bFinal = true;

	end
end

-- ///////////////////////////////
-- ///// setEnabled 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cLoadingSprite:setEnabled(bBool)
	if(bBool) then
		if(self.m_bEnabled == false) then
			if(self.m_bFinal == false) then
				self:disableFinal()
			end
			self.menuTick           = getTickCount();
			self.m_bEnabled = true;
			self.m_bFinal  = false;
			addEventHandler("onClientRender", getRootElement(), self.m_func_render)
		end
	else
		if(self.m_bEnabled == true) then
			self.m_bEnabled = false;
			self.menuTick           = getTickCount();
		--	removeEventHandler("onClientRender", getRootElement(), self.m_func_render)
		end
	end

end

-- ///////////////////////////////
-- ///// Render     		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cLoadingSprite:render()
--	if(self.m_bEnabled) then
	local rot2 = (getTickCount()-self.m_iStartTick)/15;
	local rot1 = (self.m_iStartTick-getTickCount())/15;
	local rot3 = (self.m_iStartTick-getTickCount())/50;

	local wert = ((getTickCount()-self.menuTick)/500);

	if(self.m_bEnabled == false) then
		wert = 1-((getTickCount()-self.menuTick)/500);
	end

	if(wert >= 1) then wert = 1 end
	if(wert <= 0) then
		wert = 0
		if(self.m_bEnabled == false) then
			self:disableFinal()
		end
	end

	local textWert =  ((getTickCount()-self.m_iTextTick)/500);

	if(self.m_bTextState == true) then
		textWert =  1-((getTickCount()-self.m_iTextTick)/500);
	end

	if(textWert >= 1) then textWert = 1 end
	if(textWert <= 0) then textWert = 0 end

	if(textWert >= 1) or (textWert <= 0) then
		if(self.m_bTextState == true) then
			self.m_iTextTick         = getTickCount();
			self.m_bTextState = false;

		else
			self.m_iTextTick         = getTickCount();
			self.m_bTextState = true;
		end
	end


	local alpha = 255*wert
	local textAlpha = (255*textWert)/255*alpha;

	dxDrawImage(self.m_iPosX-5, self.m_iPosY-5, self.m_iDefW+10, self.m_iDefH+10, "res/images/render/loading/1.png", rot1, 0, 0, tocolor(255, 255, 255, alpha));
	dxDrawImage(self.m_iPosX+11, self.m_iPosY+11, self.m_iDefW-22, self.m_iDefH-22, "res/images/render/loading/2.png", rot3, 0, 0, tocolor(255, 255, 255, alpha));
	dxDrawImage(self.m_iPosX+11, self.m_iPosY+11, self.m_iDefW-22, self.m_iDefH-22, "res/images/render/loading/3.png", rot2, 0, 0, tocolor(255, 255, 255, alpha));
	dxDrawText("LADE", self.m_iPosX, self.m_iPosY, self.m_iPosX+self.m_iDefW, self.m_iPosY+self.m_iDefH, tocolor(255, 255, 255, textAlpha), 0.2, self.m_font, "center", "center");


end

-- ///////////////////////////////
-- ///// BindLocalBinds		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cLoadingSprite:bindLocalBinds()
--	bindKey("F7", "down", self.m_func_enable); -- Fahrzeuge

end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cLoadingSprite:constructor(...)
	-- Klassenvariablen --
	self.m_bEnabled         = false;

	self.m_iSX, self.m_iSY  = guiGetScreenSize();

	self.m_iStartTick       = getTickCount();
	self.menuTick           = getTickCount();

	self.m_iCurrentAlpha    = 0;

	self.m_iTextTick         = getTickCount();
	self.m_bTextState        = false;

	self.m_iDefW            = 130;
	self.m_iDefH            = 130;

	self.m_iPosX            = self.m_iSX-(self.m_iDefW+15)
	self.m_iPosY            = self.m_iSY-(self.m_iDefH+15)

	self.m_font 			= dxCreateFont("res/fonts/play_bold.ttf", 64);

	-- Funktionen --
	self.m_func_render      = function(...) self:render(...) end
	self.m_func_toggle      = function(bBool) self:setEnabled(bBool) end;
	self.m_func_enable      = function() self:setEnabled(true) end

	addCommandHandler("loading", function() self.m_func_toggle(not(self.m_bEnabled)) end)
	-- Events --
	addEvent("onLoadingSpriteToggle", true)
	addEventHandler("onLoadingSpriteToggle", getLocalPlayer(), self.m_func_toggle);
end

-- EVENT HANDLER --
