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
-- Time: 16:41
-- Project: MTA iLife
--

cInformationWindow = {};
InformationWindows  = {};

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function cInformationWindow:new(...)
	local obj = setmetatable({}, {__index = self});
	if obj.constructor then
		obj:constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// Render      		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cInformationWindow:render()
	if(self.m_bEnabled) and (self.m_renderEnabled) then
		local px, py, pz       = getElementPosition(getCamera());
		local l = getDistanceBetweenPoints3D(px, py, pz, self.m_V3Position[1], self.m_V3Position[2], self.m_V3Position[3])
		if(l < self.m_iMaxDistance) then
			-- Render
			local w, h          = (322/1), (123/1)
			local oldw, oldh    = w, h

			local wert = 5;

			w = w / l * wert
			h = h / l * wert

			local max_text_addx = 160;
			local max_text_addy = 70;
			local text_addx     = max_text_addx / l * wert;
			local text_addy     = max_text_addy / l * wert;

			local maxscale      = 0.3;
			local scale         = maxscale / l * wert

			if(w > oldw) then w = oldw end
			if(h > oldh) then h = oldh end
			if(w < 0) then w    = 0 end
			if(h < 0) then h    = 0 end
			if(scale > maxscale) then scale = maxscale end;
			if(scale < 0) then scale = 0 end
			if(text_addx > max_text_addx) then text_addx = max_text_addx end
			if(text_addy > max_text_addy) then text_addy = max_text_addy end
			if(text_addx < 0) then text_addx = 0 end
			if(text_addy < 0) then text_addy = 0 end


			local x, y = getScreenFromWorldPosition(self.m_V3Position[1], self.m_V3Position[2], self.m_V3Position[3])

			if(x) and (y) and (isLineOfSightClear(px, py, pz, self.m_V3Position[1], self.m_V3Position[2], self.m_V3Position[3], true, true, false, self.m_bCheckObjects)) then
				dxDrawImage(x-(w/2), y-(h/2), w, h, "res/images/render/information_hud.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
				dxDrawText(self.m_sText, (x+text_addx)-(w/2), (y+text_addy)-(h/2), (x+text_addx)-(w/2), (y+text_addy)-(h/2), tocolor(255, 255, 255, 255), scale, fontManager.m_FONT_PLAY_BOLD, "center", "center")
			end
		end
	end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cInformationWindow:constructor(V3Position, sText, iMaxDistance, bCheckObjects)
	-- Klassenvariablen --

	self.m_V3Position       = V3Position;
	self.m_sText            = sText;
	self.m_bEnabled         = false;
	self.m_iMaxDistance     = (iMaxDistance or 30)
	self.m_bCheckObjects    = (bCheckObjects or true)
	self.m_colShape         = createColSphere(V3Position[1], V3Position[2], V3Position[3], iMaxDistance);

	self.m_renderEnabled	= toBoolean(config:getConfig("render_infotext"))

	-- Funktionen --
	self.m_funcRender           = function(...) self:render(...) end
	self.m_enterColShapeFunc    = function(uPlayer)
		if(uPlayer == localPlayer) and not(self.m_bEnabled) then
			self.m_bEnabled = true;
			addEventHandler("onClientRender", getRootElement(), self.m_funcRender)
		end
	end

	self.m_leaveColShapeFunc    = function(uPlayer)
		if(uPlayer == localPlayer) and (self.m_bEnabled) then
			self.m_bEnabled = false;
			removeEventHandler("onClientRender", getRootElement(), self.m_funcRender)
		end
	end
	-- Events --

	addEventHandler("onClientColShapeHit", self.m_colShape, self.m_enterColShapeFunc);
	addEventHandler("onClientColShapeLeave", self.m_colShape, self.m_leaveColShapeFunc);

	--
	InformationWindows[self] = self;
end

-- EVENT HANDLER --

addEvent("onInformationWindowRequestItemsBack", true);
addEventHandler("onInformationWindowRequestItemsBack", getLocalPlayer(), function(tbl)
	for index, tab in pairs(tbl) do
		cInformationWindow:new(tab[1], tab[2], tab[3]);
	end
end)

addEventHandler("onClientDownloadFinnished", getLocalPlayer(), function()
--	triggerServerEvent("onInformationWindowRequestItems", localPlayer)
end)