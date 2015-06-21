--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]


local screenX, screenY = guiGetScreenSize()
local mouseClickSound = "res/sounds/DynamicMenu/mouseClick.mp3"
local mouseEnterSound = "res/sounds/DynamicMenu/mouseEnter.mp3"

C_MenuPanel = {}

C_MenuPanel.new = function(_gap)
	
	assert(type(_gap) == "number", "'Gap' is not a valid number!")
	
	local this = {
		gap = _gap
	}
	
	local buttons = {}
	local buttonHeights = 0
	local lastSelectedButton = 0
	local instanceAlive = true
	
	function this.addButton(button)
		
		assert(button.getType() == "button", "'Button' is not a valid object!")
		
		buttons[#buttons + 1] = button
		buttonHeights = buttonHeights + button.getHeight()
		local y = screenY / 2 - (buttonHeights + (#buttons - 1) * this.gap) / 2
		
		for index, button in ipairs(buttons) do
			button.setY(y)
			y = y + button.getHeight() + this.gap
		end
	end
	
	function this.getButtons()
		return buttons
	end
	
	function this.fadeButtons(...)
		for index, button in ipairs(buttons) do
			button.fadeButton(...)
		end
	end
	
	function this.getLastSelectedButton()
		return lastSelectedButton
	end
	
	-- render-engine wich renders the assigned buttons
	addEventHandler("onClientRender", getRootElement(), function()
		if not (instanceAlive) then
			removeEventHandler("onClientRender", getRootElement(), debug.getinfo(1,"f").func)
		end
		
		for index, button in ipairs(buttons) do
			local x = button.getX()
			local y = button.getY()
			local width = button.getWidth()
			local height = button.getHeight()
			
			if (button.getState() == "fadedIn") then -- when menu is faded in
				if not (isCursorShowing()) then -- when not cursor is showing
					dxDrawRectangle(x, y, width, height, tocolor(button.rr, button.rg, button.rb, button.getAlpha()))
					dxDrawText(button.text, x, y, x + width, y + height, tocolor(button.tr, button.tg, button.tb, button.getAlpha()), 2, "arial", "center", "center", true, true)
				else -- when cursor is showing
					local cursorX, cursorY = getCursorPosition()
					cursorX = cursorX * screenX
					cursorY = cursorY * screenY
					
					if (cursorX >= x and cursorX <= x + width) and (cursorY >= y and cursorY <= y + height) then -- on mouse enter
						if (lastSelectedButton ~= index) then
							lastSelectedButton = index
							playSound(mouseEnterSound)
							if (type(button.mouseEnterFunction) == "function") then
								button.mouseEnterFunction()
							end
						end
						dxDrawRectangle(x - 20, y - 10, width + 40, height, tocolor(button.rr, button.rg, button.rb, button.getAlpha()))
						dxDrawText(button.text, x - 20, y - 10, x + width + 20, y + height, tocolor(button.tr, button.tg, button.tb, button.getAlpha()), 2, "arial", "center", "center", true, true)
					else -- on mouse leave
						if (lastSelectedButton == index) then
							lastSelectedButton = 0
							if (type(button.mouseLeaveFunction) == "function") then
								button.mouseLeaveFunction()
							end
						end
						dxDrawRectangle(x, y, width, height, tocolor(button.rr, button.rg, button.rb, button.getAlpha()))
						dxDrawText(button.text, x, y, x + width, y + height, tocolor(button.tr, button.tg, button.tb, button.getAlpha()), 2, "arial", "center", "center", true, true)
					end
					
				end
			else -- when menu not is faded in
				dxDrawRectangle(x, y, width, height, tocolor(button.rr, button.rg, button.rb, button.getAlpha()))
				dxDrawText(button.text, x, y, x + width, y + height, tocolor(button.tr, button.tg, button.tb, button.getAlpha()), 2, "arial", "center", "center", true, true)
			end
		end
	end
	)
	
	addEventHandler("onClientClick", getRootElement(), function(button, mouseState)
		if not (type(this) == "table") then
			removeEventHandler("onClientClick", getRootElement(), debug.getinfo(1,"f").func)
		end
		
		if (lastSelectedButton > 0) and (buttons[lastSelectedButton].getState() == "fadedIn") then
			if (button == "left") and (mouseState == "up") then
				playSound(mouseClickSound)
				buttons[lastSelectedButton].triggerMouseClickFunction()
			end
		end
	end
	)
	
	function this.delete()
		outputDebugString("Destructor C_MenuPanel")
		instanceAlive = false
		for index, button in ipairs(buttons) do
			button.delete()
		end
		this = nil
	end
	
	return this
end