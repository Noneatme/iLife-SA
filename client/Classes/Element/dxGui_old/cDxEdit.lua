--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

ValidEditChars = {
	["a"] = "a",
	["b"] = "b",
	["c"] = "c",
	["d"] = "d",
	["e"] = "e",
	["f"] = "f",
	["g"] = "g",
	["h"] = "h",
	["i"] = "i",
	["j"] = "j",
	["k"] = "k",
	["l"] = "l",
	["m"] = "m",
	["n"] = "n",
	["o"] = "o",
	["p"] = "p",
	["q"] = "q",
	["r"] = "r",
	["s"] = "s",
	["t"] = "t",
	["u"] = "u",
	["v"] = "v",
	["w"] = "w",
	["x"] = "x",
	["y"] = "y",
	["z"] = "z",
	["0"] = "0",
	["1"] = "1",
	["2"] = "2",
	["3"] = "3",
	["4"] = "4",
	["5"] = "5",
	["6"] = "6",
	["7"] = "7",
	["8"] = "8",
	["9"] = "9",
	["num_0"] = "0",
	["num_1"] = "1",
	["num_2"] = "2",
	["num_3"] = "3",
	["num_4"] = "4",
	["num_5"] = "5",
	["num_6"] = "6",
	["num_7"] = "7",
	["num_8"] = "8",
	["num_9"] = "9",
	["-"] = "-",
	["."] = ".",
	[","] = ",",
	["/"] = "#",
	["#"] = "ä",
	["'"] = "ö",
	[";"] = "ü",
	["="] = "+",
	["["] = "ß",
	["space"] = " ",
	["*"] = "*"
}

ValidNumericChars = {
	["0"] = "0",
	["1"] = "1",
	["2"] = "2",
	["3"] = "3",
	["4"] = "4",
	["5"] = "5",
	["6"] = "6",
	["7"] = "7",
	["8"] = "8",
	["9"] = "9",
	["num_0"] = "0",
	["num_1"] = "1",
	["num_2"] = "2",
	["num_3"] = "3",
	["num_4"] = "4",
	["num_5"] = "5",
	["num_6"] = "6",
	["num_7"] = "7",
	["num_8"] = "8",
	["num_9"] = "9",
	["."] = "."
}

ValidUpperChars = {
	["a"] = "A",
	["b"] = "B",
	["c"] = "C",
	["d"] = "D",
	["e"] = "E",
	["f"] = "F",
	["g"] = "G",
	["h"] = "H",
	["i"] = "I",
	["j"] = "J",
	["k"] = "K",
	["l"] = "L",
	["m"] = "M",
	["n"] = "N",
	["o"] = "O",
	["p"] = "P",
	["q"] = "Q",
	["r"] = "R",
	["s"] = "S",
	["t"] = "T",
	["u"] = "U",
	["v"] = "V",
	["w"] = "W",
	["x"] = "X",
	["y"] = "Y",
	["z"] = "Z",
	["0"] = "=",
	["1"] = "!",
	["2"] = "\"",
	["3"] = "§",
	["4"] = "$",
	["5"] = "%",
	["6"] = "&",
	["7"] = "/",
	["8"] = "(",
	["9"] = ")",
	["-"] = "_",
	["."] = ":",
	[","] = ";",
	["/"] = "'",
	["="] = "*",
	["["] = "?",
	["#"] = "Ä",
	["'"] = "Ö",
	[";"] = "Ü",
	["space"] = " ",
}

CDxEdit = inherit(CDxElement)

addEventHandler("onClientResourceStart", getRootElement(),
	function(startedResource)
		if (startedResource == getThisResource()) then
			editl = dxCreateTexture("res/images/dxGui/dxEditLeft.png", "argb", true, "clamp")
			editr = dxCreateTexture("res/images/dxGui/dxEditRight.png", "argb", true, "clamp")
		end
	end
)

function CDxEdit:constructor(sText, left, top, width, height, sType, color, Parent)
	self.Text = sText
	self.Type = sType or "normal"
	if (self.Type == "Number") then
		self.ValidEditChars = ValidNumericChars
	else
		self.ValidEditChars = ValidEditChars
	end
	self.Color = color
	self.Parent = Parent or false
	if (self.Parent) then
		self.StartX, self.StartY = self.Parent:getStartPosition()
	else
		self.StartX = 0
		self.StartY = 0
	end
	
	CDxElement.constructor(self, self.StartX+left or 50, self.StartY+top or 50, width or 150, height or 30)
	
	self.fEdit = bind(self.edit, self)
	self.fClick = bind(self.click, self)
	self.tRemoveLastCharFromText = bind(self.removeLastCharFromTextTimer, self)
	self.bEnabled = true
	
	self:addClickFunction(
	function()
		if (not(self.Clicked) and self.bEnabled) then
			addEventHandler("onClientKey", getRootElement(),self.fEdit)
			addEventHandler("onClientClick", getRootElement(), self.fClick )
			self.Clicked = true
			guiSetInputEnabled (true)
		end
	end
	)
