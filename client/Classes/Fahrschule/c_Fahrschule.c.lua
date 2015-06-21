--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

--[[
addEventHandler("onClientResourceStart", getRootElement(), function()

	local pnl

	addEventHandler("onClientMarkerHit", createMarker(762.29998779297, -1564.1999511719, 13.5, "corona", 4, 255, 0, 0, 255), function(hit)
		if (hit == localPlayer) then
			setElementFrozen(localPlayer, true)
			pnl = C_MenuPanel.new(7)
			pnl.addButton(C_MenuButton.new("Fahrschule 1", 200, 50, 0, 0, 0, 200, 200, 200, 255, 255, 255))
			local btn = C_MenuButton.new("still", 200, 50, 0, 0, 0, 200, 200, 200, 255, 255, 255)
			btn.addMouseClickFunction(function() outputChatBox("test") end)
			pnl.addButton(btn)
			pnl.addButton(C_MenuButton.new("in work!", 200, 50, 0, 0, 0, 200, 200, 200, 255, 255, 255))
			pnl.addButton(C_MenuButton.new("Ya know", 200, 50, 0, 0, 0, 200, 200, 200, 255, 255, 255))
			pnl.addButton(C_MenuButton.new("english?", 200, 50, 0, 0, 0, 200, 200, 200, 255, 255, 255))
			pnl.addButton(C_MenuButton.new("press", 200, 50, 0, 0, 0, 200, 200, 200, 255, 255, 255))
			btn = C_MenuButton.new("Exit", 200, 50, 0, 0, 0, 200, 200, 200, 255, 255, 255)
			btn.addMouseClickFunction(function() 
				local count = 0
				local lastIndex = 0
				local buttons = pnl.getButtons()
				
				addEventHandler("onClientRender", getRootElement(), function()
					if (count % 10 == 0) then
						lastIndex = lastIndex + 1
						buttons[lastIndex].fadeButton(true, 20, 10, 10)
						if (lastIndex == #buttons) then
							removeEventHandler("onClientRender", getRootElement(), debug.getinfo(1,"f").func)
						end
					end
					count = count + 1
				end
				)
			end
			)
			btn.addButtonFadedOutFunction(function() pnl.delete() setElementFrozen(localPlayer, false) end)
			pnl.addButton(btn)
			
			local count = 0
			local lastIndex = 0
			local buttons = pnl.getButtons()
			
			addEventHandler("onClientRender", getRootElement(), function()
				if (count % 10 == 0) then
					lastIndex = lastIndex + 1
					buttons[lastIndex].fadeButton(false, 20, 10, 10)
					if (lastIndex == #buttons) then
						removeEventHandler("onClientRender", getRootElement(), debug.getinfo(1,"f").func)
					end
				end
				count = count + 1
			end
			)
		end
	end
	)
	
end
)
]]
