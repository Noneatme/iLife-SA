--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CBreakout = {}

function CBreakout:constructor(fieldRows, fieldColumns, w)
	self.Targets = {}
	self.MaxPoints = fieldRows*fieldColumns
	for i=1,fieldRows,1 do
		self.Targets[i] = {}
		for k=1,fieldColumns,1 do
			self.Targets[i][k] = true
		end
	end
	
	self.BoxWidth = w or 20
	
	self.Border = {
		["Left"] = 50,
		["Right"] = 50,
		["Top"] = 50,
		["Bottom"] = 200
	}
	
	self.Images = {
		["target"] = false
	}
	
	self.Color = {
		["target"] = tocolor(255,255,255,255)
	}
	
	self.Racket = {
		["X"]=math.floor((fieldColumns*self.BoxWidth)/2)+self.Border["Left"]-(self.BoxWidth),
		["Width"]=self.BoxWidth*2,
		["LastVel"]=0,
		["FramesWithoutVel"]=0
	}
	
	self.Ball = {
		["X"]= math.floor((fieldColumns*self.BoxWidth)/2)+self.Border["Left"]-1,
		["Y"]=  math.floor(fieldRows*self.BoxWidth)+self.Border["Top"]+math.floor(self.Border["Bottom"]/2)-1,
		["Radius"] = 3,
		["VelX"]=0.2,
		["VelY"]=-3,
		["MaxVelX"] = 2,
		["MaxVelY"] = 2
	}

	self.Lives = 3
	
	self.Points = 0
	
	self.Width = self.Border["Left"]+self.Border["Right"]+(#self.Targets[1]*self.BoxWidth)
	self.Height = self.Border["Top"]+self.Border["Bottom"]+(#self.Targets*self.BoxWidth)
	self.StartX, self.StartY = (sx/2)-(self.Width/2), (sy/2)-(self.Height/2)
end

function CBreakout:destructor()

end

function CBreakout:render()
	if not self.Lasttick then self.Lasttick = getTickCount() end
	-- Move all the things
	self:move()
	--Render all the things
	
	--Spielfeld
	local sx,sy = guiGetScreenSize()
	dxDrawRectangle(self.StartX, self.StartY, self.Width, self.Height, tocolor(0,0,0,100), false)

	--Targets
	for k,v in ipairs(self.Targets) do
		for i,y in ipairs(v) do
			if (y == true) then
				if (self.Images["target"]) then
					dxDrawImage(self.StartX+self.Border["Left"]+((i-1)*self.BoxWidth)-1,self.StartY+self.Border["Top"]+((k-1)*self.BoxWidth)-1, self.BoxWidth-2, self.BoxWidth-2, self.Images["target"])
				else
					dxDrawRectangle(self.StartX+self.Border["Left"]+((i-1)*self.BoxWidth)-1,self.StartY+self.Border["Top"]+((k-1)*self.BoxWidth)-1, self.BoxWidth-2, self.BoxWidth-2, self.Color["target"], false)
				end
			end
		end
	end
	
	--Ball
	dxDrawRectangle(self.StartX+self.Ball["X"]-(self.Ball["Radius"]),self.StartY+self.Ball["Y"]-(self.Ball["Radius"]), self.Ball["Radius"], self.Ball["Radius"], tocolor(255,0,0,255), false)
	
	--Racket
	dxDrawRectangle(self.StartX+self.Racket["X"]+(math.floor(self.Racket["Width"]/2)),self.StartY+self.Border["Top"]+self.Border["Bottom"]+((#self.Targets)*self.BoxWidth)-10, self.Racket["Width"], 5, tocolor(0,255,0,255), false)
end

function CBreakout:move()
	if (not self.Finished) then
		--Handling
		if (getKeyState("arrow_l")) then
			if not ((self.Racket["X"]-3+math.floor(self.Racket["Width"]/2) < 0)) then
				self.Racket["FramesWithoutVel"] = 0
				self.Racket["X"] = self.Racket["X"]-6
				self.Racket["LastVel"] = -3
			end
		end
		if (getKeyState("arrow_r")) then
			if not ((self.Racket["X"]+3+math.floor(self.Racket["Width"]*1.5) > self.Width)) then
				self.Racket["FramesWithoutVel"] = 0
				self.Racket["X"] = self.Racket["X"]+6
				self.Racket["LastVel"] = 3
			else
			
			end
		end
		self.Racket["FramesWithoutVel"] = self.Racket["FramesWithoutVel"]+1
		--Check Ball Collision
		--Walls
		if ( (self.Ball["X"]+self.Ball["VelX"]+self.Ball["Radius"] > self.Width) or (self.Ball["X"]+self.Ball["VelX"]-self.Ball["Radius"] < 1) ) then
			self.Ball["VelX"] = self.Ball["VelX"]*-1
		end
		if ( (self.Ball["Y"]+self.Ball["VelY"]-self.Ball["Radius"] < 1) or (self.Ball["Y"]+self.Ball["VelY"]+self.Ball["Radius"] > self.Height)) then
			if (self.Ball["Y"]+self.Ball["VelY"]+self.Ball["Radius"] > self.Height) then
				self:setFinished(true)
			else
				self.Ball["VelY"] = self.Ball["VelY"]*-1
			end
		end
		--Racket
		if (self.Ball["Y"]+self.Ball["VelY"]+self.Ball["Radius"] >= self.Height-5) then
			if (isPointInRectangle(self.Ball["X"], 2, self.Racket["X"]+math.floor(self.Racket["Width"]/2), 0, self.Racket["Width"], 5)) then
				if (self.Racket["FramesWithoutVel"]<=30) then
					if (self.Racket["FramesWithoutVel"] == 0) then
						self.Ball["VelX"] = self.Racket["LastVel"]/3
					else
						self.Ball["VelX"] = self.Ball["VelX"]+( (self.Racket["LastVel"]/3)*(1/(self.Racket["FramesWithoutVel"]/3)) )
						if (self.Ball["VelX"] > 1.5) then
							self.Ball["VelX"] = 1.5
						end
					end
				end
				self.Ball["VelY"] = self.Ball["VelY"]*-1
			end
		end
		--Targets
		for k,v in ipairs(self.Targets) do
			for i,y in ipairs(v) do
				if (y == true) then
					--X
					local point = false
					if (isPointInRectangle(self.Ball["X"]+self.Ball["Radius"]+1, self.Ball["Y"]+self.Ball["Radius"], self.Border["Left"]+((i-1)*self.BoxWidth),self.Border["Top"]+((k-1)*self.BoxWidth),self.BoxWidth, self.BoxWidth) or isPointInRectangle(self.Ball["X"]-self.Ball["Radius"]-1, self.Ball["Y"]+self.Ball["Radius"], self.Border["Left"]+((i-1)*self.BoxWidth),self.Border["Top"]+((k-1)*self.BoxWidth),self.BoxWidth, self.BoxWidth)) then
						self.Ball["VelX"] = self.Ball["VelX"]*-1
						self.Targets[k][i] = false
						point = true
					end
					if (isPointInRectangle(self.Ball["X"]+self.Ball["Radius"]+1, self.Ball["Y"]-self.Ball["Radius"], self.Border["Left"]+((i-1)*self.BoxWidth),self.Border["Top"]+((k-1)*self.BoxWidth),self.BoxWidth, self.BoxWidth) or isPointInRectangle(self.Ball["X"]-self.Ball["Radius"]-1, self.Ball["Y"]-self.Ball["Radius"], self.Border["Left"]+((i-1)*self.BoxWidth),self.Border["Top"]+((k-1)*self.BoxWidth),self.BoxWidth, self.BoxWidth)) then
						self.Ball["VelX"] = self.Ball["VelX"]*-1
						self.Targets[k][i] = false
						point = true
					end
					if (isPointInRectangle(self.Ball["X"]+self.Ball["Radius"]+1, self.Ball["Y"], self.Border["Left"]+((i-1)*self.BoxWidth),self.Border["Top"]+((k-1)*self.BoxWidth),self.BoxWidth, self.BoxWidth) or isPointInRectangle(self.Ball["X"]-self.Ball["Radius"]-1, self.Ball["Y"], self.Border["Left"]+((i-1)*self.BoxWidth),self.Border["Top"]+((k-1)*self.BoxWidth),self.BoxWidth, self.BoxWidth)) then
						self.Ball["VelX"] = self.Ball["VelX"]*-1
						self.Targets[k][i] = false
						point = true
					end
					--Y
					if (isPointInRectangle(self.Ball["X"], self.Ball["Y"]+self.Ball["Radius"]+1, self.Border["Left"]+((i-1)*self.BoxWidth),self.Border["Top"]+((k-1)*self.BoxWidth),self.BoxWidth, self.BoxWidth) or isPointInRectangle(self.Ball["X"], self.Ball["Y"]-self.Ball["Radius"]-1, self.Border["Left"]+((i-1)*self.BoxWidth),self.Border["Top"]+((k-1)*self.BoxWidth),self.BoxWidth, self.BoxWidth)) then
						self.Ball["VelY"] = self.Ball["VelY"]*-1
						self.Targets[k][i] = false
						point = true
					end
					if (isPointInRectangle(self.Ball["X"]-self.Ball["Radius"], self.Ball["Y"]+self.Ball["Radius"]+1, self.Border["Left"]+((i-1)*self.BoxWidth),self.Border["Top"]+((k-1)*self.BoxWidth),self.BoxWidth, self.BoxWidth) or isPointInRectangle(self.Ball["X"]-self.Ball["Radius"], self.Ball["Y"]-self.Ball["Radius"]-1, self.Border["Left"]+((i-1)*self.BoxWidth),self.Border["Top"]+((k-1)*self.BoxWidth),self.BoxWidth, self.BoxWidth)) then
						self.Ball["VelY"] = self.Ball["VelY"]*-1
						self.Targets[k][i] = false
						point = true
					end
					if (isPointInRectangle(self.Ball["X"]+self.Ball["Radius"], self.Ball["Y"]+self.Ball["Radius"]+1, self.Border["Left"]+((i-1)*self.BoxWidth),self.Border["Top"]+((k-1)*self.BoxWidth),self.BoxWidth, self.BoxWidth) or isPointInRectangle(self.Ball["X"]+self.Ball["Radius"], self.Ball["Y"]-self.Ball["Radius"]-1, self.Border["Left"]+((i-1)*self.BoxWidth),self.Border["Top"]+((k-1)*self.BoxWidth),self.BoxWidth, self.BoxWidth)) then
						self.Ball["VelY"] = self.Ball["VelY"]*-1
						self.Targets[k][i] = false
						point = true
					end
					if (point) then
						self.Points = self.Points+1
					end
				end
			end
		end
		--Move Ball
		self.Ball["X"] = self.Ball["X"]+self.Ball["VelX"]
		self.Ball["Y"] = self.Ball["Y"]+self.Ball["VelY"]
	end
end

function CBreakout:setImage(key, img)
	self.Images[key] = img
end

function CBreakout:setFinished(state)
	self.Finished = state
end

function CBreakout:isFinished()
	return self.Finished
end

function CBreakout:getPoints()
	return self.Points
end