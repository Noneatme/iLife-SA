--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CDxElement = {}

function CDxElement:constructor(iX, iY, iWidth, iHeight)
	self.X 					= iX;
	self.Y 					= iY;
	self.Width 				= iWidth;
	self.Height 			= iHeight;
	self.ClickFunction 		= false;
	self.clickExecute 		= {};
	self.Visible 			= true;
	self.Disabled 			= false;
end

function CDxElement:destructor()
	if (self:hasClickFunction()) then
		removeEventHandler ( "onClientClick", getRootElement(), self.eOnClick)
	end
end

function CDxElement:onClick(button, state)
	if(self:hasClickFunction()) then
		if (button == "left" and state == "down") then
			cX,cY = getCursorPosition ()
			if (isCursorOverRectangle(cX,cY,self.X, self.Y, self.Width, self.Height)) then
				if(self.Disabled == false) then
					for k,clickFunction in ipairs(self.clickExecute) do
						clickFunction()
					end
				end
			end
		end
	end
end

function CDxElement:addClickFunction(func)
	table.insert(self.clickExecute,bind(func,self))
	self.ClickFunction = true
	
	self.eOnClick = bind(self.onClick, self)
end

function CDxElement:addClickHandlers(key)
	if (self.ClickFunction) then
		-- DEV: outputChatBox("Element: "..key)
		addEventHandler ( "onClientClick", getRootElement(), self.eOnClick)
	end
end

function CDxElement:removeClickHandlers()
	if (self.ClickFunction) then
		removeEventHandler ( "onClientClick", getRootElement(), self.eOnClick)
	end
end

function CDxElement:hasClickFunction()
	return self.ClickFunction
end

function CDxElement:setVisible(bState)
	self.Visible = bState
end

function CDxElement:getVisible()
	return self.Visible
end

function CDxElement:setDisabled(bBool)
	self.Disabled = bBool;
end
function CDxElement:getDisabled()
	return self.Disabled;
end