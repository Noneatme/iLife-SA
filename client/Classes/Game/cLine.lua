--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

vCLine = {}

function CLine:constructor(fieldRows, fieldColumns, w, ItemsPerMinute, Speeds)
	self.Field = {}
	
	self.BoxWidth = w or 50
	
	self.Images = {
		["item"] = "",
		["garbage1"] = "",
		["garbage2"] = "",

	}
	
	self.DigFont = dxCreateFont("/res/fonts/DS-DIGI.ttf", 16)
	
	self.ItemsPerMinute = ItemsPerMinute or 40
	
	
	self.Status = 0
	
	self.eOnRender = bind(CLine.render, self)
end

function CLine:destructor()
	removeEventHandler("onClientRender", getRootElement(), self.eOnRender)
end


function CLine:render()
	local cX,cY = getCursorPosition()
	
	local startx, starty = (sx/2)-((#self.Field*self.BoxWidth)/2),sy/2-((#self.Field[1]*self.BoxWidth)/2)
	
end

function CLine:setImage(key, img)
	self.Images[key] = img
end

function CLine:setFinished(state)
	self.Finished = state
end

function CLine:isFinished()
	return self.Finished
end

function CLine:getStacks()
	return self.Stacks
end

function CLine:getStatus()
	return self.Status
end

function CLine:start()
	self.StartTick = getTickCount()
	addEventHandler("onClientRender", getRootElement(), self.eOnRender)
end

addCommandHandler("startmine", 
	function()
		local instance = new(CLine, 9, 9, 20, 1)
		instance:start()
	end
)