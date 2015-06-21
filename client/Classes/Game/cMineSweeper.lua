--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CMineSweeper = {}

function CMineSweeper:constructor(fieldRows, fieldColumns, w, Bombs)
	self.Field = {}
	for i=1,fieldRows,1 do
		self.Field[i] = {}
		for k=1,fieldColumns,1 do
			self.Field[i][k] = 0
		end
	end
	
	self.visibleField = {}
	for i=1,fieldRows,1 do
		self.visibleField[i] = {}
		for k=1,fieldColumns,1 do
			self.visibleField[i][k] = 0
		end
	end
	self.BoxWidth = w or 50
	
	self.Images = {
		["mine"] = "res/images/games/minesweeper/mine.png",
		["defuse"] = "res/images/games/minesweeper/flag.png",
		["faildefuse"] = "res/images/games/minesweeper/failflag.png",
		["bad"] = "res/images/games/minesweeper/bad.png",
		["oh"] = "res/images/games/minesweeper/oh.png",
		["cool"] = "res/images/games/minesweeper/cool.png",
		["happy"] = "res/images/games/minesweeper/happy.png",
	}
	
	self.DigFont = dxCreateFont("/res/fonts/DS-DIGI.ttf", 16)
	
	self.Bombs = Bombs or 10
	
	self:generateField()
	
	
	self.FieldsToWin = (fieldRows*fieldColumns)-self.Bombs
	self.DefuseAttemps = self.Bombs
	self.Status = 0
	
	self.eOnRender = bind(CMineSweeper.render, self)
end

function CMineSweeper:destructor()
	removeEventHandler("onClientRender", getRootElement(), self.eOnRender)
end