end

function CDxEdit:destructor()

end

function CDxEdit:render()
	cX,cY = getCursorPosition ()
	if ( isCursorOverRectangle(cX,cY, self.X, self.Y, self.Width, self.Height)) then
		self.rColor = tocolor(255, 255, 255, 255)
	else
		self.rColor = tocolor(255, 255, 255, 155)
	end
	
	--dxDrawImage(self.X, self.Y, 16, self.Height, editl, 0, 0, 0, self.rColor)
	--dxDrawImage(self.X+self.Width-16, self.Y, 16, self.Height, editr, 0, 0, 0, self.rColor)
	--dxDrawImage(self.X+15, self.Y, self.Width-30, self.Height, "res/images/dxGui/dxEditMid.png", 0, 0, 0, self.rColor)
	dxDrawRectangle(self.X, self.Y, self.Width, self.Height, tocolor(0,0,0,180), false)
	if (self.Type == "Masked") then
		local temp = ""
		for i=1,#self.Text do
			temp = temp.."*"
		end
		tw = dxGetTextWidth(temp, 1, "default-bold")
		dxDrawText(temp, self.X+16, self.Y, self.X+self.Width-16, self.Y+self.Height, self.rColor, 1, "default-bold", "left", "center")
	else
		if (self.Type == "number") then
			tw = dxGetTextWidth(self.Text, 1, "default-bold")
			dxDrawText(self.Text, self.X+16, self.Y, self.X+self.Width-16, self.Y+self.Height, self.rColor, 1, "default-bold", "left", "center")
		else
			tw = dxGetTextWidth(self.Text, 1, "default-bold")
			dxDrawText(self.Text, self.X+16, self.Y, self.X+self.Width-16, self.Y+self.Height, self.rColor, 1, "default-bold", "left", "center")
		end
	end
	if ((self.Clicked) and (getTickCount()%1000 > 500)) then
		dxDrawLine(self.X+17+tw, self.Y+10, self.X+17+tw, self.Y+self.Height-10, self.rColor, 2)
	end
end

function CDxEdit:getText()
	return self.Text
end

function CDxEdit:setText(value)
	self.Text = value
	return true
end

function CDxEdit:setEnabled(bool)
	self.bEnabled = bool and true or false
end

function CDxEdit:isEnabled()
	return self.bEnabled
end

function CDxEdit:edit(button, pressed)
	if (self.ValidEditChars[button]) then
		if (self.Type == "Masked") then
			if (pressed) then
				local temp = ""
				for i=1,#self.Text do
					temp = temp.."*"
				end
				if ( (getKeyState ("lshift") or getKeyState ("rshift"))) then
					if ((dxGetTextWidth(temp, 1, "default")+30) < self.Width ) then
						self.Text = self.Text..ValidUpperChars[button]
					end
				else
					if ((dxGetTextWidth(temp, 1, "default")+30) < self.Width ) then
						self.Text = self.Text..ValidEditChars[button]
					end
				end
			end
		else
			if (pressed) then
				if ( (getKeyState ("lshift") or getKeyState ("rshift")) and (self.Type~="Number") ) then
					if ((dxGetTextWidth(self.Text, 1, "default")+30) < self.Width ) then
					self.Text = self.Text..ValidUpperChars[button]
					end
				else
					if ((dxGetTextWidth(self.Text, 1, "default")+30) < self.Width ) then
						self.Text = self.Text..ValidEditChars[button]
						if (self.Type == "Number") then
							self.Text = tostring(math.floor(tonumber(self.Text)))
						end
					end
				end
			end
		end
	else
		if (button == "backspace") then
			if (pressed) then
				self:removeLastCharFromText()
				self.BackspaceTimer = setTimer(
					function()
						if (getKeyState("backspace")) then
							self.BackspaceTimer = setTimer(self.tRemoveLastCharFromText, 80, 0)
						end
					end, 200, 1)
			else
				if (isTimer(self.BackspaceTimer)) then
					killTimer(self.BackspaceTimer)
				end				
			end
		end
	end
end

function CDxEdit:click()
	cX, cY = getCursorPosition()
	if (not (isCursorOverRectangle(cX,cY,self.X,self.Y,self.Width,self.Height))) then
		removeEventHandler("onClientKey", getRootElement(), self.fEdit)
		removeEventHandler("onClientClick", getRootElement(), self.fClick)
		self.Clicked = false
		guiSetInputEnabled (false)
	end
end

function CDxEdit:removeLastCharFromText()
	if (self.Type == "Number") and (#self.Text == 1) then
		self.Text = "0"
	else
		self.Text = tostring(self.Text):sub(0, #tostring(self.Text)-1)
	end
end

function CDxEdit:removeLastCharFromTextTimer()
	if (getKeyState("backspace")) then
		self:removeLastCharFromText()
	else
		if (isTimer(self.BackspaceTimer)) then
			killTimer(self.BackspaceTimer)
		end
	end
end