--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

-- #######################################
-- ## Project: 	HUD iLife				##
-- ## For MTA: San Andreas				##
-- ## Name: RadialMenu.lua					##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

RadialMenu = {};
RadialMenu.__index = RadialMenu;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function RadialMenu:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// Open				//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function RadialMenu:Open()
	if(self.opened == false) then
		self.opened = true;

	end
end

-- ///////////////////////////////
-- ///// Close				//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function RadialMenu:Close()
	if(self.opened == true) then
		self.opened 	= false;
		self:Trigger(self.options[self.selectedOption]);
	end
end


-- ///////////////////////////////
-- ///// Render				//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function RadialMenu:Render()
	local sx, sy = guiGetScreenSize()
	local sx2, sy2 = guiGetScreenSize()

	sx = sx/2;
	sy = sy/2;
	local currentX, currentY;
	local abstand = 45


	local current_x, current_y = getCursorPosition()

	if not(current_x) then
		current_x, current_y = 0.5, 0.5;
	end
	if(getDistanceBetweenPoints2D(current_x*sx2, current_y*sy2, self.cursorStartX*sx2, self.cursorStartY*sy2) < 150) then
		rotation = -1;
	else
		rotation = self:findRotation(self.cursorStartX, self.cursorStartY, current_x, current_y)
	end
	local selectedOption = self:GetOptionFromRotation(rotation);

	if(self.openAlpha > 0) then
		if(self.selectedOption ~= selectedOption and selectedOption ~= 0) then
			self:PlayRadialSound(1);
		end
	end

	self.selectedOption = selectedOption;


	local defaultColor = tocolor(255, 255, 255, self.openAlpha);
	local selectedColor = tocolor(150, 150, 255, self.openAlpha);
	local fontcolor		= tocolor(0, 0, 0, self.openAlpha);
	-- Draws

	-- Top
	currentX = 361;
	currentY = 37;

	local color = defaultColor;
	local scale = 0.7;

	if(selectedOption == 1) then color = selectedColor end;
	dxDrawImage(sx-currentX/2, sy-abstand*2, currentX, currentY, self.pfad.images.."top.png", 0, 0, 0, color);

	dxDrawText(self.options[1], sx-currentX/2, sy-abstand*2, (sx-currentX/2)+currentX, (sy-abstand*2)+currentY, fontcolor, scale, self.font, "center", "center", true);

	color = defaultColor;
	-- Left1
	currentX = 298;
	currentY = 36;
	if(selectedOption == 2) then color = selectedColor end;
	dxDrawImage((sx-currentX)-60, sy-abstand, currentX, currentY, self.pfad.images.."left1.png", 0, 0, 0, color);
	dxDrawText(self.options[2], (sx-currentX)-60, sy-abstand, ((sx-currentX)-60)+currentX, (sy-abstand)+currentY, fontcolor, scale, self.font, "center", "center", true);


	color = defaultColor;
	-- Left2
	currentX = 314;
	currentY = 37;
	if(selectedOption == 3) then color = selectedColor end;
	dxDrawImage((sx-currentX)-90, sy, currentX, currentY, self.pfad.images.."left2.png", 0, 0, 0, color);
	dxDrawText(self.options[3], (sx-currentX)-90, sy, ((sx-currentX)-90)+currentX, (sy)+currentY, fontcolor, scale, self.font, "center", "center", true);

	color = defaultColor;
	-- Left3
	currentX = 310;
	currentY = 35;
	if(selectedOption == 4) then color = selectedColor end;
	dxDrawImage((sx-currentX)-90, sy+abstand, currentX, currentY, self.pfad.images.."left3.png", 0, 0, 0, color);
	dxDrawText(self.options[4], (sx-currentX)-90, sy+abstand, ((sx-currentX)-90)+currentX, (sy+abstand)+currentY, fontcolor, scale, self.font, "center", "center", true);

	color = defaultColor;
	-- Left4
	currentX = 298;
	currentY = 36;
	if(selectedOption == 5) then color = selectedColor end;
	dxDrawImage((sx-currentX)-60, sy+abstand*2, currentX, currentY, self.pfad.images.."left4.png", 0, 0, 0, color);
	dxDrawText(self.options[5], (sx-currentX)-60, sy+abstand*2, ((sx-currentX)-60)+currentX, (sy+abstand*2)+currentY, fontcolor, scale, self.font, "center", "center", true);

	color = defaultColor;
	-- Bottom
	currentX = 361;
	currentY = 37;
	if(selectedOption == 6) then color = selectedColor end;
	dxDrawImage(sx-currentX/2, sy+abstand*3, currentX, currentY, self.pfad.images.."bottom.png", 0, 0, 0, color);
	dxDrawText(self.options[6], (sx-currentX/2), sy+abstand*3, ((sx-currentX/2))+currentX, (sy+abstand*3)+currentY, fontcolor, scale, self.font, "center", "center", true);

	color = defaultColor;

	-- Right1
	currentX = 298;
	currentY = 36;
	if(selectedOption == 10) then color = selectedColor end;
	dxDrawImage((sx)+60, sy-abstand, currentX, currentY, self.pfad.images.."right1.png", 0, 0, 0, color);
	dxDrawText(self.options[10], (sx)+60, sy-abstand, ((sx)+60)+currentX, (sy-abstand)+currentY, fontcolor, scale, self.font, "center", "center", true);

	color = defaultColor;
	-- Right2
	currentX = 314;
	currentY = 37;
	if(selectedOption == 9) then color = selectedColor end;
	dxDrawImage((sx)+90, sy, currentX, currentY, self.pfad.images.."right2.png", 0, 0, 0, color);
	dxDrawText(self.options[9], (sx)+90, sy, ((sx)+90)+currentX, (sy)+currentY, fontcolor, scale, self.font, "center", "center", true);

	color = defaultColor;
	-- Right3
	currentX = 310;
	currentY = 35;
	if(selectedOption == 8) then color = selectedColor end;
	dxDrawImage((sx)+90, sy+abstand, currentX, currentY, self.pfad.images.."right3.png", 0, 0, 0, color);
	dxDrawText(self.options[8], (sx)+90, sy+abstand, ((sx)+90)+currentX, (sy+abstand)+currentY, fontcolor, scale, self.font, "center", "center", true);

	color = defaultColor;
	-- Right4
	currentX = 298;
	currentY = 36;
	if(selectedOption == 7) then color = selectedColor end;
	dxDrawImage((sx)+60, sy+abstand*2, currentX, currentY, self.pfad.images.."right4.png", 0, 0, 0, color);
	dxDrawText(self.options[7], (sx)+60, sy+abstand*2, ((sx)+60)+currentX, (sy+abstand*2)+currentY, fontcolor, scale, self.font, "center", "center", true);

	color = defaultColor;

	-- Selection
	currentX = 180;
	currentY = 180;


	self.lastRotation = rotation;

	local name = "selection.png";

	if(rotation == -1) then
		name = "selection_default.png";
	end
	dxDrawImage((sx-currentX/2), sy-abstand, currentX, currentY, self.pfad.images..name, rotation, 0, 0, tocolor(255, 255, 255, self.openAlpha));

	if(self.opened) then
		if(self.openAlpha < self.maxAlpha) then
			self.openAlpha = self.openAlpha+15;
		end
	else
		if(self.openAlpha > 0) then
			self.openAlpha = self.openAlpha-15;
		end
	end

