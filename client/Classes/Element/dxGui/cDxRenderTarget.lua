--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CDxRenderTarget = inherit(CDxElement)

function CDxRenderTarget:constructor(left, top, width, height,Parent, color)
	self.Parent = Parent or false

	if (self.Parent) then
		self.StartX, self.StartY = self.Parent:getStartPosition()
	else
		self.StartX = 0
		self.StartY = 0
	end

	self.Color				= (color) or false
	self.RenderTarget		= dxCreateRenderTarget(width, height, true);
	self.Visible 			= true;

	CDxElement.constructor(self, self.StartX+left or 50, self.StartY+top or 50, width or 150, height or 30)

end

function CDxRenderTarget:destructor()

end

function CDxRenderTarget:clear()
	dxSetRenderTarget(self.RenderTarget, true)
	dxSetRenderTarget();
end

function CDxRenderTarget:dxDrawText(...)
	dxSetRenderTarget(self.RenderTarget)
	dxSetBlendMode("modulate_add")
	dxDrawText(...)
	dxSetBlendMode("blend");
	dxSetRenderTarget();
end

function CDxRenderTarget:dxDrawLine(...)
	dxSetRenderTarget(self.RenderTarget)
	dxDrawLine(...)
	dxSetRenderTarget();
end

function CDxRenderTarget:dxDrawImage(...)
	dxSetRenderTarget(self.RenderTarget)
	dxDrawImage(...)
	dxSetRenderTarget();
end

function CDxRenderTarget:dxDrawRectangle(...)
	dxSetRenderTarget(self.RenderTarget)
	dxDrawRectangle(...)
	dxSetRenderTarget();
end


function CDxRenderTarget:render()
	local cX,cY = getCursorPosition ()

	-- Render Target --
	if(self.Color) then
		dxDrawRectangle(self.X, self.Y, self.Width, self.Height, self.Color, false, false)
	end

	dxDrawImage(self.X, self.Y, self.Width, self.Height, self.RenderTarget);


	-- Lines --
	-- BLACK
	dxDrawLine(self.X, self.Y, self.X+self.Width, self.Y, tocolor(0, 0, 0, 255));		-- Oben
	dxDrawLine(self.X, self.Y+self.Height, self.X+self.Width, self.Y+self.Height, tocolor(0, 0, 0, 255)); -- unten
	dxDrawLine(self.X, self.Y, self.X, self.Y+self.Height, tocolor(0, 0, 0, 255));		-- Links
	dxDrawLine(self.X+self.Width, self.Y, self.X+self.Width, self.Y+self.Height, tocolor(0, 0, 0, 255));		-- Rechts

	-- WHITE
	dxDrawLine(self.X+1, self.Y+1, self.X+self.Width-1, self.Y+1, tocolor(255, 255, 255, 25));		-- Oben
	dxDrawLine(self.X+1, self.Y+self.Height-1, self.X+self.Width-1, self.Y+self.Height-1, tocolor(255, 255, 255, 25)); -- unten

	dxDrawLine(self.X+1, self.Y+1, self.X+1, self.Y+self.Height-1, tocolor(255, 255, 255, 25));		-- Links

	dxDrawLine(self.X+self.Width-1, self.Y+1, self.X+self.Width-1, self.Y+self.Height-1, tocolor(255, 255, 255, 25));		-- Rechts

--	dxDrawRectangle(self.X+1, self.Y, self.Width, self.Height, tocolor(0,0,0,179), false)

end