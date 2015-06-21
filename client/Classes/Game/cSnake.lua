--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

vCSnake = {}

function CSnake:constructor(fieldRows, fieldColumns, w, Speed, Eats)
	self.Field = {}
	for i=1,fieldRows,1 do
		self.Field[i] = {}
		for k=1,fieldColumns,1 do
			self.Field[i][k] = false
		end
	end
	
	self.BoxWidth = w or 50
	
	self.Move = "up"
	
	self.Field[math.floor(fieldRows/2)+1][math.floor(fieldColumns/2)+1] = "up"
	self.Field[math.floor(fieldRows/2)+1][math.floor(fieldColumns/2)+2] = "up"
	self.Field[math.floor(fieldRows/2)+1][math.floor(fieldColumns/2)+3] = "up"
	self.Field[math.floor(fieldRows/2)+1][math.floor(fieldColumns/2)+4] = "up"
	
	self.Cur = {
		["X"]= math.floor(fieldRows/2)+1,
		["Y"]= math.floor(fieldColumns/2)+1
	}
	
	self.Images = {
		["eat"] = false,
		["up"] = false,
		["down"] = false,
		["left"] = false,
		["right"] = false,
		["head"] = false
	}
	
	self.Color = {
		["eat"] = tocolor(255,255,255,255),
		["up"] = tocolor(0,255,0,255),
		["down"] = tocolor(0,255,0,255),
		["left"] = tocolor(0,255,0,255),
		["right"] = tocolor(0,255,0,255),
		["head"] = tocolor(0,125,0,255),
	}

	self.Stacks = 0
	
	self.Eats = Eats or 3
	
	for k=1,self.Eats,1 do
		self:placeEat()
	end
	
	self.Speed = Speed or 500
end

function CSnake:destructor()

end

function CSnake:placeEat()
	local placed = false
	repeat 
		local x,y = math.random(1,#self.Field), math.random(1,#self.Field[1])
		if (self.Field[x][y] == false) then
			self.Field[x][y] = "eat"
			placed = true
		end
	until placed==true
	return true
end

function CSnake:render()
	if not self.Lasttick then self.Lasttick = getTickCount() end
	local startx, starty = (sx/2)-((#self.Field*self.BoxWidth)/2),sy/2-((#self.Field[1]*self.BoxWidth)/2)
	dxDrawRectangle(startx, starty, #self.Field*self.BoxWidth, #self.Field[1]*self.BoxWidth, tocolor(0,0,0,100), false)
	for k,v in ipairs(self.Field) do
		for i,y in ipairs(v) do
			if (y == false) then
				dxDrawRectangle(startx+((k-1)*self.BoxWidth)+1, starty+((i-1)*self.BoxWidth)+1, self.BoxWidth-2, self.BoxWidth-2, tocolor(125,125,125,100), false)
			end
			if ((y == "up") or (y == "down") or (y == "left") or (y == "right") or (y == "eat")) then
				if (self.Images[y]) then
					dxDrawImage(startx+((k-1)*self.BoxWidth)+1, starty+((i-1)*self.BoxWidth)+1, self.BoxWidth-2, self.BoxWidth-2, self.Images[y])
				else
					dxDrawRectangle(startx+((k-1)*self.BoxWidth)+1, starty+((i-1)*self.BoxWidth)+1, self.BoxWidth-2, self.BoxWidth-2, self.Color[y], false)
				end
			end
		end
	end
	if (getKeyState("arrow_u")) then
		if (self.Field[self.Cur["X"]][self.Cur["Y"]] ~= "down") then
			self.Move = "up"
		end
	end
	if (getKeyState("arrow_d")) then
		if (self.Field[self.Cur["X"]][self.Cur["Y"]] ~= "up") then
			self.Move = "down"
		end
	end
	if (getKeyState("arrow_l")) then
		if (self.Field[self.Cur["X"]][self.Cur["Y"]] ~= "right") then
			self.Move = "left"
		end
	end
	if (getKeyState("arrow_r")) then
		if (self.Field[self.Cur["X"]][self.Cur["Y"]] ~= "left") then
			self.Move = "right"
		end
	end
	if (getTickCount() - self.Lasttick  > self.Speed) then
		self.Lasttick = getTickCount()
		self:move()
	end
end

function CSnake:move()
	if (not self.Finished) then
		local oldField = {}
		
		for k,v in ipairs(self.Field) do
			oldField[k] = v
		end
		local CurX = self.Cur["X"]
		local CurY = self.Cur["Y"]
		local c1,c2 = 0,0
		
		--Head
		local velX = 0
		local velY = 0
		if (self.Move == "up") then
			velY = -1
		end
		if (self.Move == "down") then
			velY = 1
		end
		if (self.Move == "left")then
			velX = -1
		end
		if (self.Move == "right") then
			velX = 1
		end
		if (((CurX+velX <= #self.Field) and CurX+velX>= 1) and ((CurY+velY <= #self.Field[1]) and CurY+velY>= 1)) and ((oldField[CurX+velX][CurY+velY] == false) or (oldField[CurX+velX][CurY+velY] == "eat")) then
			if (oldField[CurX+velX][CurY+velY] == "eat") then
				--Head -> Eat
				self.Field = oldField
				self.Field[CurX+velX][CurY+velY] = self.Move
				self.Field[CurX][CurY] = self.Move
				self.Cur["X"] = CurX+(velX)
				self.Cur["Y"] = CurY+(velY)
				self:placeEat()
				self.Speed = math.floor(self.Speed*0.92)
				self.Stacks = self.Stacks+1
				return
			else
				--Head -> Leeres Feld
				self.Field[CurX+velX][CurY+velY] = self.Move
				self.Field[CurX][CurY] = self.Move					
				self.Cur["X"] = CurX+velX
				self.Cur["Y"] = CurY+velY
			end
		else
			--Ende
			self.Finished = true
		end
		
		-- Field
		local oneDeleted = false
		for k,v in ipairs(oldField) do
			for i,y in ipairs(v) do	
				if not(oneDeleted) then
					velX = 0
					velY = 0
					if (y == "up") then
						velY = -1
					end
					if (y == "down") then
						velY = 1
					end
					if (y == "left")then
						velX = -1
					end
					if (y == "right") then
						velX = 1
					end
					if ((velX == 0) and (velY == 0)) or ((CurX == k) and (CurY == i)) then
					else
						if ((k+velX <= #oldField) and (i+velY <=#oldField[1]) and (k+velX >= 1) and (i+velY >= 1) ) then
							local del = true
							if (k+1 <= #oldField)  then
								if (oldField[k+1][i+0] == "left") then
									del = false
								end
							end
							if (i+1 <=#oldField[1]) then
								if (oldField[k][i+1] == "up") then
									del = false
								end
							end
							if (k-1 >= 1) then
								if (oldField[k-1][i] == "right") then
									del = false
								end
							end
							if (i-1 >= 1)then
								if (oldField[k][i-1] == "down") then
									del = false
								end
							end
							if (del) and not(oneDeleted) then
								oneDeleted = true
								self.Field[k][i] = false
							end
						else
							--self.Finished = true
						end
					end
				end
			end
		end
	end
end

function CSnake:setImage(key, img)
	self.Images[key] = img
end

function CSnake:setFinished(state)
	self.Finished = state
end

function CSnake:isFinished()
	return self.Finished
end

function CSnake:getStacks()
	return self.Stacks
end