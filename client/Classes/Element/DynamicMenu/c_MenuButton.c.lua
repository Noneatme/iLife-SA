--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

local screenX, screenY = guiGetScreenSize()

C_MenuButton = {}

C_MenuButton.new = function(_text, _width, _height, _rr, _rg, _rb, _br, _bg, _bb, _tr, _tg, _tb)
	
	assert(type(_text) == "string", "'Text' ist not a valid text!")
	assert(type(_width) == "number", "'Width' is not a valid number!")
	assert(type(_height) == "number", "'Width' is not a valid number!")
	
	--Rectangle Color
	assert(type(_rr) == "number" and _rr >= 0 and _rr <= 255, "'RR' is not a valid unsigned 8 bit number!")
	assert(type(_rg) == "number" and _rg >= 0 and _rg <= 255, "'RG' is not a valid unsigned 8 bit number!")
	assert(type(_rb) == "number" and _rb >= 0 and _rb <= 255, "'RB' is not a valid unsigned 8 bit number!")
	
	--Border Color
	assert(type(_br) == "number" and _br >= 0 and _br <= 255, "'BR' is not a valid unsigned 8 bit number!")
	assert(type(_bg) == "number" and _bg >= 0 and _bg <= 255, "'BG' is not a valid unsigned 8 bit number!")
	assert(type(_bb) == "number" and _bb >= 0 and _bb <= 255, "'BB' is not a valid unsigned 8 bit number!")
	
	--Text Color
	assert(type(_tr) == "number" and _tr >= 0 and _tr <= 255, "'TR' is not a valid unsigned 8 bit number!")
	assert(type(_tg) == "number" and _tg >= 0 and _tg <= 255, "'TG' is not a valid unsigned 8 bit number!")
	assert(type(_tb) == "number" and _tb >= 0 and _tb <= 255, "'TB' is not a valid unsigned 8 bit number!")
		
	local this = {
		text = _text,
		rr = _rr,
		rg = _rg,
		rb = _rb,
		br = _br,
		bg = _bg,
		bb = _bb,
		tr = _tr,
		tg = _tg,
		tb = _tb
	}

	local x = 0
	local y = 0
	local width = _width
	local height = _height
	local alpha = 0
	local state = "fadedOut"
	
	local mouseClickFunction = function() end
	local mouseEnterFunction = function() end
	local mouseLeaveFunction = function() end
	local buttonFadedOutFunction = function() end
	local buttonFadedInFunction = function() end
	
	local instanceAlive = true
	
	--X
	---------------------------------------------------------------------------------------------------
	function this.getX()
		return x
	end
	
	function this.setX(_x)
		assert(type(_x) == "number", "'X' ist not a valid number!")
		x = _x
	end
	
	--Y
	---------------------------------------------------------------------------------------------------
	function this.getY()
		return y
	end
	
	function this.setY(_y)
		assert(type(_y) == "number", "'Y' ist not a valid number!")
		y = _y
	end
	
	--Width
	---------------------------------------------------------------------------------------------------
	function this.getWidth()
		return width
	end
	
	function this.setWidth(_width)
		assert(type(_width) == "number", "'Width' ist not a valid number!")
		width = _width
	end
	
	--Height
	---------------------------------------------------------------------------------------------------
	function this.getHeight()
		return height
	end

	function this.setHeight(_height)
		assert(type(_height) == "number", "'Height' ist not a valid number!")
		height = _height
	end
	
	--Alpha
	---------------------------------------------------------------------------------------------------
	function this.getAlpha()
		return alpha
	end
	
	function this.setAlpha(_alpha)
		assert(type(_alpha) == "number", "'Alpha' ist not a valid number!")
		alpha = _alpha
	end
	
	--State
	---------------------------------------------------------------------------------------------------
	function this.getState()
		return state
	end
	
	function this.setState(_state)
		assert(_state == "fadedOut" or _state == "fadingIn" or _state == "fadedIn" or _state == "fadingOut", "No valid 'state'!")
		state = _state
	end

	--Event functions
	---------------------------------------------------------------------------------------------------
	--click
	function this.triggerMouseClickFunction()
		mouseClickFunction()
	end
	
	function this.addMouseClickFunction(func)
		assert(type(func) == "function", "'Func' ist not a valid function!")
		mouseClickFunction = func
	end
	
	function this.removeMouseClickFunction()
		mouseClickFunction = function() end
	end
	
	--mouse enter
	function this.triggerMouseEnterFunction()
		mouseEnterFunction()
	end
	
	function this.addMouseEnterFunction(func)
		assert(type(func) == "function", "'Func' ist not a valid function!")
		mouseEnterFunction = func
	end
	
	function this.removedMouseEnterFunction()
		mouseEnterFunction = function() end
	end
	
	--mouse leave
	function this.triggerMouseLeaveFunction()
		mouseLeaveFunction()
	end
	
	function this.addMouseLeaveFunctionfunc(func)
		assert(type(func) == "function", "'Func' ist not a valid function!")
		mouseLeaveFunction = func
	end
	
	function this.removedMouseLeaveFunction()
		mouseLeaveFunction = function() end
	end
	
	-- returns the type of the object
	function this.getType()
		return "button"
	end
	
	--fadedIn
	function this.triggerButtonFadedInFunction()
		buttonfadedInFunction()
	end
	
	function this.addButtonFadedInFunction(func)
		assert(type(func) == "function", "'Func' ist not a valid function!")
		buttonFadedInFunction = func
	end
	
	function this.removedButtonFadedInFunction()
		buttonFadedInFunction = function() end
	end
	
	--fadedOut
	function this.triggerButtonFadedOutFunction()
		buttonfadedOutFunction()
	end
	
	function this.addButtonFadedOutFunction(func)
		assert(type(func) == "function", "'Func' ist not a valid function!")
		buttonFadedOutFunction = func
	end
	
	function this.removedButtonFadedOutFunction()
		buttonFadedOutFunction = function() end
	end
	
	-- returns the type of the object
	function this.getType()
		return "button"
	end
	
	-- this function changes just the render values but dont renders the button itselfs
	function this.fadeButton(fade, frames, pixelPerFrame, alphaPerFrame)
		if (instanceAlive) then
		
			assert(type(fade) == "boolean", "'Fade' is not a valid boolean!")
			assert(type(frames) == "number", "'Frames' is not a valid number!")
			assert(type(pixelPerFrame) == "number", "'PixelPerFrame' is not a valid number!")
			assert(type(alphaPerFrame) == "number" and alphaPerFrame >= 0 and alphaPerFrame <= 255, "'AlphaPerFrame' is not a valid unsigned 8 bit number!")
			
			if (fade) then -- block for fading out
				if (state == "fadedIn") then
					state = "fadingOut"
					
					addEventHandler("onClientRender", getRootElement(), function()
						if not (instanceAlive) then
							removeEventHandler("onClientRender", getRootElement(), debug.getinfo(1,"f").func)
						else
						
							if (this.getX() <= screenX / 2 - width / 2 - frames * pixelPerFrame) then
								state = "fadedOut"
								this.setAlpha(0)
								removeEventHandler("onClientRender", getRootElement(), debug.getinfo(1,"f").func)
								buttonFadedOutFunction()
							else -- freeze alpha when 0
								this.setX(this.getX() - pixelPerFrame)
								local alpha = this.getAlpha()
								if (alpha >= 0 + alphaPerFrame) then
									this.setAlpha(this.getAlpha() - alphaPerFrame)
								elseif (alpha < 0 + alphaPerFrame) and (alpha > 0) then
									this.setAlpha(0)
								end
							end
						end
					end
					)
				end
			elseif not (fade) then -- block for fading in
				if (state == "fadedOut") then
					state = "fadingIn"
					this.setX((screenX / 2 - width / 2) + (frames * pixelPerFrame))
					
					addEventHandler("onClientRender", getRootElement(), function()
						if not (instanceAlive) then
							removeEventHandler("onClientRender", getRootElement(), debug.getinfo(1,"f").func)
						else
						
							if (this.getX() <= screenX / 2 - width / 2) then
								state = "fadedIn"
								removeEventHandler("onClientRender", getRootElement(), debug.getinfo(1,"f").func)
								buttonFadedInFunction()
							else -- freeze alpha when max alpha
								this.setX(this.getX() - pixelPerFrame)
								local alpha = this.getAlpha()
								if (alpha <= 255 - alphaPerFrame) then
									this.setAlpha(this.getAlpha() + alphaPerFrame)
								elseif (alpha < 255) and (alpha > alpha - alphaPerFrame) then
									this.setAlpha(255)
								end
							end
						end
					end
					)
				end
			end
		end
	end
	
	function this.delete()
		instanceAlive = false
		this = nil
	end

	return this
end