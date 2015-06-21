--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

--
-- Created by IntelliJ IDEA.
-- User: Noneatme
-- Date: 25.12.2014
-- Time: 20:02
-- Project: MTA iLife
--

cCoronaMarker3D = {};

local Corona_Markers        = {};
local C_ID                  = 1;
local Corona_Textures       =
{
	[1] = dxCreateTexture("res/images/render/corona/1.png"),
	[2] = dxCreateTexture("res/images/render/corona/2.png"),
}
--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function cCoronaMarker3D:new(...)
	local obj = setmetatable({}, {__index = self});
	if obj.constructor then
		obj:constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// Render      		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCoronaMarker3D:render()
	local x, y, z = getElementPosition(self.uObject);

	if(getScreenFromWorldPosition(x, y, z)) then
		local sx, sy = getScreenFromWorldPosition(x, y, z)
		local w, h = 256, 256
		local thick = 5

		local cx, cy, cz = getCameraMatrix();

		dxSetShaderValue(self.uShader, "fCoronaPosition", cx, cx, cz)
		dxSetShaderValue(self.uShader, "fDepthBias",1)

		--	dxDrawImage(sx-w/2, sy-h/2, w, h, "res/images/render/corona/1.png")
		dxDrawMaterialLine3D(x, y, z-thick*2, x, y, z+thick*2, self.uShader, thick, self.cColor, x, y+1, z)

		-- dxDrawMaterialLine3D( 0 + this.pos[1], 0 + this.pos[2], this.pos[3] - this.size[2] * 2, 0 + this.pos[1], 0 + this.pos[2],
		-- this.pos[3] + this.size[2] * 2, this.shader, this.size[1] * 4, tocolor(this.color[1],this.color[2],this.color[3],this.color[4]),
		-- 0 + this.pos[1],1 +  this.pos[2],0 + this.pos[3] )


		-- coronaTable.thisCorona = coronaTable.thisCorona + 1

	end

end

-- ///////////////////////////////
-- ///// setPosition 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCoronaMarker3D:setPosition(iX, iY, iZ)

	self.iX = iX;
	self.iY = iY;
	self.iZ = iZ;

	return setElementPosition(self.uObject, iX, iY, iZ);
end

-- ///////////////////////////////
-- ///// getPosition 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCoronaMarker3D:getPosition()
	return Vector3(getElementPosition(self.uObject));
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCoronaMarker3D:constructor(iX, iY, iZ, iSize, cColor)
	-- Klassenvariablen --
	self.iID    = C_ID;

	self.iX     = iX;
	self.iY     = iY;
	self.iZ     = iZ;
	self.iSize  = iSize;
	self.cColor = cColor;

	self.uObject    = createObject(1337, iX, iY, iZ);
	setElementAlpha(self.uObject, 0)
	setElementCollisionsEnabled(self.uObject, false);
	setObjectScale(self.uObject, 0);

	self.uShader    = dxCreateShader("res/shader/corona.fx", 0, 0, false, "all")
	dxSetShaderValue (self.uShader, "gCoronaTexture", Corona_Textures[1])
	dxSetShaderValue (self.uShader, "gDistFade", {420, 380})
	dxSetShaderValue (self.uShader, "fDepthSpread", 0,4)
	dxSetShaderValue (self.uShader, "fDistAdd", -2.5)
	dxSetShaderValue (self.uShader, "fDistMult", 1.0)

	-- Funktionen --
	
	
	-- Events --
	Corona_Markers[C_ID] = self;
	C_ID = C_ID+1;
end
-- ///////////////////////////////
-- ///// Destructor    		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCoronaMarker3D:destructor()
	destroyElement(self.uObject);
	Corona_Markers[self.iID] = nil;
end

-- EVENT HANDLER --

cCoronaMarker3D:new(524.25, 905.5, -64.53849029541, 1.0, tocolor(255, 255, 255, 255));

-- Manager Hier --
addEventHandler("onClientPreRender", getRootElement(), function() for id, class in pairs(Corona_Markers) do class:render() end end)