function CMineSweeper:generateField()
	local placed = 0
	while placed < self.Bombs do
		local row = math.random(1, #self.Field)
		local column = math.random(1, #self.Field[1])
		if (self.Field[row][column] ~= "bomb") then
			self.Field[row][column] = "bomb"
			placed = placed+1
		end
	end
	
	for row,columnt in ipairs(self.Field) do
		for column, value in ipairs(columnt) do
			-- increase number around the bombs!
			if (value == "bomb") then
				if (row > 1) then
					if (column > 1) then
						self:increaseField(row-1, column-1)
					end
					if (column < #columnt) then
						self:increaseField(row-1, column+1)
					end
					self:increaseField(row-1, column)
				end
				if (row < #self.Field) then
					if (column > 1) then
						self:increaseField(row+1, column-1)
					end
					if (column < #columnt) then
						self:increaseField(row+1, column+1)
					end
					self:increaseField(row+1, column)
				end
				if (column > 1) then
					self:increaseField(row, column-1)
				end
				if (column < #columnt) then
					self:increaseField(row, column+1)
				end
			end
		end
	end
end

function CMineSweeper:increaseField(x,y)
	if (self.Field[x][y] ~= "bomb") then
		self.Field[x][y] = self.Field[x][y]+1
	end
end

function CMineSweeper:openFieldsAroundPoint(x,y)
	if (x > 1) then
		if (y > 1) then
			self:action(x-1,y-1,1)
		end
		if (y < #self.Field[1]) then
			self:action(x-1,y+1,1)
		end
		self:action(x-1,y,1)
		end
		if (x < #self.Field) then
			if (y > 1) then
				self:action(x+1,y-1,1)
			end
			if (y < #self.Field[1]) then
				self:action(x+1,y+1,1)
			end
			self:action(x+1,y,1)
		end
		if (y > 1) then
			self:action(x,y-1,1)
		end
		if (y < #self.Field[1]) then
			self:action(x,y+1,1)
		end
end

function CMineSweeper:action(x,y,typ)
	if (getTickCount()-self.StartTick > 1000) then
		if (self.visibleField[x][y] == 0) then
			-- open da field
			if (typ == 1) then
				if (self.Field[x][y] == 0) then
					self.visibleField[x][y] = 1
					self.FieldsToWin = self.FieldsToWin-1
					if (self.FieldsToWin == 0) then
						self.LastTick = getTickCount()
						self:setFinished(true)
						self.Status = 2
					end
					self:openFieldsAroundPoint(x,y)
				else
					if (self.Field[x][y] ~= "bomb") then
						self.visibleField[x][y] = 1
						self.FieldsToWin = self.FieldsToWin - 1
						if (self.FieldsToWin == 0) then
							self.LastTick = getTickCount()
							self:setFinished(true)
							self.Status = 2
						end
					else
						-- handle da bomba
						self.LastTick = getTickCount()
						self.Status = 1
						self:setFinished(true)
						for k,v in ipairs(self.visibleField) do
							for i,y in ipairs(v) do
								if (self.Field[k][i] == "bomb") then
									self.visibleField[k][i] = 1
								end
							end
						end
						
					end
				end
			end
			-- defuse da bomba
			if (typ == 2) then
				self.visibleField[x][y] = 2
				self.DefuseAttemps = self.DefuseAttemps - 1
			end
		else
			if (self.visibleField[x][y] == 2) then
				if (typ == 2) then
					self.visibleField[x][y] = 0
					self.DefuseAttemps = self.DefuseAttemps + 1
				end
			end
		end
	end
end

function CMineSweeper:render()
	local cX,cY = getCursorPosition()
	
	local startx, starty = (sx/2)-((#self.Field*self.BoxWidth)/2),sy/2-((#self.Field[1]*self.BoxWidth)/2)

	if (getKeyState("mouse1") and (not isCursorOverRectangle(cX,cY, startx, starty, self.BoxWidth*#self.Field[1], self.BoxWidth*#self.Field))) then
		self.ClickedX, self.ClickedY = false, false
	end
	
	dxDrawRectangle(startx, starty-30, #self.Field*self.BoxWidth, (#self.Field[1]*self.BoxWidth) +30, tocolor(0,0,0,200), false)
	dxDrawText(tostring(self.DefuseAttemps),startx ,((starty*2)-60), startx+(#self.Field*self.BoxWidth), 30, tocolor(255,255,255,255), 1, self.DigFont, "left", "center")
	if (self.Status == 0) then
		dxDrawText(tostring( math.round( (getTickCount()-self.StartTick) / 1000)),startx ,((starty*2)-60), startx+(#self.Field*self.BoxWidth), 30, tocolor(255,255,255,255), 1, self.DigFont, "right", "center")
		dxDrawImage((startx+(#self.Field*self.BoxWidth)/2)-15, ((starty)-30), 30, 30, self.Images["happy"])
		for k,v in ipairs(self.visibleField) do
			for i,y in ipairs(v) do
				if (y == 0) then
					if ( isCursorOverRectangle(cX,cY, startx+((k-1)*self.BoxWidth)+1, starty+((i-1)*self.BoxWidth)+1, self.BoxWidth-2, self.BoxWidth-2) ) then
						if (getKeyState("mouse1")) then
							self.ClickedX, self.ClickedY = k,i
							dxDrawRectangle(startx+((k-1)*self.BoxWidth)+1, starty+((i-1)*self.BoxWidth)+1, self.BoxWidth-2, self.BoxWidth-2, tocolor(155,155,155,170), false)
							dxDrawImage((startx+(#self.Field*self.BoxWidth)/2)-15, ((starty)-30), 30, 30, self.Images["oh"])
						else
							if ((self.ClickedX == k) and (self.ClickedY == i)) then
								self:action(k,i,1)
								self.ClickedX, self.ClickedY = false, false
							end
							dxDrawRectangle(startx+((k-1)*self.BoxWidth)+1, starty+((i-1)*self.BoxWidth)+1, self.BoxWidth-2, self.BoxWidth-2, tocolor(200,200,200,170), false)
						end
						if (getKeyState("mouse2")) then
							self.ClickedRX, self.ClickedRY = k,i
						else
							if ((self.ClickedRX == k) and (self.ClickedRY == i)) then
								self:action(k,i,2)
								self.ClickedRX, self.ClickedRY = false, false
							end
						end
					else
						dxDrawRectangle(startx+((k-1)*self.BoxWidth)+1, starty+((i-1)*self.BoxWidth)+1, self.BoxWidth-2, self.BoxWidth-2, tocolor(200,200,200,170), false)
					end
				else
					-- draw da field
					if (y == 1) then
						if (self.Field[k][i] == "0") then
							dxDrawRectangle(startx+((k-1)*self.BoxWidth)+1, starty+((i-1)*self.BoxWidth)+1, self.BoxWidth-2, self.BoxWidth-2, tocolor(75,75,75,170), false)
						else
							if (self.Field[k][i] ~= "bomb") then
								-- draw da number
								dxDrawRectangle(startx+((k-1)*self.BoxWidth)+1, starty+((i-1)*self.BoxWidth)+1, self.BoxWidth-2, self.BoxWidth-2, tocolor(75,75,75,170), false)
								if (self.Field[k][i] ~= 0) then
									local interp = self.Field[k][i]/5
									if interp > 1 then interp=1 end
									local r,g,b = interpolateBetween(0,0,255,255,0,0, interp, "Linear")
									dxDrawText(tostring(self.Field[k][i]), startx+((k-1)*self.BoxWidth)+1, starty+((i-1)*self.BoxWidth)+1, startx+((k-1)*self.BoxWidth)+1+self.BoxWidth-2, starty+((i-1)*self.BoxWidth)+1+self.BoxWidth-2, tocolor(r,g,b,255), 2*(self.BoxWidth/30), "default-bold", "center", "center")
								end
							else
								-- Draw da Bomba!
								dxDrawRectangle(startx+((k-1)*self.BoxWidth)+1, starty+((i-1)*self.BoxWidth)+1, self.BoxWidth-2, self.BoxWidth-2, tocolor(75,75,75,170), false)
								dxDrawImage(startx+((k-1)*self.BoxWidth)+1, starty+((i-1)*self.BoxWidth)+1, self.BoxWidth-2, self.BoxWidth-2, self.Images["mine"])
							end
						end
					else
						-- Defuse attemp
						if (y == 2) then
							cX,cY = getCursorPosition ()
							if ( isCursorOverRectangle(cX,cY, startx+((k-1)*self.BoxWidth)+1, starty+((i-1)*self.BoxWidth)+1, self.BoxWidth-2, self.BoxWidth-2) ) then
								if (getKeyState("mouse2")) then
									self.ClickedRX, self.ClickedRY = k,i
								else
									if ((self.ClickedRX == k) and (self.ClickedRY == i)) then
										self:action(k,i,2)
										self.ClickedRX, self.ClickedRY = false, false
									end
								end
							end
							dxDrawRectangle(startx+((k-1)*self.BoxWidth)+1, starty+((i-1)*self.BoxWidth)+1, self.BoxWidth-2, self.BoxWidth-2, tocolor(155,155,155,170), false)
							dxDrawImage(startx+((k-1)*self.BoxWidth)+1, starty+((i-1)*self.BoxWidth)+1, self.BoxWidth-2, self.BoxWidth-2, self.Images["defuse"])
						end
					end
				end
			end
		end
	else
		dxDrawText(tostring( math.round( (self.LastTick-self.StartTick) / 1000)),startx ,((starty*2)-60), startx+(#self.Field*self.BoxWidth), 30, tocolor(255,255,255,255), 1, self.DigFont, "right", "center")
		if (self.Status == 1) then
			dxDrawImage((startx+(#self.Field*self.BoxWidth)/2)-15, ((starty)-30), 30, 30, self.Images["bad"])
			for k,v in ipairs(self.visibleField) do
				for i,y in ipairs(v) do
					if (y == 0) then
						dxDrawRectangle(startx+((k-1)*self.BoxWidth)+1, starty+((i-1)*self.BoxWidth)+1, self.BoxWidth-2, self.BoxWidth-2, tocolor(200,200,200,170), false)
					else
						-- draw da field
						if (y == 1) then
							if (self.Field[k][i] == "0") then
								dxDrawRectangle(startx+((k-1)*self.BoxWidth)+1, starty+((i-1)*self.BoxWidth)+1, self.BoxWidth-2, self.BoxWidth-2, tocolor(75,75,75,170), false)
							else
								if (self.Field[k][i] ~= "bomb") then
									-- draw da number
									dxDrawRectangle(startx+((k-1)*self.BoxWidth)+1, starty+((i-1)*self.BoxWidth)+1, self.BoxWidth-2, self.BoxWidth-2, tocolor(75,75,75,170), false)
									if (self.Field[k][i] ~= 0) then
										local interp = self.Field[k][i]/5
										if interp > 1 then interp=1 end
										local r,g,b = interpolateBetween(0,0,255,255,0,0, interp, "Linear")
										dxDrawText(tostring(self.Field[k][i]), startx+((k-1)*self.BoxWidth)+1, starty+((i-1)*self.BoxWidth)+1, startx+((k-1)*self.BoxWidth)+1+self.BoxWidth-2, starty+((i-1)*self.BoxWidth)+1+self.BoxWidth-2, tocolor(r,g,b,255), 2*(self.BoxWidth/30), "default-bold", "center", "center")
									end
								else
									-- Draw da Bomba!
									dxDrawRectangle(startx+((k-1)*self.BoxWidth)+1, starty+((i-1)*self.BoxWidth)+1, self.BoxWidth-2, self.BoxWidth-2, tocolor(75,75,75,170), false)
									dxDrawImage(startx+((k-1)*self.BoxWidth)+1, starty+((i-1)*self.BoxWidth)+1, self.BoxWidth-2, self.BoxWidth-2, self.Images["mine"])
								end
							end
						else
							-- Defuse attemp
							if (y == 2) then
								dxDrawRectangle(startx+((k-1)*self.BoxWidth)+1, starty+((i-1)*self.BoxWidth)+1, self.BoxWidth-2, self.BoxWidth-2, tocolor(155,155,155,170), false)
								dxDrawImage(startx+((k-1)*self.BoxWidth)+1, starty+((i-1)*self.BoxWidth)+1, self.BoxWidth-2, self.BoxWidth-2, self.Images["faildefuse"])
							end
						end
					end
				end
			end
		else
			if (self.Status == 2) then
				dxDrawImage((startx+(#self.Field*self.BoxWidth)/2)-15, ((starty)-30), 30, 30, self.Images["cool"])
				for k,v in ipairs(self.visibleField) do
					for i,y in ipairs(v) do
						if (y == 0) then
							dxDrawRectangle(startx+((k-1)*self.BoxWidth)+1, starty+((i-1)*self.BoxWidth)+1, self.BoxWidth-2, self.BoxWidth-2, tocolor(200,200,200,170), false)
							dxDrawImage(startx+((k-1)*self.BoxWidth)+1, starty+((i-1)*self.BoxWidth)+1, self.BoxWidth-2, self.BoxWidth-2, self.Images["defuse"])
						else
							-- draw da field
							if (y == 1) then
								if (self.Field[k][i] == "0") then
									dxDrawRectangle(startx+((k-1)*self.BoxWidth)+1, starty+((i-1)*self.BoxWidth)+1, self.BoxWidth-2, self.BoxWidth-2, tocolor(75,75,75,170), false)
								else
									if (self.Field[k][i] ~= "bomb") then
										-- draw da number
										dxDrawRectangle(startx+((k-1)*self.BoxWidth)+1, starty+((i-1)*self.BoxWidth)+1, self.BoxWidth-2, self.BoxWidth-2, tocolor(75,75,75,170), false)
										if (self.Field[k][i] ~= 0) then
											local interp = self.Field[k][i]/5
											if interp > 1 then interp=1 end
											local r,g,b = interpolateBetween(0,0,255,255,0,0, interp, "Linear")
											dxDrawText(tostring(self.Field[k][i]), startx+((k-1)*self.BoxWidth)+1, starty+((i-1)*self.BoxWidth)+1, startx+((k-1)*self.BoxWidth)+1+self.BoxWidth-2, starty+((i-1)*self.BoxWidth)+1+self.BoxWidth-2, tocolor(r,g,b,255), 2*(self.BoxWidth/30), "default-bold", "center", "center")
										end
									else
										-- Draw da Bomba!
										dxDrawRectangle(startx+((k-1)*self.BoxWidth)+1, starty+((i-1)*self.BoxWidth)+1, self.BoxWidth-2, self.BoxWidth-2, tocolor(75,75,75,170), false)
										dxDrawImage(startx+((k-1)*self.BoxWidth)+1, starty+((i-1)*self.BoxWidth)+1, self.BoxWidth-2, self.BoxWidth-2, self.Images["defuse"])
									end
								end
							else
								-- Defuse attemp
								if (y == 2) then
									dxDrawRectangle(startx+((k-1)*self.BoxWidth)+1, starty+((i-1)*self.BoxWidth)+1, self.BoxWidth-2, self.BoxWidth-2, tocolor(155,155,155,170), false)
									dxDrawImage(startx+((k-1)*self.BoxWidth)+1, starty+((i-1)*self.BoxWidth)+1, self.BoxWidth-2, self.BoxWidth-2, self.Images["defuse"])
								end
							end
						end
					end
				end
			end
		end
	end
	
end

function CMineSweeper:setImage(key, img)
	self.Images[key] = img
end

function CMineSweeper:setFinished(state)
	self.Finished = state
end

function CMineSweeper:isFinished()
	return self.Finished
end

function CMineSweeper:getStacks()
	return self.Stacks
end

function CMineSweeper:getStatus()
	return self.Status
end

function CMineSweeper:start()
	self.StartTick = getTickCount()
	addEventHandler("onClientRender", getRootElement(), self.eOnRender)
end

addCommandHandler("startmine", 
	function()
		local instance = new(CMineSweeper, 9, 9, 20, 1)
		instance:start()
	end
)