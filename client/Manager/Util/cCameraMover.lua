--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

-- ###############################
-- ## Project: MTA:iLife		##
-- ## Name: CameraMover			##
-- ## Author: Noneatme			##
-- ## Version: 1.0				##
-- ## License: See top Folder	##
-- ###############################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings

CameraMover = {};
CameraMover.__index = CameraMover;


-- ///////////////////////////////
-- ///// New 				//////
-- ///////////////////////////////

function CameraMover:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// RenderCam		 	//////
-- ///////////////////////////////

function CameraMover:RenderCam()
	local x, y, z = getElementPosition(self.startObject);
	local x2, y2, z2 = getElementPosition(self.lookatObject);
	setCameraMatrix(x, y, z, x2, y2, z2);
end

-- ///////////////////////////////
-- ///// GetCurrentMatrix	//////
-- ///////////////////////////////

function CameraMover:GetCurrentMatrix()
	local x1, y1, z1, x2, y2, z2 = getCameraMatrix()
	return {x1, y1, z1, x2, y2, z2};
end

-- ///////////////////////////////
-- ///// GetCamPos		 	//////
-- ///////////////////////////////

function CameraMover:GetCamPos()
	return getCameraMatrix();
end

-- ///////////////////////////////
-- ///// SmoothMoveCamera 	//////
-- ///////////////////////////////

function CameraMover:SmoothMoveCamera(x1, y1, z1, x2, y2, z2, x3, y3, z3, x4, y4, z4, time, easing)
	if(self.state == true) then
		killTimer(self.stopTimer)
		self.state = false;
		removeEventHandler("onClientPreRender", getRootElement(), self.renderFunc);
		
		
		setCameraMatrix(x3, y3, z3, x4, y4, z4);
	end
	
	self.state = true;
	setElementPosition(self.startObject, x1, y1, z1);
	setElementPosition(self.lookatObject, x2, y2, z2);
	if(easing) then else
		easing = "InOutQuad";
	end
	moveObject(self.startObject, time, x3, y3, z3, 0, 0, 0, easing);
	moveObject(self.lookatObject, time, x4, y4, z4, 0, 0, 0, easing);
	
	self.renderFunc = function()
		self:RenderCam();
	end
	addEventHandler("onClientPreRender", getRootElement(), self.renderFunc);
	
	self.stopTimer = setTimer(function()
		self.state = false;
		removeEventHandler("onClientPreRender", getRootElement(), self.renderFunc);
	end, time, 1)
end

-- ///////////////////////////////
-- ///// StopCam			//////
-- ///////////////////////////////

function CameraMover:StopCam()

	if(self.state == true) then
		killTimer(self.stopTimer)
		self.state = false;
		removeEventHandler("onClientPreRender", getRootElement(), self.renderFunc);
		
		
	--	setCameraMatrix(x3, y3, z3, x4, y4, z4);
	end
end	

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///////////////////////////////

function CameraMover:Constructor(...)
	self.state = false;
	self.startObject = createObject(1337, 0, 0, 0);
	self.lookatObject = createObject(1337, 0, 0, 0);
	setObjectScale(self.startObject, 0);
	setObjectScale(self.lookatObject, 0);
--	logger:OutputInfo("[CALLING] CameraMover: Constructor");
end

-- EVENT HANDLER --