end


-- ///////////////////////////////
-- ///// Toggle		 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function RadialMenu:Toggle(key, state)
	if(state == "down") then
		if (clientBusy) then
			return false
		end
		toggleControl(self.control, false)
	
		local sx, sy = guiGetScreenSize();
		showCursor(true, false);
		setCursorAlpha(0);

		setTimer(setCursorPosition, 50, 1, sx/2, sy/2);

		self.cursorStartX, self.cursorStartY = getCursorPosition();
		self:Open()


		addEventHandler("onClientRender", getRootElement(), self.renderFunc);
	else
		self:Close()
		showCursor(false, false);
		setCursorAlpha(255);

		removeEventHandler("onClientRender", getRootElement(), self.renderFunc);
	end

end

-- ///////////////////////////////
-- ///// PlayRadialSound	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function RadialMenu:PlayRadialSound(iSound)
	if(iSound == 1) then
		playSound(self.pfad.sounds.."buttonrollover.wav");
	elseif(iSound == 2) then
		playSound(self.pfad.sounds.."buttonclickrelease.mp3");
	end
end

-- ///////////////////////////////
-- ///// FindRotation		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function RadialMenu:findRotation(x1,y1,x2,y2)

	if(x1 and y1 and x2 and y2) then
		local t = -math.deg(math.atan2(x2-x1,y2-y1))
		if t < 0 then t = t + 360 end;
		return t;
	else
		return self.lastRotation;
	end
