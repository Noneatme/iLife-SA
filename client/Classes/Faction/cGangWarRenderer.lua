--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CGangWarRenderer = {}

function CGangWarRenderer:constructor()
	self.AttackerName = "None"
	self.DefenderName = "None"
	
	self.DefenderPoints = 1000
	self.AttackerPoints = 1000

	self.TextRenderTarget = dxCreateRenderTarget(250, 75, true)
	self.MarkerRenderTarget = dxCreateRenderTarget(250, 75, true)
	
	self.Markers = {}
	
	RPCRegister("initializeGangWarRenderer", bind(CGangWarRenderer.initialize, self))
	RPCRegister("updateGangWarRenderer", bind(CGangWarRenderer.update, self))
	RPCRegister("finshGangWarRenderer", bind(CGangWarRenderer.finish, self))

	self.eRender = bind(CGangWarRenderer.render, self)
end

function CGangWarRenderer:destructor()

end

function CGangWarRenderer:initialize(sDefenderName, sAttackerName, tblMarkers)
	self.DefenderName = sDefenderName
	self.AttackerName = sAttackerName
	
	self.DefenderPoints = 1000
	self.AttackerPoints = 1000
	
	self.Markers = tblMarkers
	
	addEventHandler("onClientRender", getRootElement(), self.eRender)
end

function CGangWarRenderer:update(DefenderPoints, AttackerPoints)
	self.DefenderPoints = DefenderPoints
	self.AttackerPoints = AttackerPoints

end

function CGangWarRenderer:finish(WinnerName)
	removeEventHandler("onClientRender", getRootElement(), self.eRender)
end

function CGangWarRenderer:render()
	if (getElementDimension(localPlayer) == 60000) then
		local sx,sy = guiGetScreenSize()
		
		dxDrawText(self.DefenderName.." "..math.floor(self.DefenderPoints).." - "..math.floor(self.AttackerPoints).." "..self.AttackerName, 0, 0, sx, sy, tocolor(255,255,255,255), 1, "default-bold", "center", "top", false, false, false)
		
		for k,v in ipairs(self.Markers) do
			local r,g,b = getMarkerColor(v)
			
			if (isElementWithinMarker(localPlayer, v)) and (math.abs(getElementData(v, "Score")) ~= 100 ) then
				local alpha = interpolateBetween(20,0,0,40,0,0, (getTickCount()%3000)/3000, "CosineCurve")
				dxDrawRectangle(((sx/2)-((#self.Markers*70)/2))+((k-1)*70), 30, 70, 84, tocolor(255, 0, 0, alpha), false)
			end
			
			--Grauer Kreis
			dxDrawImage(((sx/2)-((#self.Markers*70)/2))+((k-1)*70), 30, 70, 84, "res/images/capture_out.png", 0 ,0 ,0, tocolor(255,255,255,125), false)
			dxDrawImage(((sx/2)-((#self.Markers*70)/2))+((k-1)*70), 30, 70, 84, "res/images/capture_in.png", 0 ,0 ,0, tocolor(255,255,255,125), false)
			
			--Farbiger Kreis
			dxDrawImageSection(((sx/2)-((#self.Markers*70)/2))+((k-1)*70) , 30+(84-(84/100*math.abs(getElementData(v, "Score")))) , 70 , 84/100*math.abs(getElementData(v, "Score")) ,0,  84-(84/100*math.abs(getElementData(v, "Score"))) , 70 , 84/100*math.abs(getElementData(v, "Score")) , "res/images/capture_out.png", 0 ,0 ,0, tocolor(r,g,b,200), false)
			dxDrawImageSection(((sx/2)-((#self.Markers*70)/2))+((k-1)*70) , 30+(84-(84/100*math.abs(getElementData(v, "Score")))) , 70 , 84/100*math.abs(getElementData(v, "Score")) ,0,  84-(84/100*math.abs(getElementData(v, "Score"))) , 70 , 84/100*math.abs(getElementData(v, "Score")) , "res/images/capture_in.png", 0 ,0 ,0, tocolor(r,g,b,200), false)
		end
	end
end

GangWarRenderer = new(CGangWarRenderer)