end

-- ///////////////////////////////
-- ///// GetOptionFromRotation////
-- ///// Returns: void		//////
-- ///////////////////////////////

function RadialMenu:GetOptionFromRotation(iRot)
	local plusminus = 20;
	if(iRot ~= -1) then
		for value, option in pairs(self.rotationOptions) do
			if(value-plusminus < iRot and value+plusminus > iRot) then
				return option;
			end
		end
	end
	return 0;
end

-- ///////////////////////////////
-- ///// Trigger	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function RadialMenu:Trigger(befehl)
	if(befehl) then
		local sBefehl, sParams;

		--[[
		sBefehl = gettok(gettok(befehl, 1, "/"), 1, " ");

		sParams = split(befehl, "/"..sBefehl)[1];
		]]

		sBefehl = gettok(befehl, 1, "/");

		if(sBefehl) then
			sBefehl = gettok(sBefehl, 1, " ");
			sParams = split(gettok(befehl, 1, "/"), " ");

			if(sBefehl and sParams) then
				self:PlayRadialSound(2);
				triggerServerEvent("onRadialMenuTrigger", getLocalPlayer(), sBefehl, sParams);
				executeCommandHandler(sBefehl, unpack(sParams))
			end
		end

	end
end

-- ///////////////////////////////
-- ///// UpdateOptions 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function RadialMenu:UpdateOptions(tblNewOptions)
	self.options = tblNewOptions or {"", "", "", "", "", "", "", ""};
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function RadialMenu:Constructor(bBuildIn, tblOptions)
	self.opened 			= false;
	self.renderFunc			= function() self:Render() end;
	self.triggerFunc		= function(befehl) self:Trigger(befehl) end;
	self.openAlpha			= 0;
	self.maxAlpha			= 200;

	self.pfad 				= {}
	self.pfad.images 		= "res/images/RadialMenu/";
	self.pfad.sounds		= "res/sounds/RadialMenu/";
	self.pfad.fonts			= "res/fonts/";
	self.key				= "mouse3";
	self.control			= "vehicle_look_behind";

	self.options			= (tblOptions or {"", "", "", "", "", "", "", ""});
	self.cursorStartX, self.cursorStartY = 0, 0;
	self.lastRotation		= 0;

	self.font				= dxCreateFont(self.pfad.fonts.."asseenontv.ttf", 32, true);
	self.selectedOption		= 0;


	self.rotationOptions 	=
	{
		[180] = 1; -- Top
		[134] = 2; -- Left 1
		[106] = 3; -- Left 2
		[80] = 4; -- Left 3
		[51] = 5; -- Left 4
		[0] = 6; -- Bottom
		[360] = 6; -- Bottom
		[308] = 7; -- Right 4
		[280] = 8; -- Right 3
		[253] = 9; -- Right 2
		[225] = 10; -- Right 1
	};

	if(bBuildIn) then
		self.toggleFunc = function(...) self:Toggle(...) end;

		toggleControl(self.control, false)
		bindKey(self.key, "both", self.toggleFunc)
	end

	--outputDebugString("[CALLING] RadialMenu: Constructor");
end

-- ///////////////////////////////
-- ///// Destructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function RadialMenu:Destructor(...)
	removeEventHandler("onClientRender", getRootElement(), self.renderFunc);

end



-- EVENT HANDLER --
